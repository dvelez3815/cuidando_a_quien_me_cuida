// This is the callback that will be executed when the start alarm
// is notifying. It needs to be a high order function in order to
// be exceuted correctly
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:utm_vinculacion/modules/alarms/model.alarm.dart';
import 'package:utm_vinculacion/modules/alarms/provider.alarm.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/water/provider.water.dart';

// Dear future user, please don't try to optimize this code,
// it's a disaster, and it's so because Dart has no access to
// native APIs, so, we had to use C++; again, don't try to optimize
// this, it is really difficult to, because all of these callbacks
// must to be high order functions due to the great idea
// of the one who created the alarms package who decided to
// restrict the use of functions to only high order ones; so,
// if you are gonna make some changes anyway, please, run a full test
// to be sure it is still working.
// 
// Please, increment the next counter if you had problems with it
// 
// Veces que insultó al creador del paquete de alarmas: 12

const REMINDER_ALARM_ID = -1999;

/// This callback is used to notify to user about when he/she needs
/// to drink water. DO NOT USE IT OUTSIDE OF THIS MODULE.
Future<void> _reminderCallback(int id) async {
  final alarm = await DBProvider.db.getAlarma(id);

  if(alarm == null) return;

  // Playing a death song
  await AlarmProvider.playSong();

  // Creating alarms for the rest of the day
  final model = WaterProvider().model;
  
  // If it's the last alarm, it needs to be destroyed :)
  final DateTime current = DateTime.now();
  final DateTime last = DateTime(current.year, current.month, current.day, model.endTime.hour, model.endTime.minute);

  final diff = last.difference(current);

  // If it's true, it means that the period of notifications
  // is over, so, it must be destroyed.
  if(diff.inMinutes <= model.periodInMinutes) {
    await alarm.delete();

    alarm.title = "¡El último vaso!";
    alarm.description = "Bebe el último vaso de agua del día";
  }
  else if(model.howManyGlassesLeft <= 0) {
    await alarm.delete();

    alarm.title = "¡Bien hecho!";
    alarm.description = "Has cumplido tu objetivo de beber agua, nos vemos mañana.";
  }

  final localNotification = FlutterLocalNotificationsPlugin();
  await localNotification.show(
    alarm.id, alarm.title, alarm.description, 
    NotificationDetails(
      android: AlarmProvider.androidChannel, 
      iOS: AlarmProvider.iOSChannel
    ),
    payload: alarm.id.toString()
  );

}

/// This callback is only for the first alarm in the reminder.
/// Do not use it in another part of the app 'cause it will
/// case bugs with alarms
Future<void> startRoutineCallback(int id) async {

  final alarm = await DBProvider.db.getAlarma(id);

  if(alarm == null) return;

  final localNotification = FlutterLocalNotificationsPlugin();
  await localNotification.show(
    alarm.id, alarm.title, alarm.description, 
    NotificationDetails(
      android: AlarmProvider.androidChannel, 
      iOS: AlarmProvider.iOSChannel
    ),
    payload: alarm.id.toString()
  );

  await AlarmProvider.playSong();

  // Creating alarms for the rest of the day
  final model = WaterProvider().model;

  final reminder = new AlarmModel(
    DateTime.now().weekday, TimeOfDay.now(),
    "¡Bebe un poco de agua!", "Recuerda mantenerte hidratado",
    isMinute: true, interval: model.periodInMinutes, id: REMINDER_ALARM_ID
  );

  // TODO: make sure startAt parameter is right
  await reminder.save(activate:()async{
    await AndroidAlarmManager.periodic(
      Duration(minutes: model.periodInMinutes), // It will notify us every X minutes
      reminder.id,  // It's always the same ID
      _reminderCallback, // It is our tuned callback
      exact: true,
      rescheduleOnReboot: true,
      startAt: DateTime.now()
    );
  });
}