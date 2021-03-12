const List<String> days = ["lunes", "martes", "miercoles", "jueves", "viernes", "sabado", "domingo"];

int parseDayFromString(String day)=>days.indexOf(day) + 1;

String parseDayWeek(int day){
  switch(day){
    case 1: return "LUNES";
    case 2: return "MARTES";
    case 3: return "MIERCOLES";
    case 4: return "JUEVES";
    case 5: return "VIERNES";
    case 6: return "SABADO";
    default: return "DOMINGO";
  }
}

int parseDay(String day){

  int returnDay = 1;

  switch(day.toUpperCase()){
    case "LUNES": returnDay=1; break;
    case "MARTES": returnDay=2; break;
    case "MIERCOLES": returnDay=3; break;
    case "JUEVES": returnDay=4; break;
    case "VIERNES": returnDay=5; break;
    case "SABADO": returnDay=6; break;
    case "DOMINGO": returnDay=7; break;
  }

  return returnDay;
}

String parseMonth(int month) {
  switch(month){
    case 1: return "Enero";
    case 2: return "Febrero";
    case 3: return "Marzo";
    case 4: return "Abril";
    case 5: return "Mayo";
    case 6: return "Junio";
    case 7: return "Julio";
    case 8: return "Agosto";
    case 9: return "Septiembre";
    case 10: return "Octubre";
    case 11: return "Noviembre";
    case 12: 
    default: return "Diciembre";
  }
}

String getFormattedDate({DateTime date}){
  
  date = date ?? DateTime.now();

  return "${parseDayWeek(date.weekday)} ${date.day} de ${parseMonth(date.month)} del ${date.year}";
}