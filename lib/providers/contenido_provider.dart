import 'package:flutter/services.dart';
import 'dart:convert';
class _Contenido {
  List<dynamic> contenido = [];
  _Contenido() {
    cargarData();
  }

  Future<List<dynamic>> cargarData()async{
  final respuesta = await rootBundle.loadString('recursosexternos/contenido_app.json');
  Map data = json.decode(respuesta);
  contenido = data['contenidos'];
  print("Imprimiendo");
  print(data);
    return data['contenidos'];
  }
}

final busesProvider = new _Contenido();