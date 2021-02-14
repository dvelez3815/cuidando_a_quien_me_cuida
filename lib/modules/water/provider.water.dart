import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/water/model.water.dart';
import 'package:utm_vinculacion/user_preferences.dart';

// cuando se edita el tamaño del vaso o el objetivo diario, estas 
// permanecen intactas, es más, habrán bugs.

class WaterProvider {

  final BehaviorSubject<WaterModel> _modelStreamController = new BehaviorSubject<WaterModel>();

  Function(WaterModel) get _modelSink => _modelStreamController.sink.add;

  Stream<WaterModel> get modelStream => _modelStreamController.stream;

  WaterModel get model => _modelStreamController.value;

  dispose(){
    _modelStreamController?.close();
  }

  final _dbProvider = DBProvider.db;

  static WaterProvider _instance;

  factory WaterProvider(){
    if(_instance == null){
      _instance = new WaterProvider._();
    }

    return _instance;
  }

  WaterProvider._();

  Future<void> init()async{

    WaterModel water = await _dbProvider.lastWater();

    if(water == null) {
      water = _getDefaultModel();
      await this.storageInDB(water: water);
    }
    this._modelSink(water);
  }

  WaterModel _getDefaultModel() {
    return new WaterModel(
      2.0, 
      UserPreferences().waterProgress ?? 0.0, 
      225,
      start: TimeOfDay(hour: 6, minute: 0),
      end: TimeOfDay(hour: 21, minute: 0)
    );
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

  Future<void> restoreProgress() async {

    if(this.model == null) await this.init();

    this.model.progress = 0.0;
    this._modelStreamController.sink.add(this.model);
    UserPreferences().waterProgress = 0;

    print("process restored");
  }

  Future<void> storageInDB({WaterModel water}) async => await this._dbProvider.storeWater(water ?? this.model);

  int timesToDrinkWater({double maxValueInLts}) {
    return (maxValueInLts ?? this.model.goal) ~/ (this.model.glassSize / 1000);
  }


}