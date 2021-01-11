import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';
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
          getHeader(context, "Configuración"),
          Expanded(
            child: ListView(
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
              children: [  
                // ListTile(
                //   leading: Icon(Icons.account_box),
                //   title: Text("Cuenta"),
                //   subtitle: Text("Gestione su cuenta de respaldo de datos"),
                //   trailing: Icon(Icons.arrow_forward_ios),
                // ),
                // ListTile(
                //   leading: Icon(Icons.backup),
                //   title: Text("Respaldar datos"),
                //   subtitle: Text("Deberá iniciar sesión primero"),
                //   trailing: Icon(Icons.arrow_forward_ios),
                // ),
                // Divider(),
                SwitchListTile(
                  title: Text("Modo oscuro"),
                  value: UserPreferences().darkMode ?? false,
                  onChanged: (value){UserPreferences().darkMode = value; setState((){});},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text("Políticas de privacidad"),
                  subtitle: Text("Lea las políticas de privacidad de la aplicación"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: ()=>launch("https://www.privacypolicies.com/live/2e4524ea-2df4-4d66-a3d2-e6d4c2d93676"),
                ),
                ListTile(
                  leading: Icon(Icons.verified_user),
                  title: Text("Condiciones de uso"),
                  subtitle: Text("Lea las condiciones de uso de la aplicación"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: ()=>launch("https://www.websitepolicies.com/policies/view/9CSD8301"),
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text("Tutorial de uso"),
                  subtitle: Text("Tutorial de cómo usar la aplicación"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: null,
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}