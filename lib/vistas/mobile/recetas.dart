import 'package:flutter/material.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class Recetas extends StatefulWidget {
  Recetas({Key key}) : super(key: key);

  @override
  _RecetasState createState() => _RecetasState();
}

class _RecetasState extends State<Recetas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text('Nombre de la app'), actions: <Widget>[
        tresPuntos()        
      ],),      
      body: Center(child: Text('Aca va a ir la vista de Recetas'),),
    );
  }
}