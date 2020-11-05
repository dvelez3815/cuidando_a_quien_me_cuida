import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utm_vinculacion/models/alarma_model.dart';
import 'package:utm_vinculacion/providers/alarms_provider.dart';


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
Future<void> showAlarmNotification(AlarmModel alarm) async {

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
  await db.execute(
    "CREATE TABLE Actividad("
    "id INTEGER PRIMARY KEY,"
    "nombre VARCHAR NOT NULL,"
    "descripcion VARCHAR NOT NULL,"
    "date VARCHAR NULL,"
    "time VARCHAR NULL,"
    "active INTEGER DEFAULT 0"
    ");"
  );
        
  await db.execute(
    "CREATE TABLE Ingrediente("
    "id INTEGER PRIMARY KEY,"
    "nombre VARCHAR NOT NULL"
    ");"
  );

  await db.execute(
    "CREATE TABLE Comida("
    "id INTEGER PRIMARY KEY,"
    "nombre VARCHAR NOT NULL,"
    "descripcion VARCHAR NOT NULL,"
    "preparacion VARCHAR NOT NULL,"
    "total VARCHAR NOT NULL,"
    "calorias VARCHAR NOT NULL,"
    "coccion VARCHAR NOT NULL,"
    "comensales VARCHAR NOT NULL,"
    "tipo VARCHAR NOT NULL,"
    "urlImagen VARCHAR,"
    "rutaVista VARCHAR"
    ");"
  );

  await db.execute(
    "CREATE TABLE ComidaIngrediente("
    "idComida INTEGER NOT NULL,"
    "idIngrediente VARCHAR NOT NULL,"
    "CONSTRAINT pkComidaIngrediente PRIMARY KEY(idComida, idIngrediente),"
    "CONSTRAINT fkComida FOREIGN KEY(idComida) REFERENCES Comida(id) "
    "ON UPDATE CASCADE ON DELETE NO ACTION,"
    "CONSTRAINT fkIngrediente FOREIGN KEY(idIngrediente) REFERENCES Ingrediente(nombre) "
    "ON UPDATE CASCADE ON DELETE NO ACTION"
    ");"
  );

  await db.execute(
    "CREATE TABLE cuidado("
    "id INTEGER NOT NULL,"
    "nombre VARCHAR NOT NULL,"
    "descripcion VARCHAR NOT NULL,"
    "date VARCHAR NULL," // "YYYY/MM/DD"
    "time VARCHAR NULL," // "HH:MM"
    "active INTEGER DEFAULT 1,"
    "CONSTRAINT pkCuidado PRIMARY KEY(id)"
    ");"
  );

  await db.execute(
    "CREATE TABLE alarma("
    "id INTEGER PRIMARY KEY,"
    "title VARCHAR NULL DEFAULT \"Sin título\","
    "body VARCHAR NULL DEFAULT \"Sin descripción\","
    "date VARCHAR NOT NULL," // "YYYY/MM/DD"
    "time VARCHAR NOT NULL," // "HH:MM"
    "active INTEGER DEFAULT 1,"
    "interval INTEGER DEFAULT 7"
    ");"
  );

  await db.execute(
    "CREATE TABLE actividadesAlarmas("
    "alarma_id INTEGER NOT NULL,"
    "actividad_id INTEGER NOT NULL,"
    "FOREIGN KEY(actividad_id) REFERENCES actividad(id) ON UPDATE CASCADE ON DELETE NO ACTION,"
    "FOREIGN KEY(alarma_id) REFERENCES alarma(id) ON UPDATE CASCADE ON DELETE NO ACTION"
    ");"
  );

  await db.execute(
    "CREATE TABLE cuidadosAlarmas("
    "alarma_id INTEGER NOT NULL,"
    "cuidado_id INTEGER NOT NULL,"
    "FOREIGN KEY(alarma_id) REFERENCES alarma(id) ON UPDATE CASCADE ON DELETE NO ACTION,"
    "FOREIGN KEY(cuidado_id) REFERENCES cuidado(id) ON UPDATE CASCADE ON DELETE NO ACTION"
    ");"
  );
}