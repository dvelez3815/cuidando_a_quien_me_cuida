
import 'package:flutter/material.dart';
import 'package:utm_vinculacion/vistas/mobile/contenido.dart';
import 'package:utm_vinculacion/vistas/mobile/home.dart';
import 'const_rutas.dart' as constantesRutas;

Route<dynamic> generarRutas(RouteSettings routeSettings){
  switch (routeSettings.name) {
    case (constantesRutas.HOME): //En caso de que... Navigator.pushNamed(context, 'Home') <- fuese ese lo mando a la ruta Home
      return MaterialPageRoute(builder: (BuildContext context)=>Home());
      break;
    case(constantesRutas.CONTENIDO):
      return MaterialPageRoute(builder: (BuildContext context)=>Contenido());
      break;
    default:
    return MaterialPageRoute(builder: (BuildContext context)=>Home());
  }
}