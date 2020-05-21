import 'package:flutter/material.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class AddPlatos extends StatefulWidget {
  
  AddPlatos({Key key}) : super(key: key);

  @override
  
  _AddPlatosState createState() => _AddPlatosState();
}


class _AddPlatosState extends State<AddPlatos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text('Nombre de la app'), actions: <Widget>[
        tresPuntos()        
      ],),
      body: ListView(
        children: <Widget>[
          new Column(
    children: <Widget>[
      new ListTile(
        leading: const Icon(Icons.fastfood),
        title: new TextField(
          decoration: new InputDecoration(
            hintText: "Nombre del plato",
          ),
        ),
      ),
      new ListTile(
        leading: const Icon(Icons.table_chart),
        title: new TextField(
          decoration: new InputDecoration(
            hintText: "Descripción",
          ),
        ),
      ),
      new ListTile(
        leading: const Icon(Icons.email),
        title: new TextField(
          decoration: new InputDecoration(
            hintText: "Email",
          ),
        ),
      ),
      const Divider(
        height: 1.0,
      ),
      new ListTile(
        leading: const Icon(Icons.label),
        title: const Text('Nick'),
        subtitle: const Text('None'),
      ),
      new ListTile(
        leading: const Icon(Icons.today),
        title: const Text('Birthday'),
        subtitle: const Text('February 20, 1980'),
      ),
      new ListTile(
        leading: const Icon(Icons.group),
        title: const Text('Contact group'),
        subtitle: const Text('Not specified'),
      )
    ],
  ),
        ],
      )
    );
  }
}