// Contador de las veces que maldijo cosas
// inexistentes por culpa de este archivo.
// 
// Contador: 1 

import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/water/widget.water_goal_editor.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';

import 'model.water.dart';
import 'provider.water.dart';

class WaterPreferences extends StatefulWidget {

  final _waterLtsController = new TextEditingController();
  final _provider = new WaterProvider();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  _WaterPreferencesState createState() => _WaterPreferencesState();
}

class _WaterPreferencesState extends State<WaterPreferences> {

  bool alarmsActive;

  @override
  void initState() {
    super.initState();

    alarmsActive = widget._provider.model.isActive ?? false;
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
        // _getAlarmRemainder(),
        // Divider(),
        // _getAlarmsSettings()
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

  void _editGlassEvent(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          semanticLabel: "Ajustar vaso de agua",
          content: WaterGoalEditor(
            widget._scaffoldKey,
            maxValue: 500,
            minValue: 50,
            division: 30,
            initialValue: widget._provider.model?.glassSize.toString() ?? "250",
            title: "Ajustar vaso de agua",
            unit: "mililitros",
            unitPrefix: "ml",
          ),
        );
      }
    );
  }

  void _getWaterGoalEditor() {

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ajustar objetivo diario"),
          content: WaterGoalEditor(
            widget._scaffoldKey,
            minValue: 1,
            maxValue: 7,
          )
        );
      }
    );
  }
}
