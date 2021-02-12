import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/global/settings.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';
import 'package:utm_vinculacion/widgets/widget.tunned_listtile.dart';

import 'model.activity.dart';

// extensions
import 'package:utm_vinculacion/modules/global/extensions.dart' show StringExt;

class Actividades extends StatefulWidget {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Actividades({Key key}) : super(key: key);

  @override
  _ActividadesState createState() => _ActividadesState();

  static void onDeleteCare(BuildContext context, Actividad item, GlobalKey<ScaffoldState> scaffoldKey){

    bool deleting = false;

    showDialog(
      context: context,
      builder: (contextInternal){
        return AlertDialog(
          title: Text("¡Atención!"),
          content: Text("Está a punto de eliminar esta actividad, ¿desea continuar?"),
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.cancel),
              label: Text("Cancelar"),
              onPressed: ()=>Navigator.of(contextInternal).pop(),
            ),
            FlatButton.icon(
              icon: Icon(Icons.check_circle, color: Colors.red),
              label: Text("Eliminar", style: TextStyle(color: Colors.red)),
              onPressed: ()async{
                if(!deleting){
                  final ok = await Actividades.deleteEvent(item);

                  scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: Text("El cuidado ${ok? "fue eliminado":"no pudo ser eliminado"}"),
                    duration: Duration(seconds: 2),
                  ));

                  Navigator.of(contextInternal).pop();
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      }, 
    );    
  }

  
  static Future<bool> deleteEvent(Actividad item) async {
    return await item.delete();
  }
}

class _ActividadesState extends State<Actividades>{

  final DBProvider dbProvider = DBProvider.db;

  @override
  Widget build(BuildContext context) {

    dbProvider.getActivities();
    
    return Scaffold(
      key: widget._scaffoldKey,
      body: Column(
        children: [
          getHeader(context, "ACTIVIDADES"),
          SizedBox(height: 30.0,),
          Expanded(
            child: SingleChildScrollView(
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
              child: _listaContenido(setState, widget._scaffoldKey)
            )
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
            onTap: ()=>Navigator.of(context).pushNamed(ADDACTIVIDADES),
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

  Widget _listaContenido(Function setState, GlobalKey<ScaffoldState> scaffoldKey){

    return StreamBuilder(
      stream: dbProvider.actividadStream,
      builder: (BuildContext context, AsyncSnapshot<List<Actividad>> snapshot){

        if(!snapshot.hasData) return Center(child: CircularProgressIndicator());                
        if(snapshot.data.isEmpty) return sinDatos();

        final Map<String, dynamic> activityTypes = AppSettings().settings["activities_type"];
        
        final content = new List<Widget>();
        content.addAll(List<Widget>.from(activityTypes.keys.map((String key){

            final String title = activityTypes[key];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: ExpansionTile(
                  tileColor: Theme.of(context).accentColor,
                  textColor: Theme.of(context).canvasColor,   
                  title: Text(title.capitalize(), style: TextStyle(fontWeight: FontWeight.bold),),
                  children: _getActivityData(key, snapshot.data),
                  maintainState: false,
                  initiallyExpanded: true,   
                ),
              ),
            );
          })
        ));

        content.add(SizedBox(height: 50.0,));

        return Column(
          children: content,
        );
      },
    );
  }

  void showEditDeleteOptions(BuildContext context, Actividad item, GlobalKey<ScaffoldState> scaffoldKey) {
    showModalBottomSheet(
      context: context, 
      isDismissible: true,
      builder: (context){
        return SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FlatButton.icon(
                        icon: Icon(Icons.edit),
                        label: Text("Editar"),
                        onPressed: (){
                          Navigator.of(context).pushNamed(
                            ADDACTIVIDADES, 
                            arguments: {
                            "model_data": item
                          });
                        },
                      ),
                      FlatButton.icon(
                        icon: Icon(Icons.delete, color: Colors.red),
                        label: Text("Eliminar", style: TextStyle(color: Colors.red)),
                        onPressed: (){
                          Actividades.onDeleteCare(context, item, scaffoldKey);
                        },
                      ),
                    ],
                  )
                ],
              ),
          ),
        );
      }
    );
  }


  List<Widget> _getActivityData(String key, List<Actividad> fullData) {

    final filteredData = fullData.where((Actividad actividad){
      return actividad.typeString == key;
    });

    return List<Widget>.from(filteredData.map((Actividad activity){

      final trailing = Switch(
        value: activity.estado, 
        onChanged: (value)=>setState((){activity.estado = value;})
      );
      
      return Column(
        children: [
          TunnedListTile(
            activity: activity,
            leadingEvent: ()=>showEditDeleteOptions(context, activity, widget._scaffoldKey),
            trailing: trailing,
          ),
          Divider()
        ],
      );
    }));
  }

}

