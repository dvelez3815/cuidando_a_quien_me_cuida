import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/activity/model.activity.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';

class Rutina extends StatelessWidget {

  final DBProvider _db = DBProvider.db;

  @override
  Widget build(BuildContext context) {

    _db.getActivities();
    
    return Scaffold(
      body: Column(
        children: [
          getHeader(context, "MIS EVENTOS"),
          Expanded(
            child: StreamBuilder(
              stream: _db.actividadStream,
              builder: (BuildContext context, AsyncSnapshot<List<Actividad>> snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator());
                }

                return ListView(
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  children: _listaContenido(context, snapshot.data),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text("Información"),
                content: Text(
                  "Para agregar una nueva actividad a \"mis eventos\" deberás activar algunas"
                  " de las actividades que se mostrarán a continuación.\n\nPresiona OK para continuar.",
                  textAlign: TextAlign.justify,
                ),
                actions: [
                  FlatButton.icon(
                    icon: Icon(Icons.check_circle),
                    label: Text("OK"),
                    onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, ACTIVIDADES);
                    }
                  )
                ],
              );
            }
          );
        }
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

      if(!actividadesGenerales[i].estado) continue;

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


    List<Widget> actividadesManania = maniana.map((Actividad item)=> _createActivityTile(context, item)).toList();
    List<Widget> actividadesTarde = tarde.map((item)=> _createActivityTile(context, item)).toList();
    List<Widget> actividadesNoche = noche.map((item)=> _createActivityTile(context, item)).toList();
    List<Widget> actividadesND = noDefinida.map((item)=> _createActivityTile(context, item)).toList();


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
        Icon(Icons.ac_unit_rounded, color: Theme.of(context).accentColor), 
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

  Widget _createActivityTile(BuildContext context, Actividad item){
    return Column(
      children: [
        new ListTile(
          title: Text(item.nombre ?? "Sin nombre"),
          leading: Text("${item.time.format(context)}"),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: ()=>Navigator.of(context).pushNamed(ACTIVITY_DETAIL, arguments: item)
        ),
        Divider()
      ],
    );
  }

  Widget _titleListTile(String title, Icon icon, List<Widget> activities){
    return ExpansionTile(
      title: Text(
        title ?? "Sin título",
        style: TextStyle(fontWeight: FontWeight.bold)
      ),
      initiallyExpanded: true,
      leading: icon,
      children: activities,
    );
  }

  void onPressedEvent(BuildContext context) => Navigator.of(context).pushNamed(ADDACTIVIDADES);
}
