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

  bool get darkMode => _prefs.getBool('dark_mode');
  Stream<bool> get darkStream => darkModeController.stream;
}