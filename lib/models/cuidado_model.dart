import 'package:utm_vinculacion/providers/db_provider.dart';

import 'alarma_model.dart';

class Cuidado {

  int idCuidado;
  String nombre;
  String descripcion;
  DateTime date;
  List<String> daysToNotify;
  bool _estado;

  DBProvider db = DBProvider.db;

  static const List<String> days = ["lunes", "martes", "miercoles", "jueves", "viernes", "sabado", "domingo"];

  Cuidado(this.date, this.daysToNotify, {this.nombre, this.descripcion}){
    this._estado=true;
    this.idCuidado = AlarmModel.generateID(); // Esto es tremendamente necesario
  }

  Future<void> setAlarms()async{

    daysToNotify.forEach((day)async{
      print("Alarma para el día ${parseDayFromString(day)}");
      final AlarmModel alarm = new AlarmModel(
        new DateTime(date.year, date.month, parseDayFromString(day), date.hour, date.minute),
        title: this.nombre, description: this.descripcion
      );
      await alarm.save();
      await db.newCareAlarm(this.idCuidado, alarm.id);
    });
  }

  Future<void> chainStateUpdate()async{
    List<AlarmModel> alarms = await db.getAlarmsByCare(this.idCuidado);

    alarms.forEach((element)async{
      if(this._estado){
        await element.reactivate();
      }else{
        await element.cancelAlarm();
      }
      await db.updateAlarmState(element.id, this._estado?1:0);
    });

    await db.updateCareState(this.idCuidado, this._estado?1:0);

  }

  Cuidado.fromJson(Map<String, dynamic> json){

    idCuidado = json['idCuidado'];
    nombre = json['nombre'];
    descripcion = json['descripcion'];
    this._estado = json['active'] == 1;
    
    List<int> date = json["date"].toString().split("/").map((i)=>int.parse(i)).toList();
    List<int> time = json["time"].toString().split(":").map((i)=>int.parse(i)).toList();

    this.date = new DateTime(date[0], date[1], date[2], time[0], time[1]);
    
  }

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      "idCuidado"  : idCuidado,
      "nombre"     : nombre,
      "descripcion": descripcion,
      "active"     : this._estado? 1:0,
      "date"       : "${date.year}/${date.month}/${date.day}",
      "time"       : "${date.hour}:${date.minute}",
    };
  }

  get estado => this._estado;

  set estado(bool status) {
    this._estado = status;
    chainStateUpdate();
  }

  int parseDayFromString(String day)=>days.indexOf(day) + 1;
}