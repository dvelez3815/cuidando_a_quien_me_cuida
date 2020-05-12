
import 'package:flutter/material.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart' as constantesRutas;
class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nombre de la app'),),
      body: Center(
        child: RaisedButton(
            child: Text("Garcia, mira el codigo del onpress, asi harás la navegación entre widgets"),
            //Estoy trabajando con una arquitectura de rutas, para crear una nueva ruta primero necesitas definir su nombre en las constantes
            //luego en rutas.dart agregas en el switch case el nombre de esa ruta y lo mandas a esa vista
            onPressed: (){
              Navigator.pushNamed(context, constantesRutas.OtroWidget);
          })
      )
    );
  }
}