import 'package:utm_vinculacion/models/global_activity.dart';

import 'alarma_model.dart';

class Cuidado extends GlobalActivity{

  bool _estado = true;
  Cuidado(DateTime date, List<String> daysToNotify, {String nombre, String descripcion}):super(date, daysToNotify, nombre:nombre, descripcion:descripcion);

  ///////////////////////////////// CRUD /////////////////////////////////
  Cuidado.fromJson(Map<String, dynamic> json):super.fromJson(json){
    this._estado = json['active']==1;
  }

  @override
  Future<bool> save() async {
    final res = await this.createAlarms();
    return res && (await db.nuevoCuidado(this));
  }

  @override
  Future<bool> update(Map<String, dynamic> params) async {
    // TODO update alarms if its state change
    return await db.updateCare(params, this.id);
  }

  @override
  Future<bool> delete() async {
    this._estado = false;
    await chainStateUpdate();

    return (await db.deleteCare(this)) && (await db.deleteCareAlarm(this));
  }

  ////////////////////////////// Functions //////////////////////////////
  @override
  Future<bool> createAlarms() {
    // TODO: implement createAlarms
    throw UnimplementedError();
  }

  @override
  Future<void> chainStateUpdate()async{
    List<AlarmModel> alarms = await db.getAlarmsByCare(this.id);

    alarms.forEach((element)async{
      if(this.estado){
        await element.activate();
      }else{
        await element.desactivate();
      }
      // await db.updateAlarmState(element.id, this.estado?1:0);
    });

    // await db.updateCareState(this.id, this.estado?1:0);
    throw UnimplementedError();

  }

  

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      "id"         : id,
      "nombre"     : nombre,
      "descripcion": descripcion,
      "active"     : this.estado? 1:0,
      "date"       : "${date.year}/${date.month}/${date.day}",
      "time"       : "${date.hour}:${date.minute}",
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