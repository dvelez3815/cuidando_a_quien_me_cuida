import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'rutas/rutas.dart' as rutas;

void main() => runApp(DevicePreview(builder: (context)=>MyApp()));
//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.of(context).locale,
      builder: DevicePreview.appBuilder,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en','US'), 
          const Locale('es','ES')
          ],
      debugShowCheckedModeBanner: false,
      onGenerateRoute: rutas.generarRutas,
      initialRoute: 'test',
    );
  }
}