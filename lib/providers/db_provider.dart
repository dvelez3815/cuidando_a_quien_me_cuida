import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utm_vinculacion/helpers/helpers.dart' as helpers;

import 'package:utm_vinculacion/models/actividades_model.dart';
import 'package:utm_vinculacion/models/alarma_model.dart';
import 'package:utm_vinculacion/models/comida_model.dart';
import 'package:utm_vinculacion/models/cuidado_model.dart';
import 'package:utm_vinculacion/models/global_activity.dart';
export 'package:utm_vinculacion/models/actividades_model.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = new DBProvider._();

  // This will contain temporal data
  List<Actividad>actividades = new List<Actividad>();
  List<Comida>comidas        = new List<Comida>();
  List<Cuidado>cuidados      = new List<Cuidado>();
  List<AlarmModel> alarmas   = new List<AlarmModel>();
  List<GlobalActivity> todoElContenido = new List<GlobalActivity>();

  // Streams to update components in real time
  final _streamControllerActividades = new StreamController<List<Actividad>>.broadcast();
  final _streamControllerComidas     = new StreamController<List<Comida>>.broadcast();
  final _streamControllerCuidados    = new StreamController<List<Cuidado>>.broadcast();
  final _streamControllerAlarmas     = new StreamController<List<AlarmModel>>.broadcast();
  final _streamControllerTodoElContenido     = new StreamController<List<GlobalActivity>>.broadcast();

  // Streams getters and setters
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

  // Every stream needs to be closed to avoid memory leaks
  void dispose(){
    _streamControllerActividades?.close();
    _streamControllerComidas?.close();
    _streamControllerCuidados?.close();
    _streamControllerAlarmas?.close();
    _streamControllerTodoElContenido?.close();
  }

  DBProvider._();

  // This will create a database instance or return an existing one
  Future<Database> get database async {

    if(_database != null){
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  // this initialices the database
  Future<Database> initDB() async{

    // This is part of an external package
    Directory directory = await getApplicationDocumentsDirectory();

    // The logical address of the database
    final String path = directory.path+"vinculacionI.db";

    return await openDatabase(
      path,
      version: 5,
      onOpen: (db){},
      onCreate: helpers.initDatabase
    );
  }


  //////////////////////////////// Alarms ////////////////////////////////
  Future<bool> nuevaAlarma(AlarmModel alarma) async {
    final db = await database;

    final res = await db.insert('Alarma', alarma.toJson());

    // recordar que 0 es error
    if(res != 0){
      print("Alarma creada con el id ${alarma.id}");
      alarmas.add(alarma);
      alarmSink(alarmas);
    }

    return res>0;
  }

  // Updates all fields except the ID
  Future<bool> updateAlarm(Map<String, dynamic> params, int id) async {

    final db = await database;

    // you can't change the ID
    if(params.containsKey("id") || params.containsKey("ID")){
      throw new ErrorDescription("You cannot update an ID");
    }

    final res = await db.update("alarma", params, where: "id=?", whereArgs: [id]);
    
    // updating streams and temporal data
    if(res > 0) {
      final modelToDelete = alarmas.firstWhere((element) => element.id==id);
      alarmas.remove(modelToDelete);
      await getAlarmas();
    }

    return res > 0;
  }

  /// Returns a list of all alarms, no matter if it's active or not. This
  /// also will update all streams asociated with alarms
  Future<List<AlarmModel>> getAlarmas()async{
    final db = await database;

    List<Map<String, dynamic>> res = await db.query("Alarma");

    if(res.length>0){
      alarmas.clear();
      alarmas = res.map((f)=>AlarmModel.readFromDB(f)).toList();
      alarmSink(alarmas);
    }

    return alarmas;
  }
  
  Future<AlarmModel> getAlarma(int id)async{
    final db = await database;

    List<Map<String, dynamic>> res = await db.rawQuery("SELECT * FROM alarma WHERE id=?", [id]);

    if(res.isEmpty) {
      print("No existen alarmas");
      return null;
    }

    return AlarmModel.readFromDB(res[0]);
  }

  /// Delete and update all dependencies from an alarm
  Future<bool> deleteAlarm(int id) async {
    final db = await database;

    final res = await db.delete("Alarma", where: "id=?", whereArgs: [id]);

    if(res > 0){
      final toDelete = alarmas.firstWhere((element) => element.id==id);
      alarmas.remove(toDelete);
      alarmSink(alarmas); // this updates all dependencies
    }

    return res > 0;
  }
  


  //////////////////////////////// Care ////////////////////////////////
  Future<bool> nuevoCuidado(Cuidado cuidado) async {
    final db = await database;
    final res = await db.insert("cuidado", cuidado.toJson()); 

    if(res > 0){

      cuidados.add(cuidado);
      cuidadoSink(cuidados);

      todoElContenido.add(cuidado);
      todoContenidoSink(todoElContenido);
    }

    return res>0;
  }

  Future<Cuidado> updateCare(Map<String, dynamic> params, int id) async {
    final db = await database;

    // you can't change the ID
    if(params.containsKey("id") || params.containsKey("ID")){
      throw new ErrorDescription("You cannot update an ID");
    }

    final res = await db.update("cuidado", params, where: "id=?", whereArgs: [id]);
    
    // updating streams and temporal data
    if(res > 0) {
      final modelToDelete = cuidados.firstWhere((element) => element.id==id);
      cuidados.remove(modelToDelete);
      await getCuidados();
    }

    return Cuidado.fromJson((await db.query("cuidado", where: "id=?", whereArgs: [id]))[0]);
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

  Future<bool> deleteCare(Cuidado cuidado) async {
    final db = await database;
    final res = await db.rawDelete("DELETE FROM cuidado WHERE id=?", [cuidado.id]);

    if(res > 0){
      cuidados.remove(cuidado);
      todoElContenido.remove(cuidado);
      cuidadoSink(cuidados);
      todoContenidoSink(todoElContenido);
    }

    return res>0;
  }

  
  ///////////////////////////// Activities /////////////////////////////
  Future<bool> newActivity(Actividad activity) async {
    final db = await database;
    final res = await db.insert("actividad", activity.toJson()); 

    if(res > 0){

      actividades.add(activity);
      actividadSink(actividades);

      todoElContenido.add(activity);
      todoContenidoSink(todoElContenido);
    }

    return res>0;
  }

  Future<Actividad> updateActivity(Map<String, dynamic> params, int id) async {
    final db = await database;

    // you can't change the ID
    if(params.containsKey("id") || params.containsKey("ID")){
      throw new ErrorDescription("You cannot update an ID");
    }

    final res = await db.update("actividad", params, where: "id=?", whereArgs: [id]);
    
    // updating streams and temporal data
    if(res > 0) {
      final modelToDelete = actividades.firstWhere((element) => element.id==id);
      actividades.remove(modelToDelete);
      await getActivities();
    }

    return Actividad.fromJson((await db.query("actividad", where: "id=?", whereArgs: [id]))[0]);
  }

  Future<List<Actividad>> getActivities() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query("actividad");

    if(res.isNotEmpty){
      actividades.clear();
      actividades = res.map((f)=>Actividad.fromJson(f)).toList();
      actividadSink(actividades);
    }
    return actividades;

  }

  Future<bool> deleteActivity(Actividad activity) async {
    final db = await database;
    final res = await db.rawDelete("DELETE FROM actividad WHERE id=?", [activity.id]);

    if(res > 0){
      actividades.remove(activity);
      todoElContenido.remove(activity);
      actividadSink(actividades);
      todoContenidoSink(todoElContenido);
    }

    return res>0;
  }

  /////////////////////////// Activity alarms ///////////////////////////
  Future<void> newActivityAlarm(int activityID, int alarmID)async{
    final db = await database;
    await db.insert('actividadesAlarmas', {
      "actividad_id": activityID,
      "alarma_id": alarmID
    });
  }

  Future<void> updateAlarmStateByActivity(int activityID, int state)async{
    final db = await database;
    final String query = "UPDATE alarma SET active=? WHERE id in";
    final String subQuery = "(SELECT alarma_id FROM actividadesAlarmas WHERE alarma_id=?)";

    await db.rawUpdate("$query $subQuery", [state, activityID]);
  }

  Future<List<AlarmModel>> getAlarmsByActivity(int activityID) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(
      "SELECT * FROM alarma WHERE id IN (SELECT alarma_id FROM actividadesAlarmas WHERE actividad_id=?) and active=?",
      [activityID, 1]
    );

    return res.map((alarm)=>AlarmModel.readFromDB(alarm)).toList();
  }

  Future<bool> eliminaActividadAlarmas(Actividad actividad)async{
    final db = await database;

    int res = await db.rawDelete(
      "DELETE FROM alarma WHERE id in(SELECT alarma_id FROM actividadesAlarmas WHERE actividad_id=?)",
      [actividad.id]
    );

    res += await db.rawDelete(
      "DELETE FROM actividadesAlarmas WHERE actividad_id=?", [actividad.id]
    );

    return res > 0;
  }


  ///////////////////////////// Care alarms /////////////////////////////
  Future<void> newCareAlarm(int careID, int alarmID)async{
    final db = await database;
    await db.insert('cuidadosAlarmas', {
      "alarma_id": alarmID,
      "cuidado_id": careID
    });
  }

  Future<bool> deleteCareAlarm(Cuidado care)async{
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

  /// Here you can't update all alrms at once, if you want to do so,
  /// you need to use getAlarmsByCare to obtain a list of all alarms
  /// asociated with the careID you provide
  Future<void> updateAlarmStateByCare(int careID, int state)async{
    final db = await database;
    final String query = "UPDATE cuidado SET active=? WHERE id in";
    final String subQuery = "(SELECT alarma_id FROM cuidadosAlarmas WHERE alarma_id=?)";

    await db.rawUpdate("$query $subQuery", [state, careID]);
  }

  /// Returns all alarms asociated with the careID
  Future<List<AlarmModel>> getAlarmsByCare(int careID)async{
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(
      "SELECT * FROM alarma WHERE id IN (SELECT alarma_id FROM cuidadosAlarmas WHERE cuidado_id=?) AND active=? ORDER BY day, time desc",
      [careID, 1]
    );

    return res.map((alarm)=>AlarmModel.readFromDB(alarm)).toList();
  }

  //////////////////////////////// Events ////////////////////////////////
  /// An event could be a care or an activity, so, you will get a list of
  /// all the alarms created by all cares and all activities
  Future<List<AlarmModel>> eventsByWeekday(int weekday) async {
    final db = await database;

    List<AlarmModel> events = new List<AlarmModel>();

    List<AlarmModel> raw = (await db.rawQuery('select * from alarma where active=?', [1])).map((i)=>AlarmModel.readFromDB(i)).toList();

    raw.forEach((element) {
      if(element.dayToNotify == weekday){
        events.add(element);
      }
    });

    return events;    
  }

  Future<void> initAllEvents() async{
    final todasActividades = await getActivities();
    final todosCuidados = await getCuidados();

    List<GlobalActivity> init = new List<GlobalActivity>();

    if(todasActividades.isNotEmpty){
      init.addAll(todasActividades);
    }
    if(todosCuidados.isNotEmpty){
      init.addAll(todosCuidados);
    }

    todoElContenido.clear();
    todoElContenido.addAll(init);
    todoContenidoSink(init);
  }

  ///////////////////////////////// Food /////////////////////////////////
  ///
  Future<int> eliminarComidas() async {
    final db = await database;
    final res = await db.delete('Comida');
    final res1 = await db.delete('ComidaIngrediente');

    comidas.clear();

    comidaSink(comidas);

    return res*res1;
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