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
  Map<String, dynamic> dataPre;
  TimeOfDay time;
  DBProvider dbProvider;

  List<String> litems = [];

  TextEditingController objetivosActividad = new TextEditingController();
  TextEditingController nombreActividad = new TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController eCtrl = new TextEditingController();
  final AlarmProvider alarm = new AlarmProvider();

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
      Cuidado item = dataPre["care_model"];
      nombreActividad.text = dataPre["title"];
      objetivosActividad.text = dataPre["description"];
      time = TimeOfDay.fromDateTime(item.date);

      if(!values.containsValue(true)){
        // rellenando los dias en que suena la alarma
        dbProvider.getAlarmsByCare(item.id).then((value){
          value.forEach((element) {
            values.update(parseDayWeek(element.time.weekday).toLowerCase(), (value) => true);
          });
          
          setState((){});
        });

      }
    }

    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text(dataPre.isEmpty? 'Agregar Cuidado':'Actualizar Cuidado'),
        actions: <Widget>[tresPuntos(context)],
      ),
      body: ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              ListTile(
                leading: Image.asset("assets/imagenes/medicine.png"),
                title: TextFormField(                  
                  // controller: nombreActividad,             
                  onChanged: (value)=>nombreActividad.text=value, 
                  initialValue: nombreActividad.text ?? "",
                  decoration: InputDecoration(                    
                    hintText: "Nombre del medicamento",
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.table_chart),
                title: TextFormField(
                  maxLines: 5,
                  // controller: objetivosActividad, 
                  onChanged: (value) => objetivosActividad.text = value,         
                  initialValue: objetivosActividad.text ?? "",
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
                        values.update(key, (_) => value);
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
                    label: Text('Establecer hora')
                  ),
                ],
              ),
              
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: RaisedButton(
                  color: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: saveAlarm,
                  child: Text(dataPre.isEmpty? "Guardar":"Actualizar"),
                )
              )
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
    if(dataPre.containsKey("care_model")){
      Cuidado cuidado = dataPre['care_model'];
      cuidado.estado = false;
      await dbProvider.deleteCare(cuidado);
    }
    return await _newAlarm();
  }

  Future<void> _newAlarm() async {
    final date = DateTime.now();

    final List<String> daysToNotify = new List<String>();

    this.values.forEach((key, value) {
      if(value) daysToNotify.add(key);
    });

    print("Days to notify "+daysToNotify.toString());

    if(daysToNotify.isEmpty) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text("Debe seleccionar al menos un día")));
      return;
    }

    AlarmModel model = new AlarmModel(
        new DateTime(date.year, date.month, date.day, time.hour, time.minute),
        title: nombreActividad.text ?? "",
        description: objetivosActividad.text
    );

    Cuidado care = new Cuidado(
      model.time,
      daysToNotify,
      nombre: nombreActividad.text,
      descripcion: objetivosActividad.text
    );

    if(dataPre.isNotEmpty){
       Cuidado _care = dataPre["care_model"];
       await dbProvider.removeCuidado(_care);
       await dbProvider.eliminaCuidadoAlarmas(_care);
    }
    
    await dbProvider.nuevoCuidado(care);
    await care.setAlarms(); // esto crea multiples alarmas y las guarda en SQLite

    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('La alarma sonara el ${date.day}/${date.month}/${date.year} a las ${time.hour}:${time.minute}')));
  
    Navigator.of(context).pop();
  }

  Future showPicker() async {
    // Obteniendo hora de la alarma
    if(dataPre.isNotEmpty){
      Cuidado cuidado = dataPre['care_model'];
      time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(cuidado.date));
    }
    else{
      time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    }
  }
  
}