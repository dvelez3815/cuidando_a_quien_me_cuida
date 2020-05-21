import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utm_vinculacion/providers/comidas_json_provider.dart';
import 'package:utm_vinculacion/providers/contenido_provider.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class Recetas extends StatefulWidget {
  
  const Recetas({Key key}) : super(key: key);

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
      body: listaContenido()
    );
  }
  Widget listaContenido(){
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: FutureBuilder(
        future: comidaProvider.cargarData(),
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
    List<Widget> contenido = [];
    contenido.add(Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Text("Mis recetas",style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),),Spacer(),IconButton(icon: Icon(Icons.add), onPressed: (){Navigator.pushNamed(context, ADDPLATOS);})],));
    contenido.add(Divider());
    data.forEach((data){
       contenido..add(ListTile(leading: Container(width: MediaQuery.of(context).size.width*0.2,child: Image.asset(data['url-imagen'])),subtitle: Text(data['descripcion']),title:Text(data['nombre']),))
       ..add(Divider());
    });
    return contenido;
  }
}