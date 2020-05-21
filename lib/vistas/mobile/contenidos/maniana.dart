import 'package:flutter/material.dart';
import 'package:utm_vinculacion/providers/actividades_provider.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class Maniana extends StatefulWidget {
  
  const Maniana({Key key}) : super(key: key);

  @override
  _ManianaState createState() => _ManianaState();
}

class _ManianaState extends State<Maniana> {
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
    final actividades = data[0]["mañana"];
    contenido.add(Row(children: <Widget>[Icon(Icons.wb_sunny,color: Colors.yellow,), Text("MAÑANA"),Spacer(),]),);

    contenido.add(Divider());
    
    actividades.forEach((data){
      contenido.add(Container(padding: EdgeInsets.symmetric(horizontal: 2),child: Row(children: <Widget>[convertirStringIcono(data["icono"]), Text(data["nombre"].toString()), Spacer(),Text(data["hora"]),Switch(value: data["estado"], 
      onChanged: (value){setState(() {
      });})],),));
    });
    contenido.add(Divider());
    return contenido;
  }
}