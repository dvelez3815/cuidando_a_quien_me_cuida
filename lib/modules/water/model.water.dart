import 'package:utm_vinculacion/modules/global/helpers.dart';

class WaterModel {

  double _goal;
  double _progress;
  int _size;
  int _id;

  WaterModel(this._goal, this._progress, this._size){
    this._id = generateID();
  }

  WaterModel.fromJson(Map<String, dynamic> json){
    this._goal = json['goal'];
    this._progress = json['progress'];
    this._size = json['size'];
    this._id = json['id'];
  }

  Map<String, dynamic> toJson()=>{
    'id': this._id,
    'goal': this._goal,
    'progress': this._progress,
    'size': this._size
  };

  double get progress => this._progress;
  double get goal => this._goal;
  int get glassSize => this._size;
  int get id => this._id;

  set goal(double value) {
    assert(value != null && value > 0);
    this._goal = value;
  }

  set glassSize(int value) {
    assert(value != null && value > 0);
    this._size = value;
  }

  set progress(double value) {
    assert(value != null && value > 0);
    this._progress = value;
  }

}