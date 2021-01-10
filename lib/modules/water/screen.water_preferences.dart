// Contador de las veces que maldijo cosas
// inexistentes por culpa de este archivo.
// 
// Contador: 1 

import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/alarms/model.alarm.dart';
import 'package:utm_vinculacion/modules/water/widget.water_goal_editor.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/input.dart';

import 'model.water.dart';
import 'provider.water.dart';

// TODO: Remember that you need to provide the 'waterReminder' key in json from DB

class WaterPreferences extends StatefulWidget {
  
  final _waterLtsController = new TextEditingController();
  final _provider = new WaterProvider();
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  _WaterPreferencesState createState() => _WaterPreferencesState();
}

class _WaterPreferencesState extends State<WaterPreferences> {

  bool alarmsActive;

  @override
  void initState() {
    super.initState();

    alarmsActive = false;
    widget._waterLtsController.text = widget._provider.model.glassSize.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              getHeader(context, "Preferencias Agua"),
              _getOptions()
            ],
          ),
        ),
      ),
    );
  }

  Widget _getOptions() {
    return Column(
      children: [
        _getGoalComponent(),
        _getGlassEditor(),
        _getAlarmRemainder(),
        Divider(),
        _getAlarmsSettings()
      ],
    );
  }

  StreamBuilder<WaterModel> _getGoalComponent() {
    return StreamBuilder(
      stream: widget._provider.modelStream,
      builder: (BuildContext context, AsyncSnapshot<WaterModel> snapshot) {

        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListTile(
          title: Text("Objetivo diario"),
          subtitle: Text("Tu objetivo diario es beber ${snapshot.data.goal} lts de agua"),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: _getWaterGoalEditor
          ),
        );
      },

    );
  }

  Widget _getGlassEditor() {
    return StreamBuilder<WaterModel>(
      stream: widget._provider.modelStream,
      builder: (BuildContext context, AsyncSnapshot<WaterModel> snapshot) {

        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }

        return ListTile(
          title: Text("Editar vaso de agua"),
          subtitle: Text("Actualmente el vaso es de ${snapshot.data.glassSize} ml"),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editGlassEvent,
          ),
        );
      }
    );
  }

  Widget _getAlarmRemainder() {
    return SwitchListTile(
      value: this.alarmsActive ?? false,
      onChanged: (value)=>setState((){this.alarmsActive = value;}),
      title: Text("Alarmas"),
      subtitle: Text("¿Desea que se le recuerde cada vez que deba tomar agua?"),
      secondary: Icon((this.alarmsActive ?? false)? Icons.notifications_active:Icons.notifications_off)
    );
  }

  Widget _getAlarmsSettings() {
    return (!this.alarmsActive)? Container(): StreamBuilder<WaterModel>(
      stream: widget._provider.modelStream,
      builder: (context, AsyncSnapshot<WaterModel> snapshot) {

        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            ListTile(
              leading: Text("${snapshot.data.startTime.format(context)}"),
              title: Text("Hora de inicio"),
              subtitle: Text("¿A qué hora desea tomar el primer vaso de agua?"),
            ),
            ListTile(
              leading: Text("${snapshot.data.endTime.format(context)}"),
              title: Text("Hora de finalización"),
              subtitle: Text("¿A qué hora desea tomar el último vaso de agua?"),
            ),
          ],
        );
      }
    );
  }


  void _editGlassEvent(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          semanticLabel: "Ajustar objetivo de litros de agua",
          title: Text("Ajustar vaso de agua"),
          content:_getGlassContentForm(),
          actions: [
            FlatButton.icon(
              onPressed: ()=>Navigator.of(context).pop(),
              icon: Icon(Icons.cancel),
              label: Text("Cancelar"),
            ),
            _getSaveGlassContent(),
          ],
        );
      }
    );
  }

  FlatButton _getSaveGlassContent() {
    return FlatButton.icon(
      icon: Icon(Icons.save),
      label: Text("Guardar"),
      onPressed: (){

        if(widget._formKey.currentState.validate()){
          widget._provider.updateGlassContent(int.parse(widget._waterLtsController.text));
          Navigator.of(context).pop();
          widget._scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: Text("El valor del vaso de agua ha sido ajustado"),
          ));
        }

      },
    );
  }

  Widget _getGlassContentForm() {
    return Form(
      key: widget._formKey,
      child: getInputStyle(
        "Mililitros de agua",
        "¿Cuántos mililitros de agua contiene el vaso?",
        widget._waterLtsController, null, 
        inputType: TextInputType.numberWithOptions(
          decimal: false,
          signed: false
        ),
        validatorCallback: (number){
          int n = int.parse(number ?? "", onError: (err)=>-1);
          
          if(n <= 0) return "Valor no válido. Ingrese un entero";
          if(n < 200) return "El tamaño mínimo es 200 ml";

          return null;
        }
      ),
    );
  }


  void _getWaterGoalEditor() {

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ajustar objetivo diario"),
          content: WaterGoalEditor(widget._scaffoldKey)
        );
      }
    );
  }

  Future<void> _createAlarmsEvent() async {

    // Validate that glass Size is not bigger than goal size
    final WaterModel waterModel = widget._provider.model;
    final int howManyReminders = waterModel.goal ~/ (waterModel.glassSize / 1000);
    
    // How many minutes are between start and end date
    final int timeDiff = waterModel.timeDiff;

    final startAlarm = new AlarmModel(
      DateTime.monday, 
      waterModel.startTime, 
      "Beber agua", "Recuerda mantenerte hidratado",
      interval: timeDiff ~/ howManyReminders
    );

    // startAlarm.activate();



  }

  // Future<void> _showDefineHourAlert({bool isStart = true}) async {
    
  //   final selectedTime = await showTimePicker(
  //     context: context,
  //     initialTime: widget._provider.model.startTime,
  //     helpText: "¿A qué hora desea que inicien los recordatorios?",
  //     initialEntryMode: TimePickerEntryMode.dial,
  //     confirmText: "Guardar",
  //     cancelText: "Cancelar",
  //   );

  //   if(selectedTime==null) return;

  //   try{
  //     if(isStart) widget._provider.model.startTime = selectedTime;
  //     else widget._provider.model.endTime = selectedTime;
  //   }catch(error){
  //     showAlertDialog(error);
  //     return;
  //   }

  // }

  void showAlertDialog(Object obj) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(
            "El periodo de tiempo entre las alarmas de inicio y fin es muy corto"
            ".\nAumenta el tamaño del vaso o reduce tu objetivo diario."
          ),
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.check_circle),
              label: Text("Aceptar"),
              onPressed: ()=>Navigator.of(context).pop(),
            )
          ],
        );
      }
    );
  }
}