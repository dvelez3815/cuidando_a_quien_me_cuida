import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart' as dp;
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:utm_vinculacion/modules/global/settings.dart';
import 'package:utm_vinculacion/modules/global/theme.dart';
import 'package:utm_vinculacion/modules/music/provider.music.dart';
import 'package:utm_vinculacion/modules/water/provider.water.dart';
import 'package:utm_vinculacion/user_preferences.dart';
import 'modules/alarms/provider.alarm.dart';

import 'routes/routes.dart' as rutas;

void main() async {
  // Esto es para que los widgets tengan prioridad en la carga
  WidgetsFlutterBinding.ensureInitialized();

  // Cache memory for non critical data, like theme, water progress, etc.
  final UserPreferences pref = new UserPreferences();
  
  if(!pref.isInitialized){
    await pref.initPrefs(); // user preferences

  }
  
  
  // This will initialize all application data like name, texts, 
  // colors, etc.
  final AppSettings appSettings = new AppSettings();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.blueAccent,
    ),
  );
  
  // WARNING: the way and order next methods are called matters! Be careful if
  // you want to change it
  // await DotEnv().load(fileName: '.env'); // environment variables
  await AndroidAlarmManager.initialize(); // To create alarms
  await WaterProvider().init(); // water settings
  await appSettings.initState(); // application settings

  MusicProvider().init(); // It does nothing :| but it's important

  if(!UserPreferences().areWaterAlarmsCreated){
    await WaterProvider.loadWaterData();
    UserPreferences().areWaterAlarmsCreated = true;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final AlarmProvider alarmProvider = new AlarmProvider();


  MyApp(){
    // This will allow user to set only portrait up orientation. You
    // can't enable landscape mode in app runtime.
    SystemChrome.setPreferredOrientations([
       DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {

    alarmProvider.init(context);

    return StreamBuilder(
      stream: UserPreferences().darkStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        return MaterialApp(
          // locale: DevicePreview.of(context).locale,
          builder: dp.DevicePreview.appBuilder,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: [const Locale('en', 'US'), const Locale('es', 'ES')],
          debugShowCheckedModeBanner: false, // It only works in development mode
          theme: getMainTheme(),
          darkTheme: ThemeData.dark(),// getDarkTheme(),
          themeMode: (UserPreferences().darkMode ?? false)? ThemeMode.dark:ThemeMode.light,
          initialRoute: '/',
          routes: rutas.getRoutes(),
        );
      },
    );
  }
}
