import 'package:flutter/services.dart';
import 'dart:convert';
class _Actividades {
  List<dynamic> actividades = [];
  List<dynamic> actividadesManiana = [];
  List<dynamic> actividadesTarde = [];
  List<dynamic> actividadesNoche = [];
  _Actividades() {
    cargarData();
  }

  Future<List<dynamic>> cargarData()async{
  final respuesta = await rootBundle.loadString('recursosexternos/actividades.json');
  Map data = json.decode(respuesta);
  actividades = data['actividades'];
    return data['actividades'];
  }
}

final actividadesProvider = new _Actividades();
