import 'package:flutter/material.dart';
import 'package:utm_vinculacion/widgets/components/expansion_tile.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/input.dart';

class AddPlatos extends StatefulWidget {

  // final DBProvider dbProvider = DBProvider.db;
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<Map<String, dynamic>> ingredientes = new List<Map<String, dynamic>>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  State createState() => new _AddPlatosState();
}

class _AddPlatosState extends State<AddPlatos> {


  @override
  void initState() {
    // widget.dbProvider.getComidas();
    super.initState();    
  }

  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
      key: widget.scaffoldKey,
      body: Column(
        children: [
          getHeader(context, MediaQuery.of(context).size, "Agregar Comida"),
          _getContent()
        ],
      )
    );
  }

  Widget _getContent() {

    final TextEditingController nameController = TextEditingController();

    return Expanded(
      child: ListView(
        children: [
          getInputStyle("Nombre", "Nombre de la receta", widget.titleController, Icons.restaurant),
          getInputStyle("Preparación", "Paso a paso", widget.descriptionController, Icons.info, maxLines: null),
          
          getExpansionTile(
            controller: nameController,
            items: widget.ingredientes,
            onPressed: ()=>_getDialog(widget.titleController),
            setState: setState,
            title: "Ingredientes"
          ),
          Divider(),
        ],
      ),
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

}
