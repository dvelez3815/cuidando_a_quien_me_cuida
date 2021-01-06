import 'package:flutter/material.dart';

import 'provider.water.dart';

class WaterGoalEditor extends StatefulWidget {

  final _provider = new WaterProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey;

  final _maxValue = 7.0;
  final _minValue = 2.0;

  WaterGoalEditor(this._scaffoldKey);

  @override
  _WaterGoalEditorState createState() => _WaterGoalEditorState();
}

class _WaterGoalEditorState extends State<WaterGoalEditor> {

  TextEditingController _goalEditController;

  @override
  void initState() {
    this._goalEditController = new TextEditingController();
    this._goalEditController.text = widget._provider.model.goal.toStringAsFixed(2);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Ingrese el valor en litros"),
          Slider(
            divisions: (2 * (widget._maxValue - widget._minValue))~/1,
            onChanged: (value)=>setState(()=>this._goalEditController.text = value.toStringAsFixed(2)),
            value: double.parse(this._goalEditController.text ?? '0', (error)=>0.0),
            label: (this._goalEditController.text ?? '0') + " Lts",
            min: widget._minValue,
            max: widget._maxValue,
          ),
          Text("Objetivo cambiado a ${this._goalEditController.text ?? 0} Lts"),
          SizedBox(height: 10,),
          (double.parse(this._goalEditController.text) < 7)? 
            Container():
            Text(
              "¡Cuidado con la sobrehidratación!",
              style: TextStyle(fontSize: 12.0, color: Colors.red)
          ),
          SizedBox(height: 30,),
          _getActionButtons()
        ],
      ),
    );
  }

  Widget _getActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton.icon(
          icon: Icon(Icons.cancel),
          label: Text("Cancelar"),
          onPressed: ()=>Navigator.of(context).pop(),
        ),
        FlatButton.icon(
          icon: Icon(Icons.check_circle),
          label: Text("Aceptar"),
          onPressed: ()async{
            await widget._provider.updateGoal(double.parse(this._goalEditController.text ?? "3.0"));
            Navigator.of(context).pop();
            
            widget._scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: Text("Objetivo actualizado"),
            ));
          }
        ),
      ],
    );
  }
}