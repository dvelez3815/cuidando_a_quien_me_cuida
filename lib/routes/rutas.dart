import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/activity/screen.activity.dart';
import 'package:utm_vinculacion/modules/activity/view.add_activity.dart';
import 'package:utm_vinculacion/modules/alarms/view.alarm.dart';
import 'package:utm_vinculacion/modules/care/screen.care.dart';
import 'package:utm_vinculacion/modules/care/view.add_care.dart';
import 'package:utm_vinculacion/modules/food/model.food.dart';
import 'package:utm_vinculacion/modules/food/screen.food.dart';
import 'package:utm_vinculacion/modules/food/view.add_food.dart';
import 'package:utm_vinculacion/modules/food/view.recipe_info.dart';
import 'package:utm_vinculacion/modules/settings/settings.dart';
import 'package:utm_vinculacion/vistas/mobile/rutina.dart';
import 'package:utm_vinculacion/vistas/mobile/screen.home.dart';
import 'package:utm_vinculacion/vistas/mobile/ver_contenido/contenido_panel_P.dart';
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