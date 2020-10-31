import 'package:utm_vinculacion/models/global_activity.dart';

import 'alarma_model.dart';

class Cuidado extends GlobalActivity{

  bool _estado = true;

  Cuidado(DateTime date, List<String> daysToNotify, {String nombre, String descripcion}):super(date, daysToNotify, nombre:nombre, descripcion:descripcion);

  Cuidado.fromJson(Map<String, dynamic> json) : super.fromJson(json, (estado)=>{estado == estado});

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      "id"         : id,
      "nombre"     : nombre,
      "descripcion": descripcion,
      "active"     : this.estado? 1:0,
      "date"       : "${date.year}/${date.month}/${date.day}",
      "time"       : "${date.hour}:${date.minute}",
    };
  }

  Future<void> setAlarms()async{
    daysToNotify.forEach((day)async{
      print("Alarma para el día ${parseDayFromString(day)}");
      final AlarmModel alarm = new AlarmModel(
        new DateTime(date.year, date.month, parseDayFromString(day), date.hour, date.minute),
        title: this.nombre, description: this.descripcion
      );
      await alarm.save();
      await db.newCareAlarm(this.id, alarm.id);
    });
  }

  Future<void> chainStateUpdate()async{
    List<AlarmModel> alarms = await db.getAlarmsByCare(this.id);

    alarms.forEach((element)async{
      if(this.estado){
        await element.reactivate();
      }else{
        await element.cancelAlarm();
      }
      await db.updateAlarmState(element.id, this.estado?1:0);
    });

    await db.updateCareState(this.id, this.estado?1:0);

  }

  get estado =>_estado;
  set estado(bool status) {
    print("Entrar");
    this._estado = status;
    chainStateUpdate();
  }
}