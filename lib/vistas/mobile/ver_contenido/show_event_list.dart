import 'package:flutter/material.dart';

import 'package:utm_vinculacion/models/cuidado_model.dart';
import 'package:utm_vinculacion/models/global_activity.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class ShowEventList {

  final db = DBProvider.db;

  Widget listaContenido(BuildContext context, Function setState, GlobalKey<ScaffoldState> scaffoldKey, bool isCare){
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
        child: Column(
          children: <Widget>[
            _headListTile(context, isCare),
            StreamBuilder(
                stream: isCare? db.cuidadoStream:db.actividadStream,
                builder: (BuildContext context, AsyncSnapshot<List<GlobalActivity>> snapshot){

                  if(!snapshot.hasData) return Center(child: CircularProgressIndicator());                
                  if(snapshot.data.isEmpty) return sinDatos();

                  final List<Widget> widgets = new List<Widget>();

                  widgets.addAll(snapshot.data.map((item)=>Column(
                    children: [
                      alarmTileHead(item, setState),
                      alarmTileBody(context, item, scaffoldKey),
                      Divider()
                    ],
                  )).toList());

                  return Column(
                    children: widgets,
                  );
                },
              ),
          ],
        )
      ),
      
    );
  }

  Widget _headListTile(BuildContext context, bool isCare) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Cuidados",
          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.add), 
          onPressed: (){
            Navigator.pushNamed(context, isCare? ADDCUIDADOS:ADDACTIVIDADES);
          },
        )
      ],
    );
  }

  Widget alarmTileBody(BuildContext context, GlobalActivity item, GlobalKey<ScaffoldState> scaffoldKey) {
    return ListTile(
      title: _daysListView(item, context),
      trailing: IconButton(
        icon: Icon(Icons.settings),
        onPressed: ()=>showEditDeleteOptions(context, item, scaffoldKey),
      )
    );
  }

  Widget _daysListView(GlobalActivity item, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: item.daysToNotify.map((day){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
            margin: EdgeInsets.only(right: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Theme.of(context).accentColor
            ),
            child: Text(
              day.toUpperCase(), 
              style: TextStyle(
                color: Theme.of(context).canvasColor,
                fontSize: 10.0
              ),
            )
          );
        }).toList(),
      ),
    );
  }

  Widget alarmTileHead(GlobalActivity item, Function setState) {
  
    return SwitchListTile(
      value: item.estado,
      onChanged: (status){
        item.estado = status;
        setState(() {});
      },
      subtitle: Text(item.descripcion),
      title: Text("${item.nombre ?? "Sin nombre"}"),
      secondary: _showTimeCareInfo(item),
    );
  }

  Widget _showTimeCareInfo(GlobalActivity item) {
    return Column(
      children: [            
        Icon(Icons.alarm),
        Text("${item.time.hour}:${item.time.minute}"), 
      ],
    );
  }

  void showEditDeleteOptions(BuildContext context, GlobalActivity item, GlobalKey<ScaffoldState> scaffoldKey) {
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
                  ListTile(
                    title: Text((item is Cuidado)?"Cuidado":"Actividad"),
                    subtitle: Text(item.nombre,),
                  ),
                  ListTile(
                    title: Text("Descripción"),
                    subtitle: Text(item.descripcion,),
                  ),
                  ListTile(
                    title: Text("Días para notificar"),
                    subtitle: _daysListView(item, context)
                  ),
                  ListTile(
                    title: Text("Hora para notificar"),
                    subtitle: Text("${item.time.hour}:${item.time.minute}")
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FlatButton.icon(
                        icon: Icon(Icons.edit),
                        label: Text("Editar"),
                        onPressed: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(
                            (item is Cuidado)? ADDCUIDADOS:ADDACTIVIDADES, 
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
                          Navigator.of(context).pop();
                          _onDeleteCare(context, item, scaffoldKey);
                        },
                      )
                    ],
                  )
                ],
              ),
          ),
        );
      }
    );
  }

  Future<bool> deleteEvent(GlobalActivity item) async {
    return await item.delete();
  }

  void _onDeleteCare(BuildContext context, GlobalActivity item, GlobalKey<ScaffoldState> scaffoldKey){

    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("¡Atención!"),
        content: Text("Está a punto de eliminar est${(item is Cuidado)? "e cuidado":"a actividad"}, ¿desea continuar?"),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.cancel),
            label: Text("Cancelar"),
            onPressed: ()=>Navigator.of(context).pop(),
          ),
          FlatButton.icon(
            icon: Icon(Icons.check_circle, color: Colors.red),
            label: Text("Eliminar", style: TextStyle(color: Colors.red)),
            onPressed: ()async{
              Navigator.of(context).pop();
              final ok = await deleteEvent(item);
              scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: Text("El cuidado ${ok? "fue eliminado":"no pudo ser eliminado"}"),
              ));
            },
          )
        ],
      )
    );    
  }
}