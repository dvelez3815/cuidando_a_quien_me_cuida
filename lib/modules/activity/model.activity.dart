import 'package:flutter/material.dart';

import 'package:utm_vinculacion/modules/alarms/model.alarm.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/dates/helper.date.dart';
import 'package:utm_vinculacion/modules/global/helpers.dart';

enum ActivityType {
  mental,
  recreation,
  physical,
  care
}

class Actividad{
  
  int id;
  String nombre;
  String descripcion;
  List<String> daysToNotify;
  TimeOfDay time; // time to be notified
  bool _estado = true;
  ActivityType type;  

  DBProvider db = DBProvider.db;

  Actividad(this.type, this.time, this.daysToNotify, {this.nombre, this.descripcion}){
    this.type = this.type ?? ActivityType.recreation;
    this.id = generateID(); // Esto es tremendamente necesario
  }
  
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

  Actividad.fromJson(Map<String, dynamic> json){

    List<int> time = json["time"].toString().split(":").map((i)=>int.parse(i)).toList();
    String days = json['days'] ?? "[]";
    days = days.replaceAll("[", "");
    days = days.replaceAll("]", "");
    days = days.replaceAll(" ", "");

    this.id = json['id'];
    this._estado = json['active']==1;
    this.nombre = json['nombre'];
    this.descripcion = json['descripcion'];
    this.time = new TimeOfDay(hour: time[0], minute: time[1]);
    this.daysToNotify = days.split(",");
    
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