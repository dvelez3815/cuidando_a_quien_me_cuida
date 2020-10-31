import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/alarma_model.dart';
import 'package:utm_vinculacion/providers/alarms_provider.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class AddActividades extends StatefulWidget {
  @override
  State createState() => new _AddActividadesState();
}

class _AddActividadesState extends State<AddActividades> {
  Map<String, dynamic> dataPre;
  DBProvider dbProvider = DBProvider.db;
  TextEditingController nombreActividad = new TextEditingController();
  TextEditingController objetivosActividad = new TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AlarmProvider alarm = new AlarmProvider();

  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();

  TimeOfDay time;
  Map<String, bool> values;

  @override
  void initState() { 
    dbProvider = DBProvider.db;
    values = {
      'lunes': false,
      'martes': false,
      'miercoles': false,
      'jueves': false,
      'viernes': false,
      'sabado': false,
      'domingo': false,
    };

    super.initState();    
  }

  @override
  Widget build(BuildContext ctxt) {

    dataPre = ModalRoute.of(context).settings.arguments ?? {};

    if(dataPre.isNotEmpty){
      Actividad item = dataPre["activity_model"];
      nombreActividad.text = dataPre["title"];
      objetivosActividad.text = dataPre["description"];
      time = TimeOfDay.fromDateTime(item.date);

      if(!values.containsValue(true)){

        // rellenando los dias en que suena la alarma
        dbProvider.getAlarmsByActivity(item.id).then((value){
          value.forEach((element) {
            values[parseDayWeek(element.time.weekday).toLowerCase()] = true;
          });
          
          setState((){});
        });

      }
    }

    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text(NOMBREAPP),
        actions: <Widget>[tresPuntos(context)],
      ),
      body: ListView(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.directions_run),
                title: TextFormField(
                  onChanged: (value)=>nombreActividad.text=value, 
                  initialValue: nombreActividad.text ?? "",
                  decoration: InputDecoration(                    
                    hintText: "Nombre de la actividad",
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.table_chart),
                title: TextFormField(
                  maxLines: 5,
                  onChanged: (value) => objetivosActividad.text = value,         
                  initialValue: objetivosActividad.text ?? "",
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
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: FlatButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: showPicker,
                    color: Colors.green,
                    icon: Icon(Icons.timer),
                    label: Text('Establecer hora')),
              ),


              Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: RaisedButton(
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: saveAlarm,
                    child: Text(dataPre.isEmpty? "Guardar":"Actualizar"),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  
  String parseDayWeek(int day){
    switch(day){
      case 1: return "LUNES";
      case 2: return "MARTES";
      case 3: return "MIERCOLES";
      case 4: return "JUEVES";
      case 5: return "VIERNES";
      case 6: return "SABADO";
      default: return "DOMINGO";
    }
  }

  int parseDay(String day) {
    int returnDay = 1;

    switch (day.toUpperCase()) {
      case "LUNES":
        returnDay = 1;
        break;
      case "MARTES":
        returnDay = 2;
        break;
      case "MIERCOLES":
        returnDay = 3;
        break;
      case "JUEVES":
        returnDay = 4;
        break;
      case "VIERNES":
        returnDay = 5;
        break;
      case "SABADO":
        returnDay = 6;
        break;
      case "DOMINGO":
        returnDay = 7;
        break;
    }

    return returnDay;
  }

  Future<void> saveAlarm() async {
    if(dataPre.isNotEmpty){
      Actividad cuidado = dataPre['activity_model'];
      cuidado.estado = false;
      await dbProvider.deleteActivity(cuidado);
    }
    return await _newAlarm();
  }


  Future<void> _newAlarm() async {

    AlarmModel model;
    final date = DateTime.now();
    final List<String> days = new List<String>();

    // Validaciones
    if (nombreActividad.text.length < 4 || objetivosActividad.text.length < 4) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: Text("El nombre y los objetivos deben ser rellenados")));
      return;
    }

    this.values.forEach((key, value) {
      if (value) days.add(key);
    });

    if (days.isEmpty) {
      scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: Text("Debe seleccionar al menos un día")));
      return;
    }

    // La creacion como tal     

    model = new AlarmModel(
        new DateTime(date.year, date.month, date.day, time.hour, time.minute),
        title: (nombreActividad.text ?? "").length > 0
            ? nombreActividad.text
            : "Sin título",
        description: objetivosActividad.text);

    Actividad activity = new Actividad(
      model.time,
      days, // dias para notificar
      nombre: nombreActividad.text,
      descripcion: objetivosActividad.text
    );

    await dbProvider.removActividad(dataPre["activity_model"]);
    await dbProvider.nuevaActividad(activity);    
    await activity.setAlarms(); // esto crea multiples alarmas y las guarda en SQLite

    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
          'La alarma sonara el ${date.day}/${date.month}/${date.year} a las ${time.hour}:${time.minute}'
      )
    ));
    Navigator.of(context).pop();
  }

  Future showPicker() async {
    // Obteniendo hora de la alarma
    if(dataPre.isNotEmpty){
      Actividad cuidado = dataPre['activity_model'];
      time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(cuidado.date));
    }
    else{
      time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    }
  }
}
