import 'package:flutter/material.dart';
import 'package:utm_vinculacion/providers/actividades_provider.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart';

import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';
class Tarde extends StatefulWidget {
  
  const Tarde({Key key}) : super(key: key);

  @override
  _TardeState createState() => _TardeState();
}

class _TardeState extends State<Tarde> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text('Nombre de la app'), actions: <Widget>[
        tresPuntos()        
      ],),
      body: listaContenido()
    );
  }
  Widget listaContenido(){
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: FutureBuilder(
        future: actividadesProvider.cargarData(),
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
          return ListView(
            children: _listaContenido(snapshot.data),
          );

        },
      ),
    );
  }
  List<Widget> _listaContenido(List<dynamic> data){
    final List<Widget> contenido = [];
    List actividadesTarde = data[1]["tarde"];
    contenido.add(Row(children: <Widget>[Icon(Icons.wb_sunny,color: Colors.grey,), Text("TARDE"),Spacer()]),);


    contenido.add(Divider());
    for (var i = 0; i < actividadesTarde.length; i++) {
      contenido.add(Container(padding: EdgeInsets.symmetric(horizontal: 2),child: Row(children: <Widget>[convertirStringIcono(actividadesTarde[i]["icono"]), Text(actividadesTarde[i]["nombre"].toString()), Spacer(),Text(actividadesTarde[i]["hora"]),Switch(value: actividadesTarde[i]["estado"], 
      onChanged: (value){setState(() {
      });})],),));

    }

    return contenido;
  }
}