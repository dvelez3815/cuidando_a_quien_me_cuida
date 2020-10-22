import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/comida_model.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class AddActividades extends StatefulWidget {
  @override
  State createState() => new _AddActividadesState();
}

class _AddActividadesState extends State<AddActividades> {

  DBProvider dbProvider = DBProvider.db;
  TextEditingController nombreActividad = new TextEditingController();
  TextEditingController objetivosActividad = new TextEditingController();


  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();

  Map<String, bool> values = {
    'lunes': true,
    'martes': true,
    'miercoles': false,
    'jueves': false,
    'viernes': false,
    'sabado': false,
    'domingo': false,
  };

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Nombre de la app'),
          actions: <Widget>[tresPuntos()],
        ),
        body: ListView(children: <Widget>[
          new Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.directions_run),
                title: TextField(
                  controller: nombreActividad,
                  decoration: InputDecoration(
                    hintText: "Nombre de la actividad",
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.table_chart),
                title: TextField(
                  maxLines: 5,
                  controller: objetivosActividad,
                  decoration: InputDecoration(
                    hintText: "Objetivos de la actividad",
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              ListTile(
                 title: RichText(text: TextSpan(
                   text: "Seleccione los días en los cuales la actividad se realizara",
                   style: TextStyle(color: Colors.grey, fontSize: 18)
                 ),),
              ),
              Column(
                children: values.keys.map((String key) {
          return new CheckboxListTile(
            title: new Text(key),
            value: values[key],
            onChanged: (bool value) {
              setState(() {
                values[key] = value;
              });
            },
          );
        }).toList(),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: RaisedButton(
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async {
                      /*
                      Comida comida = new Comida(
                          calorias: calorias.text,
                          coccion: coccion.text,
                          comensales: commensales.text,
                          descripcion: descripcion.text,
                          ingredientes: litems,
                          nombre: nombreActividad.text,
                          preparacion: objetivosActividad.text,
                          rutaVista: null,
                          tipo: _horaActual,
                          total: total.text,
                          urlImagen: "assets/imagenes/recetas.jpg"
                        );
                        */
                      /*final int response = await dbProvider.nuevaComida(comida);
                      mostrarAlerta("${response != 0?"Datos guardados":"La tarea fracasó"} con éxito", context);
                      */
                    },
                    child: Text("Guardar"),
                  ))
            ],
          )
        ]));
  }
}
