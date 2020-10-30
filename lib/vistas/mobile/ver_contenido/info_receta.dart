import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/comida_model.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';


class InfoReceta extends StatelessWidget {
  final Comida comida;

  const InfoReceta({Key key, this.comida}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text('Nombre de la app'), actions: <Widget>[
        tresPuntos(context)        
      ],),      
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
          Container(child: Text("Descripción del plato: "+comida.descripcion),),
          Padding(padding: EdgeInsets.only(top: 7)),
          Container(child: Text("Total de calorías: "+comida.calorias),),
          Padding(padding: EdgeInsets.only(top: 7)),
          Container(child: Text("Tiempo de cocción: "+comida.coccion),),
          Padding(padding: EdgeInsets.only(top: 7)),
          Container(child: Text("Tipo de plato: "+comida.tipo),),
          Padding(padding: EdgeInsets.only(top: 7)),
          Container(child: Text("Comensales: "+comida.comensales),),
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