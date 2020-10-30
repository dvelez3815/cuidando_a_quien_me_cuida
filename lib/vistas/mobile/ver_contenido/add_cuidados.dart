import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/alarma_model.dart';
import 'package:utm_vinculacion/models/cuidado_model.dart';
import 'package:utm_vinculacion/providers/alarms_provider.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';

import '../widgets_reutilizables.dart';


class AddCuidado extends StatefulWidget {
  @override
  State createState() => new _AddCuidadoState();
}

class _AddCuidadoState extends State<AddCuidado> {
  DBProvider dbProvider = DBProvider.db;
  TextEditingController nombreActividad = new TextEditingController();
  TextEditingController objetivosActividad = new TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AlarmProvider alarm = new AlarmProvider();

  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();

  TimeOfDay time;
  Map<String, bool> values = {
    'lunes': true,
    'martes': true,
    'miercoles': false,
    'jueves': false,
    'viernes': false,
    'sabado': false,
    'domingo': false,
  };

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text('Nombre de la app'),
        actions: <Widget>[tresPuntos(context)],
      ),
      body: ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              ListTile(
                leading: Image.asset("assets/imagenes/medicine.png"),
                title: TextField(
                  controller: nombreActividad,
                  decoration: InputDecoration(
                    hintText: "Nombre del medicamento",
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.table_chart),
                title: TextField(
                  maxLines: 5,
                  controller: objetivosActividad,
                  decoration: InputDecoration(
                    hintText: "Descripción del medicamento",
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(
                      text:
                          "Seleccione los días en los cuales el paciente tomará el medicamento",
                      style: TextStyle(color: Colors.grey, fontSize: 18)),
                ),
              ),
              Column(
                children: values.keys.map((String key) {
                  return new CheckboxListTile(
                    title: new Text(key),
                    value: values[key],
                    onChanged: (bool value) {
                      setState(() {
                        values[key] = value;
                      });
                    },
                  );
                }).toList(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlatButton.icon(
                      onPressed: showPicker,
                      color: Colors.green,
                      icon: Icon(Icons.timer),
                      label: Text('Establecer hora')),
                ],
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: RaisedButton(
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: saveAlarm,
                    child: Text("Guardar"),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  int parseDay(String day){
    int returnDay = 1;

    switch(day.toUpperCase()){
      case "LUNES": returnDay=1; break;
      case "MARTES": returnDay=2; break;
      case "MIERCOLES": returnDay=3; break;
      case "JUEVES": returnDay=4; break;
      case "VIERNES": returnDay=5; break;
      case "SABADO": returnDay=6; break;
      case "DOMINGO": returnDay=7; break;
    }

    return returnDay;

  }

  Future<void> saveAlarm() async {
    final date = DateTime.now();

    
    final List<String> daysToNotify = new List<String>();
    this.values.forEach((key, value) {if(value) daysToNotify.add(key);});

    if(daysToNotify.isEmpty) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text("Debe seleccionar al menos un día")));
      return;
    }

    AlarmModel model = new AlarmModel(
        new DateTime(date.year, date.month, date.day, time.hour, time.minute),
        title: (nombreActividad.text ?? "").length>0? nombreActividad.text:"Sin título",
        description: objetivosActividad.text
    );

    Cuidado care = new Cuidado(
      model.time,
      daysToNotify,
      nombre: nombreActividad.text,
      descripcion: objetivosActividad.text
    );

    await dbProvider.nuevoCuidado(care);
    await care.setAlarms(); // esto crea multiples alarmas y las guarda en SQLite

 
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('La alarma sonara el ${date.day}/${date.month}/${date.year} a las ${time.hour}:${time.minute}')));
  }

  Future showPicker() async {
    // Obteniendo hora de la alarma
    time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }
}