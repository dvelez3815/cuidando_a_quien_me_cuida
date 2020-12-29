import 'package:rxdart/rxdart.dart';
import 'package:utm_vinculacion/user_preferences.dart';

class WaterProvider {

  static WaterProvider _instance;

  factory WaterProvider(){
    if(_instance == null){
      _instance = new WaterProvider._();
    }

    return _instance;
  }

  WaterProvider._();

  final BehaviorSubject<double> _goalStreamController = new BehaviorSubject<double>();
  final BehaviorSubject<double> _progressStreamController = new BehaviorSubject<double>();

  Function(double) get goalSink => _goalStreamController.sink.add;
  Function(double) get progressSink => _progressStreamController.add;

  Stream<double> get goalStream => _goalStreamController.stream;
  Stream<double> get progressStream => _progressStreamController.stream;

  double get goalValue => _goalStreamController.value;

  dispose(){
    _goalStreamController?.close();
    _progressStreamController?.close();
  }

  void init(){
    goalSink(UserPreferences().waterGoal ?? 2.0);
    progressSink(UserPreferences().waterProgress ?? 0.0);
  }

  void addWaterLts(double lts) {
    assert(lts > 0);
    progressSink(lts + _progressStreamController.value);
    UserPreferences().waterProgress = _progressStreamController.value;
  }

  void updateGoal(double newGoal) {

    assert(newGoal > 0);
    goalSink(newGoal);
    progressSink(_progressStreamController.value);
    UserPreferences().waterGoal = _goalStreamController.value;
  }

}