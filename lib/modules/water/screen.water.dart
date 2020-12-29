import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/water/widget.water_circular.dart';
import 'package:utm_vinculacion/user_preferences.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/input.dart';

import 'provider.water.dart';


class WaterScreen extends StatefulWidget {
  final _provider = new WaterProvider();
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _waterLtsController = new TextEditingController();

  @override
  _WaterScreenState createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {

  @override
  void initState() { 
    super.initState();
    widget._waterLtsController.text = ((UserPreferences().glassContent ?? 0.5) * 1000).toStringAsFixed(2);
    widget._provider.init();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: widget._scaffoldKey,
      body: Container(
        child: SingleChildScrollView(
          physics: ScrollPhysics(parent: BouncingScrollPhysics()),
          child: Column(
            children: [
              getHeader(context, size, "AGUA", transparent: true),
              _getBody(context, size)
            ],
          )
        ),
      )
    );
  }

  Widget _getBody(BuildContext context, Size size) {
    return Column(
      children: [
        _getWaterGlassComponent(),
        _getWaterGlassEditor(),
        Center(
          child: FlatButton.icon(
            icon: Icon(Icons.restore),
            label: Text("Reiniciar progreso"),
            onPressed: ()=>widget._provider.restoreProgress()
          ),
        ),
        _getProgressComponent(size),
        _getGoalComponent()
      ],
    );
  }

  Center _getWaterGlassEditor() {
    return Center(
      child: FlatButton.icon(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        icon: Icon(
          Icons.edit,
          size: 14.0,
        ),
        label: Text(
          "Ajustar tamaño del vaso",
          style: TextStyle(fontSize: 14.0),
        ),
        onPressed: (){
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
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
      ),
    );
  }

  FlatButton _getSaveGlassContent() {
    return FlatButton.icon(
      icon: Icon(Icons.save),
      label: Text("Guardar"),
      onPressed: (){

        if(widget._formKey.currentState.validate()){
          // TODO: storage it in database
          widget._provider.updateGlassContent(double.parse(widget._waterLtsController.text)/1000);
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

  Center _getWaterGlassComponent() {
    return Center(
        child: FlatButton.icon(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          icon: Icon(Icons.bubble_chart_rounded, size: 20.0),
          label: Text(
            "Agregar vaso de agua",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: ()=>widget._provider.addWaterLts(),
        ),
      );
  }

  StreamBuilder<double> _getGoalComponent() {
    return StreamBuilder(
      stream: widget._provider.goalStream,
      initialData: 0.0,
      builder: (context, AsyncSnapshot<double> snapshot) {
        return ListTile(
          title: Text("Objetivo diario"),
          subtitle: Text("Tu objetivo diario es beber ${snapshot.data} lts de agua"),
        );
      },

    );
  }

  StreamBuilder<double> _getProgressComponent(Size size) {
    return StreamBuilder(
      stream: widget._provider.progressStream,
      initialData: 0.0,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              fit: StackFit.loose,
              alignment: Alignment.center,
              children: [
                WaterCircular(
                  progress: snapshot.data/widget._provider.goalValue,
                  completed: snapshot.data >= widget._provider.goalValue,
                ),
                (snapshot.data >= widget._provider.goalValue)? Container(
                  width: size.width*0.8,
                  height: size.width*0.8,
                  decoration: BoxDecoration(
                    color: snapshot.data > 6.0?
                          Colors.red.withOpacity(0.6):
                          Theme.of(context).canvasColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(size.width*0.8)
                  ),
                  child: Center(
                    child: Text(
                      snapshot.data > 6.0? "SOBREHIDRATACIÓN":"COMPLETADO",
                      style: TextStyle(
                        fontSize: 30.0, 
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                ):Container()
              ],
            ),
            Divider(),
            ListTile(
              title: Text("Progreso de hoy"),
              subtitle: Text("Hoy has tomado "+snapshot.data.toStringAsFixed(2)+" lts de agua"),
            )
          ],
        );
      },
    );
  }
}