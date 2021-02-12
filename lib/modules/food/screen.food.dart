import 'dart:async';

import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';
import 'package:utm_vinculacion/widgets/components/widget.searchBar.dart';

import 'model.food.dart';

class Recetas extends StatefulWidget {
   
  final DBProvider dbProvider = DBProvider.db;

  @override
  _RecetasState createState() => _RecetasState();
}

class _RecetasState extends State<Recetas> {


  final _elementsStream = new StreamController<List<String>>.broadcast();

  @override
  void initState() {
    widget.dbProvider.getComidas();
    super.initState();
  }

  @override
  void dispose(){
    _elementsStream?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(      
      body: Column(
        children: [
          getHeader(context, "RECETAS"),
          _listaContenido(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>Navigator.of(context).pushNamed(ADDPLATOS),
      ),
    );
  }

  Widget _listaContenido(){
    return StreamBuilder(
      stream: widget.dbProvider.comidaStream,
      builder: (BuildContext context, AsyncSnapshot<List<Comida>> snapshot){
        
        if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
        if(snapshot.data.isEmpty) return sinDatos();

        final List<Widget> widgets = new List<Widget>();

        widgets.add(
          SearchBar(
            elements: snapshot.data.map((i)=>i.nombre).toList(), 
            sink: _elementsStream.sink.add,
          )
        );

        return StreamBuilder(
          stream: _elementsStream.stream,
          initialData: List<String>.from(snapshot.data.map((i)=>i.nombre)),
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot2){
            
            List<Comida> search = snapshot.data.where(
              (element) => snapshot2.data.contains(element.nombre)
            ).toList();

            // Removing all elements to refill with the search ones. It doesn't delete the search bar
            widgets.removeRange(1, widgets.length);

            widgets.addAll(search.map((Comida item)=>Column(
              children: [
                _getFoodTile(item),
                Divider()
              ],
            )).toList());

            // This is a blank space to allow user tap on option button
            // of the las tile, because there is the "add" button and
            // the last tile has a little problem to be showed
            widgets.add(SizedBox(height: 50.0));

            return Expanded(
              child: Column(
                children: [
                  widgets[0],
                  SizedBox(height: 20.0),
                  Expanded(
                    child: ListView(
                      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                      children: widgets.length>1?widgets.sublist(1):[sinDatos(message: "Comida no encontrada")],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _getFoodTile(Comida item) {
    return ListTile(
      onTap: (){
        Navigator.pushNamed(context, INFO_COMIDA, arguments: item);
      },
      leading: Container(
        width: MediaQuery.of(context).size.width*0.2,
        child: item.urlImagen != null?Image.asset(item.urlImagen):Container()
      ),
      title: Text(item.nombre),
      trailing: IconButton(
        icon: Icon(Icons.settings),
        onPressed: (){
          _showEditDeleteOptions(item);
        },
      ),
    );
  }

  Future _showEditDeleteOptions(Comida item) {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Opciones"),
          content: Text("Seleccione una acción"),
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.edit),
              label: Text("Editar"),
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ADDPLATOS, arguments:{
                  "model_data": item
                });
              }
            ),
            FlatButton.icon(
              icon: Icon(Icons.delete, color: Colors.red),
              label: Text("Eliminar", style: TextStyle(color: Colors.red)),
              onPressed: (){
                widget.dbProvider.eliminarComida(item);
                Navigator.of(context).pop();
              }
            ),

          ],
        );
      }
    );
  }
}