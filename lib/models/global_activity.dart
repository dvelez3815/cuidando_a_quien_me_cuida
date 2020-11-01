import 'package:utm_vinculacion/providers/db_provider.dart';

abstract class GlobalActivity {

  int id;
  String nombre;
  String descripcion;
  DateTime date;
  List<String> daysToNotify;

  DBProvider db = DBProvider.db;

  static const List<String> days = ["lunes", "martes", "miercoles", "jueves", "viernes", "sabado", "domingo"];

  GlobalActivity(this.date, this.daysToNotify, {this.nombre, this.descripcion}){
    this.id = generateID(); // Esto es tremendamente necesario
  }

  GlobalActivity.fromJson(Map<String, dynamic> json){

    id = json['id'];
    nombre = json['nombre'];
    descripcion = json['descripcion'];
    
    List<int> date = json["date"]==null? null:json["date"].toString().split("/").map((i)=>int.parse(i)).toList();
    List<int> time = json["time"]==null? null:json["time"].toString().split(":").map((i)=>int.parse(i)).toList();

    this.date = date==null? null:new DateTime(date[0], date[1], date[2], time[0], time[1]);
    
  }

  int generateID() {

    final date = DateTime.now();
    final secondsNow = date.year*31104000+date.month*2592000+date.day*86400+date.hour*3600+date.minute*60+date.second+date.microsecond;

    return secondsNow - 62832762060;
  }

  int parseDayFromString(String day)=>days.indexOf(day) + 1;

  Future<void> setAlarms();
  Future<void> chainStateUpdate();

}