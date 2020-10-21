

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmsProvider {
	DateTime _date; // fecha en la que sonara la alarma
	String _proposito; // descripcion de la alarma
	String _titulo; // El titulo que se mostrara en la barra de estado
	int _id = DateTime.now().hashCode; // Check this one

	AlarmsProvider(DateTime date, {String proposito, String titulo}){
		this._date = date;
		this._proposito = proposito;
		this._titulo = titulo;
	}
	
	static final androidChannel = AndroidNotificationDetails('show weekly channel id', 'show weekly channel name', 'show weekly description');
	static final iOSChannel = IOSNotificationDetails();

  

  int get id => _id;
  String get titulo => _titulo ?? "Sin título";
  String get proposito => _proposito ?? "Sin descripción";
  DateTime get fecha => _date;
}
	
