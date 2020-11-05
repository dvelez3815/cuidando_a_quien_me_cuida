import 'package:flutter/material.dart';

import 'package:utm_vinculacion/helpers/helpers.dart' as helpers;
import 'package:utm_vinculacion/models/alarma_model.dart';
import 'package:utm_vinculacion/models/global_activity.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';

class Actividad extends GlobalActivity{
  
  final db = DBProvider.db;  
  bool _estado = true;

  Actividad(TimeOfDay time, List<String> daysToNotify, {String nombre, String descripcion}):super(
    time, daysToNotify, nombre:nombre, descripcion:descripcion
  );
  
  /////////////////////////////////// CRUD ///////////////////////////////////
  Future<bool> save() async {
    final res = await this.createAlarms();
    return res && (await db.newActivity(this));
  }

  /// params need to be in the database format
  Future<bool> update(Map<String, dynamic> params) async {

    final activityUpdated = await db.updateActivity(params, this.id);
    String rawDays = params["days"];    

    // If it's not 0, it means that someting change
    if(rawDays.compareTo(this.daysToNotify.toString()) != 0) {
      await db.eliminaActividadAlarmas(this);
      await activityUpdated.createAlarms(); // creating new alarms
    }    
    else {
      Map<String, dynamic> updateAlarmParams = new Map<String, dynamic>();

      if(params.containsKey("active")){
        updateAlarmParams.addAll({"active": params["active"]});
      }
      if(params.containsKey("nombre")){
        updateAlarmParams.addAll({"title": params["nombre"]});
      }
      if(params.containsKey("descripcion")){
        updateAlarmParams.addAll({"body": params["descripcion"]});
      }
      if(params.containsKey("time")){
        updateAlarmParams.addAll({"time": params["time"]});
      }

      if(updateAlarmParams.isNotEmpty){
        final alarms = await db.getAlarmsByActivity(this.id);
        
        // updating all alarms
        alarms.forEach((AlarmModel element)async{
          await element.update(updateAlarmParams);
        });
      }
      
    }

    return true;
  }

  Actividad.fromJson(Map<String, dynamic> json):super.fromJson(json){
    this._estado = json['active']==1;
  }

  Future<bool> delete() async {
    this.estado = false; // this will trigger the setter and update all alarms status
    return (await db.deleteActivity(this)) && (await db.eliminaActividadAlarmas(this));
  }

  ////////////////////////////// Functionality //////////////////////////////
  @override
  Future<bool> createAlarms() async {
      this.daysToNotify.forEach((String element)async{
      AlarmModel alarm = new AlarmModel(
        helpers.parseDay(element), // day to be notified
        this.time, // time to be notified
        this.nombre,
        this.descripcion
      );

      await alarm.save();
      await db.newActivityAlarm(this.id, alarm.id);
    });

    return Future.value(true);
  }

  @override
  Future<void> chainStateUpdate()async{
    List<AlarmModel> alarms = await db.getAlarmsByActivity(this.id);

    alarms.forEach((element)async{
      if(this.estado){
        await element.activate();
      }else{
        await element.desactivate();
      }
      // This do not delete anything, it just change the state of this alarm
      // in the database
      await db.updateAlarmStateByActivity(element.id, this.estado?1:0);
    });

    await db.updateActivity({"active": this._estado?1:0}, this.id);
  }

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      "id"         : id,
      "nombre"     : nombre,
      "descripcion": descripcion,
      "active"     : this.estado? 1:0,
      "time"       : "${this.time.hour}:${this.time.minute}",
      "days"       : this.daysToNotify.toString()
    };
  }

  /////////////////////////////// Getters ///////////////////////////////
  get estado =>_estado;

  /////////////////////////////// Setters ///////////////////////////////
  set estado(bool status) {
    this._estado = status;
    chainStateUpdate();
  }
}