import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/water/widget.water_goal_editor.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/input.dart';

import 'model.water.dart';
import 'provider.water.dart';

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
    widget._waterLtsController.text = (widget._provider.model.glassSize).toStringAsFixed(2);
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
    return ListTile(
      title: Text("Editar vaso de agua"),
      subtitle: Text("¿Cuántos mililitros de agua contiene el vaso?"),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: _editGlassEvent,
      ),
    );
  }

  Widget _getAlarmRemainder() {
    return SwitchListTile(
      value: this.alarmsActive ?? false, //TODO: complete this 
      onChanged: (value)=>setState((){this.alarmsActive = value;}),
      title: Text("Alarmas"),
      subtitle: Text("¿Desea que se le recuerde cada vez que deba tomar agua?"),
      secondary: Icon((this.alarmsActive ?? false)? Icons.notifications_active:Icons.notifications_off)
    );
  }

  Widget _getAlarmsSettings() {
    return (!this.alarmsActive)? Container(): Column(
      children: [
        ListTile(
          leading: Text("08:20"),
          title: Text("Hora de inicio"),
          subtitle: Text("¿A qué hora desea tomar el primer vaso de agua?"),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){} //TODO: do this,
          ),
        ),
        ListTile(
          leading: Text("21:20"),
          title: Text("Hora de finalización"),
          subtitle: Text("¿A qué hora desea tomar el último vaso de agua?"),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){} //TODO: do this,
          ),
        ),
      ],
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
          // TODO: storage it in database
          widget._provider.updateGlassContent(int.parse(widget._waterLtsController.text));
          Navigator.of(context).pop();
          widget._scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: Text("El valor del vaso de agua ha sido ajustado"),
          ));
        }

      },
    );
  }

  Form _getGlassContentForm() {
    return Form(
      key: widget._formKey,
      child: getInputStyle(
        "Mililitros de agua",
        "¿Cuántos mililitros de agua contiene el vaso?",
        widget._waterLtsController, null, 
        inputType: TextInputType.numberWithOptions(
          decimal: true,
          signed: false
        ),
        validatorCallback: (number){
          double n = double.parse(number ?? "", (e)=>-1.0);
          
          if(n <= 0) return "El valor ingresado no es válido";

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
}