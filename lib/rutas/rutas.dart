
import 'package:flutter/material.dart';
import 'package:utm_vinculacion/vistas/mobile/actividades.dart';
import 'package:utm_vinculacion/vistas/mobile/contenido.dart';
import 'package:utm_vinculacion/vistas/mobile/cuidados.dart';
import 'package:utm_vinculacion/vistas/mobile/home.dart';
import 'package:utm_vinculacion/vistas/mobile/recetas.dart';
import 'package:utm_vinculacion/vistas/mobile/rutina.dart';
import 'const_rutas.dart' as constantesRutas;

Route<dynamic> generarRutas(RouteSettings routeSettings){
  switch (routeSettings.name) {
    case (constantesRutas.HOME): //En caso de que... Navigator.pushNamed(context, 'Home') <- fuese ese lo mando a la ruta Home
      return MaterialPageRoute(builder: (BuildContext context)=>Home());
      break;
    case(constantesRutas.CONTENIDO):
      return MaterialPageRoute(builder: (BuildContext context)=>Contenido());
      break;
    case(constantesRutas.CUIDADO):
      return MaterialPageRoute(builder: (BuildContext context)=>Cuidados());
      break;
    case(constantesRutas.ACTIVIDADES):
      return MaterialPageRoute(builder: (BuildContext context)=>Actividades());
      break;
    case(constantesRutas.RECETAS):
      return MaterialPageRoute(builder: (BuildContext context)=>Recetas());
      break;
    case(constantesRutas.RUTINA):
      return MaterialPageRoute(builder: (BuildContext context)=>Rutina());
      break;                        
    default:
    return MaterialPageRoute(builder: (BuildContext context)=>Home());
  }
}