import 'package:flutter/material.dart';

import 'package:utm_vinculacion/models/cuidado_model.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart';
import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class Cuidados extends StatefulWidget {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Cuidados({Key key}) : super(key: key);

  @override
  
  _CuidadosState createState() => _CuidadosState();
}


class _CuidadosState extends State<Cuidados> {

  final DBProvider dbProvider = DBProvider.db;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {    
    dbProvider.getCuidados();

    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(elevation: 0,title: Text(NOMBREAPP), actions: <Widget>[
        tresPuntos(context)        
      ],),      
      body: listaContenido()
    );
  }

  Widget listaContenido(){
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Row(
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
                    Navigator.pushNamed(context, ADDCUIDADOS);
                  },
                )
              ],
            ),
            SingleChildScrollView(
              child: StreamBuilder(
                stream: dbProvider.cuidadoStream,
                builder: (BuildContext context, AsyncSnapshot<List<Cuidado>> snapshot){

                  if(!snapshot.hasData) return Center(child: CircularProgressIndicator());                
                  if(snapshot.data.isEmpty) return sinDatos();

                  final List<Widget> widgets = new List<Widget>();

                  widgets.addAll(snapshot.data.map((item)=>Column(
                    children: [
                      alarmTileHead(item),
                      alarmTileBody(item, context),
                      Divider()
                    ],
                  )).toList());

                  return Column(
                    children: widgets,
                  );
                },
              ),
            ),
          ],
        )
      ),
      
    );
  }

  Widget alarmTileBody(Cuidado item, BuildContext context) {
    return ListTile(
      title: _daysListView(item, context),
      trailing: IconButton(
        icon: Icon(Icons.settings),
        onPressed: ()=>showEditDeleteOptions(item),
      )
    );
  }

  SingleChildScrollView _daysListView(Cuidado item, BuildContext context) {
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

  Widget alarmTileHead(Cuidado item) {
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

  Column _showTimeCareInfo(Cuidado item) {
    return Column(
      children: [            
        Icon(Icons.alarm),
        Text("${item.time.hour}:${item.time.minute}"), 
      ],
    );
  }

  void showEditDeleteOptions(Cuidado item) {
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
                    title: Text("Detalles del cuidado"),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: ()=>Navigator.of(context).pop()
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Cuidado"),
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
                          Navigator.of(context).pushNamed(ADDCUIDADOS, arguments: {
                            "title": item.nombre,
                            "description": item.descripcion,
                            "care_model": item
                          });
                        },
                      ),
                      FlatButton.icon(
                        icon: Icon(Icons.delete, color: Colors.red),
                        label: Text("Eliminar", style: TextStyle(color: Colors.red)),
                        onPressed: (){
                          Navigator.of(context).pop();
                          _onDeleteCare(item);
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

  Future<bool> _deleteCare(Cuidado cuidado) async {
    return await cuidado.delete();
  }

  void _onDeleteCare(Cuidado cuidado){

    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("¡Atención!"),
        content: Text("Está a punto de eliminar este cuidado, ¿desea continuar?"),
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
              final ok = await _deleteCare(cuidado);
              widget._scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: Text("El cuidado ${ok? "fue eliminado":"no pudo ser eliminado"}"),
              ));
              Navigator.of(context).pop();
            },
          )
        ],
      )
    );    
  }

}