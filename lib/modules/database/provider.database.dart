import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utm_vinculacion/modules/activity/model.activity.dart';
import 'package:utm_vinculacion/modules/alarms/model.alarm.dart';
import 'package:utm_vinculacion/modules/contacts/model.contacts.dart';
import 'package:utm_vinculacion/modules/food/model.food.dart';
import 'package:utm_vinculacion/modules/global/helpers.dart';
import 'package:utm_vinculacion/modules/water/model.water.dart';
import 'package:utm_vinculacion/user_preferences.dart';

import 'helper.database.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = new DBProvider._();

  // This will contain temporal data
  List<Actividad>actividades = new List<Actividad>();
  List<Comida>comidas        = new List<Comida>();
  List<AlarmModel> alarmas   = new List<AlarmModel>();
  List<Contact> contacts     = new List<Contact>();

  // Streams to update components in real time
  final _streamControllerActividades = new StreamController<List<Actividad>>.broadcast();
  final _streamControllerComidas     = new StreamController<List<Comida>>.broadcast();
  final _streamControllerAlarmas     = new StreamController<List<AlarmModel>>.broadcast();
  final _streamControllerContacts    = new StreamController<List<Contact>>.broadcast();

  // Streams getters and setters
  Function(List<AlarmModel>) get alarmSink => _streamControllerAlarmas.sink.add;
  Stream<List<AlarmModel>> get alarmStream => _streamControllerAlarmas.stream;

  Function(List<Actividad>) get actividadSink => _streamControllerActividades.sink.add;
  Stream<List<Actividad>> get actividadStream => _streamControllerActividades.stream;

  Function(List<Comida>) get comidaSink => _streamControllerComidas.sink.add;
  Stream<List<Comida>> get comidaStream => _streamControllerComidas.stream;

  Function(List<Contact>) get contactSink => _streamControllerContacts.sink.add;
  Stream<List<Contact>> get contactStream => _streamControllerContacts.stream;


  // Every stream needs to be closed to avoid memory leaks
  void dispose(){
    _streamControllerActividades?.close();
    _streamControllerComidas?.close();
    _streamControllerAlarmas?.close();
    _streamControllerContacts?.close();
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

  /// this initialices the database
  Future<Database> initDB() async{

    // This is part of an external package
    Directory directory = await getApplicationDocumentsDirectory();

    // The logical address of the database
    final String path = directory.path+"CrackFieraMastodonteGenio.db";

    return await openDatabase(
      path,
      version: 3, // last was 3
      onUpgrade: (db, oldVersion, newVersion)async{
        await upgradeDB(db);
        print("Database upgraded");
      },
      onOpen: (db)=>print("Database started"),
      onCreate: (db, version)async{
        await initDatabase(db, version);
        await defaultData(db);

        print("Database created");
      }
    );
  }

  
  /// You can storage an alarm in database providing a model in [alarma]
  /// param.
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

  /// Updates all fields specified in [params], except the [id]
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
      final toDelete = alarmas.firstWhere((element) => element.id==id, orElse: ()=>null);
      
      if(toDelete != null){
        alarmas.remove(toDelete);
        alarmSink(alarmas); // this updates all dependencies        
      }

    }

    return res > 0;
  }
  

  ///////////////////////////// Activities /////////////////////////////
  Future<bool> newActivity(Actividad activity) async {
    final db = await database;
    final res = await db.insert("actividad", activity.toJson()); 

    if(res > 0){
      await getActivities();
    }

    return res>0;
  }

  Future<bool> existActivity(int id) async {
    final db = await database;
    final res = await db.query("actividad", where: "id=?", whereArgs: [id]); 

    return res.isNotEmpty;
  }

  Future<Actividad> getActivity(int id) async {
      final db = await database;
      final res = await db.query("actividad", where: "id=?", whereArgs: [id]); 

      return res.isNotEmpty? Actividad.fromJson(res[0]):null;
  }

  Future<Actividad> updateActivity(Map<String, dynamic> params, int id) async {
    final db = await database;

    // you can't change the ID
    if(params.containsKey("id") || params.containsKey("ID")){
      throw new ErrorDescription("You cannot update an ID");
    }

    final res = await db.update("actividad", params, where: "id=?", whereArgs: [id]);
    Actividad newActivity = Actividad.fromJson((await db.query("actividad", where: "id=?", whereArgs: [id]))[0]);

    // updating streams and temporal data
    if(res > 0) {
      final modelToDelete = actividades.firstWhere((element) => element.id==id);
      actividades.remove(modelToDelete);
      await getActivities();

    }

    return newActivity;
  }

  Future<List<Actividad>> getActivities() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query("actividad", orderBy: "time");

    if(res.isNotEmpty){
      actividades.clear();
      actividades = List<Actividad>.from(res.map((f)=>Actividad.fromJson(f)).toList());
    }
    actividadSink(actividades);
    return actividades;

  }

  Future<bool> deleteActivity(Actividad activity) async {
    final db = await database;
    final res = await db.rawDelete("DELETE FROM actividad WHERE id=?", [activity.id]);

    if(res > 0){
      actividades.removeWhere((Actividad a)=>a.id == activity.id);
      actividadSink(actividades);
    }

    return res>0;
  }

  Future<List<String>> loadActivityImages(int id) async {

    final db = await database;

    final res = await db.query("imagenesactividades", where: "activity_id=?", whereArgs: [id]);
    final List<String> urls = List<String>.from(res.map((e) => e["url"]));

    return urls;
  }

  Future<String> loadActivityProcedure(int id) async {
    final db = await database;

    final res = await db.query("procedimiento", where: "activity_id=?", whereArgs: [id]);
    String steps = "";
    if(res!=null && res.isNotEmpty)
    {
      steps = res[0]["steps"];
    }
      
    return steps ?? "";
  }

  Future<void> setProcedure(int activityID, String procedure) async {
    final db = await database;

    await db.insert('procedimiento', {
      "steps": procedure,
      "id": generateID(),
      "activity_id": activityID,
    });
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
    final String subQuery = "(SELECT alarma_id FROM actividadesAlarmas WHERE actividad_id=?)";

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

    if(res > 0){
      res += await db.rawDelete(
        "DELETE FROM actividadesAlarmas WHERE actividad_id=?", [actividad.id]
      );
    }

    return res > 0;
  }
 
  /////////////////////////////// Contacts ///////////////////////////////
  Future<void> getContacts() async {
    
    contacts.clear();

    final db = await database;
    final affectedRows = List<Map<String, dynamic>>.from(await db.query("contacto"));

    contacts.addAll(affectedRows.map((Map<String, dynamic> e) => Contact.fromJson(e)));

    contactSink(contacts);
  }

  Future<void> createContact(Contact contact) async {

    final db = DBProvider._database;

    final affectedRows = await db.insert("contacto", contact.toJson());

    // It means that some rows were affected
    if(affectedRows > 0) {
      contacts.add(contact);
      contactSink(contacts);
    }

  }

  Future<void> updateContact(Contact contact) async {    
    final db = DBProvider._database;

    final response = await db.update("contacto", contact.toJson(), where: "id=?", whereArgs: [contact.id]);

    if(response > 0){

      contacts.removeWhere((element) => element.id == contact.id);
      contacts.add(contact);

      contactSink(contacts);

    }
  }

  Future<void> deleteContact(Contact contact) async {
    final db = DBProvider._database;
    final response = await db.delete("contacto", where: "id=?", whereArgs: [contact.id]);

    if(response > 0){
      contacts.removeWhere((element) => element.id == contact.id);
      contactSink(contacts);
    }
  }
  //////////////////////////////// Events ////////////////////////////////
  /// An event could be a care or an activity, so, you will get a list of
  /// all the alarms created by all cares and all activities
  /// 
  Future<List<AlarmModel>> eventsByWeekday(int weekday) async {
    final db = await database;

    List<AlarmModel> raw = (await db.rawQuery(
      'select * from alarma where active=? and day=? order by time', 
      [1, weekday])
    ).map((i)=>AlarmModel.readFromDB(i)).toList();

    return raw;    
  }


  ///////////////////////////////// Food /////////////////////////////////
  Future<int> eliminarComida(Comida food) async {
    final db = await database;
    final res = await db.delete('Comida', where: "id=?", whereArgs: [food.id]);

    await getComidas();

    return res;
  }

  Future<bool> nuevaComida(Comida comida) async {

    final db = await database;
    final response = await db.insert("Comida", comida.toJson()); 
    
    await getComidas();

    return response > 0;
  }

  Future<void> getComidas() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query("Comida", orderBy: "nombre");
    
    comidaSink(List<Comida>.from(res.map((f)=>Comida.fromJson(f))));
  }

  Future<bool> storeWater(WaterModel water) async {
    final db = await database;

    final Map<String, dynamic> save = water.toJson();
    save.remove("progress");

    return (await db.insert('water', save)) > 0;
  }

  Future<WaterModel> lastWater() async {    
    final db = await database;

    const query = "select * from water order by id desc limit 1";

    List<Map<String, dynamic>> response = await db.rawQuery(query);

    if(response.isEmpty) return null;

    double progress = UserPreferences()?.waterProgress ?? 0.0;
    Map<String, dynamic> lastElement = new Map<String, dynamic>();
    
    lastElement.addAll(response[0]);
    lastElement.addAll({"progress": progress});


    return WaterModel.fromJson(lastElement);
  }

  Future<bool> updateWater(Map<String, dynamic> params, int id) async {  
    final db = await database;

    params.remove("id");

    final res = await db.update('water', params, where: "id=?", whereArgs: [id]);
    print("Response is $res");
    return res  > 0;
  }

  Future<void> newWaterAlarm(int waterID, int alarmID)async{
    final db = await database;
    await db.insert('waterAlarms', {
      "water_id": waterID,
      "alarm_id": alarmID
    });
  }

}