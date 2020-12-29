import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{

  static final UserPreferences _userPrefs = new UserPreferences._internal();

  StreamController<bool> darkModeController = new StreamController<bool>();

  void dispose(){
    darkModeController?.close();
  }

  factory UserPreferences(){
    return _userPrefs;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }


  set darkMode(bool value) {
    darkModeController.sink.add(value);
    _prefs.setBool('dark_mode', value);
  }

  set waterGoal(double lts) {
    _prefs.setDouble('water_goal', lts);
  }

  set waterProgress(double lts) {
    _prefs.setDouble('water_progress', lts);
  }

  set glassContent(double lts) {
    _prefs.setDouble('glass_content', lts);
  }

  bool get darkMode => _prefs.getBool('dark_mode');
  Stream<bool> get darkStream => darkModeController.stream;
  double get waterGoal => _prefs.getDouble("water_goal");
  double get waterProgress => _prefs.getDouble("water_progress");
  double get glassContent => _prefs.getDouble("glass_content");
}