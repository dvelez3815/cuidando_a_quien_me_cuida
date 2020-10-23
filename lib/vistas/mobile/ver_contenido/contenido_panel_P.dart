import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utm_vinculacion/providers/contenido_provider.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class Contenido extends StatefulWidget {
  
  const Contenido({Key key}) : super(key: key);

  @override
  _ContenidoState createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text('Nombre de la app'), actions: <Widget>[
        tresPuntos(context)        
      ],),
      body: listaContenido()
    );
  }
  Widget listaContenido(){
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: FutureBuilder(
        future: dataContenidoPanel.cargarData(),
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
    String dia = DateFormat('EEEE', 'es').format(DateTime.now()).toString()+" "+DateTime.now().day.toString();
    final List<Widget> contenido = [];
    contenido.add(Container(padding: EdgeInsets.only(left: 20, bottom: 15),child: Text("Contenido"+" |  "+dia,style: TextStyle(fontSize: 17),),));
    data.forEach((dataCiudades){
       contenido..add(ListTile(leading: Container(width: MediaQuery.of(context).size.width*0.2,child: Image.asset(dataCiudades['imagen'])),subtitle: Text(dataCiudades['descripcion']),title:Text(dataCiudades['nombre']),onTap: ()=>Navigator.pushNamed(context, dataCiudades['ruta']),))
       ..add(Divider());
    });
    return contenido;
  }
}