import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:utm_vinculacion/modules/alarms/provider.alarm.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';


/// Calculate the first time that an alarm will be shot.
/// 
/// This method is really important 'cause if you desactivate an alarm, for
/// example, for 3 months, you need to know the exact date that the alarm
/// needs to be reescheduled
DateTime nextDateAlarm(DateTime current, int targetWeekDay, {TimeOfDay time}){

  int _currentDay = current.weekday;

  final nextTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, time.hour, time.minute);

  final bool targetIsBefore  = targetWeekDay < _currentDay;

  // If nextTime.difference(current) is negative it means that 'current' occurs after 'nextTime'
  final bool targetIsEarlier = (targetWeekDay == _currentDay) && (nextTime.difference(current).isNegative);

  // If target occurs before current time, then it should be activated next week
  if(targetIsBefore || targetIsEarlier){
    targetWeekDay +=7;
  }

  int diff =  targetWeekDay - _currentDay;

  return nextTime.add(new Duration(days: diff,));
}

/// This will show the alarm at the notification bar of your cellphone
Future<void> showAlarmNotification(int id, {Function callback}) async {

  final alarm = await DBProvider.db.getAlarma(id);

  if(alarm == null) return;
  if(callback != null) await callback();

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
}