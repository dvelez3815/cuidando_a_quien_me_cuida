import 'package:flutter/material.dart';

import 'package:utm_vinculacion/models/cuidado_model.dart';
import 'package:utm_vinculacion/providers/alarms_provider.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';

class EventAC {

  // dabase
  final DBProvider dbProvider = DBProvider.db;

  // These come from input fields in each specific class
  final TextEditingController objetivosActividad = new TextEditingController();
  final TextEditingController nombreActividad = new TextEditingController();


  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController eCtrl = new TextEditingController();
  final AlarmProvider alarm = new AlarmProvider();

  Map<String, dynamic> updateData;  // this data will be defined in each specific class
  TimeOfDay time = TimeOfDay.now(); // Time to be notified

  List<String> litems = [];


  // these are the days that user will be notified
  final Map<String, bool> daysToNotify = {
    'lunes': false,
    'martes': false,
    'miercoles': false,
    'jueves': false,
    'viernes': false,
    'sabado': false,
    'domingo': false,
  };

  /////////////////////////////////// Methods ///////////////////////////////////
  void loadUpdateData(Function setState) {
    Cuidado care = updateData["care_model"];
    
    nombreActividad.text = care.nombre;
    objetivosActividad.text = care.descripcion;
    
    time = care.time;
    
    // if there are no days to notify, then put one by default
    care.daysToNotify.forEach((element) {
      daysToNotify[element.toLowerCase()] = true;
    });

    setState((){});
  }

  ////////////////////////// Interface functions //////////////////////////
  Widget getDaysSelector(Function setState) {
    return Column(
      children: daysToNotify.keys.map((String key) {
        return new CheckboxListTile(
          title: new Text(key),
          value: daysToNotify[key],
          onChanged: (bool value) {
            setState(() {
              daysToNotify.update(key, (_) => value);
            });
          },
        );
      }).toList(),
    );
  }

}