import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/activity/model.activity.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';

import 'model.events.dart';


class Rutina extends StatelessWidget {

  final DBProvider _db = DBProvider.db;

  @override
  Widget build(BuildContext context) {

    _db.initAllEvents().then((i)=>print("Todas las actividades inicializadas"));
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Column(
        children: [
          getHeader(context, size, "MIS EVENTOS"),
          Expanded(
            child: StreamBuilder(
              stream: _db.todoContenidoStream,
              builder: (BuildContext context, AsyncSnapshot<List<GlobalActivity>> snapshot){
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
        child: Icon(Icons.add_to_photos),
        onPressed: ()=>onPressedEvent(context),
      ),
    );
  }

  List<Widget> _listaContenido(BuildContext context, List<GlobalActivity> actividadesGenerales){

    // Ordenando por hora
    List<GlobalActivity> maniana = new List<GlobalActivity>();
    List<GlobalActivity> tarde = new List<GlobalActivity>();
    List<GlobalActivity> noche = new List<GlobalActivity>();
    List<GlobalActivity> noDefinida = new List<GlobalActivity>();

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

  ListTile _createActivityTile(BuildContext context, GlobalActivity item){
    return new ListTile(
      title: Text(item.nombre ?? "Sin nombre"),
      subtitle: Text(item.descripcion ?? "No disponible"),
      trailing: RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        onPressed: (){
          if(item is Actividad){
            Navigator.of(context).pushNamed(ADDACTIVIDADES, arguments: {
              "title": item.nombre,
              "description": item.descripcion,
              "model_data": item
            });
          }
          else{
            Navigator.of(context).pushNamed(ADDCUIDADOS, arguments: {
              "title": item.nombre,
              "description": item.descripcion,
              "model_data": item
            });
          }
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
            onPressed: ()=>Navigator.of(context).pushNamed(ADDCUIDADOS),
            icon: Icon(Icons.emoji_emotions),
            label: Text("Cuidado")
          ),
          FlatButton.icon(
            onPressed: (){
              Navigator.of(context).pushNamed(ADDACTIVIDADES);
            },
            icon: Icon(Icons.directions_run),
            label: Text("Actividad")
          ),
        ],
      )
    );
  }

  
}
