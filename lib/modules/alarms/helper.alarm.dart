import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:utm_vinculacion/modules/alarms/provider.alarm.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';


/// Calculate the first time that an alarm will be shot.
/// 
/// This method is really important 'cause if you desactivate an alarm, for
/// example, for 3 months, you need to know the exact date that the alarm
/// needs to be reescheduled
DateTime nextDateAlarm(DateTime current, int targetWeekDay){

  int _currentDay = current.weekday;

  if(targetWeekDay < _currentDay){
    targetWeekDay +=7;
  }

  int diff =  targetWeekDay - _currentDay;

  return current.add(new Duration(days: diff,));
}

/// This will show the alarm at the notification bar of your cellphone
Future<void> showAlarmNotification(int id) async {

  final alarm = await DBProvider.db.getAlarma(id);

  if(alarm == null) return;

  final localNotification = FlutterLocalNotificationsPlugin();
  await localNotification.show(
    alarm.id, alarm.title, alarm.description, 
    NotificationDetails(AlarmProvider.androidChannel, AlarmProvider.iOSChannel),
    payload: alarm.id.toString()
  );
  // await AlarmProvider.playSong();
}