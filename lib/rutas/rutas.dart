import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/comida_model.dart';
import 'package:utm_vinculacion/vistas/mobile/settings.dart';
import 'package:utm_vinculacion/vistas/mobile/settings/alarms_view.dart';
import 'package:utm_vinculacion/vistas/mobile/ver_contenido/actividades.dart';
import 'package:utm_vinculacion/vistas/mobile/ver_contenido/add_actividades.dart';
import 'package:utm_vinculacion/vistas/mobile/ver_contenido/add_cuidados.dart';
import 'package:utm_vinculacion/vistas/mobile/ver_contenido/add_platos.dart';
import 'package:utm_vinculacion/vistas/mobile/ver_contenido/contenido_panel_P.dart';
import 'package:utm_vinculacion/vistas/mobile/ver_contenido/cuidados.dart';
import 'package:utm_vinculacion/vistas/mobile/home.dart';
import 'package:utm_vinculacion/vistas/mobile/ver_contenido/info_receta.dart';
import 'package:utm_vinculacion/vistas/mobile/ver_contenido/recetas.dart';
import 'package:utm_vinculacion/vistas/mobile/rutina.dart';
import 'const_rutas.dart' as constantesRutas;

Route<dynamic> generarRutas(RouteSettings routeSettings){
  switch (routeSettings.name) {
    case (constantesRutas.HOME): //En caso de que... Navigator.pushNamed(context, 'Home') <- fuese ese lo mando a la ruta Home
      return MaterialPageRoute(builder: (BuildContext context)=>Home());

    case(constantesRutas.CONTENIDO):
      return MaterialPageRoute(builder: (BuildContext context)=>Contenido());

    case(constantesRutas.CUIDADO):
      return MaterialPageRoute(builder: (BuildContext context)=>Cuidados());

    case(constantesRutas.ADDCUIDADOS):
      return MaterialPageRoute(
        builder: (BuildContext context)=>AddCuidado(),
        settings: RouteSettings(arguments: routeSettings.arguments)
      );

    case(constantesRutas.ACTIVIDADES):
      return MaterialPageRoute(builder: (BuildContext context)=>Actividades());

    case(constantesRutas.ADDACTIVIDADES):
      return MaterialPageRoute(
        builder: (BuildContext context)=>AddActividades(),        
        settings: RouteSettings(arguments: routeSettings.arguments)
      );

    case(constantesRutas.RECETAS):
      return MaterialPageRoute(builder: (BuildContext context)=>Recetas());

    case(constantesRutas.RUTINA):
      return MaterialPageRoute(builder: (BuildContext context)=>Rutina());

    case(constantesRutas.ADDPLATOS):
      return MaterialPageRoute(builder: (BuildContext context)=>AddPlatos()); 

    // case(constantesRutas.TESTING):
    //   return MaterialPageRoute(builder: (BuildContext context)=>TestPage());
    // case(constantesRutas.TESTING):
    //   return MaterialPageRoute(builder: (BuildContext context)=>TestPage());

    case(constantesRutas.INFO_COMIDA):
      Comida comida = routeSettings.arguments;
      return MaterialPageRoute(builder: (BuildContext context)=>InfoReceta(comida: comida));

    case(constantesRutas.SETTINGS):
      return MaterialPageRoute(builder: (BuildContext context)=>SettingsPage());
    case(constantesRutas.ALARMS):
      return MaterialPageRoute(builder: (BuildContext context)=>AlarmsView());

    default:
      return MaterialPageRoute(builder: (BuildContext context)=>Home());
  }
}