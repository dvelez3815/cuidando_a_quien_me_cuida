import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:device_preview/device_preview.dart' as dp;
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:utm_vinculacion/modules/global/settings.dart';
import 'package:utm_vinculacion/modules/global/theme.dart';
import 'package:utm_vinculacion/modules/music/provider.music.dart';
import 'package:utm_vinculacion/user_preferences.dart';
import 'modules/alarms/provider.alarm.dart';

import 'routes/routes.dart' as rutas;

void main() async {
  // Esto es para que los widgets tengan prioridad en la carga
  WidgetsFlutterBinding.ensureInitialized();
  
  final AppSettings appSettings = new AppSettings();
  final UserPreferences pref = new UserPreferences();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.blueAccent,
    ),
  );
  
  await DotEnv().load('.env');

  MusicProvider().init();
  await AndroidAlarmManager.initialize();
  await appSettings.initState();
  await pref.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final AlarmProvider alarmProvider = new AlarmProvider();


  MyApp(){
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
          debugShowCheckedModeBanner: false,
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
