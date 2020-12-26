import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/activity/screen.activity.dart';
import 'package:utm_vinculacion/modules/activity/screen.routine.dart';
import 'package:utm_vinculacion/modules/activity/view.add_activity.dart';
import 'package:utm_vinculacion/modules/contacts/screen.contacts.dart';
import 'package:utm_vinculacion/modules/contacts/view.add_contact.dart';
import 'package:utm_vinculacion/modules/dates/screen.calendar.dart';
import 'package:utm_vinculacion/modules/food/screen.food.dart';
import 'package:utm_vinculacion/modules/food/view.add_food.dart';
import 'package:utm_vinculacion/modules/food/view.recipe_info.dart';
import 'package:utm_vinculacion/modules/home/screen.home.dart';
import 'package:utm_vinculacion/modules/music/screen.playlist.dart';
import 'package:utm_vinculacion/modules/music/view.music.dart';
import 'package:utm_vinculacion/modules/settings/screen.settings.dart';
import 'package:utm_vinculacion/modules/water/screen.water.dart';
import 'route.names.dart' as constantesRutas;

Map<String, Widget Function(BuildContext)> getRoutes() {
  return <String, Widget Function(BuildContext _)>{
    constantesRutas.ACTIVIDADES: (_)=>Actividades(),
    constantesRutas.ADDACTIVIDADES: (_)=>AddActividades(),
    constantesRutas.ADDCONTACT: (_)=>CreateContactView(),
    constantesRutas.ADDPLATOS: (_)=>AddPlatos(),
    constantesRutas.CALENDAR: (_)=>CalendarScreen(),
    constantesRutas.CONTACTS: (_)=>ContactsScreen(),
    constantesRutas.EVENTS: (_)=>Rutina(),
    constantesRutas.HOME: (_)=>Home(),
    constantesRutas.INFO_COMIDA: (_)=>InfoReceta(),
    constantesRutas.MUSICA: (_)=>PlaylistScreen(),
    constantesRutas.MUSIC_DETAIL: (_)=>MusicPage(),
    constantesRutas.RECETAS: (_)=>Recetas(),
    constantesRutas.SETTINGS: (_)=>SettingsPage(),
    constantesRutas.WATER: (_)=>WaterScreen(),
  };
}
