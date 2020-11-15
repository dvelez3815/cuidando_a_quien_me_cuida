import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/events/view.event_list.dart';

import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';
import 'package:utm_vinculacion/widgets/widget.circular_banner.dart';

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
          _getBanner(size),
          listaContenido(context, setState, widget._scaffoldKey, true),
        ],
      )
    );
  }

  Widget _getBanner(Size size) {
    return Container(
      width: size.width,
      height: size.height*0.3,
      child: CustomPaint(
        painter: CircularBannerWidget(),
        child: Column(
          children: [
            SafeArea(
              child: ListTile(
                title: Text("Cuidando a quien me cuida", style: TextStyle(color: Colors.white)),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white), 
                  onPressed: ()=>Navigator.of(context).pop()
                ),
                trailing: tresPuntos(context),
              ),
            ),
            SizedBox(height: size.height*0.05),
            Text(
              "CUIDADOS",
              style: TextStyle(
                fontSize: 25.0, 
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            )
          ],
        ),
      ),
    );
  }

}