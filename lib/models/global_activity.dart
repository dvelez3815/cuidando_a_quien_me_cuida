import 'package:utm_vinculacion/helpers/helpers.dart' as helpers;
import 'package:utm_vinculacion/providers/db_provider.dart';

abstract class GlobalActivity {

  int id;
  String nombre;
  String descripcion;
  DateTime date;
  List<String> daysToNotify;

  DBProvider db = DBProvider.db;


  GlobalActivity(this.date, this.daysToNotify, {this.nombre, this.descripcion}){
    this.id = helpers.generateID(); // Esto es tremendamente necesario
  }

  GlobalActivity.fromJson(Map<String, dynamic> json){

    id = json['id'];
    nombre = json['nombre'];
    descripcion = json['descripcion'];
    
    List<int> date = json["date"]==null? null:json["date"].toString().split("/").map((i)=>int.parse(i)).toList();
    List<int> time = json["time"]==null? null:json["time"].toString().split(":").map((i)=>int.parse(i)).toList();

    this.date = date==null? null:new DateTime(date[0], date[1], date[2], time[0], time[1]);
    
  }

  Future<bool> save();
  Future<bool> update(Map<String, dynamic> params);
  Future<bool> delete();
  Future<void> createAlarms();
  Future<void> chainStateUpdate();

}