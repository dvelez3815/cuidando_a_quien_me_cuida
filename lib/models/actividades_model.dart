import 'package:utm_vinculacion/models/alarma_model.dart';
import 'package:utm_vinculacion/models/global_activity.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';

class Actividad extends GlobalActivity{
  
  final db = DBProvider.db;  
  bool _estado = true;

  Actividad(DateTime date, List<String> daysToNotify, {String nombre, String descripcion}):super(date, daysToNotify, nombre:nombre, descripcion:descripcion);
  
  /////////////////////////////////// CRUD ///////////////////////////////////
  Future<bool> save() async {
    final res = await this.createAlarms();
    return res && (await db.newActivity(this));
  }

  Future<bool> update(Map<String, dynamic> params) async {
    // TODO update alarms if its state change
    return await db.updateActivity(params, this.id);
  }

  Actividad.fromJson(Map<String, dynamic> json):super.fromJson(json){
    this._estado = json['active']==1;
  }

  Future<bool> delete() async {
    this._estado = false;
    await chainStateUpdate();

    return (await db.deleteActivity(this)) && (await db.eliminaActividadAlarmas(this));
  }

  ////////////////////////////// Functionality //////////////////////////////
  @override
  Future<bool> createAlarms() async {
    // TODO: create alarms and save it in db
    return true;
  }

  @override
  Future<void> chainStateUpdate()async{
    List<AlarmModel> alarms = await db.getAlarmsByActivity(this.id);

    alarms.forEach((element)async{
      if(this.estado){
        await element.activate();
      }else{
        await element.desactivate();
      }
      // TODO: complete this
      // await db.updateAlarmState(element.id, this.estado?1:0);
    });

    await db.updateActivity({"active": this._estado?1:0}, this.id);
  }


  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      "id"         : id,
      "nombre"     : nombre,
      "descripcion": descripcion,
      "active"     : this.estado? 1:0,
      "date"       : this.date==null? null:"${date.year}/${date.month}/${date.day}",
      "time"       : this.date==null? null:"${date.hour}:${date.minute}",
    };
  }

  /////////////////////////////// Getters ///////////////////////////////
  get estado =>_estado;

  /////////////////////////////// Setters ///////////////////////////////
  set estado(bool status) {
    this._estado = status;
    chainStateUpdate();
  }
}