import "package:flutter/material.dart";
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/user_preferences.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';

class SettingsPage extends StatefulWidget {

  final DBProvider dbProvider = DBProvider.db;
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
      body: Column(
        children: [
          getHeader(context, MediaQuery.of(context).size, "Configuración"),
          Expanded(
            child: ListView(
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
              children: [  
                ListTile(title: Text("Ver alarmas"), onTap: ()=>Navigator.of(context).pushNamed("settings/alarms")),
                Divider(),
                SwitchListTile(
                  title: Text("Modo oscuro"),
                  value: UserPreferences().darkMode ?? false,
                  onChanged: (bool value){UserPreferences().darkMode = value; setState((){});},
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}