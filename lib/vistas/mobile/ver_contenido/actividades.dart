import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/alarma_model.dart';
import 'package:utm_vinculacion/providers/alarms_provider.dart';

/*
class Actividades extends StatefulWidget {
  Actividades({Key key}) : super(key: key);

  @override
  _ActividadesState createState() => _ActividadesState();
}

class _ActividadesState extends State<Actividades> {

  final DBProvider dbProvider = DBProvider.db;
  // Esto es para el sonido de la alarma (deben ser estaticos)
  static AudioPlayer player = AudioPlayer();
  static AudioCache cache = new AudioCache();

  static final androidChannel = AndroidNotificationDetails(
     'show weekly channel id', 'show weekly channel name', 'show weekly description');
  static final iOSChannel = IOSNotificationDetails();
  // Esto es para las notificaciones
  final notification = FlutterLocalNotificationsPlugin();


  @override
  void initState() {
    dbProvider.getActividades();
    // Esto es para la notificacion en la barra de estado
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // "app_icon" debe existir en la ruta android\app\src\main\res\drawable y debe ser png.
    final initializationSettingsAndroid = AndroidInitializationSettings("app_icon");
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification
    );
    super.initState();
  }

  // Esto dice que hacer cuando el usuario da tap en la notificacion
  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.of(context).pushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text('Nombre de la app'), actions: <Widget>[
        tresPuntos()        
      ],),
      body: listaContenido()
    );
  }

  Widget listaContenido(){
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Mis Actividades",
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add), 
                  onPressed: showTemporalPicker,
                )
              ],
            ),
            StreamBuilder(
              stream: dbProvider.actividadStream,
              builder: (BuildContext context, AsyncSnapshot<List<Actividad>> snapshot){
                
                if(!snapshot.hasData) return sinDatos();

                final List<Widget> widgets = new List<Widget>();

                widgets.addAll(snapshot.data.map((item)=>ListTile(
                  onTap: (){},  
                  // Suspendido hasta que se agreguen imagenes 
                  // leading: Container(
                  //   width: MediaQuery.of(context).size.width*0.2,
                  //   child: item.rutaImagen != null?Image.asset(item.rutaImagen):Container()
                  // ),
                  subtitle: Text(item.hora),
                  title: Text(item.nombre),
                  trailing: Text(item.estado? "Activo":"Inactivo"),
                )).toList());

                return Column(
                  children: widgets,
                );

              },
            ),
          ],
        )
      ),
      
    );
  }

  Future<void> showTemporalPicker() async{
    final date = DateTime.now();
    
    // Obteniendo hora de la alarma
    final time = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now()
    );

    AlarmsProvider alarm = new AlarmsProvider(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
      titulo: "Título de la alarma",
      proposito: "Descripción"
    );

    print("Llego aca ${alarm.fecha.hour}:${alarm.fecha.minute} - ${alarm.fecha.day}/${alarm.fecha.month}/${alarm.fecha.year}");
    AndroidAlarmManager.oneShotAt(
       alarm.fecha, 
       alarm.id, ejecucion
    );
  }

  // Esto reproduce el sonido y muestra la notificacion
  static Future<void> ejecucion() async {
    print("Aca tambien");
    player = await cache.play('sonido.mp3');

    final localNotification = FlutterLocalNotificationsPlugin();
    await localNotification.show(
      1999, "Titulo Alarma", "Esto es un body", 
      NotificationDetails(androidChannel, iOSChannel)
    );
  }
}*/
class Actividades extends StatefulWidget {                
  @override
  _ActividadesState createState() => _ActividadesState();
}

class _ActividadesState extends State<Actividades> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AlarmProvider alarm = new AlarmProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarmas')
      ),
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: FlatButton.icon(
                onPressed: showPicker,
                color: Colors.green,
                icon: Icon(Icons.timer),
                label: Text('Establecer hora')
              ),
            ),
            FlatButton.icon(
              onPressed: ()async{
                await AndroidAlarmManager.cancel(1999);
              }, 
              icon: Icon(Icons.cancel), 
              label: Text('Cancelar alarma'),
              color: Colors.red,
              textColor: Colors.white,
            ),
            FlatButton.icon(
              onPressed: ()async{
                await AlarmProvider.player.stop();
              },
              icon: Icon(Icons.stop),
              label: Text('Detener alarma'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showPicker()async{
    final date = DateTime.now();

    // Obteniendo hora de la alarma
    final time = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now()
    );

    // cancelando alarma anterior
    // await AndroidAlarmManager.cancel(alarmID);
    AlarmModel model = new AlarmModel(
      new DateTime(date.year, date.month, date.day, time.hour, time.minute),
      title: "Alarma", description: "Body"
    );

    await model.save();

    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('La alarma sonara el ${date.day}/${date.month}/${date.year} a las ${time.hour}:${time.minute}')
    ));
  }
}