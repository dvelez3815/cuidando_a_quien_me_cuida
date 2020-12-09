import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  final DBProvider dbProvider = DBProvider.db;

  _ContactScreenState(){
    dbProvider.getComidas();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(      
      body: Column(
        children: [
          getHeader(context, size, "CONTACTOS"),
          ListTile(leading: Icon(Icons.people), title: Text("Contactos de emergencia")),
          Expanded(child: _getBody())
        ],
      )
    );
  }

  Widget _getBody() {
    return ListView(
      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
      children: [
        ListTile(title: Text("A"),),
        _getContact("Admin", "09xxxxxxxx"),
        ListTile(title: Text("F"),),
        _getContact("Fulana", "09xxxxxxxx"),
        _getContact("Fulano", "09xxxxxxxx"),
        ListTile(title: Text("M"),),
        _getContact("Mamá", "09xxxxxxxx"),        
        ListTile(title: Text("P"),),
        _getContact("Papá", "09xxxxxxxx"),
        _getContact("Person 1", "09xxxxxxxx"),
        ListTile(title: Text("U"),),
        _getContact("Usuario 1", "09xxxxxxxx"),
      ],
    );
  }

  Widget _getContact(String user, String phone) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.toUpperCase()[0]),
      ),
      title: Text(user ?? "Sin nombre"),
      subtitle: Text(phone),
      trailing: IconButton(
        icon: Icon(Icons.phone),
        onPressed: (){},
      ),
    );
  }

}