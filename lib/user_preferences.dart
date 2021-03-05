import 'dart:async';

import 'package:flutter/painting.dart';
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
    _prefs.setBool('reminder_created', value);
  }

  set showTutorial(bool value) {
    _prefs.setBool('show_tutorial', value);
  }

  bool get areWaterAlarmsCreated => _prefs.getBool('reminder_created') ?? false;
  bool get darkMode => _prefs.getBool('dark_mode');
  bool get showTutorial => _prefs.getBool('show_tutorial') ?? true;
  Stream<bool> get darkStream => darkModeController.stream;
  double get waterProgress => _prefs.getDouble("water_progress");
}