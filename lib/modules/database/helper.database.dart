import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

Future<void> initDatabase(Database db, int version) async{

  String script = await rootBundle.loadString("assets/database.sql", cache: true);

  script = script.trim();
  final queries = script.split(";");
  queries.removeLast();
  // You need to let trim act because of blank spaces
  queries.forEach((String query)async{
    await db.execute(query+";");
  });
}
