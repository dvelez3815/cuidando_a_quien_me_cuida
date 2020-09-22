import 'package:flutter/material.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class Actividades extends StatefulWidget {
  Actividades({Key key}) : super(key: key);

  @override
  _ActividadesState createState() => _ActividadesState();
}

class _ActividadesState extends State<Actividades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text('Nombre de la app'), actions: <Widget>[
        tresPuntos()        
      ],),      
      body: Center(child: Text('Aca va a ir la vista de Actividades'),),
    );
  }
}