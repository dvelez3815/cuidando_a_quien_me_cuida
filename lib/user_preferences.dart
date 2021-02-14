import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{

  static UserPreferences _userPrefs;

  StreamController<bool> darkModeController = new StreamController<bool>();

  void dispose(){
    darkModeController?.close();
  }

  factory UserPreferences(){
    if(_userPrefs == null) {
      _userPrefs = new UserPreferences._internal();
    }
    return _userPrefs;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  bool get isInitialized => this._prefs != null;


  set darkMode(bool value) {
    darkModeController.sink.add(value);
    _prefs.setBool('dark_mode', value);
  }

  set waterProgress(double lts) {
    _prefs.setDouble('water_progress', lts);
  }

  set areWaterAlarmsCreated(bool value) {
    _prefs.setBool('water_reminders', value);
  }

  bool get areWaterAlarmsCreated => _prefs.getBool('water_reminders') ?? false;
  bool get darkMode => _prefs.getBool('dark_mode');
  Stream<bool> get darkStream => darkModeController.stream;
  double get waterProgress => _prefs.getDouble("water_progress");
}