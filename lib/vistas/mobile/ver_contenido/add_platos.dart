import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/comida_model.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class AddPlatos extends StatefulWidget {
  @override
  State createState() => new _AddPlatosState();
}

class _AddPlatosState extends State<AddPlatos> {
  List<TextEditingController> ingredientesController =
      new List<TextEditingController>();
  
  DBProvider dbProvider = DBProvider.db;
  TextEditingController nombrePlato = new TextEditingController();
  TextEditingController descripcion = new TextEditingController();
  TextEditingController preparacion = new TextEditingController();
  TextEditingController total = new TextEditingController();
  TextEditingController calorias = new TextEditingController();
  TextEditingController coccion = new TextEditingController();
  TextEditingController commensales = new TextEditingController();
  TextEditingController tipo = new TextEditingController();
  List ingredientes;
  List _horarios = ["Desayuno", "Almuerzo", "Merienda"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _horaActual;
  int totalIngredientes;
  @override
  void initState() {
    ingredientes = [];
    _dropDownMenuItems = getDropDownMenuItems();
    _horaActual = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String horas in _horarios) {
      items.add(new DropdownMenuItem(value: horas, child: new Text(horas)));
    }
    return items;
  }

  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(NOMBREAPP),
          actions: <Widget>[tresPuntos(context)],
        ),
        body: ListView(children: <Widget>[
          new Column(
            children: <Widget>[
              new ListTile(
                leading: const Icon(Icons.fastfood),
                title: new TextField(
                  controller: nombrePlato,
                  decoration: new InputDecoration(
                    hintText: "Nombre del plato",
                  ),
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.table_chart),
                title: new TextField(
                  controller: descripcion,
                  decoration: new InputDecoration(
                    hintText: "Descripción del plato",
                  ),
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.table_chart),
                title: new TextField(
                  maxLines: 5,
                  controller: preparacion,
                  decoration: new InputDecoration(
                    hintText: "Preparación",
                  ),
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.table_chart),
                title: new TextField(
                  controller: total,
                  decoration: new InputDecoration(
                    hintText: "Total",
                  ),
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.table_chart),
                title: new TextField(
                  controller: calorias,
                  decoration: new InputDecoration(
                    hintText: "Calorias",
                  ),
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.table_chart),
                title: new TextField(
                  controller: coccion,
                  decoration: new InputDecoration(
                    hintText: "Cocción",
                  ),
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.table_chart),
                title: new TextField(
                  controller: commensales,
                  decoration: new InputDecoration(
                    hintText: "Commensales",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.table_chart),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new DropdownButton(
                      value: _horaActual,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    )
                  ],
                ),
              ),
              Container(
                height: 150,
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      leading: const Icon(Icons.fastfood),
                      title: new TextField(
                        decoration: InputDecoration(hintText: "Ingredientes"),
                        controller: eCtrl,
                        onSubmitted: (text) {
                          litems.add(text);
                          eCtrl.clear();
                          setState(() {});
                        },
                      ),
                    ),
                    new Expanded(
                      child: Scrollbar(
                      child: new ListView.builder(
                          itemCount: litems.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return new ListTile(
                                leading: const Icon(Icons.fastfood),
                                title: Text(litems[index]));
                          }),
                    ))
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: RaisedButton(
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async {
                      // List<String> ingredientesString = [];
                      // for (var i = 0; i < ingredientes.length; i++) {
                      //   ingredientesString.add(ingredientes[i].text);
                      // }
                      Comida comida = new Comida(
                          calorias: calorias.text,
                          coccion: coccion.text,
                          comensales: commensales.text,
                          descripcion: descripcion.text,
                          ingredientes: litems,
                          nombre: nombrePlato.text,
                          preparacion: preparacion.text,
                          rutaVista: null,
                          tipo: _horaActual,
                          total: total.text,
                          urlImagen: "assets/imagenes/recetas.jpg"
                        );
                      final int response = await dbProvider.nuevaComida(comida);
                      if(response!=0){
                        mostrarAlerta("Datos guardados", context);
                        Navigator.pop(context);
                      }else{
                        mostrarAlerta("La tarea fracasó", context);
                      }
  
                    },
                    child: Text("Guardar"),
                  ))
            ],
          )
        ]));
  }

  void changedDropDownItem(String _horaSeleccionada) {
    setState(() {
      _horaActual = _horaSeleccionada;
    });
  }
}
