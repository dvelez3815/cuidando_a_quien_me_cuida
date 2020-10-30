import "package:flutter/material.dart";
import 'package:utm_vinculacion/local_storage/user_preferences.dart';
import 'package:utm_vinculacion/models/comida_model.dart';
import 'package:utm_vinculacion/models/cuidado_model.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/providers/json_db.dart';

class SettingsPage extends StatefulWidget {

  final DBProvider dbProvider = DBProvider.db;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final JsonToDBProvider jsonProvider = JsonToDBProvider();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: AppBar(
        title: Text("Configuración"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.file_upload),
            title: Text("Cargar cuidados por defecto"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: ()async{
              List<Map<String, dynamic>> data = await widget.jsonProvider.cargaDatosDelJson('recursosexternos/cuidados.json');
              for(Map<String, dynamic> item in data){
                Cuidado cuidado = Cuidado.fromJson(item);
                await widget.dbProvider.nuevoCuidado(cuidado);
              }
              widget.scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text('Cuidados cargados')));
            },
          ),
          ListTile(
            leading: Icon(Icons.file_upload),
            title: Text("Cargar actividades por defecto"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: ()async{
              List<Map<String, dynamic>> data = await widget.jsonProvider.cargaDatosDelJson('recursosexternos/actividades.json');
              for(Map<String, dynamic> item in data){
                Actividad actividad = Actividad.fromJson(item);
                await widget.dbProvider.nuevaActividad(actividad);
              }
              widget.scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text('Actividades cargadas')));
            },
          ),
          ListTile(
            leading: Icon(Icons.file_upload),
            title: Text("Cargar recetas por defecto"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: ()async{
              final List<Map<String, dynamic>> data = await widget.jsonProvider.cargaDatosDelJson('recursosexternos/comidas.json');
              for(Map<String, dynamic> item in data){
                Comida comida = Comida.fromJson(item);
                comida.urlImagen = item['url-imagen'];
                await widget.dbProvider.nuevaComida(comida);
              }
              widget.scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text('Datos de recetas cargados')));
            },
          ),
          Divider(),
          ListTile(title: Text("Ver alarmas"), onTap: ()=>Navigator.of(context).pushNamed("settings/alarms")),
          Divider(),
          SwitchListTile(
            title: Text("Modo oscuro"),
            value: UserPreferences().darkMode ?? false,
            onChanged: (bool value){UserPreferences().darkMode = value; setState((){});},
          )
        ],
      )
    );
  }
}