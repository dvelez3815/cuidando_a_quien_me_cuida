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
  Widget build(BuildContext ctxt) {

    // data to stablish if it is for update or not
    updateData = ModalRoute.of(context).settings.arguments ?? {};

    // If there is something to update, then load it
    if(updateData.isNotEmpty){
      loadUpdateData(setState);
    }

    return new Scaffold(
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
              getTimeSelector(),
              getSaveButton()
            ],
          ),
        ],
      ),
    );
  }

  Widget getSaveButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: RaisedButton(
        color: Colors.amber,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        onPressed: saveAlarm,
        child: Text(updateData.isEmpty? "Guardar":"Actualizar"),
      )
    );
  }

  Widget getTimeSelector() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlatButton.icon(
          onPressed: showPicker,
          color: Colors.green,
          icon: Icon(Icons.timer),
          label: Text('Establecer hora')
        ),
      ],
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

  Future<void> saveAlarm() async {  
    // What I actually do, is to delete the current event and its alarms
    // and then I create a new one with the new data
    if(updateData.containsKey("care_model")){
      Cuidado cuidado = updateData['care_model'];

      final List<String> daysActive = new List<String>();

      this.daysToNotify.forEach((key, value) {
        if(value) daysActive.add(key);
      });

      await cuidado.update({
        "days": daysActive.toString(),
        "nombre": this.nombreActividad.text,
        "descripcion": this.objetivosActividad.text
      });

      this.scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("La alarma fué actualizada")
      ));
    
      Navigator.of(context).pop();
      return;
      // cuidado.estado = false; // I do this to delete all alarms of this events
      // await dbProvider.deleteCare(cuidado);
      // await dbProvider.deleteCareAlarm(cuidado);
    }

    return await _newAlarm();
  }

  Future<void> _newAlarm() async {

    // This will contains only the days to notify
    final List<String> daysActive = new List<String>();

    this.daysToNotify.forEach((key, value) {
      if(value) daysActive.add(key);
    });

    // At least one day should be selected
    if(daysActive.isEmpty) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text("Debe seleccionar al menos un día")));
      return;
    }

    // Creating the model
    Cuidado care = new Cuidado(
      this.time,
      daysActive, // this is not the class attribute
      nombre: this.nombreActividad.text ?? "Sin título",
      descripcion: this.objetivosActividad.text ?? "Sin objetivos"
    );

    await care.save(); // this save this care in local database

    this.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('La alarma fué creada')
    ));
  
    Navigator.of(context).pop();
  }

  Future showPicker() async {
    // Obteniendo hora de la alarma
    if(updateData.isNotEmpty){
      Cuidado cuidado = updateData['care_model'];
      time = await showTimePicker(context: context, initialTime: cuidado.time);
    }
    else{
      time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    }
  }
  
}