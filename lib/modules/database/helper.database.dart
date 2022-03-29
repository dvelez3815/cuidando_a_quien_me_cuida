import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

/// Loads all default data defined in database_script.sql file and
/// saves it in [db] what is an instance of database
Future<void> defaultData(Database db) async {
  bool success = await _performQueries(db, "lib/modules/database/database_script.sql");
  
  await upgradeDB(db);

  if(success){
    print("All default data has been added");
  }
  else {
    throw new ErrorDescription("There were some errors while trying to load default data");
  }
}

/// Initialize an instance of the database [db] with the [version]
Future<void> initDatabase(Database db, int version) async{
  await _performQueries(db, "lib/modules/database/database.sql"); // Creation

}

/// Updates database. You should put here all the files corresponging to
/// updates to SQLite.
Future<void> upgradeDB(Database db) async {
  await _performQueries(db, "lib/modules/database/update.sql");
  await _performQueries(db, "lib/modules/database/update03.28.22.sql");
}

/// This will transform all queries in database_script.sql located in [route] into a
/// string that can be interpretated by the [db]
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
