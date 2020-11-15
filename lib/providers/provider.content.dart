import 'package:flutter/services.dart';
import 'dart:convert';
class _Contenido {
  List<dynamic> contenido = [];
  _Contenido() {
    cargarData();
  }

  Future<List<dynamic>> cargarData()async{
  final respuesta = await rootBundle.loadString('assets/contenido_app.json');
  Map data = json.decode(respuesta);
  contenido = data['contenidos'];
    return data['contenidos'];
  }
}

final dataContenidoPanel = new _Contenido();
