import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utm_vinculacion/models/actividades_model.dart';

export 'package:utm_vinculacion/models/actividades_model.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = new DBProvider._();

  // esto es parte del patrón BLOC
  List<Actividad>actividades = new List<Actividad>();

  bool _bandera = false; // esto es para que no haga peticiones de más.

  // uso de streams
  final _streamControllerActividades = new StreamController<List<Actividad>>.broadcast();

  /*
   * Estos métodos lo que hacen es retornar una función llamándola con
   * otro nombre, facilita las cosas ya que con el nombre del get sería
   * más que suficiente para hacer referencia a una propiedad, en vez de
   * tener que escribir todo la sintaxis reglamentaria
   */

  Function(List<Actividad>) get actividadSink => _streamControllerActividades.sink.add;
  Stream<List<Actividad>> get actividadStream => _streamControllerActividades.stream;

  // método para cerrrar el stream controller
  // El '?' pregunta si no es null, o si no es vacío
  void dispose(){
    _streamControllerActividades?.close();
  }

  DBProvider._();

  Future<Database> get database async {

    if(_database != null){
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async{

    Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path+"vinculacionI.db";

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async{
        await db.execute(
          "CREATE TABLE Actividad("
          "id INTEGER PRIMARY KEY,"
          "titulo VARCHAR NOT NULL,"
          "contenido VARCHAR DEFAULT 0,"
          "completado VARCHAR NOT NULL,"
          "anio INTEGER,"
          "mes INTEGER,"
          "dia INTEGER,"
          "hora INTEGER,"
          "minuto INTEGER"
          ");"          
        );
      }
    );

  }

  
  /// ************************** Actividades ****************************/
  // si retorna 0 es error
  Future<int> nuevaActividad(Actividad actividad) async {

    final db = await database;

    final res = await db.insert('todo', actividad.toJson());


    if(res != 0){
      actividades.add(actividad);
      actividadSink(actividades);
    }
    return res;
  }
  
  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.delete('ToDo');

    actividades.clear();

    actividadSink(actividades);

    return res;
  }

  Future getToDoByHorario() async {

    if(_bandera) return;

    _bandera = true;

    final db = await database;
    List<Map<String, dynamic>> res = await db.query("todo");

    if(res.isNotEmpty){

      actividades.clear();

      for(Actividad i in res.map((f)=>Actividad.fromJson(f)).toList()){
        actividades.add(i);
      }

      actividadSink(actividades);

    }
    _bandera = false;

  }
}