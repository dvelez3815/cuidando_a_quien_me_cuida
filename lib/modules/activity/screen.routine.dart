import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/activity/model.activity.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';

class Rutina extends StatelessWidget {

  final DBProvider _db = DBProvider.db;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    _db.getActivities();
    
    return Scaffold(
      body: Column(
        children: [
          getHeader(context, size, "MIS EVENTOS"),
          Expanded(
            child: StreamBuilder(
              stream: _db.actividadStream,
              builder: (BuildContext context, AsyncSnapshot<List<Actividad>> snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: _listaContenido(context, snapshot.data),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>onPressedEvent(context),
      ),
    );
  }

  List<Widget> _listaContenido(BuildContext context, List<Actividad> actividadesGenerales){

    // Ordenando por hora
    List<Actividad> maniana = new List<Actividad>();
    List<Actividad> tarde = new List<Actividad>();
    List<Actividad> noche = new List<Actividad>();
    List<Actividad> noDefinida = new List<Actividad>();

    // Filtrando todo 
    for(int i=0; i<actividadesGenerales.length; ++i){

      if(actividadesGenerales[i].time.hour>=6 && actividadesGenerales[i].time.hour<12){
        maniana.add(actividadesGenerales[i]);
      }
      else if(actividadesGenerales[i].time.hour >=12 && actividadesGenerales[i].time.hour<19){
        tarde.add(actividadesGenerales[i]);
      }
      else{        
        noche.add(actividadesGenerales[i]);
      }
    }
    
    final List<Widget> contenido = [];


    List<ListTile> actividadesManania = maniana.map((item){
      return _createActivityTile(context, item);
    }).toList();
    List<ListTile> actividadesTarde = tarde.map((item){
      return _createActivityTile(context, item);
    }).toList();
    List<ListTile> actividadesNoche = noche.map((item){
      return _createActivityTile(context, item);
    }).toList();
    List<ListTile> actividadesND = noDefinida.map((item){
      return _createActivityTile(context, item);
    }).toList();


    if(actividadesNoche.isEmpty) actividadesNoche.add(ListTile(title: Text("Sin eventos"), trailing: Icon(Icons.sentiment_dissatisfied)));
    if(actividadesTarde.isEmpty) actividadesTarde.add(ListTile(title: Text("Sin eventos"), trailing: Icon(Icons.sentiment_dissatisfied)));
    if(actividadesManania.isEmpty) actividadesManania.add(ListTile(title: Text("Sin eventos"), trailing: Icon(Icons.sentiment_dissatisfied)));

    
    // maniana
    // contenido.add(Divider());
    if(noDefinida.isNotEmpty){
      contenido.add(_titleListTile("Sin hora definida", null, actividadesND));
    }
    contenido.add(_titleListTile(
        "Mañana",
        Icon(Icons.wb_sunny, color: Theme.of(context).accentColor), 
        actividadesManania
        )
    );
    contenido.add(_titleListTile(
        "Tarde",
        Icon(Icons.wb_cloudy , color: Theme.of(context).accentColor),
        actividadesTarde
        )
    );
    contenido.add(_titleListTile(
        "Noche",
        Icon(Icons.nights_stay,color: Theme.of(context).accentColor),
        actividadesNoche
      )
    );

    return contenido;

  }

  ListTile _createActivityTile(BuildContext context, Actividad item){
    return new ListTile(
      title: Text(item.nombre ?? "Sin nombre"),
      subtitle: Text(item.descripcion ?? "No disponible"),
      trailing: RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        onPressed: (){
          Navigator.of(context).pushNamed(ADDACTIVIDADES, arguments: {
              "title": item.nombre,
              "description": item.descripcion,
              "model_data": item
            });
        }, 
        icon: Icon(Icons.edit),
        label: Text("Editar")
      ),
      leading: Column(
        children: [
          Text("${item.time.hour}:${item.time.minute}"),
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

  void onPressedEvent(BuildContext context) => Navigator.of(context).pushNamed(ADDACTIVIDADES);
}
