import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utm_vinculacion/modules/alarms/model.alarm.dart';
import 'package:utm_vinculacion/modules/water/helper.water.dart' as waterHelper;
import 'package:utm_vinculacion/modules/water/provider.water.dart';
import 'package:utm_vinculacion/user_preferences.dart';

Future<void> defaultData(Database db) async {
  bool success = await _performQueries(db, "lib/modules/database/database_script.sql");

  if(success){
    print("All default data has been added");
    await loadWaterData();
    UserPreferences().areWaterAlarmsCreated = true;
  }
}

Future<void> loadWaterData()async{
  final model = WaterProvider().model;

  // This restart the water reminder object and all streams around it
  await AndroidAlarmManager.periodic(
    Duration(days: 1), 
    waterHelper.FIRST_REMINDER_ALARM_ID, 
    waterHelper.startCallback
  );

  await AndroidAlarmManager.periodic(
    Duration(days: 1), 
    waterHelper.MORNIGN_REMINDER_ALARM_ID, 
    waterHelper.reminderCallback
  );

  final AlarmModel startAlarm = new AlarmModel(
    DateTime.now().weekday,
    TimeOfDay(hour: 7, minute: 0),
    "¡Recuerda mantenerte hidratado!",
    "Bebe un vaso de agua",
    interval: 1, id: waterHelper.MORNIGN_REMINDER_ALARM_ID
  );

  final AlarmModel middayAlarm = new AlarmModel(
    DateTime.now().weekday,
    TimeOfDay(hour: 13, minute: 0),
    "¡Recuerda mantenerte hidratado!",
    "Bebe un vaso de agua",
    interval: 1, id: waterHelper.MIDDAY_REMINDER_ALARM_ID
  );

  final AlarmModel lastAlarm = new AlarmModel(
    DateTime.now().weekday,
    TimeOfDay(hour: 13, minute: 0),
    model.howManyGlassesLeft > 0? "¡Aún puedes alcazar tu meta diaria!":
        "¡Felicidades! ¡Cumpliste tu objetivo diario!",
    model.howManyGlassesLeft > 0? "Te faltan ${model.howManyGlassesLeft} vasos de agua":
        "¡Has bebido ${model.goal} litros de agua hoy!",
    interval: 1, id: waterHelper.LAST_REMINDER_ALARM_ID
  );

  await startAlarm.save();
  await middayAlarm.save();
  await lastAlarm.save();
}

Future<void> initDatabase(Database db, int version) async{
  await _performQueries(db, "lib/modules/database/database.sql");

}

Future<bool> _performQueries(Database db, String route) async {
  final batch = db.batch(); // to excecute atomic operations

  String script = await rootBundle.loadString(route, cache: false);
  script = script.trim();

  script.split(';').forEach((element) {
    if(element.length < 5) return;
    batch.execute(element);
  });
  
  // batch.execute(script);
  final res = await batch.commit();
  
  print(res.length.toString() + " operations performed");
  return res.length > 0;
}
