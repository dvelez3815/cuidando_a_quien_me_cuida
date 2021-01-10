import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/alarms/provider.alarm.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/widgets/components/expansion_tile.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/input.dart';

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
    'miercoles': false,
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
  List<Map<String, dynamic>> materiales;
  bool loadFirstTime;
  TimeOfDay time; // Time to be notified
  ActivityType actType;
  int selectedType; // what is the activity type selected by the user

  @override
  void initState() {
    time = TimeOfDay.now();
    loadFirstTime = false;
    selectedType = 2;
    litems = [];
    materiales = [];

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
          getHeader(context, "Agregar actividad"),
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

    // getting the model from the route parameters
    Actividad activity = updateData["model_data"];
    
    // Loading values into text controllers
    widget.nombreActividad.text = activity.nombre;
    widget.objetivosActividad.text = activity.descripcion;
    
    // This is the time where alarms will be activated
    time = activity.time;

    // load activity type, it's a number because it is
    // related with a radio button and it needs the index
    // of the button which is selected
    switch(activity.type){      
      case ActivityType.mental:
        this.selectedType = 1;
        break;
      case ActivityType.recreation:
        this.selectedType = 2;
        break;
      case ActivityType.physical:
        this.selectedType = 0;
        break;
      case ActivityType.care:
        this.selectedType = 3;
        break;
    }

    this.materiales = activity.complements;
    this.actType = activity.type;
    
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FlatButton.icon(
          onPressed: ()=>showPicker(context),
          color: Theme.of(context).bottomAppBarColor,
          icon: Icon(Icons.timer),
          label: Text('Establecer hora')
        ),
      ],
    );
  }

  Future<void> showPicker(BuildContext context) async {
        // Obteniendo hora de la alarma
    if(updateData.isNotEmpty){
      Actividad cuidado = updateData['model_data'];
      time = await showTimePicker(context: context, initialTime: cuidado.time);
    }
    else{
      time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    }
  }

  Widget getSaveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      width: MediaQuery.of(context).size.width * 0.5,
      child: RaisedButton(
        color: Theme.of(context).bottomAppBarColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        onPressed: ()=>saveAlarm(context),
        child: Text(updateData.isEmpty? "Guardar":"Actualizar"),
      )
    );
  }

  Future<void> saveAlarm(BuildContext context) async {  
    // What I actually do, is to delete the current event and its alarms
    // and then I create a new one with the new data
    if(updateData.isNotEmpty){
      Actividad activity = updateData['model_data'];
      await activity.delete();
    }

    return await _newAlarm(context);
  }

  Future<void> _newAlarm(BuildContext context) async {

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
      this.actType ?? ActivityType.recreation,
      this.time,
      daysActive, // this is not the class attribute
      nombre: widget.nombreActividad.text ?? "Sin título",
      descripcion: widget.objetivosActividad.text ?? "Sin objetivos",
      complements: this.materiales
    );

    await activity.save(); // this save this activity/activity in local database

    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('La alarma fué creada')
    ));
  
    Navigator.of(context).pop();
  }

  Widget _getTitleField() {
    return getInputStyle(
      "Nombre", "¿Cómo se llamará la actividad?",
      widget.nombreActividad, Icons.info
    );
  }

  Widget _getDescriptionField() {

    return getInputStyle(
      "Descripción", "¿Cuál es el objetivo de la actividad?",
      widget.objetivosActividad, Icons.description,
      maxLines: null
    );
  }
  
  List<Widget> _getElementList() {

    TextEditingController controller = new TextEditingController();

    return <Widget>[
      ListTile(
        title: Text("Defina su actividad"),
      ),
      _getTitleField(),
      _getDescriptionField(),
      getExpansionTile(
        controller: controller,
        items: this.materiales,
        setState: setState,
        title: "Materiales",
        onPressed: ()=>_getDialog(controller),
      ),
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
      getSaveButton(context)
    ];
  }

  Future<void> _getDialog(TextEditingController controller) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text("Agregar material"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getInputStyle("Nombre", "Nombre del material", controller, Icons.sports_baseball),
            ],
          ),
        ),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.cancel),
            label: Text("Cancelar"),
            onPressed: ()=>Navigator.of(context).pop(),
          ),
          FlatButton.icon(
            icon: Icon(Icons.check_circle),
            label: Text("Guardar"),
            onPressed: ()=>setState((){

              if(this.materiales.indexWhere((element) => (element["title"] == controller.text)) > -1){
                widget.scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: Text("Material ya existe"),
                ));
                return;
              }

              this.materiales.add({
                "title": controller.text
              });
              Navigator.of(context).pop();
            })
          ),
        ],
      )
    );
  }

  IconData _getIconByDay(String key) {
    switch(key.toLowerCase()){
      case "lunes": return Icons.work;
      case "martes": return Icons.wysiwyg;
      case "miercoles": return Icons.airport_shuttle;
      case "jueves": return Icons.insert_emoticon;
      case "viernes": return Icons.pending_actions;
      case "sabado": return Icons.sports_baseball;
      case "domingo": return Icons.wb_sunny;
      default: return Icons.info;
    }
  }


}
