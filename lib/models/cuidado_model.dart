import 'package:flutter/material.dart';

import 'package:utm_vinculacion/helpers/helpers.dart' as helpers;
import 'package:utm_vinculacion/models/global_activity.dart';
import 'alarma_model.dart';

class Cuidado extends GlobalActivity{

  Cuidado(TimeOfDay time, List<String> daysToNotify, {String nombre, String descripcion}):super(
    time, daysToNotify, nombre:nombre, descripcion:descripcion
  );

  ///////////////////////////////// CRUD /////////////////////////////////
  Cuidado.fromJson(Map<String, dynamic> json):super.fromJson(json);

  @override
  Future<bool> save() async {
    final res = await this.createAlarms();
    return res && (await db.nuevoCuidado(this));
  }

  @override
  Future<bool> update(Map<String, dynamic> params) async {
    final careUpdated = await db.updateCare(params, this.id);
    String rawDays = params["days"] ?? [];    

    // If it's not 0, it means that someting change
    if(rawDays.compareTo(this.daysToNotify.toString()) != 0) {
      await db.deleteCareAlarm(this);
      await careUpdated.createAlarms(); // creating new alarms
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
        final alarms = await db.getAlarmsByCare(this.id);
        
        // updating all alarms
        alarms.forEach((AlarmModel element)async{
          await element.update(updateAlarmParams);
        });
      }
      
    }

    return true;
  }

  @override
  Future<bool> delete() async {
    List<AlarmModel> alarms = await db.getAlarmsByCare(this.id);

    alarms.forEach((element)async{
      await element.desactivate();
    });

    await db.deleteCareAlarm(this); // delete all alarms of this object
    await db.deleteCare(this); // delete current activity

    return true;
  }

  ////////////////////////////// Functions //////////////////////////////
  @override
  Future<bool> createAlarms() {
    this.daysToNotify.forEach((String element)async{
      AlarmModel alarm = new AlarmModel(
        helpers.parseDay(element), // day to be notified
        this.time, // time to be notified
        this.nombre,
        this.descripcion
      );

      await alarm.save();
      await db.newCareAlarm(this.id, alarm.id);
    });

    return Future.value(true);
  }

  @override
  Future<void> chainStateUpdate()async{
    List<AlarmModel> alarms = await db.getAlarmsByCare(this.id);

    alarms.forEach((element)async{
      if(this.estado){
        await element.activate();
      }else{
        await element.desactivate();
      }
    });

    await db.updateAlarmStateByCare(this.id, this.estado?1:0);
    await db.updateCare({"active": this.estado?1:0}, this.id);
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