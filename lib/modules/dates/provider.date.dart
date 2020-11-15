import 'package:utm_vinculacion/modules/database/provider.database.dart';

class _FechasProvider {

  DBProvider dbProvider = DBProvider.db;

  List<String> dias = new List<String>();
  List<String> meses = new List<String>();
  //int _selectedTab = 0;

  _FechasProvider(){
    dias.add('Lunes');
    dias.add('Martes');
    dias.add('Miércoles');
    dias.add('Jueves');
    dias.add('Viernes');
    dias.add('Sábado');
    dias.add('Domingo');

    meses.add('Enero');
    meses.add('Febrero');
    meses.add('Marzo');
    meses.add('Abril');
    meses.add('Mayo');
    meses.add('Junio');
    meses.add('Julio');
    meses.add('Agosto');
    meses.add('Septiembre');
    meses.add('Octubre');
    meses.add('Noviembre');
    meses.add('Diciembre');
  }

  String getFechaEnString(DateTime fecha){
    String dia, mes;

    dia = dias[fecha.weekday - 1];
    mes = meses[fecha.month - 1];

    return '$dia ${fecha.day} de $mes del ${fecha.year}';
  }

  String getHorario(DateTime fecha){

    String horario;

    if(fecha.hour<12 && fecha.hour>5) horario = 'Morning';
    else if(fecha.hour>=12 && fecha.hour < 19) horario = 'Tarde';
    else horario = 'Noche';

    return horario;

  }

  // // si retorna false, es que la fecha no es válida
  // Future<bool> guardaActividad(Actividad actividad) async{

  //   if(actividad.fecha.compareTo(DateTime.now()) <= 0 ){
  //     return false;
  //   }

  //   if( await dbProvider.nuevaActividad(actividad) == 0) return false;

  //   return true;
  // }

}

// este objeto será el que se llamará en los otros archivos
_FechasProvider fechaProvider = new _FechasProvider();