import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';

import 'model.food.dart';

class Recetas extends StatefulWidget {
   

  @override
  _RecetasState createState() => _RecetasState();
}

class _RecetasState extends State<Recetas> {

  final DBProvider dbProvider = DBProvider.db;

  _RecetasState(){
    dbProvider.getComidas();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(      
      body: Column(
        children: [
          getHeader(context, size, "RECETAS"),
          listaContenido(),
        ],
      )
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
                  "Mis recetas",
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add), 
                  onPressed: (){
                    Navigator.pushNamed(context, ADDPLATOS);
                  }
                )
              ],
            ),
            StreamBuilder(
              stream: dbProvider.comidaStream,
              builder: (BuildContext context, AsyncSnapshot<List<Comida>> snapshot){
                
                if(!snapshot.hasData) return sinDatos();

                final List<Widget> widgets = new List<Widget>();

                widgets.addAll(snapshot.data.map((item)=>ListTile(
                  onTap: (){
                    //Aca mando los datos de la comida que desea ver y los muestros en info comida
                    Comida comida = item;
                    Navigator.pushNamed(context, INFO_COMIDA, arguments: comida);
                    },            
                  leading: Container(
                    width: MediaQuery.of(context).size.width*0.2,
                    child: item.urlImagen != null?Image.asset(item.urlImagen):Container()
                  ),
                  title: Text(item.nombre),
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
}