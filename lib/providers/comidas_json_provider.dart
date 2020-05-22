import 'package:flutter/services.dart';
import 'dart:convert';
class _Comida {
  List<dynamic> contenido = [];
  _Comida() {
    cargarData();
  }

  Future<List<dynamic>> cargarData()async{
  final respuesta = await rootBundle.loadString('recursosexternos/comidas.json');
  Map data = json.decode(respuesta);
  contenido = data['data'];
    return data['data'];
  }
}

final comidaProvider = new _Comida();
