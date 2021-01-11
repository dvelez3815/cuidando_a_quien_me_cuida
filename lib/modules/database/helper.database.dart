import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

Future<void> defaultData(Database db) async {
  bool success = await _performQueries(db, "lib/modules/database/database_script.sql");

  if(success){
    print("All default data has been added");
    // Initializing alarms
    // final res = List<Map<String, dynamic>>.from(await db.query("Actividad"));

    // res.forEach((Map<String, dynamic> element)async{
    //   await Actividad.fromJson(element).createAlarms();
    // });
  }
}

Future<void> initDatabase(Database db, int version) async{
  await _performQueries(db, "lib/modules/database/database.sql");
}

Future<bool> _performQueries(Database db, String route) async {
  final batch = db.batch(); // to excecute atomic operations

  String script = await rootBundle.loadString(route, cache: false);
  script = script.trim();

  script.split(';').forEach((element) {
    if(element.length < 5) return;
    batch.execute(element);
  });
  
  // batch.execute(script);
  final res = await batch.commit();
  
  print(res.length.toString() + " operations performed");
  return res.length > 0;
}
