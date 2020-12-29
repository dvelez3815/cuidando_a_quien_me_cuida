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

  double _glassContent = 0.5;

  final BehaviorSubject<double> _goalStreamController = new BehaviorSubject<double>();
  final BehaviorSubject<double> _progressStreamController = new BehaviorSubject<double>();

  Function(double) get _goalSink => _goalStreamController.sink.add;
  Function(double) get _progressSink => _progressStreamController.add;

  Stream<double> get goalStream => _goalStreamController.stream;
  Stream<double> get progressStream => _progressStreamController.stream;

  double get goalValue => _goalStreamController.value;
  double get glassContent => _glassContent;

  dispose(){
    _goalStreamController?.close();
    _progressStreamController?.close();
  }

  void init(){
    _goalSink(UserPreferences().waterGoal ?? 2.0);
    _progressSink(UserPreferences().waterProgress ?? 0.0);
    this._glassContent = UserPreferences().glassContent ?? 0.5;
  }

  void addWaterLts({double lts}) {
    assert(lts == null || (lts != null && lts > 0));

    lts = lts ?? this._glassContent;

    _progressSink(lts + _progressStreamController.value);
    UserPreferences().waterProgress = _progressStreamController.value;
  }

  void updateGoal(double newGoal) {

    assert(newGoal > 0);
    _goalSink(newGoal);
    _progressSink(_progressStreamController.value);
    UserPreferences().waterGoal = _goalStreamController.value;
  }

  void updateGlassContent(double lts) {
    this._glassContent = lts;
    UserPreferences().glassContent = lts;
  }

  void restoreProgress() {    
    _progressSink(0);
    UserPreferences().waterProgress = 0;
  }
}