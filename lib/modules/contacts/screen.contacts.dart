import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';

import 'model.contacts.dart';
import 'package:utm_vinculacion/modules/global/extensions.dart' show StringExt;

class ContactsScreen extends StatelessWidget {

  final _dbProvider = DBProvider.db;

  @override
  Widget build(BuildContext context) {

    _dbProvider.getContacts();

    return Scaffold(
      body: Column(
        children: [
          getHeader(context, MediaQuery.of(context).size, "Contactos"),
          Expanded(child: _getContent(context))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>Navigator.of(context).pushNamed(ADDCONTACT),
      ),
    );
  }

  Widget _getContent(BuildContext context) {

    return StreamBuilder(
      stream: this._dbProvider.contactStream,
      builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot){
        
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if(snapshot.data.isEmpty) return sinDatos();

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index){
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                child: Text(snapshot.data[index].title[0].toUpperCase() ?? '?'),
              ),
              title: Text(snapshot.data[index].title.capitalize() ?? "Sin título"),
              subtitle: Text(snapshot.data[index].description.capitalize() ?? "Sin descripción"),
              trailing: IconButton(
                icon: Icon(Icons.call),
                onPressed: null,
              ),
            );
          },
        );

      },
    );

  }

}