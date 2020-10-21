import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:utm_vinculacion/local_storage/user_preferences.dart';
import 'rutas/rutas.dart' as rutas;

void main() async {
  // Esto es para que los widgets tengan prioridad en la carga
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  // Preferencias de usuario que se almacenan en cache
  UserPreferences pref = new UserPreferences();
  await pref.initPrefs();  


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: UserPreferences().darkStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        return MaterialApp(
          // locale: DevicePreview.of(context).locale,
          builder: DevicePreview.appBuilder,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: [const Locale('en', 'US'), const Locale('es', 'ES')],
          debugShowCheckedModeBanner: false,
          onGenerateRoute: rutas.generarRutas,
          darkTheme: ThemeData.dark(),
          themeMode: (UserPreferences().darkMode ?? false)? ThemeMode.dark:ThemeMode.light,
          initialRoute: '/',
        );
      },
    );

  }

}
