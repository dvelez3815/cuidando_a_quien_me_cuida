import 'dart:convert';

import 'package:flutter/services.dart';

class AppSettings {

  static AppSettings _instance;
  Map<String, dynamic> settings;

  factory AppSettings() {

    if(_instance == null){
      _instance = new AppSettings._();
    }

    return _instance;
  }

  Future<void> initState() async {
    final data = await rootBundle.loadString("assets/global_settings.json");
    this.settings = json.decode(data);
  }

  AppSettings._();

}