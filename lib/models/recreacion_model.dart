import 'package:flutter/foundation.dart';

class Recreacion{

  String nombre;
  String materiales;
  String instrucciones;
  String beneficios;
  String observacion;

  Recreacion({@required this.nombre, @required this.instrucciones, this.materiales, this.beneficios, this.observacion});

  Recreacion.fromJson(Map<String, dynamic> json){
    nombre = json['nombre'];
    materiales = json['materiales'];
    instrucciones = json['instrucciones'];
    beneficios = json['beneficios'];
    observacion = json['observacion'];
  }

  Map<String, dynamic> toJson()=>{
    "nombre": nombre,
    "materiales": materiales,
    "instrucciones": instrucciones,
    "beneficios": beneficios,
    "observacion": observacion
  };

}