import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utm_vinculacion/models/actividades_model.dart';
import 'package:utm_vinculacion/models/comida.dart';

export 'package:utm_vinculacion/models/actividades_model.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = new DBProvider._();

  // esto es parte del patrón BLOC
  List<Actividad>actividades = new List<Actividad>();
  List<Comida>comidas        = new List<Comida>();

  // uso de streams
  final _streamControllerActividades = new StreamController<List<Actividad>>.broadcast();
  final _streamControllerComidas     = new StreamController<List<Comida>>.broadcast();

  /*
   * Estos métodos lo que hacen es retornar una función llamándola con
   * otro nombre, facilita las cosas ya que con el nombre del get sería
   * más que suficiente para hacer referencia a una propiedad, en vez de
   * tener que escribir todo la sintaxis reglamentaria
   */

  Function(List<Actividad>) get actividadSink => _streamControllerActividades.sink.add;
  Stream<List<Actividad>> get actividadStream => _streamControllerActividades.stream;

  Function(List<Comida>) get comidaSink => _streamControllerComidas.sink.add;
  Stream<List<Comida>> get comidaStream => _streamControllerComidas.stream;

  // método para cerrrar el stream controller
  // El '?' pregunta si no es null, o si no es vacío
  void dispose(){
    _streamControllerActividades?.close();
    _streamControllerComidas?.close();
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
          "nombre VARCHAR NOT NULL,"
          "hora VARCHAR NOT NULL,"
          "rutaImagen VARCHAR NOT NULL,"
          "estado INTEGER DEFAULT 0,"
          "icono VARCHAR NOT NULL"
          ");"
        );
        
        await db.execute(
          "CREATE TABLE Ingrediente("
          "id INTEGER PRIMARY KEY,"
          "nombre VARCHAR NOT NULL"
          ");"
        );

        await db.execute(
          "CREATE TABLE Comida("
          "id INTEGER PRIMARY KEY,"
          "nombre VARCHAR NOT NULL,"
          "descripcion VARCHAR NOT NULL,"
          "preparacion VARCHAR NOT NULL,"
          "total VARCHAR NOT NULL,"
          "calorias VARCHAR NOT NULL,"
          "coccion VARCHAR NOT NULL,"
          "comensales VARCHAR NOT NULL,"
          "tipo VARCHAR NOT NULL,"
          "urlImagen NOT NULL,"
          "rutaVista NOT NULL"
          ");"
        );

        await db.execute(
          "CREATE TABLE ComidaIngrediente("
          "idComida INTEGER NOT NULL,"
          "idIngrediente VARCHAR NOT NULL,"
          "CONSTRAINT pkComidaIngrediente PRIMARY KEY(idComida, idIngrediente),"
          "CONSTRAINT fkComida FOREIGN KEY(idComida) REFERENCES Comida(id) "
          "ON UPDATE CASCADE ON DELETE NO ACTION,"
          "CONSTRAINT fkIngrediente FOREIGN KEY(idIngrediente) REFERENCES Ingrediente(nombre) "
          "ON UPDATE CASCADE ON DELETE NO ACTION"
          ");"
        );
      }
    );

  }

  
  /// ************************** Actividades ****************************/
  // si retorna 0 es error
  Future<int> nuevaActividad(Actividad actividad) async {

    final db = await database;

    final res = await db.insert('Actividad', actividad.toJson());


    if(res != 0){
      actividades.add(actividad);
      actividadSink(actividades);
    }
    return res;
  }
  
  Future<int> eliminarToDos() async {
    final db = await database;
    final res = await db.delete('ToDo');

    actividades.clear();

    actividadSink(actividades);

    return res;
  }

  Future getToDos() async {

    final db = await database;
    List<Map<String, dynamic>> res = await db.query("todo");

    if(res.isNotEmpty){

      actividades.clear();

      for(Actividad i in res.map((f)=>Actividad.fromJson(f)).toList()){
        actividades.add(i);
      }

      actividadSink(actividades);

    }

  }

  Future<int> nuevaComida(Comida comida) async {

    final db = await database;
    final res1 = await db.insert("Comida", comida.toJson()); 

    // le pone un id a la comida si no lo tiene
    if(comida.id == null){
      final idComida = await db.rawQuery("select id from comida");
      comida.id = idComida[idComida.length - 1]["id"];
    }

    // esta variable sirve para detectar errores
    int res2 = 5;
    List<Map<String, dynamic>> tmp;

    for(String i in comida.ingredientes){
      tmp = await db.query("ComidaIngrediente", where: "idIngrediente = ?", whereArgs: [i]);

      // si ya está el ingrediente registrado
      if(tmp.length == 0){
        res2 = await db.insert('Ingrediente', {
          "nombre": i
        });
      }

      // si hay error, rompe el buble
      if(res2 == 0) break;

      res2 = await db.insert('ComidaIngrediente', {
        "idComida": comida.id,
        "idIngrediente":i
      });

      // si hay error, rompe el buble
      if(res2 == 0) break;

    }
    
    if(res1 != 0 && res2 != 0){
      comidas.add(comida);
      comidaSink(comidas);
    }
    return res1 == 0 || res2 == 0? 0:1;

  }

  Future getComidas() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query("Comida");
    List<Map<String, dynamic>> res2;

    if(res.isNotEmpty){

      comidas.clear();

      for(Comida i in res.map((f)=>Comida.fromJson(f)).toList()){
        res2 = await db.query("ComidaIngrediente", where: "idComida = ?", whereArgs: [i.id]);
        i.ingredientes.addAll(res2.map((e) => e["idIngrediente"]));
        comidas.add(i);
      }

      comidaSink(comidas);
    }
  }
}