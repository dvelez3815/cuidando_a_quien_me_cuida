import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/comida_model.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class AddPlatos extends StatefulWidget {
  @override
  State createState() => new _AddPlatosState();
}

class _AddPlatosState extends State<AddPlatos> {
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
  Widget build (BuildContext ctxt) {
    return new Scaffold(
              appBar: AppBar(
          elevation: 0,
          title: Text('Nombre de la app'),
          actions: <Widget>[tresPuntos()],
        ),
      body: 
      ListView(
        children: <Widget>[
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
                      hintText: "Descripción",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: new TextField(
                    controller: preparacion,
                    decoration: new InputDecoration(
                      hintText: "Preparación",
                    ),
                  ),
                ),
                const Divider(
                  height: 1.0,
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
                decoration: InputDecoration(
                  hintText: "Ingredientes"
                ),
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
                              child: new ListView.builder
                  (
                    itemCount: litems.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return         new ListTile(
            leading: const Icon(Icons.table_chart),
            title: Text(litems[Index])
                  );
                    }
                ),
              )
          )
          ],
        ),
      ),
                Container(width: MediaQuery.of(context).size.width*0.5,child: RaisedButton(color: Colors.amber,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),onPressed: () async {
                  List<String> ingredientesString = [];
                  for (var i = 0; i < ingredientes.length; i++) {
                    ingredientesString.add(ingredientes[i].text);
                  }
                  Comida comida = new Comida(calorias: calorias.text, coccion: coccion.text,comensales: commensales.text,descripcion: descripcion.text,ingredientes: litems,nombre: nombrePlato.text,preparacion: preparacion.text, rutaVista: "",tipo: _horaActual, total: total.text,urlImagen: "");
                  print("Calorias: "+calorias.text+" coccion: "+coccion.text+" commensales: "+commensales.text+" descripcion: "+descripcion.text+" ingredientes: "+litems.toString()+" \nnombrePlato: "+nombrePlato.text+" preparacion: "+preparacion.text+" rutivaVista:   Tipo: "+_horaActual+" total: "+total.text+"url imagne:");
                  mostrarAlerta("Datos guardados con éxito", context);
                },child: Text("Guardar"),))

        ],
      )
        ]
      )
    );
    
  }
    void changedDropDownItem(String _horaSeleccionada) {
    setState(() {
      _horaActual = _horaSeleccionada;
    });
  }
}
  




















/*
class AddPlatos extends StatefulWidget {
  AddPlatos({Key key}) : super(key: key);

  @override
  _AddPlatosState createState() => _AddPlatosState();
}

class _AddPlatosState extends State<AddPlatos> {
  DBProvider db;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Nombre de la app'),
          actions: <Widget>[tresPuntos()],
        ),
        body: ListView(
          children: <Widget>[
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
                      hintText: "Descripción",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: new TextField(
                    controller: preparacion,
                    decoration: new InputDecoration(
                      hintText: "Preparación",
                    ),
                  ),
                ),
                const Divider(
                  height: 1.0,
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
                new ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: new TextField(
                    enabled: false,
                    decoration: new InputDecoration(
                      hintText: "Ingredientes",
                    ),
                  ),
                  trailing: IconButton(icon: Icon(Icons.add), onPressed: (){
                    setState(() {
                    ingredientes.add(new TextEditingController());
                    });
                  }),
                ),
                ingredientes.length<=0?SizedBox()
                :Column(
                  children: crearListaTitle(ingredientes.length),
                ),
                Container(width: MediaQuery.of(context).size.width*0.5,child: RaisedButton(color: Colors.amber,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),onPressed: () async {
                  List<String> ingredientesString = [];
                  for (var i = 0; i < ingredientes.length; i++) {
                    ingredientesString.add(ingredientes[i].text);
                  }
                  Comida comida = new Comida(calorias: calorias.text, coccion: coccion.text,comensales: commensales.text,descripcion: descripcion.text,ingredientes: ingredientesString,nombre: nombrePlato.text,preparacion: preparacion.text, rutaVista: "",tipo: _horaActual, total: total.text,urlImagen: "");
                  print("Calorias: "+calorias.text+" coccion: "+coccion.text+" commensales: "+commensales.text+" descripcion: "+descripcion.text+" ingredientes: "+ingredientesString.toString()+" \nnombrePlato: "+nombrePlato.text+" preparacion: "+preparacion.text+" rutivaVista:   Tipo: "+_horaActual+" total: "+total.text+"url imagne:");
                  mostrarAlerta("Datos guardados con éxito", context);
                },child: Text("Guardar"),))
              ],
            ),
          ],
        ));
  }
  List<Widget> crearListaTitle(int total){
    List<Widget> listaIngredientes = new List();
    for (var i = 0; i < total; i++) {
      ingredientes[i] = new TextEditingController();
      listaIngredientes.add(
        new ListTile(
          leading: const Icon(Icons.table_chart),
          title: new TextField(
            controller: ingredientes[i],
            decoration: new InputDecoration(
              hintText: "Ingredientes",
              ),
                ),
              ),
      );
    }
    return listaIngredientes;
  }
  void changedDropDownItem(String _horaSeleccionada) {
    setState(() {
      _horaActual = _horaSeleccionada;
    });
  }
}
*/
