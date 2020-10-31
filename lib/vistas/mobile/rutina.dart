import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/cuidado_model.dart';
import 'package:utm_vinculacion/models/global_activity.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';



class Rutina extends StatefulWidget {
  
  const Rutina({Key key}) : super(key: key);

  @override
  _Rutina createState() => _Rutina();
}

class _Rutina extends State<Rutina> {

  final DBProvider _db = DBProvider.db;

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
        future: _listaContenido(),
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }

          if(snapshot.data.isEmpty){
            return ListTile(title: Text("Sin datos"));
          }
          
          return ListView(
            children: snapshot.data,
          );
        },
      ),
    );
  }
  Future<List<Widget>> _listaContenido()async{


    List<GlobalActivity> actividadesGenerales = new List<GlobalActivity>();
    actividadesGenerales.addAll(await _db.getActividades());
    print("yuhuuuuu!");
    actividadesGenerales.addAll(await _db.getCuidados());

    // Ordenando por hora
    List<GlobalActivity> maniana = new List<GlobalActivity>();
    List<GlobalActivity> tarde = new List<GlobalActivity>();
    List<GlobalActivity> noche = new List<GlobalActivity>();

    print("Veamos bro");
    // Filtrando todo 
    
    actividadesGenerales.forEach((element) {
      
      print("Agregando el elemento ${element.nombre}");
      print(element.date.hour);
      if(element.date.hour>=6 && element.date.hour<12){
        maniana.add(element);
      }
      else if(element.date.hour >=12 && element.date.hour<7){
        tarde.add(element);
      }
      else{
        noche.add(element);
      }
    });
    
    
    print("hasta aqui");
    final List<Widget> contenido = [];


    List<ListTile> actividadesManania = maniana.map((item){
      return ListTile(
        title: Text(item.nombre ?? "Sin nombre"),
        subtitle: Text(item.descripcion ?? "No disponible"),
        trailing: Text("${item.date.hour}:${item.date.minute}"),
        leading: Icon((item is Cuidado)? Icons.brightness_medium:Icons.brightness_medium),
      );
    }).toList();
    List<ListTile> actividadesTarde = tarde.map((item){
      return ListTile(
        title: Text(item.nombre ?? "Sin nombre"),
        subtitle: Text(item.descripcion ?? "No disponible"),
        trailing: Text("${item.date.hour}:${item.date.minute}"),
        leading: Icon((item is Cuidado)? Icons.brightness_medium:Icons.brightness_medium),
      );
    }).toList();
    List<ListTile> actividadesNoche = noche.map((item){
      return ListTile(
        title: Text(item.nombre ?? "Sin nombre"),
        subtitle: Text(item.descripcion ?? "No disponible"),
        trailing: Text("${item.date.hour}:${item.date.minute}"),
        leading: Icon((item is Cuidado)? Icons.brightness_medium:Icons.brightness_medium),
      );
    }).toList();
    
    
    contenido.add(Row(children: <Widget>[Icon(Icons.wb_sunny,color: Colors.yellow,), Text("Mañana"),Spacer(),RaisedButton(color: Colors.blue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),onPressed: (){},child: Text("Ver todo"),)]),);
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
