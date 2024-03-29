
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/global/helpers.dart';

import 'helper.alarm.dart';

class AlarmModel {
  int _id; 
  String _title; // part of payload
  String _description; // part of payload
  int _dayToNotify; // time where this alarm has to notify
  bool _active; // if this alarm is active or not
  int _interval; // this is the repetition rate for alarms measured in days
  TimeOfDay _time; // time to be notified
  Duration _period;

  // this is the seed for id generation
  static final DateTime referenceDateId = new DateTime(2020, 1, 1, 1, 1, 1);
  static DBProvider db = DBProvider.db;

  //////////////////////////////// Constructor ////////////////////////////////
  AlarmModel(this._dayToNotify, this._time, this._title, this._description, {int interval, bool isMinute=false, int id}) {

    assert(interval==null || interval > 0);

    this._id = id ?? generateID();
    this._interval = interval ?? 7; // repeat it every 7 days (every week)
    this._period = isMinute? Duration(minutes: this._interval):Duration(days: this._interval);
    this._active=true;  // at the beginning all alarms will be active
  }

  ////////////////////////////// CRUD in database //////////////////////////////
  
  /// This method will create an alarm in local database. If you want to relate
  /// this with a care or an activity you need to go to that model and search for
  /// that method.
  /// @interval variable will storage the frequency of repetition measured in days.
  Future<bool> save({int interval, bool isMinute=false, Function activate}) async {    
    this._interval = interval ?? this._interval;
    this._period = isMinute? Duration(minutes: this._interval):Duration(days: this._interval);
    
    // You can create your own activate method if you want to do something else
    await this.activate(showNotification: activate);

    await db.deleteAlarm(this.id);
    return await db.nuevaAlarma(this);
  }

  /// You need to provide a map with the response of the database
  AlarmModel.readFromDB(Map<String, dynamic> json) {
    final timeDB = json["time"].toString().split(":").map((i)=>int.parse(i)).toList();
    
    this._id = json["id"];
    this._title = json["title"];
    this._description = json["body"];
    this._active = json["active"]==1;
    this._time = new TimeOfDay(hour: timeDB[0], minute: timeDB[1]);
    this._dayToNotify = json["day"] ?? 1;
    this._interval = json["interval"] ?? 7;
    this._period = (json["waterReminder"] ?? false)? Duration(minutes: this._interval):Duration(days: this._interval);
  }

  /// In params you need to specify which fields you want to change. ID
  /// are not allowed to change.
  Future<bool> update(Map<String, dynamic> params) async {
    return await db.updateAlarm(params, this._id);
  }

  Future<bool> delete() async {
    bool res = await db.deleteAlarm(this._id);
    return res && (await AndroidAlarmManager.cancel(this._id));
  }

  /////////////////////////////// Funtionality ///////////////////////////////
  /// This method will create and schedule a service in android OS to be
  /// notifyed at an specific time.
  Future<void> activate({Function showNotification}) async {    
    // this will be the next time this alarm will be triggered
    final date = nextDateAlarm(DateTime.now(), this._dayToNotify, time: this._time);

    await AndroidAlarmManager.periodic(
      this._period,
      this._id,
      showNotification ?? showAlarmNotification,
      startAt: date,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true // no poner true hasta estar seguros de que funciona
    );
  }

  /// You can use this to pause/cancel/delete an alarm from the operative system
  Future<bool> desactivate() async => await AndroidAlarmManager.cancel(this._id);

  /// Will create a json to storage it in database
  Map<String, dynamic> toJson()=>{
    "id":    this._id,
    "title": this._title,
    "body":  this._description,
    "interval": this._interval,
    "active": (this._active ?? true)? 1:0,
    "time": "${this._time.hour}:${this._time.minute}",
    "day": this._dayToNotify
  };

  ////////////////////////////////////// Getters //////////////////////////////////////
  int get id => this._id;
  String get title => this._title;
  String get description => this._description;
  bool get status => this._active;
  int get dayToNotify => this._dayToNotify;
  TimeOfDay get time => this._time;
  ////////////////////////////////////// Setters //////////////////////////////////////
  set title(String title) => this._title = title;
  set description(String desc) => this._description = desc;

}
