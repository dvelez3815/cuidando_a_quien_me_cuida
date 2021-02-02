import 'package:flutter/material.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/widget.tunned_expansion.dart';

import 'model.food.dart';


class InfoReceta extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Comida food = ModalRoute.of(context).settings.arguments;

    return Scaffold(  
      body: Column(
        children: [
          getHeader(context, "Receta"),
          Expanded(child: _getContent(context, food)),
        ],
      )
    );
  }

  ListView _getContent(BuildContext context, Comida food) {
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
            TunnedExpansion(
              expansionTile: ExpansionTile(
                tileColor : Theme.of(context).accentColor,
                textColor: Theme.of(context).canvasColor,
                initiallyExpanded: true,
                title: Text("Imágen de la receta"),
                children: [
                  food.urlImagen != null?Image.asset(
                      food.urlImagen,
                      fit: BoxFit.fitHeight,
                      height: MediaQuery.of(context).size.width*0.8,
                    ):ListTile(title: Text("No hay imágen")),
                ],
              ),
            ),
            Divider(),
            TunnedExpansion(
              expansionTile: ExpansionTile(
                tileColor : Theme.of(context).accentColor,
                textColor: Theme.of(context).canvasColor,
                title: Text("Ingredientes"),
                initiallyExpanded: true,
                children: food.ingredientes.isEmpty?
                  [ListTile(leading: Icon(Icons.info), title: Text("Sin ingredientes"))]:
                  food.ingredientes.map((String e){
                    return ListTile(
                      leading: Icon(Icons.fastfood),
                      title: Text(e ?? "Sin nombre"),
                    );
                  }).toList(),
              ),
            ),
            Divider(),
            TunnedExpansion(
              expansionTile: ExpansionTile(
                tileColor : Theme.of(context).accentColor,
                textColor: Theme.of(context).canvasColor,
                title: Text("Prepa"),
                initiallyExpanded: true,
                children: [
                  ListTile(
                    leading: Icon(Icons.restaurant),
                    title: Text("Preparación\n"),
                    subtitle: Text(
                      food.preparacion ?? "Sin descripción",
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ]
              ),
            ),
          ],
        )
      ],
    );
  }
}