import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/activity/view.event_list.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
class Actividades extends StatefulWidget {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Actividades({Key key}) : super(key: key);

  @override
  _ActividadesState createState() => _ActividadesState();
}

class _ActividadesState extends State<Actividades> with ShowEventList{

  final DBProvider dbProvider = DBProvider.db;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    dbProvider.getActivities();
    return Scaffold(
      key: widget._scaffoldKey,
      body: Column(
        children: [
          getHeader(context, size, "MIS ACTIVIDADES"),
          Expanded(
            child: SingleChildScrollView(
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
              child: listaContenido(context, setState, widget._scaffoldKey, false)
            )
          ),
        ],
      )
    );
  }

}

