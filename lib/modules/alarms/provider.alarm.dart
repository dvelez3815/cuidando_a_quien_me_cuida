
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:utm_vinculacion/routes/route.names.dart';

class AlarmProvider {
    
  static final androidChannel = AndroidNotificationDetails(
     'show weekly channel id', 'show weekly channel name', 'show weekly description');
  static final iOSChannel = IOSNotificationDetails();
  
  // Esto es para el sonido de la alarma (deben ser estaticos)
  static AudioPlayer player = AudioPlayer();
  static AudioCache cache = new AudioCache();

  // Esto es para la notificacion en la barra de estado
  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final initializationSettingsAndroid = AndroidInitializationSettings("app_icon");
  static final initializationSettingsIOS = IOSInitializationSettings();
  static final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid, 
    iOS: initializationSettingsIOS
  );

  static AlarmProvider _instance;

  factory AlarmProvider() {
    if(_instance == null) {
      _instance = new AlarmProvider._();
    }

    return _instance;
  }

  AlarmProvider._();

  
  static Future<void> playSong()async{
    final audio = new AudioCache();
    await audio.play(
      'sonido.mp3',
      stayAwake: true,
      isNotification: true,
      volume: double.infinity, 
    );
  }

  static Future<void> stopSong() async {
    await player.stop();
  }

  void init(BuildContext context){
    
    // Esto dice que hacer cuando el usuario da tap en la notificacion
    Future selectNotification(String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      await AlarmProvider.stopSong();
      await Navigator.of(context).pushNamed(HOME);
    }

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification
    );
  }
  
}