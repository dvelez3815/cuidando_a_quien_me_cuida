
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:utm_vinculacion/providers/alarms_provider.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';

class AlarmModel {
  int _id;
  String title;
  String description;
  DateTime time;
  bool active;

  static DBProvider db = DBProvider.db;

  AlarmModel(this.time, {this.title, this.description}) {
    _id = DateTime.now().hashCode;
  }

  Future<void> playSong()async{
    await AlarmProvider.player.play('sonido.mp3', isLocal: true);
  }

  Future<void> stopSong() async {
    await AlarmProvider.player.stop();
  }

  static Future<void> showAlarm(int id) async {

    // buscando la alarma en la DB
    AlarmModel alarm = await db.getAlarma(id);

    if(alarm == null) return;

    final localNotification = FlutterLocalNotificationsPlugin();
    await localNotification.show(
      alarm.id, alarm.title, alarm.description, 
      NotificationDetails(AlarmProvider.androidChannel, AlarmProvider.iOSChannel)
    );
  }

  Future<void> save()async{
    await AndroidAlarmManager.oneShotAt(time, _id, showAlarm);
    await db.nuevaAlarma(this);
  }

  Map<String, dynamic> toJson()=>{
    "id":    _id,
    "title": title,
    "body":  description,
    "active": (active ?? true)? 1:0
  };

  AlarmModel.fromJson(Map<String, dynamic> json) {
    this._id = json["id"];
    this.title = json["title"];
    this.description = json["body"];
    this.active = json["active"]==1;
  }

  int get id =>_id;
}