import 'package:flutter/material.dart';

import 'provider.water.dart';

class WaterGoalEditor extends StatefulWidget {

  final _provider = new WaterProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey;

  final double maxValue;// = 7.0;
  final double minValue; // = 2.0;
  final String title;
  final String unit;
  final String unitPrefix;
  final int division;
  final String initialValue;

  WaterGoalEditor(this._scaffoldKey, {
    @required this.maxValue, 
    @required this.minValue, this.title, this.unit, this.unitPrefix, this.division, this.initialValue});

  @override
  _WaterGoalEditorState createState() => _WaterGoalEditorState();
}

class _WaterGoalEditorState extends State<WaterGoalEditor> {

  TextEditingController _goalEditController;

  @override
  void initState() {
    this._goalEditController = new TextEditingController();
    this._goalEditController.text = widget.initialValue ?? widget._provider.model.goal.toStringAsFixed(2);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title ?? "Ingrese el valor en ${widget.unit ?? "litros"}"),
          Slider(
            divisions: widget.division ?? (4 * (widget.maxValue - widget.minValue))~/1,
            onChanged: (value)=>setState(()=>this._goalEditController.text = value.toStringAsFixed(2)),
            value: double.parse(this._goalEditController.text ?? '0', (error)=>0.0),
            label: (this._goalEditController.text ?? '0') + " "+(widget.unitPrefix ?? "Lts"),
            min: widget.minValue,
            max: widget.maxValue,
          ),
          Text("Valor cambiado a ${this._goalEditController.text ?? 0} ${widget.unitPrefix ?? "Lts"}"),
          SizedBox(height: 10,),
          (double.parse(this._goalEditController.text) < 7 || widget.unit != null)? 
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

            if(widget.unit != null) {
              await widget._provider.updateGlassContent(double.parse(this._goalEditController.text ?? "250") ~/1);
            }
            else {
              await widget._provider.updateGoal(double.parse(this._goalEditController.text ?? "3.0"));
            }
            Navigator.of(context).pop();
            widget._scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: Text("Valor actualizado"),
            ));
          }
        ),
      ],
    );
  }
}
