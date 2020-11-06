import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utm_vinculacion/providers/alarms_provider.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';


const List<String> days = ["lunes", "martes", "miercoles", "jueves", "viernes", "sabado", "domingo"];

/// This will generate a random id based on the current time
int generateID() {

  final date = DateTime.now();
  final secondsNow = date.year*31104000+date.month*2592000+date.day*86400+date.hour*3600+date.minute*60+date.second+date.microsecond;

  return secondsNow - 62832762060;
}

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

int parseDayFromString(String day)=>days.indexOf(day) + 1;

Future<void> initDatabase(Database db, int version) async{

  String script = await rootBundle.loadString("recursosexternos/database.sql", cache: true);

  script = script.trim();
  final queries = script.split(";");
  queries.removeLast();
  // You need to let trim act because of blank spaces
  queries.forEach((String query)async{
    await db.execute(query+";");
  });
}

String parseDayWeek(int day){
  switch(day){
    case 1: return "LUNES";
    case 2: return "MARTES";
    case 3: return "MIERCOLES";
    case 4: return "JUEVES";
    case 5: return "VIERNES";
    case 6: return "SABADO";
    default: return "DOMINGO";
  }
}

int parseDay(String day){
  int returnDay = 1;

  switch(day.toUpperCase()){
    case "LUNES": returnDay=1; break;
    case "MARTES": returnDay=2; break;
    case "MIERCOLES": returnDay=3; break;
    case "JUEVES": returnDay=4; break;
    case "VIERNES": returnDay=5; break;
    case "SABADO": returnDay=6; break;
    case "DOMINGO": returnDay=7; break;
  }

  return returnDay;
}