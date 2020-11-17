import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/events/view.events.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';

import 'model.activity.dart';

class AddActividades extends StatefulWidget {
  @override
  State createState() => new _AddActividadesState();
}

class _AddActividadesState extends State<AddActividades> with EventAC{

  @override
  Widget build(BuildContext ctxt) {

    updateData = ModalRoute.of(context).settings.arguments ?? {};

    if(updateData.isNotEmpty){
      loadUpdateData(setState);
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text(updateData.isEmpty? 'Agregar Actividad':'Actualizar Actividad'),
        actions: <Widget>[tresPuntos(context)],
      ),
      body: ListView(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _getTitleField(),
              _getDescriptionField(),
              SizedBox(height: 25,),
              ListTile(
                title: RichText(
                  text: TextSpan(
                      text:
                          "Seleccione los días en los cuales la actividad se realizara",
                      style: TextStyle(color: Colors.grey, fontSize: 18)),
                ),
              ),
              this.getDaysSelector(setState),
              this.getTimeSelector(context),
              getSaveButton(context, new Actividad(TimeOfDay.now(), []))
            ],
          ),
        ],
      ),
    );
  }


  Widget _getDescriptionField() {
    return ListTile(
      leading: const Icon(Icons.table_chart),
      title: TextFormField(
        maxLines: 5,
        onChanged: (value) => objetivosActividad.text = value,         
        initialValue: objetivosActividad.text ?? "",
        decoration: InputDecoration(
          hintText: "Objetivos de la actividad",
        ),
      ),
    );
  }

  Widget _getTitleField() {
    return ListTile(
      leading: const Icon(Icons.directions_run),
      title: TextFormField(
        onChanged: (value)=>nombreActividad.text=value, 
        initialValue: nombreActividad.text ?? "",
        decoration: InputDecoration(                    
          hintText: "Nombre de la actividad",
        ),
      ),
    );
  }

}
