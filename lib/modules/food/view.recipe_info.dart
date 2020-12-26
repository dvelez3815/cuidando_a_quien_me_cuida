import 'package:flutter/material.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';

import 'model.food.dart';


class InfoReceta extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Comida food = ModalRoute.of(context).settings.arguments;

    return Scaffold(  
      body: Column(
        children: [
          getHeader(context, MediaQuery.of(context).size, "Receta"),
          Expanded(child: _getContent(food)),
        ],
      )
    );
  }

  ListView _getContent(Comida food) {
    return ListView(
      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.food_bank),
              title: Text("Nombre"),
              subtitle: Text(food.nombre ?? "Sin nombre"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Imágen de la receta"),
            ),
            food.urlImagen != null?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  food.urlImagen,
                  fit: BoxFit.cover,
                  height: 200.0,
                ),
              ],
            ):ListTile(title: Text("No hay imágen")),
            Divider(),
            ListTile(
              leading: Icon(Icons.restaurant),
              title: Text("Preparación"),
              subtitle: Text(food.preparacion ?? "Sin descripción"),
            ),
            Divider(),
            ExpansionTile(
              title: Text("Ingredientes"),
              children: food.ingredientes.isEmpty?
                [ListTile(leading: Icon(Icons.info), title: Text("Sin ingredientes"))]:
                food.ingredientes.map((String e){
                  return ListTile(
                    leading: Icon(Icons.fastfood),
                    title: Text(e ?? "Sin nombre"),
                  );
                }).toList(),
            ),
          ],
        )
      ],
    );
  }
}