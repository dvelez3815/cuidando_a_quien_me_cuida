
import 'package:flutter/material.dart';
import 'package:utm_vinculacion/vistas/mobile/borrar.dart';
import 'package:utm_vinculacion/vistas/mobile/home.dart';
import 'const_rutas.dart' as constantesRutas;

Route<dynamic> generarRutas(RouteSettings routeSettings){
  switch (routeSettings.name) {
    case (constantesRutas.Home): //En caso de que... Navigator.pushNamed(context, 'Home') <- fuese ese lo mando a la ruta Home
      return MaterialPageRoute(builder: (BuildContext context)=>Home());
      break;
    case(constantesRutas.OtroWidget):
      return MaterialPageRoute(builder: (BuildContext context)=>NoSirveEsteWidget());
      break;
    default:
    return MaterialPageRoute(builder: (BuildContext context)=>Home());
  }
}