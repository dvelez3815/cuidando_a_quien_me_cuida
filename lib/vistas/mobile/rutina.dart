import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/cuidado_model.dart';
import 'package:utm_vinculacion/models/global_activity.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart';
import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';


class Rutina extends StatelessWidget {

  final DBProvider _db = DBProvider.db;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text(NOMBREAPP), actions: <Widget>[
        tresPuntos(context)        
      ],),
      body: listaContenido(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_to_photos),
        onPressed: ()=>onPressedEvent(context),
      ),
    );
  }

  Widget listaContenido(){
    return Container(
      // padding: EdgeInsets.only(top: 20),
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
    List<Actividad> actividadesDB = (await _db.getActividades()) ?? [];
    List<Cuidado> cuidadosDB = (await _db.getCuidados()) ?? [];

    if(actividadesDB.length > 0)
      actividadesGenerales.addAll(actividadesDB);
    if(cuidadosDB.length > 0)
      actividadesGenerales.addAll(cuidadosDB);


    // Ordenando por hora
    List<GlobalActivity> maniana = new List<GlobalActivity>();
    List<GlobalActivity> tarde = new List<GlobalActivity>();
    List<GlobalActivity> noche = new List<GlobalActivity>();
    List<GlobalActivity> noDefinida = new List<GlobalActivity>();

    
    print("Aqui bro");
    // Filtrando todo 
    for(int i=0; i<actividadesGenerales.length; ++i){

      if(actividadesGenerales[i].date == null){
        noDefinida.add(actividadesGenerales[i]);
      }
      print("Holaaaaa");
      if(actividadesGenerales[i].date.hour>=6 && actividadesGenerales[i].date.hour<12){
        maniana.add(actividadesGenerales[i]);
      }
      else if(actividadesGenerales[i].date.hour >=12 && actividadesGenerales[i].date.hour<19){
        tarde.add(actividadesGenerales[i]);
      }
      else{        
        noche.add(actividadesGenerales[i]);
      }
    }

    print("Here");
    
    final List<Widget> contenido = [];


    List<ListTile> actividadesManania = maniana.map((item){
      return _createActivityTile(item);
    }).toList();
    List<ListTile> actividadesTarde = tarde.map((item){
      return _createActivityTile(item);
    }).toList();
    List<ListTile> actividadesNoche = noche.map((item){
      return _createActivityTile(item);
    }).toList();
    List<ListTile> actividadesND = noDefinida.map((item){
      return _createActivityTile(item);
    }).toList();

    
    print("98");

    if(actividadesNoche.isEmpty) actividadesNoche.add(ListTile(title: Text("Sin actividades"), trailing: Icon(Icons.sentiment_dissatisfied)));
    if(actividadesTarde.isEmpty) actividadesTarde.add(ListTile(title: Text("Sin actividades"), trailing: Icon(Icons.sentiment_dissatisfied)));
    if(actividadesManania.isEmpty) actividadesManania.add(ListTile(title: Text("Sin actividades"), trailing: Icon(Icons.sentiment_dissatisfied)));

    
    // maniana
    // contenido.add(Divider());
    if(noDefinida.isNotEmpty){
      contenido.add(_titleListTile("Sin hora definida", null, actividadesND));
    }
    contenido.add(_titleListTile("Mañana", Icon(Icons.wb_sunny,color: Colors.yellow,), actividadesManania));
    contenido.add(_titleListTile("Tarde", Icon(Icons.wb_sunny,color: Colors.yellow,), actividadesTarde));
    contenido.add(_titleListTile("Noche", Icon(Icons.bedtime,color: Colors.yellow,), actividadesNoche));

    return contenido;

  }

  ListTile _createActivityTile(GlobalActivity item){
    return new ListTile(
      title: Text(item.nombre ?? "Sin nombre"),
      subtitle: Text(item.descripcion ?? "No disponible"),
      trailing: RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        onPressed: (){}, 
        icon: Icon(Icons.edit),
        label: Text("Alarmas")
      ),
      leading: Column(
        children: [
          Text("${item.date.hour}:${item.date.minute}"),
        ],
      ),
    );
  }

  Widget _titleListTile(String title, Icon icon, List<ListTile> activities){
    return ExpansionTile(
      title: Text(title ?? "Sin título"),
      leading: icon,
      children: activities,
    );
  }

  void onPressedEvent(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      child: AlertDialog(
        title: Text("¿Qué tipo de evento desea añadir?", textAlign: TextAlign.center,  ),
        content: Text(
          "Para cancelar o salir toque cualquier lugar fuera de este menú",
          textAlign: TextAlign.center,  
        ),
        actions: [
          FlatButton.icon(
            onPressed: ()=>Navigator.of(context).pushNamed(ADDCUIDADOS, arguments:true),
            icon: Icon(Icons.medical_services_outlined),
            label: Text("Cuidado")
          ),
          FlatButton.icon(
            onPressed: (){
              Navigator.of(context).pushNamed(ADDACTIVIDADES, arguments: true);
            },
            icon: Icon(Icons.event_available_outlined),
            label: Text("Actividad")
          ),
        ],
      )
    );
  }
}
