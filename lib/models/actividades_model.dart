class Actividad {

  String titulo;
  String contenido;
  DateTime fecha;
  bool completado;

  Actividad({this.titulo, this.contenido, this.fecha, this.completado = false});

  Actividad.fromJson(Map<String, dynamic> json){
    titulo      = json['titulo'];
    contenido   = json['contenido'];
    fecha       = new DateTime(json['anio'], json['mes'], json['dia'], json['hora'], json['minuto']);
    completado  = json['completado'];
  }

  Map<String, dynamic> toJson() => {
    'titulo'    :titulo,
    'contenido' :contenido,
    'completado':completado,
    'anio'      :fecha.year,
    'mes'       :fecha.month,
    'dia'       :fecha.day,
    'hora'      :fecha.hour,
    'minuto'    :fecha.minute,
  };

}