import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/cuidado_model.dart';

import 'package:utm_vinculacion/vistas/mobile/ver_contenido/eventos.dart';
import '../widgets_reutilizables.dart';


class AddCuidado extends StatefulWidget {
  
  @override
  State createState() => new _AddCuidadoState();
}

class _AddCuidadoState extends State<AddCuidado> with EventAC{

  @override
  void initState() {  

    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    
    // this come from 'rutina' file and it's only for update  
    updateData = ModalRoute.of(context).settings.arguments ?? {};

    if(updateData.isNotEmpty){
      // loading data to update
      loadUpdateData(setState);
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text(updateData.isEmpty? 'Agregar Cuidado':'Actualizar Cuidado'),
        actions: <Widget>[tresPuntos(context)],
      ),
      body: ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              getTitleField(),
              getDescriptionField(),
              SizedBox(height: 25),
              ListTile(
                title: RichText(
                  text: TextSpan(
                      text:
                          "Seleccione los días en los cuales el paciente tomará el medicamento",
                      style: TextStyle(color: Colors.grey, fontSize: 18)),
                ),
              ),
              getDaysSelector(setState),
              getTimeSelector(context),
              getSaveButton(context, new Cuidado(TimeOfDay.now(), []))
            ],
          ),
        ],
      ),
    );
  }

  Widget getDescriptionField() {
    return ListTile(
      leading: const Icon(Icons.table_chart),
      title: TextFormField(
        maxLines: 5,
        onChanged: (value) => objetivosActividad.text = value,         
        initialValue: objetivosActividad.text ?? "",
        decoration: InputDecoration(
          hintText: "Descripción del medicamento",
        ),
      ),
    );
  }

  Widget getTitleField() {
    return ListTile(
      leading: Image.asset("assets/imagenes/medicine.png"),
      title: TextFormField(                  
        // controller: nombreActividad,             
        onChanged: (value)=>nombreActividad.text=value, 
        initialValue: nombreActividad.text ?? "",
        decoration: InputDecoration(                    
          hintText: "Nombre del medicamento",
        ),
      ),
    );
  }

}