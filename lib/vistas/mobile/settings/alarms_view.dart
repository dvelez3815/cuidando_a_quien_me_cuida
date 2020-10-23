import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/alarma_model.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';

class AlarmsView extends StatefulWidget {

  @override
  _AlarmsViewState createState() => _AlarmsViewState();
}

class _AlarmsViewState extends State<AlarmsView> {
  final DBProvider db = DBProvider.db;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de alarmas")),
      body: FutureBuilder(
        future: db.getAlarmas(),
        builder: (BuildContext context, AsyncSnapshot<List<AlarmModel>> snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }

          if(snapshot.data.isEmpty){
            return ListTile(title: Text("No hay alarmas aún"), leading: Icon(Icons.alarm),);
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index){

              AlarmModel data = snapshot.data[index];
              print("${data.id}");
              return SwitchListTile(
                onChanged: (change)async{

                  data.active = !(data.active ?? true);
                  await data.updateState();

                  setState(() {});
                },
                value: data.active ?? true,
                title: Text(data.title ?? "Sin título"),
                subtitle: Text(data.description ?? "Sin descripción"),
                secondary: Column(
                  children: [
                    Icon(Icons.alarm),
                    Text("${data.time.hour}:${data.time.minute < 10? "0":""}${data.time.minute}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}