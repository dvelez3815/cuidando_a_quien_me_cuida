import 'package:flutter/material.dart';

ThemeData getMainTheme() {
  return new ThemeData(
    brightness: Brightness.light,
    canvasColor: Colors.white,
    accentColor: Color(0xff01402d),
    backgroundColor: Color(0xffd4a478),
    bottomAppBarColor: Color(0xffbdcc55)
  );
}

ThemeData getDarkTheme() {
  return new ThemeData(
    brightness: Brightness.dark,
    canvasColor: Color(0xff01402d),
    accentColor: Color(0xffa2724c),
    backgroundColor: Color(0xffbdcc55),
    bottomAppBarColor: Color(0xffbdcc55)
  );
}