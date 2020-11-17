import 'package:flutter/material.dart';

import 'package:utm_vinculacion/modules/alarms/model.alarm.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/dates/helper.date.dart';
import 'package:utm_vinculacion/modules/events/model.events.dart';

class Actividad extends GlobalActivity{
  
  final db = DBProvider.db;

  Actividad(TimeOfDay time, List<String> daysToNotify, {String nombre, String descripcion}):super(
    time, daysToNotify, nombre:nombre, descripcion:descripcion
  );
  
  /////////////////////////////////// CRUD ///////////////////////////////////
  @override
  Future<bool> save() async {
    final res = await this.createAlarms();
    return res && (await db.newActivity(this));
  }

  /// params need to be in the database format
  @override
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

  Actividad.fromJson(Map<String, dynamic> json):super.fromJson(json);

  @override
  Future<bool> delete() async {

    List<AlarmModel> alarms = await db.getAlarmsByActivity(this.id);

    alarms.forEach((element)async{
      await element.desactivate();
    });

    await db.eliminaActividadAlarmas(this); // delete all alarms of this object
    await db.deleteActivity(this); // delete current activity

    return true;
  }

  ////////////////////////////// Functionality //////////////////////////////
  @override
  Future<bool> createAlarms() async {
      this.daysToNotify.forEach((String element)async{
      AlarmModel alarm = new AlarmModel(
        parseDay(element), // day to be notified
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
    });

    await db.updateAlarmStateByActivity(this.id, this.estado?1:0);
    await db.updateActivity({"active": this.estado?1:0}, this.id);
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


}