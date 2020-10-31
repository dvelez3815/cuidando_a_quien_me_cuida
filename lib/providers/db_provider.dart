import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:utm_vinculacion/models/actividades_model.dart';
import 'package:utm_vinculacion/models/alarma_model.dart';
import 'package:utm_vinculacion/models/comida_model.dart';
import 'package:utm_vinculacion/models/cuidado_model.dart';
import 'package:utm_vinculacion/models/global_activity.dart';
export 'package:utm_vinculacion/models/actividades_model.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = new DBProvider._();

  // esto es parte del patrón BLOC
  List<Actividad>actividades = new List<Actividad>();
  List<Comida>comidas        = new List<Comida>();
  List<Cuidado>cuidados      = new List<Cuidado>();
  List<AlarmModel> alarmas   = new List<AlarmModel>();
  List<GlobalActivity> todoElContenido = new List<GlobalActivity>();

  // uso de streams
  final _streamControllerActividades = new StreamController<List<Actividad>>.broadcast();
  final _streamControllerComidas     = new StreamController<List<Comida>>.broadcast();
  final _streamControllerCuidados    = new StreamController<List<Cuidado>>.broadcast();
  final _streamControllerAlarmas     = new StreamController<List<AlarmModel>>.broadcast();
  final _streamControllerTodoElContenido     = new StreamController<List<GlobalActivity>>.broadcast();

  /*
   * Estos métodos lo que hacen es retornar una función llamándola con
   * otro nombre, facilita las cosas ya que con el nombre del get sería
   * más que suficiente para hacer referencia a una propiedad, en vez de
   * tener que escribir todo la sintaxis reglamentaria
   */

  Function(List<AlarmModel>) get alarmSink => _streamControllerAlarmas.sink.add;
  Stream<List<AlarmModel>> get alarmStream => _streamControllerAlarmas.stream;

  Function(List<Actividad>) get actividadSink => _streamControllerActividades.sink.add;
  Stream<List<Actividad>> get actividadStream => _streamControllerActividades.stream;

  Function(List<Cuidado>) get cuidadoSink => _streamControllerCuidados.sink.add;
  Stream<List<Cuidado>> get cuidadoStream  => _streamControllerCuidados.stream;

  Function(List<Comida>) get comidaSink => _streamControllerComidas.sink.add;
  Stream<List<Comida>> get comidaStream => _streamControllerComidas.stream;

  Function(List<GlobalActivity>) get todoContenidoSink => _streamControllerTodoElContenido.sink.add;
  Stream<List<GlobalActivity>> get todoContenidoStream => _streamControllerTodoElContenido.stream;

  // método para cerrrar el stream controller
  // El '?' pregunta si no es null, o si no es vacío
  void dispose(){
    _streamControllerActividades?.close();
    _streamControllerComidas?.close();
    _streamControllerCuidados?.close();
    _streamControllerAlarmas?.close();
    _streamControllerTodoElContenido?.close();
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
      version: 4,
      onOpen: (db){},
      onCreate: (Database db, int version) async{
        await db.execute(
          "CREATE TABLE Actividad("
          "id INTEGER PRIMARY KEY,"
          "nombre VARCHAR NOT NULL,"
          "descripcion VARCHAR NOT NULL,"
          "date VARCHAR NULL,"
          "time VARCHAR NULL,"
          "active INTEGER DEFAULT 0"
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
          "urlImagen VARCHAR,"
          "rutaVista VARCHAR"
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

        await db.execute(
          "CREATE TABLE cuidado("
          "id INTEGER NOT NULL,"
          "nombre VARCHAR NOT NULL,"
          "descripcion VARCHAR NOT NULL,"
          "date VARCHAR NULL," // "YYYY/MM/DD"
          "time VARCHAR NULL," // "HH:MM"
          "active INTEGER DEFAULT 1,"
          "CONSTRAINT pkCuidado PRIMARY KEY(id)"
          ");"
        );

        await db.execute(
          "CREATE TABLE alarma("
          "id INTEGER PRIMARY KEY,"
          "title VARCHAR NULL DEFAULT \"Sin título\","
          "body VARCHAR NULL DEFAULT \"Sin descripción\","
          "date VARCHAR NOT NULL," // "YYYY/MM/DD"
          "time VARCHAR NOT NULL," // "HH:MM"
          "active INTEGER DEFAULT 1"
          ");"
        );

        await db.execute(
          "CREATE TABLE actividadesAlarmas("
          "alarma_id INTEGER NOT NULL,"
          "actividad_id INTEGER NOT NULL,"
          "FOREIGN KEY(actividad_id) REFERENCES actividad(id) ON UPDATE CASCADE ON DELETE NO ACTION,"
          "FOREIGN KEY(alarma_id) REFERENCES alarma(id) ON UPDATE CASCADE ON DELETE NO ACTION"
          ");"
        );

        await db.execute(
          "CREATE TABLE cuidadosAlarmas("
          "alarma_id INTEGER NOT NULL,"
          "cuidado_id INTEGER NOT NULL,"
          "FOREIGN KEY(alarma_id) REFERENCES alarma(id) ON UPDATE CASCADE ON DELETE NO ACTION,"
          "FOREIGN KEY(cuidado_id) REFERENCES cuidado(id) ON UPDATE CASCADE ON DELETE NO ACTION"
          ");"
        );
      }
    );

  }

  //****************************** Alarmas ******************************
  Future<void> nuevaAlarma(AlarmModel alarma) async {
    final db = await database;

    final res = await db.insert('Alarma', alarma.toJson());

    // recordar que 0 es error
    if(res != 0){
      print("Alarma creada con el id ${alarma.id}");
      alarmas.add(alarma);
      alarmSink(alarmas);
    }
  }

  Future<void> newActivityAlarm(int activityID, int alarmID)async{
    final db = await database;
    await db.insert('actividadesAlarmas', {
      "actividad_id": activityID,
      "alarma_id": alarmID
    });
  }

  Future<List<AlarmModel>> getAlarmsByActivity(int activityID) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(
      "SELECT * FROM alarma WHERE id IN (SELECT alarma_id FROM actividadesAlarmas WHERE actividad_id=?)",
      [activityID]
    );

    return res.map((alarm)=>AlarmModel.fromJson(alarm)).toList();
  }

  Future<void> updateAlarmStateByActivity(int activityID, int state)async{
    final db = await database;
    final String query = "UPDATE alarma SET active=? WHERE id in";
    final String subQuery = "(SELECT alarma_id FROM actividadesAlarmas WHERE alarma_id=?)";

    await db.rawUpdate("$query $subQuery", [state, activityID]);
  }

  Future<void> updateActivityState(int activityID, state)async{    
    final db = await database;
    await db.rawUpdate("UPDATE actividad SET estado=? WHERE id=?", [state, activityID]);
  }

  Future<void> updateAlarmState(int id, int active)async{
    final db = await database;
    final up = await db.rawUpdate("UPDATE alarma SET active=? WHERE id = ?", [active, id]);
    if(up>0){
      print("Alarma actualizada con id $id");
    }
  }

  Future<AlarmModel> getAlarma(int id)async{
    final db = await database;

    List<Map<String, dynamic>> res = await db.rawQuery("SELECT * FROM alarma WHERE id=?", [id]);

    if(res.isEmpty) {
      print("No existen alarmas");
      return null;
    }

    return AlarmModel.fromJson(res[0]);
  }

  Future<List<AlarmModel>> getAlarmas()async{
    final db = await database;

    List<Map<String, dynamic>> res = await db.query("Alarma");

    if(res.length>0){
      alarmas.clear();
      alarmas = res.map((f)=>AlarmModel.fromJson(f)).toList();
      alarmSink(alarmas);
    }

    return alarmas;
  }

  ///***************************** Cuidados *****************************
  Future<int> removeCuidado(Cuidado cuidado) async {
    final db = await database;
    final res = await db.rawDelete("DELETE FROM cuidado WHERE id=?", [cuidado.id]);

    if(res > 0){
      cuidados.remove(cuidado);
      todoElContenido.remove(cuidado);
      cuidadoSink(cuidados);
      todoContenidoSink(todoElContenido);
    }

    return res;
  }
  
  Future<int> nuevoCuidado(Cuidado cuidado) async {
    final db = await database;
    final res = await db.insert("cuidado", cuidado.toJson()); 

    if(res != 0){

      cuidados.add(cuidado);
      cuidadoSink(cuidados);

      todoElContenido.add(cuidado);
      todoContenidoSink(todoElContenido);
    }

    return res;
  }

  Future<void> newCareAlarm(int careID, int alarmID)async{
    final db = await database;
    await db.insert('cuidadosAlarmas', {
      "alarma_id": alarmID,
      "cuidado_id": careID
    });
  }

  Future<void> updateAlarmStateByCare(int careID, int state)async{
    final db = await database;
    final String query = "UPDATE cuidado SET active=? WHERE id in";
    final String subQuery = "(SELECT alarma_id FROM cuidadosAlarmas WHERE alarma_id=?)";

    await db.rawUpdate("$query $subQuery", [state, careID]);
  }
  
  Future<void> updateCareState(int careID, state)async{    
    final db = await database;
    await db.rawUpdate("UPDATE cuidado SET active=? WHERE id=?", [state, careID]);
  }

  Future<List<AlarmModel>> getAlarmsByCare(int careID)async{
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(
      "SELECT * FROM alarma WHERE id IN (SELECT alarma_id FROM cuidadosAlarmas WHERE cuidado_id=?)",
      [careID]
    );

    return res.map((alarm)=>AlarmModel.fromJson(alarm)).toList();
  }
  
  Future<bool> deleteCare(Cuidado care)async{
    final db = await database;

    int status = await db.rawDelete("DELETE FROM cuidado WHERE id=?", [care.id]);
    if(status>0){
      status += await db.rawDelete("DELETE FROM cuidadosAlarmas WHERE cuidado_id=?", [care.id]);
    }

    cuidados.remove(care);
    todoElContenido.remove(care);
    cuidadoSink(cuidados);

    return status>0;
  }

  Future<List<GlobalActivity>> eventsByWeekday(int weekday) async {
    await initTodasActividades();
    List<GlobalActivity> events = new List<GlobalActivity>();

    todoElContenido.forEach((element) {
      if(element.date.weekday == weekday){
        events.add(element);
      }
    });

    return events;
    
  }
  /// ************************** Actividades ****************************/
  // si retorna 0 es error

  Future<int> removActividad(Actividad cuidado) async {
    final db = await database;
    final res = await db.rawDelete("DELETE FROM actividad WHERE id=?", [cuidado.id]);

    if(res > 0){
      actividades.remove(cuidado);
      todoElContenido.remove(cuidado);
      actividadSink(actividades);
      todoContenidoSink(todoElContenido);
    }

    return res;
  }

  Future<int> nuevaActividad(Actividad actividad) async {

    final db = await database;

    if(actividades.length == 0) await getToDos();
    // if(comidas.length == 0) await getComidas(); ???????

    final res = await db.insert('Actividad', actividad.toJson());

    if(res != 0){
      actividades.add(actividad);
      actividadSink(actividades);

      todoElContenido.add(actividad);
      todoContenidoSink(todoElContenido);
    }
    return res;
  }
  
  Future<List<Actividad>> getActividades() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query("Actividad");
    if(res.isNotEmpty){
      actividades.clear();
      actividades = res.map((f)=>Actividad.fromJson(f)).toList();
      actividadSink(actividades);
      print(actividades);
    }
    return actividades;
  }

  Future<bool> deleteActivity(Actividad actividad)async{
    final db = await database;

    int status = await db.rawDelete("DELETE FROM actividad WHERE id=?", [actividad.id]);
    if(status>0){
      status += await db.rawDelete("DELETE FROM cuidadosAlarmas WHERE cuidado_id=?", [actividad.id]);
    }

    actividades.remove(actividad);
    todoElContenido.remove(actividad);
    actividadSink(actividades);

    return status>0;
  }

  Future<int> eliminarToDos() async {
    final db = await database;
    final res = await db.delete('Actividad');

    actividades.clear();

    actividadSink(actividades);

    return res;
  }

  Future<int> eliminarComidas() async {
    final db = await database;
    final res = await db.delete('Comida');
    final res1 = await db.delete('ComidaIngrediente');

    comidas.clear();

    comidaSink(comidas);

    return res*res1;
  }

  Future getToDos() async {

    final db = await database;
    List<Map<String, dynamic>> res = await db.query("Actividad");

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

  Future<List<Cuidado>> getCuidados() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query("cuidado");

    if(res.isNotEmpty){
      cuidados.clear();
      cuidados = res.map((f)=>Cuidado.fromJson(f)).toList();
      cuidadoSink(cuidados);
    }
    return cuidados;
  }

  Future<void> initTodasActividades() async{
    final todasActividades = await getActividades();
    final todosCuidados = await getCuidados();

    List<GlobalActivity> init = new List<GlobalActivity>();

    if(todasActividades.isNotEmpty){
      init.addAll(todasActividades);
    }
    if(todosCuidados.isNotEmpty){
      init.addAll(todosCuidados);
    }

    todoElContenido.addAll(init);
    todoContenidoSink(init);
  }
}