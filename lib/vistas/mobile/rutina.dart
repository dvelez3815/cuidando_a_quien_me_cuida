import 'package:flutter/material.dart';

class Rutina extends StatefulWidget {
  Rutina({Key key}) : super(key: key);

  @override
  _RutinaState createState() => _RutinaState();
}

class _RutinaState extends State<Rutina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nombre de la app"),),
      body: Center(child: Text('Aca va a ir la vista de las rutinas'),),
    );
  }
}