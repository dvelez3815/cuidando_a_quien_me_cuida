import 'package:flutter/material.dart';

import 'package:utm_vinculacion/helpers/helpers.dart' as helpers;
import 'package:utm_vinculacion/providers/db_provider.dart';

abstract class GlobalActivity {

  int id;
  String nombre;
  String descripcion;
  List<String> daysToNotify;
  TimeOfDay time; // time to be notified

  DBProvider db = DBProvider.db;


  GlobalActivity(this.time, this.daysToNotify, {this.nombre, this.descripcion}){
    this.id = helpers.generateID(); // Esto es tremendamente necesario
  }

  GlobalActivity.fromJson(Map<String, dynamic> json){

    List<int> time = json["time"].toString().split(":").map((i)=>int.parse(i)).toList();
    String days = json['days'] ?? "[]";
    days = days.replaceAll("[", "");
    days = days.replaceAll("]", "");
    days = days.replaceAll(" ", "");

    this.id = json['id'];
    this.nombre = json['nombre'];
    this.descripcion = json['descripcion'];
    this.time = new TimeOfDay(hour: time[0], minute: time[1]);
    this.daysToNotify = days.split(",");
    
  }

  Future<bool> save();
  Future<bool> update(Map<String, dynamic> params);
  Future<bool> delete();
  Future<void> createAlarms();
  Future<void> chainStateUpdate();

}