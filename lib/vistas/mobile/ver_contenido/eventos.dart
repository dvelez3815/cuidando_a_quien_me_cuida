import 'package:flutter/material.dart';

import 'package:utm_vinculacion/models/cuidado_model.dart';
import 'package:utm_vinculacion/models/global_activity.dart';
import 'package:utm_vinculacion/providers/alarms_provider.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';

class EventAC {

  bool loadFirstTime = false;

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
    
    if(!loadFirstTime) loadFirstTime = true;
    else return;
    
    GlobalActivity care = updateData["model_data"];
    
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

  Widget getTimeSelector(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlatButton.icon(
          onPressed: ()=>showPicker(context),
          color: Colors.green,
          icon: Icon(Icons.timer),
          label: Text('Establecer hora')
        ),
      ],
    );
  }

  Future showPicker(BuildContext context) async {
        // Obteniendo hora de la alarma
    if(updateData.isNotEmpty){
      GlobalActivity cuidado = updateData['model_data'];
      time = await showTimePicker(context: context, initialTime: cuidado.time);
    }
    else{
      time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    }
  }

  Widget getSaveButton(BuildContext context, GlobalActivity type) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: RaisedButton(
        color: Colors.amber,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        onPressed: ()=>saveAlarm(context, type),
        child: Text(updateData.isEmpty? "Guardar":"Actualizar"),
      )
    );
  }

  Future<void> saveAlarm(BuildContext context, GlobalActivity type) async {  
    // What I actually do, is to delete the current event and its alarms
    // and then I create a new one with the new data
    if(updateData.isNotEmpty){
      GlobalActivity activity = updateData['model_data'];
      await activity.delete();
    }

    return await _newAlarm(context, type);
  }

  Future<void> _newAlarm(BuildContext context, GlobalActivity type) async {

    // This will contains only the days to notify
    final List<String> daysActive = new List<String>();

    this.daysToNotify.forEach((key, value) {
      if(value) daysActive.add(key);
    });

    // At least one day should be selected
    if(daysActive.isEmpty) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text("Debe seleccionar al menos un día")));
      return;
    }

    // Creating the model
    GlobalActivity activity;

    if(type is Cuidado){
      activity = new Cuidado(
        this.time,
        daysActive, // this is not the class attribute
        nombre: this.nombreActividad.text ?? "Sin título",
        descripcion: this.objetivosActividad.text ?? "Sin objetivos"
      );
    }else{
      activity = new Actividad(
        this.time,
        daysActive, // this is not the class attribute
        nombre: this.nombreActividad.text ?? "Sin título",
        descripcion: this.objetivosActividad.text ?? "Sin objetivos"
      );
    }

    await activity.save(); // this save this care/activity in local database

    this.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('La alarma fué creada')
    ));
  
    Navigator.of(context).pop();
  }  

}