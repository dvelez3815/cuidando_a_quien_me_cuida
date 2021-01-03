import 'package:rxdart/rxdart.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/water/model.water.dart';
import 'package:utm_vinculacion/user_preferences.dart';

class WaterProvider {

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
      water = new WaterModel(2.0, UserPreferences().waterProgress ?? 0.0, 225);
      // TODO: make sure this is correct
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

  void restoreProgress() {    
    this.model.progress = 0.0;
    this._modelSink(this.model);
    UserPreferences().waterProgress = 0;
  }

  Future<void> storageInDB({WaterModel water}) async {
    // TODO: define alarms
    // final alarm = new AlarmModel(
    //   DateTime.now().weekday, TimeOfDay.now(), 
    //   "Tomar agua", "Bebe un poco de agua", interval: 1
    // );

    await this._dbProvider.storeWater(water ?? this.model);
    // await alarm.save();
  }

  int timesToDrinkWater({double maxValueInLts}) {
    return (maxValueInLts ?? this.model.goal) ~/ (this.model.glassSize / 1000);
  }


}