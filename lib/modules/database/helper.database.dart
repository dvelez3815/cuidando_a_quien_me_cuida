import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

Future<void> defaultData(Database db) async {
  await _performQueries(db, "lib/modules/database/database_script.sql");
}

Future<void> initDatabase(Database db, int version) async{
  await _performQueries(db, "lib/modules/database/database.sql");
}

Future<void> _performQueries(Database db, String route) async {
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
}
