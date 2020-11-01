import 'package:flutter/material.dart';

import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart';
import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class Actividades extends StatefulWidget {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Actividades({Key key}) : super(key: key);

  @override
  _ActividadesState createState() => _ActividadesState();
}

class _ActividadesState extends State<Actividades> {

  final DBProvider dbProvider = DBProvider.db;

  @override
  void initState() {
    dbProvider.getActividades();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  "Mis Actividades",
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add), 
                  onPressed: (){
                    Navigator.pushNamed(context, ADDACTIVIDADES);
                  },
                )
              ],
            ),
            StreamBuilder(
              stream: dbProvider.actividadStream,
              builder: (BuildContext context, AsyncSnapshot<List<Actividad>> snapshot){

                if(!snapshot.hasData) return sinDatos();

                final List<Widget> widgets = new List<Widget>();

                widgets.addAll(snapshot.data.map((item)=>Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            value: item.estado,
                            onChanged: (status){
                              item.estado = status;
                              setState(() {});
                            },
                            subtitle: Text("${item.descripcion}"),
                            title: Text("${item.nombre ?? "Sin nombre"}"),
                            secondary: Column(
                              children: [
                                Icon(Icons.alarm),
                                Text("${item.date.hour}:${item.date.minute}"),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: (){
                                Navigator.of(context).pushNamed(ADDACTIVIDADES, arguments: {
                                  "title": item.nombre,
                                  "description": item.descripcion,
                                  "activity_model": item
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: ()=>_onDeleteActivity(item)
                            ),
                          ],
                        )
                      ],
                    ),
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

  Future<bool> _deleteActivity(Actividad actividad) async {
    actividad.estado = false;
    return await dbProvider.deleteActivity(actividad);
  }

  void _onDeleteActivity(Actividad item) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("¡Atención!"),
        content: Text("Está a punto de eliminar esta actividad, ¿desea continuar?"),
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
              final ok = await _deleteActivity(item);
              await dbProvider.eliminaActividadAlarmas(item);
              widget._scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: Text("La actividad ${ok? "fue eliminada":"no pudo ser eliminada"}"),
              ));
              Navigator.of(context).pop();
            },
          )
        ],
      )
    );
  }
}

