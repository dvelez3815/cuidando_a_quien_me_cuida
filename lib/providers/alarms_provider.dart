
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    initializationSettingsAndroid, initializationSettingsIOS
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
    final audio = new AudioCache().fixedPlayer;
    await audio.play('sonido.mp3', isLocal: true, respectSilence: true,);
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
      await playSong();
      await Navigator.of(context).pushNamed('/');
    }

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification
    );
  }
  
}