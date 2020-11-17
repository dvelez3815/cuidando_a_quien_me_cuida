import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/events/view.event_list.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';

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

    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: widget._scaffoldKey,   
      body: Column(
        children: [
          getHeader(context, size, "BIENESTAR"),
          listaContenido(context, setState, widget._scaffoldKey, true),
        ],
      )
    );
  }
}