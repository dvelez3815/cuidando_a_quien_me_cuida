import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/events/view.event_list.dart';

import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class Cuidados extends StatefulWidget {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Cuidados({Key key}) : super(key: key);

  @override
  
  _CuidadosState createState() => _CuidadosState();
}


class _CuidadosState extends State<Cuidados> with ShowEventList{

  final DBProvider dbProvider = DBProvider.db;

  @override
  Widget build(BuildContext context) { 
    dbProvider.getCuidados();

    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(elevation: 0,title: Text(NOMBREAPP), actions: <Widget>[
        tresPuntos(context)        
      ],),      
      body: listaContenido(context, setState, widget._scaffoldKey, true)
    );
  }

}