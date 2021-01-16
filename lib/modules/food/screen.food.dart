import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';

import 'model.food.dart';

class Recetas extends StatefulWidget {
   
  final DBProvider dbProvider = DBProvider.db;

  @override
  _RecetasState createState() => _RecetasState();
}

class _RecetasState extends State<Recetas> {

  @override
  void initState() {
    widget.dbProvider.getComidas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(      
      body: Column(
        children: [
          getHeader(context, "RECETAS"),
          Expanded(child: _listaContenido()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>Navigator.of(context).pushNamed(ADDPLATOS),
      ),
    );
  }

  Widget _listaContenido(){
    return ListView(
      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
      children: <Widget>[
        StreamBuilder(
          stream: widget.dbProvider.comidaStream,
          builder: (BuildContext context, AsyncSnapshot<List<Comida>> snapshot){
            
            if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
            if(snapshot.data.isEmpty) return sinDatos();

            final List<Widget> widgets = new List<Widget>();

            widgets.addAll(snapshot.data.map((Comida item)=>Column(
              children: [
                _getFoodTile(item),
                Divider()
              ],
            )).toList());

            // This is a blank space to allow user tap on option button
            // of the las tile, because there is the "add" button and
            // the last tile has a little problem to be showed
            widgets.add(SizedBox(height: 50.0));

            return Column(
              children: widgets,
            );
          },
        ),
      ],
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