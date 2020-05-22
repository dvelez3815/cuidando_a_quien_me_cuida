import 'package:flutter/material.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class AddPlatos extends StatefulWidget {
  AddPlatos({Key key}) : super(key: key);

  @override
  _AddPlatosState createState() => _AddPlatosState();
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
  List ingredientes = [];
  List _horarios = ["Desayuno", "Almuerzo", "Merienda"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _horaActual;
  int totalIngredientes;
  @override
  void initState() {
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
                    decoration: new InputDecoration(
                      hintText: "Nombre del plato",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Descripción",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: new TextField(
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
                    decoration: new InputDecoration(
                      hintText: "Total",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Calorias",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Cocción",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: new TextField(
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
                    ingredientes.add(new TextEditingController());
                    setState(() {

                    });
                  }),
                ),
                ingredientes.length<0?SizedBox()
                :Container(
                  height: 150,
                  child: ListView(
                    children: crearListaTitle(ingredientes.length),
                  )
                ),
                Container(width: MediaQuery.of(context).size.width*0.5,child: RaisedButton(color: Colors.amber,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),onPressed: (){},child: Text("Guardar"),))
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
