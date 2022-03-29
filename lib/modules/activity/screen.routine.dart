import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:utm_vinculacion/modules/activity/model.activity.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/widget.tunned_listtile.dart';

class Rutina extends StatelessWidget {

  final DBProvider _db = DBProvider.db;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    _db.getActivities();
    
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          getHeader(context, "EVENTOS"),
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
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        visible: true,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add_box_sharp),     
            label: "Agregar",       
            onTap: ()=>_getAddEvent(context)
          ),
          SpeedDialChild(
            child: Icon(Icons.calendar_today),     
            label: "Calendario",
            onTap: ()=>Navigator.of(context).pushNamed(CALENDAR),
          ),
        ],
      )
    );
  }

  Future _getAddEvent(BuildContext context) {
    return showDialog(
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
            TextButton.icon(
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


    if(actividadesNoche.isEmpty){
      actividadesNoche.add(_getEmptyActivity(context));
    }
    if(actividadesTarde.isEmpty) {
      actividadesTarde.add(_getEmptyActivity(context));
    }
    if(actividadesManania.isEmpty) {
      actividadesManania.add(_getEmptyActivity(context));
    }

    
    // maniana
    // contenido.add(Divider());
    if(noDefinida.isNotEmpty){
      contenido.add(_titleListTile(
        context,
        "Sin hora definida", 
        null, 
        actividadesND)
      );
    }

    contenido.add(SizedBox(height: 30,));

    contenido.add(_titleListTile(
        context,
        "Mañana",
        Icons.ac_unit_rounded,
        actividadesManania
      )
    );
    contenido.add(_titleListTile(
        context,
        "Tarde",
        Icons.wb_cloudy,
        actividadesTarde
      )
    );
    contenido.add(_titleListTile(
        context,
        "Noche",
        Icons.nights_stay,
        actividadesNoche
      )
    );

    return contenido;

  }

  Widget _getEmptyActivity(context) {
    return ListTileTheme(
      tileColor: Theme.of(context).canvasColor,
      child: ListTile(
        title: Text("Sin eventos"), 
        trailing: Icon(Icons.sentiment_dissatisfied)
      ),
    );
  }

  Widget _createActivityTile(BuildContext context, Actividad item){
    
    return Container(
	color: Colors.white,
      child: Column(
        children: [
          TunnedListTile(
            activity: item,
            leadingEvent: ()=>Navigator.of(context).pushNamed(ADDACTIVIDADES, arguments: {"model_data": item, "restricted":true}),
            trailing: Icon(Icons.arrow_forward_ios),
            leadingIcon: Icons.edit,
          ),
          Divider()
        ],
      ),
    );
  }

  Widget _titleListTile(BuildContext context, String title, IconData icon, List<Widget> activities){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: ExpansionTile(
          initiallyExpanded: true,
	  backgroundColor: Theme.of(context).accentColor,
	  collapsedTextColor: Colors.white,
	  collapsedBackgroundColor: Theme.of(context).accentColor,
          leading: Icon(icon, color: Theme.of(context).canvasColor),
	  textColor: Colors.white,
          // tileColor: Theme.of(context).accentColor,
          title: Text(
            title ?? "Sin título",
            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).canvasColor)
          ),
          children: activities
        ),
      ),
    );
  }
}
