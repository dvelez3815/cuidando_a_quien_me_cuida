import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/global/settings.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';

import 'model.activity.dart';

// extensions
import 'package:utm_vinculacion/modules/global/extensions.dart' show StringExt;

class Actividades extends StatefulWidget {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Actividades({Key key}) : super(key: key);

  @override
  _ActividadesState createState() => _ActividadesState();
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
          getHeader(context, "MIS ACTIVIDADES"),
          Expanded(
            child: SingleChildScrollView(
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
              child: listaContenido(setState, widget._scaffoldKey)
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>Navigator.of(context).pushNamed(ADDACTIVIDADES),
      ),
    );
  }

  Widget listaContenido(Function setState, GlobalKey<ScaffoldState> scaffoldKey){

    return StreamBuilder(
      stream: dbProvider.actividadStream,
      builder: (BuildContext context, AsyncSnapshot<List<Actividad>> snapshot){

        if(!snapshot.hasData) return Center(child: CircularProgressIndicator());                
        if(snapshot.data.isEmpty) return sinDatos();

        final Map<String, dynamic> activityTypes = AppSettings().settings["activities_type"];
        
        return Column(
          children: List<ExpansionTile>.from(activityTypes.keys.map((String key){

            final String title = activityTypes[key];

            return ExpansionTile(
              title: Text(title.capitalize(), style: TextStyle(fontWeight: FontWeight.bold),),
              maintainState: false,
              initiallyExpanded: true,              
              children: _getActivityData(key, snapshot.data)
            );
          })
        ));
      },
    );
  }

  Widget alarmTileBody(BuildContext context, Actividad item, GlobalKey<ScaffoldState> scaffoldKey) {
    return ListTile(
      title: _daysListView(item, context),
      trailing: RaisedButton.icon(
        icon: Icon(Icons.settings),
        label: Text("Ver más"),
        onPressed: ()=>showEditDeleteOptions(context, item, scaffoldKey),
      )
    );
  }

  Widget _daysListView(Actividad item, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: item.daysToNotify.map((day){
          return Container(
            margin: EdgeInsets.only(right: 5.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              radius: 12.0,            
              child: Text(
                day != "miercoles"? day[0].toUpperCase(): "X", 
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 10.0
                ),
              )
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget alarmTileHead(Actividad item, Function setState) {
  
    return SwitchListTile(
      value: item.estado,
      onChanged: (status){
        item.estado = status;
        setState(() {});
      },
      subtitle: Text(item.descripcion, maxLines: 4, overflow: TextOverflow.ellipsis,),
      title: Text("${item.nombre ?? "Sin nombre"}"),
      secondary: _showTimeCareInfo(item),
    );
  }

  Widget _showTimeCareInfo(Actividad item) {
    return Column(
      children: [            
        Icon(Icons.alarm),
        Text("${item.time.format(context)}"), 
      ],
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
                            "title": item.nombre,
                            "description": item.descripcion,
                            "model_data": item
                          });
                        },
                      ),
                      FlatButton.icon(
                        icon: Icon(Icons.delete, color: Colors.red),
                        label: Text("Eliminar", style: TextStyle(color: Colors.red)),
                        onPressed: (){
                          _onDeleteCare(context, item, scaffoldKey);
                        },
                      ),
                      // FlatButton.icon(
                      //   icon: Icon(Icons.info),
                      //   label: Text("Ver más",),
                      //   onPressed: ()=>Navigator.pushNamed(context, ACTIVITY_DETAIL, arguments: item)
                      // )
                    ],
                  )
                ],
              ),
          ),
        );
      }
    );
  }

  Future<bool> deleteEvent(Actividad item) async {
    return await item.delete();
  }

  void _onDeleteCare(BuildContext context, Actividad item, GlobalKey<ScaffoldState> scaffoldKey){

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
                  final ok = await deleteEvent(item);

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

  List<Widget> _getActivityData(String key, List<Actividad> fullData) {

    final filteredData = fullData.where((Actividad actividad){
      return actividad.typeString == key;
    });

    return List<Widget>.from(filteredData.map((Actividad activity){
      
      final leading = new Column(
        children: [
          Icon(Icons.alarm),
          Text(activity.time.format(context))
        ],
      );

      final body = new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            activity.nombre,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
          ),
          _daysListView(activity, context),
        ],
      );

      final trailing = new Column(
        children: [
          Switch(value: activity.estado, onChanged: (value)=>setState((){activity.estado = value;})),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: ()=>showEditDeleteOptions(context, activity, widget._scaffoldKey),
          ),
        ],
      );
      
      return GestureDetector(        
        onTap: ()=>Navigator.pushNamed(context, ACTIVITY_DETAIL, arguments: activity),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  leading, SizedBox(width: 15.0,), Expanded(child: body), trailing
                ],
              ),
              Divider()
            ],
          ),
        ),
      );
    }));
  }

}

