import 'package:utm_vinculacion/models/alarma_model.dart';
import 'package:utm_vinculacion/models/global_activity.dart';

class Actividad extends GlobalActivity{
  
  bool _estado = true;

  Actividad(DateTime date, List<String> daysToNotify, {String nombre, String descripcion}):super(date, daysToNotify, nombre:nombre, descripcion:descripcion);
  
  @override
  Future<void> setAlarms()async{
    daysToNotify.forEach((day)async{
      print("Alarma para el día ${parseDayFromString(day)}");
      final AlarmModel alarm = new AlarmModel(
        new DateTime(date.year, date.month, parseDayFromString(day), date.hour, date.minute),
        title: "Recordatorio", description: this.nombre
      );
      await alarm.save();
      await db.newActivityAlarm(this.id, alarm.id);
    });
  }

  @override
  Future<void> chainStateUpdate()async{
    List<AlarmModel> alarms = await db.getAlarmsByActivity(this.id);

    if(this.date != null){
      alarms.forEach((element)async{
        if(this.estado){
          await element.reactivate();
        }else{
          await element.cancelAlarm();
        }
        await db.updateAlarmState(element.id, this.estado?1:0);
      });
    }

    await db.updateActivityState(this.id, this.estado);
  }

  Actividad.fromJson(Map<String, dynamic> json):super.fromJson(json, (estado)=>{estado = estado});

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      "id"         : id,
      "nombre"     : nombre,
      "descripcion": descripcion,
      "active"     : this.estado? 1:0,
      "date"       : this.date==null? null:"${date.year}/${date.month}/${date.day}",
      "time"       : this.date==null? null:"${date.hour}:${date.minute}",
    };
  }

  get estado =>_estado;
  set estado(bool status) {
    this._estado = status;
    chainStateUpdate();
  }
}