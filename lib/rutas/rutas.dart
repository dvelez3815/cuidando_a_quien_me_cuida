
import 'package:flutter/material.dart';
import 'package:utm_vinculacion/vistas/mobile/home.dart';
import 'const_rutas.dart' as constantesRutas;

Route<dynamic> generarRutas(RouteSettings routeSettings){
  switch (routeSettings.name) {
    case (constantesRutas.Home):
      return MaterialPageRoute(builder: (BuildContext context)=>Home());
      break;
    default:
    return MaterialPageRoute(builder: (BuildContext context)=>Home());
  }
}