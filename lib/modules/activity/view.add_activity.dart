import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/alarms/provider.alarm.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';

import 'model.activity.dart';

class AddActividades extends StatefulWidget {
  // dabase
  final DBProvider dbProvider = DBProvider.db;  
  
  // These come from input fields in each specific class
  final TextEditingController objetivosActividad = new TextEditingController();
  final TextEditingController nombreActividad = new TextEditingController();
  
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController eCtrl = new TextEditingController();
  final AlarmProvider alarm = new AlarmProvider();

  // these are the days that user will be notified
  final Map<String, bool> daysToNotify = {
    'lunes': false,
    'martes': false,
    'miércoles': false,
    'jueves': false,
    'viernes': false,
    'sabado': false,
    'domingo': false,
  };

  @override
  State createState() => new _AddActividadesState();
}

class _AddActividadesState extends State<AddActividades>{
  
  Map<String, dynamic> updateData;  // this data will be defined in each specific class
  List<String> litems;
  bool loadFirstTime;
  TimeOfDay time; // Time to be notified
  ActivityType actType;
  int selectedType; // what is the activity type selected by the user

  @override
  void initState() {
    time = TimeOfDay.now();
    loadFirstTime = false;
    selectedType = 0;
    litems = [];

    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {

    updateData = ModalRoute.of(context).settings.arguments ?? {};

    if(updateData.isNotEmpty){
      loadUpdateData(setState);
    }

    return Scaffold(
      key: widget.scaffoldKey,
      body: Column(
        children: [
          getHeader(context, MediaQuery.of(context).size, "Agregar actividad"),
          Expanded(
            child: ListView(
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
              children: _getElementList()
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////////////// Methods ///////////////////////////////////
  void loadUpdateData(Function setState) {
    
    if(!loadFirstTime) loadFirstTime = true;
    else return;
    
    Actividad activity = updateData["model_data"];
    
    widget.nombreActividad.text = activity.nombre;
    widget.objetivosActividad.text = activity.descripcion;
    
    time = activity.time;
    
    // if there are no days to notify, then put one by default
    activity.daysToNotify.forEach((element) {
      widget.daysToNotify[element.toLowerCase()] = true;
    });

    setState((){});
  }

  ////////////////////////// Interface functions //////////////////////////
  Widget getDaysSelector(Function setState) {
    return Column(
      children: widget.daysToNotify.keys.map((String key) {
        return new SwitchListTile(
          title: new Text(key[0].toUpperCase()+key.substring(1).toLowerCase()),
          value: widget.daysToNotify[key],
          secondary: Icon(_getIconByDay(key)),
          onChanged: (bool value) {
            setState(() {
              widget.daysToNotify.update(key, (_) => value);
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
      Actividad cuidado = updateData['model_data'];
      time = await showTimePicker(context: context, initialTime: cuidado.time);
    }
    else{
      time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    }
  }

  Widget getSaveButton(BuildContext context, Actividad type) {
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

  Future<void> saveAlarm(BuildContext context, Actividad type) async {  
    // What I actually do, is to delete the current event and its alarms
    // and then I create a new one with the new data
    if(updateData.isNotEmpty){
      Actividad activity = updateData['model_data'];
      await activity.delete();
    }

    return await _newAlarm(context, type);
  }

  Future<void> _newAlarm(BuildContext context, Actividad type) async {

    // This will contains only the days to notify
    final List<String> daysActive = new List<String>();

    this.widget.daysToNotify.forEach((key, value) {
      if(value) daysActive.add(key);
    });

    // At least one day should be selected
    if(daysActive.isEmpty) {
      widget.scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text("Debe seleccionar al menos un día")));
      return;
    }

    // Creating the model
    Actividad activity = new Actividad(
      ActivityType.recreation, //TODO: complete this
      this.time,
      daysActive, // this is not the class attribute
      nombre: widget.nombreActividad.text ?? "Sin título",
      descripcion: widget.objetivosActividad.text ?? "Sin objetivos"
    );

    await activity.save(); // this save this activity/activity in local database

    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('La alarma fué creada')
    ));
  
    Navigator.of(context).pop();
  }

  Widget _getDescriptionField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLines: null,
        onChanged: (value) => widget.objetivosActividad.text = value,         
        initialValue: widget.objetivosActividad.text ?? "",        
        decoration: InputDecoration(
          labelText: "Descripción",
          hintText: "¿Cuál es el objetivo de la actividad?",
          icon: Icon(Icons.description),
          border: OutlineInputBorder()
        ),
      ),
    );
  }

  Widget _getTitleField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onChanged: (value)=>widget.nombreActividad.text=value, 
        maxLines: 1,
        initialValue: widget.nombreActividad.text ?? "",
        decoration: InputDecoration(                    
          labelText: "Nombre",
          hintText: "¿Cómo se llamará la actividad?",
          icon: Icon(Icons.info),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  List<Widget> _getElementList() {
    return <Widget>[
      ListTile(
        title: Text("Defina su actividad"),
      ),
      _getTitleField(),
      _getDescriptionField(),
      Divider(),
      ListTile(
        title: Text("Seleccione el tipo de actividad"),
      ),
      RadioListTile(
        groupValue: this.selectedType,
        value: 0,
        secondary: Icon(Icons.directions_run),
        onChanged: (value){
          setState((){
            this.selectedType = value;
            this.actType = ActivityType.physical;
          });
        },
        title: Text("Física"),
      ),
      RadioListTile(
        groupValue: this.selectedType,
        secondary: Icon(Icons.lightbulb),
        onChanged: (value){
          setState((){
            this.selectedType = value;
            this.actType = ActivityType.mental;
          });
        },
        value: 1,
        title: Text("Mental"),
      ),
      RadioListTile(
        groupValue: this.selectedType,
        secondary: Icon(Icons.sports_baseball),
        onChanged: (value){
          setState((){
            this.selectedType = value;
            this.actType = ActivityType.recreation;
          });
        },
        value: 2,
        title: Text("Recreación"),
      ),
      RadioListTile(
        groupValue: this.selectedType,
        secondary: Icon(Icons.volunteer_activism),
        onChanged: (value){
          setState((){
            this.selectedType = value;
            this.actType = ActivityType.care;
          });
        },
        value: 3,
        title: Text("Bienestar"),
      ),
      Divider(),
      ListTile(
        title: Text("Seleccione los días en que realizará la actividad")
      ),
      this.getDaysSelector(setState),
      this.getTimeSelector(context),
      getSaveButton(context, new Actividad(
          ActivityType.recreation, //TODO: complete this
          TimeOfDay.now(), 
          []
        )
      )
    ];
  }

  IconData _getIconByDay(String key) {
    switch(key.toLowerCase()){
      case "lunes": return Icons.work;
      case "martes": return Icons.wysiwyg;
      case "miércoles": return Icons.airport_shuttle;
      default: return Icons.info;
    }
  }

}