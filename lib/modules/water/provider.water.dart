import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utm_vinculacion/modules/alarms/model.alarm.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/water/model.water.dart';
import 'package:utm_vinculacion/user_preferences.dart';

import 'helper.water.dart';

// TODO: hacer la creación de las alarmas algo dinámico. De momento
// cuando se edita el tamaño del vaso o el objetivo diario, estas 
// permanecen intactas, es más, habrán bugs.

class WaterProvider {

  static const START_ALARM_ID = -1;

  final _dbProvider = DBProvider.db;

  static WaterProvider _instance;

  factory WaterProvider(){
    if(_instance == null){
      _instance = new WaterProvider._();
    }

    return _instance;
  }

  WaterProvider._();

  final BehaviorSubject<WaterModel> _modelStreamController = new BehaviorSubject<WaterModel>();

  Function(WaterModel) get _modelSink => _modelStreamController.sink.add;

  Stream<WaterModel> get modelStream => _modelStreamController.stream;

  WaterModel get model => _modelStreamController.value;

  dispose(){
    _modelStreamController?.close();
  }

  Future<void> init()async{

    WaterModel water = await _dbProvider.lastWater();

    if(water == null) {
      water = new WaterModel(
        2.0, 
        UserPreferences().waterProgress ?? 0.0, 
        225,
        start: TimeOfDay(hour: 6, minute: 0),
        end: TimeOfDay(hour: 21, minute: 0)
      );
      await this.storageInDB(water: water);
    }
    this._modelSink(water);
  }

  void addWaterLts({double lts}) {
    assert(lts == null || (lts != null && lts > 0));

    // how many lts of water user is gonna drink
    lts = lts ?? this.model.glassSize / 1000;

    this.model.progress = lts + model.progress;
    this._modelSink(this.model);
    UserPreferences().waterProgress = this.model.progress;
  }

  Future<void> updateGoal(double newGoal) async{

    assert(newGoal > 0);

    final res = await this._dbProvider.updateWater({"goal": newGoal}, model.id);
    
    if(res) {
      this.model.goal = newGoal;
      _modelSink(this.model);
    }
  }

  Future<void> updateGlassContent(int mlts) async {

    assert(mlts > 0);

    final res = await this._dbProvider.updateWater({"size": mlts}, model.id);
    
    if(res) {
      this.model.glassSize = mlts;
      this._modelSink(this.model);
    }
  }

  void removeWaterGlasses({int howManyGlasses = 1}) {
    
    final progress = this.model.progress;
    final glassSize = this.model.glassSize / 1000;

    assert(howManyGlasses >= 1 && progress >= glassSize*howManyGlasses);

    this.model.progress -= glassSize*howManyGlasses;
    this._modelSink(this.model);
    UserPreferences().waterProgress = this.model.progress;
  }

  void restoreProgress() {    
    this.model.progress = 0.0;
    this._modelSink(this.model);
    UserPreferences().waterProgress = 0;
  }

  Future<void> storageInDB({WaterModel water}) async => await this._dbProvider.storeWater(water ?? this.model);

  Future<void> enableAlarms()async{
    
    // IMPORTANT: This alarm model does not work with the same
    // callback that activity models, it has its own callback
    // defined at the top of this file.
    final startAlarm = new AlarmModel(
      DateTime.now().weekday, TimeOfDay.now(), 
      "Tomar agua", "Bebe un poco de agua", 
      interval: 1, id: START_ALARM_ID
    );

    await startAlarm.save(activate: ()async{
      await AndroidAlarmManager.periodic(
        Duration(days: 1), // It will notify us every day
        startAlarm.id, // It's the same ID always
        startRoutineCallback, // It is our tuned callback
        exact: true,
        rescheduleOnReboot: true
      );
    });

    this.model.isActive = true;
    await this._dbProvider.updateWater({
      "active": 1
    }, this.model.id);
  }

  Future<void> destroyAlarms()async{
    final alarmStart = await DBProvider.db.getAlarma(START_ALARM_ID);
    final alarmReminders = await DBProvider.db.getAlarma(REMINDER_ALARM_ID);

    await alarmStart.delete();
    await alarmReminders.delete();

    this.model.isActive = false;
    await this._dbProvider.updateWater({
      "active": 0
    }, this.model.id);
  }

  int timesToDrinkWater({double maxValueInLts}) {
    return (maxValueInLts ?? this.model.goal) ~/ (this.model.glassSize / 1000);
  }


}