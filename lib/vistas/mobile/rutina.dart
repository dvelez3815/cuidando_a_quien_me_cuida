import 'package:flutter/material.dart';
import 'package:utm_vinculacion/providers/actividades_provider.dart';
import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';



class Rutina extends StatefulWidget {
  
  const Rutina({Key key}) : super(key: key);

  @override
  _Rutina createState() => _Rutina();
}

class _Rutina extends State<Rutina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text(NOMBREAPP), actions: <Widget>[
        tresPuntos(context)        
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
        builder: (BuildContext context, snapshot){
          return ListView(
            children: _listaContenido(snapshot.data),
          );

        },
      ),
    );
  }
  List<Widget> _listaContenido(data){
    
    final List<Widget> contenido = [];
    List<Container> actividadesManania = new List<Container>();
    List<Container> actividadesTarde = new List<Container>();
    List<Container> actividadesNoche = new List<Container>();
    
    
    for (var item in data) {
      int hora = int.parse(item["hora"].replaceAll(new RegExp(':'),'')); 

       if(hora>0100 && hora <= 1200){
         
         actividadesManania.add(Container(padding: EdgeInsets.symmetric(horizontal: 2),child: Row(children: <Widget>[convertirStringIcono(item["icono"]), Text(item["nombre"].toString()), Spacer(),Text(item["hora"]),Switch(value: item["estado"], 
      onChanged: (value){setState(() {
      });})],),));    
       }else if(hora>1200 && hora<1900){
         actividadesTarde.add(Container(padding: EdgeInsets.symmetric(horizontal: 2),child: Row(children: <Widget>[convertirStringIcono(item["icono"]), Text(item["nombre"].toString()), Spacer(),Text(item["hora"]),Switch(value: item["estado"], 
      onChanged: (value){setState(() {
      });})],),));    
       }else{
         actividadesNoche.add(Container(padding: EdgeInsets.symmetric(horizontal: 2),child: Row(children: <Widget>[convertirStringIcono(item["icono"]), Text(item["nombre"].toString()), Spacer(),Text(item["hora"]),Switch(value: item["estado"], 
      onChanged: (value){setState(() {
      });})],),));    
       }

    }
    contenido.add(Row(children: <Widget>[Icon(Icons.wb_sunny,color: Colors.yellow,), Text("Mañana"),Spacer()]),);

    contenido.add(Divider());

    contenido.add(Column(children: actividadesManania,));  

    //tarde
    contenido.add(Row(children: <Widget>[Icon(Icons.wb_sunny,color: Colors.yellow,), Text("Tarde"),Spacer()]),);

    contenido.add(Divider());

    contenido.add(Column(children: actividadesTarde,));  

    //noche
    contenido.add(Row(children: <Widget>[Icon(Icons.airline_seat_flat,color: Colors.grey,), Text("Noche"),Spacer()]),);

    contenido.add(Divider());

    contenido.add(Column(children: actividadesNoche,));  
    return contenido;

  }
}
