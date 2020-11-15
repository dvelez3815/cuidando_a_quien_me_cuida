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