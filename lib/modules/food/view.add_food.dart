import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/food/model.food.dart';
import 'package:utm_vinculacion/widgets/components/expansion_tile.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/input.dart';

class AddPlatos extends StatefulWidget {

  final DBProvider dbProvider = DBProvider.db;
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<Map<String, dynamic>> ingredientes = new List<Map<String, dynamic>>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  State createState() => new _AddPlatosState();
}

class _AddPlatosState extends State<AddPlatos> {

  Map<String, dynamic> updateData;  // this data will be defined in each specific class
  bool loadFirstTime;

  @override
  void initState() {
    loadFirstTime = false;
    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {

    updateData = ModalRoute.of(context).settings.arguments ?? {};

    if(updateData.isNotEmpty){
      loadUpdateData(setState);
    }

    return Scaffold(
      key: widget.scaffoldKey,
      body: Column(
        children: [
          getHeader(context, "Agregar Comida"),
          _getContent()
        ],
      )
    );
  }

  Widget _getContent() {

    final TextEditingController nameController = TextEditingController();

    return Expanded(
      child: ListView(
        physics: ScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          getInputStyle("Nombre", "Nombre de la receta", widget.titleController, Icons.restaurant),
          getInputStyle("Preparación", "Paso a paso", widget.descriptionController, Icons.info, maxLines: null),
          getExpansionTile(
            controller: nameController,
            items: widget.ingredientes,
            onPressed: ()=>_getDialog(nameController),
            setState: setState,
            title: "Ingredientes"
          ),
          Divider(),
          _getSaveButton(context)
        ],
      ),
    );
  }

  Widget _getSaveButton(BuildContext context) {

    bool canPress = true;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      width: MediaQuery.of(context).size.width * 0.5,
      child: RaisedButton(
        color: Colors.amber,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        onPressed: !canPress? null:()async{
          canPress = false;
          await _saveAction();
        },
        child: Text(updateData.isEmpty? "Guardar":"Actualizar"),
      )
    );
  }

  Future<void> _getDialog(TextEditingController controller) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text("Agregar ingrediente"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getInputStyle("Nombre", "Nombre del ingrediente", controller, null),
            ],
          ),
        ),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.cancel),
            label: Text("Cancelar"),
            onPressed: ()=>Navigator.of(context).pop(),
          ),
          FlatButton.icon(
            icon: Icon(Icons.check_circle),
            label: Text("Guardar"),
            onPressed: ()=>setState((){

              if(widget.ingredientes.indexWhere((element) => (element["title"] == controller.text)) > -1){
                widget.scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: Text("Material ya existe"),
                ));
                return;
              }

              widget.ingredientes.add({
                "title": controller.text
              });
              Navigator.of(context).pop();
            })
          ),
        ],
      )
    );
  }

  void loadUpdateData(Function setState) {
    
    if(!loadFirstTime) loadFirstTime = true;
    else return;

    print("Loading updated data");
    
    Comida food = updateData["model_data"];
    
    widget.descriptionController.text = food.preparacion;
    widget.titleController.text = food.nombre;
    
    widget.ingredientes.addAll(food.ingredientes.map((String i)=><String, dynamic>{"title": i}));

    setState((){});
  }

  Future<void> _saveAction()async{

    if(updateData.isNotEmpty){
      await widget.dbProvider.eliminarComida(updateData['model_data']);
    }

    // The food we're gonna save
    Comida food = new Comida(
      ingredientes: List<String>.from(widget.ingredientes.map((e) => e["title"])),
      nombre: widget.titleController.text ?? "Sin nombre",
      preparacion: widget.descriptionController.text ?? "Sin descripción",
      urlImagen: "assets/imagenes/recetas.jpg"
    );

    // saving the new information
    await widget.dbProvider.nuevaComida(food);

    widget.scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text("Receta ${updateData.isNotEmpty?"actualizada":"agregada"}"),
    ));

    // Delayed to show the snackbar
    Future.delayed(Duration(seconds: 1)).then((value) => Navigator.of(context).pop());
  }

}
