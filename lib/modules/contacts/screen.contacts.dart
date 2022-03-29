import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';

import 'model.contacts.dart';
import 'package:utm_vinculacion/modules/global/extensions.dart' show StringExt;

class ContactsScreen extends StatelessWidget {

  final _dbProvider = DBProvider.db;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    _dbProvider.getContacts();

    return Scaffold(
      key: this._scaffoldKey,
      body: Column(
        children: [
          getHeader(context, "Contactos"),
          Expanded(child: _getContent(context))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>Navigator.of(context).pushNamed(ADDCONTACT),
      ),
    );
  }

  /// Contains basic information of contacts (title and a short description)
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
	  physics: BouncingScrollPhysics(),
          itemBuilder: (context, index){
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                child: Text(snapshot.data[index].title[0].toUpperCase() ?? '?'),
              ),
              title: Text(snapshot.data[index].title.capitalize() ?? "Sin título"),
              subtitle: Text(snapshot.data[index].description ?? "Sin descripción"),
              trailing: Icon(Icons.settings),
              onTap: ()=> _getOptionAction(context, snapshot.data[index]),
            );
          },
        );

      },
    );

  }

  /// Shows additional information for [contact] such as location and/or webpage
  void _getOptionAction(BuildContext context, Contact contact) {
    
    bool deleting = false;

    showBottomSheet(                  
      elevation: 2.0,
      shape: Border.all(color: Colors.grey[100]),
      context: context,
      clipBehavior: Clip.hardEdge,
      builder: (context) { 
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25,),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("Información del contacto"),
                trailing: IconButton(icon: Icon(Icons.close), onPressed: ()=>Navigator.of(context).pop()),
              ),
              Divider(),
              ListTile(
                title: Text("Nombre"),
                subtitle: Text(contact.title.capitalize() ?? "Sin título"),
              ),
              ListTile(
                title: Text("Localización"),
                subtitle: Text(contact.location ?? "No disponible"),
              ),
              ListTile(
                title: Text("Teléfono"),
                subtitle: Text(contact.phone ?? "Sin teléfono"),
                trailing: Icon(Icons.call),
                onTap: contact.phone ==null? null:()=>launch("tel:${contact.phone}"),
              ),
              ListTile(
                title: Text("Email"),
                subtitle: Text(contact.email ?? "Sin email"),
                trailing: Icon(Icons.email),
                onTap: contact.email != null?()=>launch("${contact.email}"):null,
              ),
              ListTile(
                title: Text("Página web"),
                subtitle: Text(contact.webpage ?? "Desconocida"),
                trailing: Icon(Icons.link),
                onTap: contact.webpage != null?()=>launch("${contact.webpage}"):null
              ),
              ListTile(
                title: Text("Descripción"),
                subtitle: Text(contact.description ?? "Sin descripción"),
              ),

              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.delete),
                    label: Text("Eliminar"),
                    onPressed: ()async{
                      // You can't delete anything if you're already deleting something
                      if(deleting) return;

                      deleting = true; // changing deleting state
                      await _dbProvider.deleteContact(contact); // removing contact from database

                      // closing this widget context
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                        content: Text("Contacto eliminado"),
                      ));

                      // waiting for 500 milliseconds to show a snackbar to user
                      // await Future.delayed(Duration(milliseconds: 500));
                      deleting = false; // restoring deleting state

                    },
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text("Editar"),
                    onPressed: ()=>Navigator.of(context).pushNamed(ADDCONTACT, arguments: contact)
                  ),
                ],
              )
            ],
          ),
        );
      }
    );
  }

}
