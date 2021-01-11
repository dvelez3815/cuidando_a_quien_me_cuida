import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/global/helpers.dart';

class WaterModel {

  double _goal;
  double _progress;
  int _size;
  int _id;
  bool _active;
  TimeOfDay _start;
  TimeOfDay _end;

  WaterModel(this._goal, this._progress, this._size, {TimeOfDay start, TimeOfDay end}){
    this._start = start;
    this._end = end;
    this._active = false;
    this._id = generateID();
  }

  WaterModel.fromJson(Map<String, dynamic> json){
    this._goal = json['goal']/1.0;
    this._progress = json['progress']/1.0;
    this._size = json['size'];
    this._id = json['id'];
    this._start = new TimeOfDay(hour: json['start_hour'], minute: json['start_minute']);
    this._end = new TimeOfDay(hour: json['end_hour'], minute: json['end_minute']);
    this._active = (json['active'] ?? 0) == 1;
  }

  Map<String, dynamic> toJson()=>{
    'id': this._id,
    'goal': this._goal,
    'progress': this._progress,
    'size': this._size,
    'start_hour': this._start.hour,
    'start_minute': this._start.minute,
    'end_hour': this._end.hour,
    'end_minute': this._end.minute,
    'active': this._active? 1:0
  };

  /// This will give you the glass size measured in liters
  double get progress => this._progress;
  
  /// This will give you the glass size measured in liters
  double get goal => this._goal;

  /// This will give you the glass size measured in mililiters
  int get glassSize => this._size;

  int get id => this._id;
  TimeOfDay get startTime => this._start;
  TimeOfDay get endTime => this._end;

  int get timeDiff {
    final now = DateTime.now();
    final startTime = new DateTime(now.year, now.month, now.day, this._start.hour, this._start.minute);
    final endTime = new DateTime(now.year, now.month, now.day, this._end.hour, this._end.minute);

    final diff = endTime.difference(startTime);

    return diff.inMinutes;
  }

  /// This will return how many minutes is the period of alarms,
  /// it means, every X minutes the alarms will notify the user, 
  /// where X is the period
  int get periodInMinutes => this.timeDiff ~/ this.howManyGlasses;

  /// Returns the number of glasses of water that user
  /// needs to drink
  int get howManyGlasses => (this.goal / (this.glassSize / 1000)).ceil();

  /// Returns the number of glasses of water left to
  /// achieve the daily goal
  int get howManyGlassesLeft {

    if(this.progress >= this.goal) return 0;
    if(this.glassSize > this.goal*1000) return 1;

    return (1000 * (this.goal - this.progress) / this.glassSize).ceil();
  }

  bool get isActive => this._active;

  set isActive(bool value) => this._active = value;

  set goal(double value) {
    assert(value != null && value >= 0);
    this._goal = value;
  }

  set glassSize(int value) {
    assert(value != null && value >= 0);
    this._size = value;
  }

  set progress(double value) {
    assert(value != null && value >= 0);
    this._progress = value;
  }

  set startTime(TimeOfDay time) {
    final alarmsToCreate = this.goal ~/ (this.glassSize/1000);

    if(this._end.hour - time.hour < alarmsToCreate/2){
      throw ErrorDescription("Period of time between start and end alarms are too close");
    }
    else{
      this._start = time;
    }
  }

  set endTime(TimeOfDay time) {
    final alarmsToCreate = this.goal ~/ (this.glassSize/1000);

    if(time.hour - this._start.hour < alarmsToCreate/2){
      throw ErrorDescription("Period of time between start and end alarms are too close");
    }
    else{
      this._end = time;
    }
  }


}