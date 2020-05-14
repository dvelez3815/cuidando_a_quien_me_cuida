
class _FechasProvider {

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

}

_FechasProvider fechaProvider = new _FechasProvider();