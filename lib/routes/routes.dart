import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/activity/screen.activity.dart';
import 'package:utm_vinculacion/modules/activity/view.add_activity.dart';
import 'package:utm_vinculacion/modules/care/screen.care.dart';
import 'package:utm_vinculacion/modules/care/view.add_care.dart';
import 'package:utm_vinculacion/modules/dates/screen.calendar.dart';
import 'package:utm_vinculacion/modules/events/screen.event.dart';
import 'package:utm_vinculacion/modules/food/screen.food.dart';
import 'package:utm_vinculacion/modules/food/view.add_food.dart';
import 'package:utm_vinculacion/modules/food/view.recipe_info.dart';
import 'package:utm_vinculacion/modules/home/screen.home.dart';
import 'package:utm_vinculacion/modules/music/screen.music.dart';
import 'package:utm_vinculacion/modules/settings/screen.settings.dart';
import 'route.names.dart' as constantesRutas;

Map<String, Widget Function(BuildContext)> getRoutes() {
  return <String, Widget Function(BuildContext _)>{
    constantesRutas.HOME: (_)=>Home(),
    constantesRutas.CUIDADO: (_)=>Cuidados(),
    constantesRutas.ADDCUIDADOS: (_)=>AddCuidado(),
    constantesRutas.ACTIVIDADES: (_)=>Actividades(),
    constantesRutas.ADDACTIVIDADES: (_)=>AddActividades(),
    constantesRutas.RECETAS: (_)=>Recetas(),
    constantesRutas.EVENTS: (_)=>Rutina(),
    constantesRutas.ADDPLATOS: (_)=>AddPlatos(),
    constantesRutas.INFO_COMIDA: (_)=>InfoReceta(),
    constantesRutas.SETTINGS: (_)=>SettingsPage(),
    constantesRutas.MUSICA: (_)=>MusicScreen(),
    constantesRutas.CALENDAR: (_)=>CalendarScreen(),
  };
}
