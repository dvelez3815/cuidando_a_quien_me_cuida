import 'package:utm_vinculacion/models/alarma_model.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';

class Actividad {
  String nombre;
  String descripcion;
  bool _estado;
  int id;
  DateTime date;
  List<String> daysToNotify;

  DBProvider db = DBProvider.db;

  static const List<String> days = ["lunes", "martes", "miercoles", "jueves", "viernes", "sabado", "domingo"];

  Actividad(this.daysToNotify,this.date,this.nombre,this.descripcion){
    this._estado=true;
    this.id = AlarmModel.generateID(); // Esto es tremendamente necesario
  }

  int parseDayFromString(String day)=>days.indexOf(day) + 1;

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

  Future<void> chainStateUpdate()async{
    List<AlarmModel> alarms = await db.getAlarmsByActivity(this.id);

    alarms.forEach((element)async{
      if(this._estado){
        await element.reactivate();
      }else{
        await element.cancelAlarm();
      }
      await db.updateAlarmState(element.id, this._estado?1:0);
    });

    await db.updateActivityState(this.id, this._estado);
  }

  Actividad.fromJson(Map<String, dynamic> json){
    this.id = json['id'];
    this.nombre = json['nombre'];
    this.descripcion = json['description'];
    
    List<int> date = json["date"].toString().split("/").map((i)=>int.parse(i)).toList();
    List<int> time = json["time"].toString().split(":").map((i)=>int.parse(i)).toList();

    this.date = new DateTime(date[0], date[1], date[2], time[0], time[1]);
    _estado = json['estado'] == 1;

  }

  Map<String, dynamic> toJson()=>{
    "id"         : this.id,
    "nombre"     : this.nombre,
    "estado"     : this._estado? 1:0,
    "date"       : "${date.year}/${date.month}/${date.day}",
    "time"       : "${date.hour}:${date.minute}",
    "description": this.descripcion
  };
  get estado => this._estado;

  set estado(bool status) {
    this._estado = status;
    chainStateUpdate();
  }

}