import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:utm_vinculacion/models/alarma_model.dart';
import 'package:utm_vinculacion/providers/alarms_provider.dart';

import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

class AddActividades extends StatefulWidget {
  @override
  State createState() => new _AddActividadesState();
}

class _AddActividadesState extends State<AddActividades> {
  DBProvider dbProvider = DBProvider.db;
  TextEditingController nombreActividad = new TextEditingController();
  TextEditingController objetivosActividad = new TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AlarmProvider alarm = new AlarmProvider();

  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();

  var time;
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
        actions: <Widget>[tresPuntos()],
      ),
      body: ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.directions_run),
                title: TextField(
                  controller: nombreActividad,
                  decoration: InputDecoration(
                    hintText: "Nombre de la actividad",
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.table_chart),
                title: TextField(
                  maxLines: 5,
                  controller: objetivosActividad,
                  decoration: InputDecoration(
                    hintText: "Objetivos de la actividad",
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
                          "Seleccione los días en los cuales la actividad se realizara",
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
                  
                  FlatButton.icon(
                    onPressed: () async {
                      await AndroidAlarmManager.cancel(1999);
                    },
                    icon: Icon(Icons.cancel),
                    label: Text('Cancelar alarma'),
                    color: Colors.red,
                    textColor: Colors.white,
                  ),
                  FlatButton.icon(
                    onPressed: () async {
                      await AlarmProvider.player.stop();
                    },
                    icon: Icon(Icons.stop),
                    label: Text('Detener alarma'),
                  )
                ],
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: RaisedButton(
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async {
                       final date = DateTime.now();                                     

                      // cancelando alarma anterior
                      // await AndroidAlarmManager.cancel(alarmID);
                      AlarmModel model = new AlarmModel(
                          new DateTime(date.year, date.month, date.day, time.hour, time.minute),
                          title: "Alarma",
                          description: "Body");

                      AndroidAlarmManager.oneShotAt(model.time, model.id, ejecucion);

                      scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                              'La alarma sonara el ${date.day}/${date.month}/${date.year} a las ${time.hour}:${time.minute}')));
                    },
                    child: Text("Guardar"),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Future showPicker() async {
    // Obteniendo hora de la alarma
    time = await showTimePicker(context: context, initialTime: TimeOfDay.now());

  }

  // Esto reproduce el sonido y muestra la notificacion
  static Future<void> ejecucion() async {
    AlarmProvider.player = await AlarmProvider.cache.play('sonido.mp3');

    final localNotification = FlutterLocalNotificationsPlugin();
    await localNotification.show(
        1999,
        "Titulo Alarma",
        "Esto es un body",
        NotificationDetails(
            AlarmProvider.androidChannel, AlarmProvider.iOSChannel));
  }
}
