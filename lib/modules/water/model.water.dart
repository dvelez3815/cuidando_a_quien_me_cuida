import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/global/helpers.dart';

class WaterModel {

  double _goal;
  double _progress;
  int _size;
  int _id;
  TimeOfDay _start;
  TimeOfDay _end;

  WaterModel(this._goal, this._progress, this._size, {TimeOfDay start, TimeOfDay end}){
    this._start = start;
    this._end = end;
    this._id = generateID();
  }

  WaterModel.fromJson(Map<String, dynamic> json){
    this._goal = json['goal']/1.0;
    this._progress = json['progress']/1.0;
    this._size = json['size'];
    this._id = json['id'];
    this._start = new TimeOfDay(hour: json['start_hour'], minute: json['start_minute']);
    this._end = new TimeOfDay(hour: json['end_hour'], minute: json['end_minute']);
  }

  Map<String, dynamic> toJson()=>{
    'id': this._id,
    'goal': this._goal,
    'progress': this._progress,
    'size': this._size,
    'start_hour': this._start.hour,
    'start_minute': this._start.minute,
    'end_hour': this._end.hour,
    'end_minute': this._end.minute
  };

  double get progress => this._progress;
  double get goal => this._goal;
  int get glassSize => this._size;
  int get id => this._id;

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

}