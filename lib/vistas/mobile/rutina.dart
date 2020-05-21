import 'package:flutter/material.dart';
import 'package:utm_vinculacion/providers/actividades_provider.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart';
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
    
    List actividadesManiana = data[0]["mañana"]; //esta es la data de la mañana.
    
    List actividadesTarde = data[1]["tarde"];
    
    List actividadesNoche = data[2]["noche"];    
    //agrego la cabecera que dice mañana con un sol a la izquierda
    contenido.add(Row(children: <Widget>[Icon(Icons.wb_sunny,color: Colors.yellow,), Text("MAÑANA"),Spacer(),RaisedButton(color: Colors.blue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),onPressed: (){Navigator.pushNamed(context, RUTINAMANIANA);},child: Text("Ver todo"),)]),);

    contenido.add(Divider());
    //este for itera la lista de las actividades de la mañana y así para las otras, por alguna razón que no comprendo flutter me hecha un error cuando hago la expresión data[0]["mañana"] tarde o noche, no encuentro la solución para resolverlo, lo dejaré así ya que luego se cambiará la data del json por la de la db
    for (var i = 0; i < 2; i++) {
      contenido.add(Container(padding: EdgeInsets.symmetric(horizontal: 2),child: Row(children: <Widget>[convertirStringIcono(actividadesManiana[i]["icono"]), Text(actividadesManiana[i]["nombre"].toString()), Spacer(),Text(actividadesManiana[i]["hora"]),Switch(value: actividadesManiana[i]["estado"], 
      onChanged: (value){setState(() {
      });})],),));

    }
    contenido.add(Divider());
    contenido.add(Row(children: <Widget>[Icon(Icons.wb_sunny,color: Colors.grey,), Text("TARDE"),Spacer(),RaisedButton(color: Colors.blue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),onPressed: (){Navigator.pushNamed(context, RUTINATARDE);},child: Text("Ver todo"),)]),);


    contenido.add(Divider());
    for (var i = 0; i < 2; i++) {
      contenido.add(Container(padding: EdgeInsets.symmetric(horizontal: 2),child: Row(children: <Widget>[convertirStringIcono(actividadesManiana[i]["icono"]), Text(actividadesTarde[i]["nombre"].toString()), Spacer(),Text(actividadesTarde[i]["hora"]),Switch(value: actividadesTarde[i]["estado"], 
      onChanged: (value){setState(() {
      });})],),));

    }
    contenido.add(Divider());    
    contenido.add(Row(children: <Widget>[Icon(Icons.airline_seat_individual_suite,color: Colors.grey,), Text("NOCHE"),Spacer(),RaisedButton(color: Colors.blue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),onPressed: (){Navigator.pushNamed(context, RUTINANOCHE);},child: Text("Ver todo"),)]),);

    contenido.add(Divider());
    for (var i = 0; i < 2; i++) {
      contenido.add(Container(padding: EdgeInsets.symmetric(horizontal: 2),child: Row(children: <Widget>[convertirStringIcono(actividadesNoche[i]["icono"]), Text(actividadesNoche[i]["nombre"].toString()), Spacer(),Text(actividadesNoche[i]["hora"]),Switch(value: actividadesNoche[i]["estado"], 
      onChanged: (value){setState(() {
      });})],),));

    }
    contenido.add(Divider());    

    return contenido;
  }
}