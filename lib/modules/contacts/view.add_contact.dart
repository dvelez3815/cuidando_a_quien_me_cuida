import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/input.dart';

import 'model.contacts.dart';

class CreateContactView extends StatelessWidget {

  final _nameCTRL = new TextEditingController();
  final _aboutCTRL = new TextEditingController();
  final _phoneCTRL = new TextEditingController();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();

  final _dbProvider = DBProvider.db;
  
  final RegExp regExp = new RegExp(r"^(0|\+593)9[0-9]{8}");


  @override
  Widget build(BuildContext context) {

    final Contact edit = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          getHeader(context, "Agregar Contacto"),
          _getContent(context, edit)
        ],
      ),
    );  
  }

  Widget _getContent(BuildContext context, Contact contact) {

    this._nameCTRL.text = contact?.title ?? this._nameCTRL.text;
    this._aboutCTRL.text = contact?.description ?? this._aboutCTRL.text;
    this._phoneCTRL.text = contact?.phone ?? this._phoneCTRL.text;

    return Expanded(
      child: ListView(
        physics: ScrollPhysics(parent: PageScrollPhysics()),
        children: [
          Form(
            key: this._formKey,
            child: Column(
              children: [
                getInputStyle(
                  "Nombre", "Nombre del contacto", this._nameCTRL, Icons.person,
                  validatorCallback: (String content){
                    if(content.length < 3) return "Nombre muy corto";
                    return null;
                  }
                ),
                getInputStyle(
                  "Descripción", "Descripción del contacto", this._aboutCTRL, Icons.info,
                ),
                getInputStyle(
                  "Teléfono", "Número de teléfono", this._phoneCTRL, Icons.phone_android, 
                  inputType: TextInputType.number, validatorCallback: phoneValidator
                ),
              ],
            ),
          ),
          Divider(),
          _getSaveBtn(context, contact)
        ],
      ),
    );
  }

  Widget _getSaveBtn(BuildContext context, Contact contact) {

    bool canPress = true;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      width: MediaQuery.of(context).size.width * 0.5,
      child: RaisedButton(
        color: Colors.amber,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        onPressed: !canPress? null:()async{
          
          if(!canPress) return;

          canPress = false;

          await _saveAction(context, contact);
          canPress = true;
        },
        child: Text((contact == null)? "Guardar":"Actualizar"),
      )
    );
  }

  String phoneValidator(String content) {
    // if(!regExp.hasMatch(content)) {
    //   this._scaffoldKey.currentState.showSnackBar(new SnackBar(
    //     content: Text("El número de teléfono que ingresó no es válido"),
    //   ));
    //   return "Número de teléfono inválido";
    // }
    // print(content);
    return null;
  }

  Future<void> _saveAction(BuildContext context, Contact contact) async {
    if(this._formKey.currentState.validate()){
      this._scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Text("El número de teléfono ha sido ${contact != null? "actualizado":"agregado"}"),
      ));

      if(contact == null){
        await this._dbProvider.createContact(new Contact(
          title: this._nameCTRL.text,
          description: this._aboutCTRL.text,
          phone: this._phoneCTRL.text
        ));
      }
      else {
        contact.title = this._nameCTRL.text;
        contact.description = this._aboutCTRL.text;
        contact.phone = this._phoneCTRL.text;

        await this._dbProvider.updateContact(contact);
      }
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.of(context).pop();
    }
  }
}