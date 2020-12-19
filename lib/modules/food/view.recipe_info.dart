import 'package:flutter/material.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';

import 'model.food.dart';


class InfoReceta extends StatelessWidget {
  final Comida comida;

  const InfoReceta({Key key, this.comida}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Cuidando a quien me cuida"), 
        actions: <Widget>[
          tresPuntos(context)        
        ],
      ),      
      body: ListView(
        children: [
          Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 5)),
          Center(child: Text(comida.nombre,style: TextStyle(fontWeight: FontWeight.bold),),),
          Padding(padding: EdgeInsets.only(top: 7)),
          Divider(),
          Padding(padding: EdgeInsets.only(top: 7)),
          Container(child: Text("Ingredientes: "+(comida.ingredientes).toString()),),
          Padding(padding: EdgeInsets.only(top: 7)),
          Container(child: Center(child: Text("Preparación: ",style: TextStyle(fontWeight: FontWeight.bold),)),),
          Padding(padding: EdgeInsets.only(top: 7)),
          Divider(),
          Container(child: Text(comida.preparacion),),
          Padding(padding: EdgeInsets.only(top: 7)),
          comida.urlImagen != null?Image.asset(comida.urlImagen):Container(),

        ],
      )
        ],
      )
    );
  }
}