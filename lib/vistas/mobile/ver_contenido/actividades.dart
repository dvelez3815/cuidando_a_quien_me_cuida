import 'package:flutter/material.dart';

import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart';
import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class Actividades extends StatefulWidget {
  Actividades({Key key}) : super(key: key);

  @override
  _ActividadesState createState() => _ActividadesState();
}

class _ActividadesState extends State<Actividades> {

  final DBProvider dbProvider = DBProvider.db;

  @override
  void initState() {
    dbProvider.getActividades();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text(NOMBREAPP), actions: <Widget>[
        tresPuntos(context)        
      ],),      
      body: listaContenido()
    );
  }

  Widget listaContenido(){
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Mis Actividades",
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add), 
                  onPressed: (){
                    Navigator.pushNamed(context, ADDACTIVIDADES);
                  },
                )
              ],
            ),
            StreamBuilder(
              stream: dbProvider.actividadStream,
              builder: (BuildContext context, AsyncSnapshot<List<Actividad>> snapshot){

                if(!snapshot.hasData) return sinDatos();

                final List<Widget> widgets = new List<Widget>();

                widgets.addAll(snapshot.data.map((item)=>SwitchListTile(
                  value: item.estado,
                  onChanged: (status){
                    setState(() {
                      item.estado = status;
                    });
                  },
                  subtitle: Text("${item.descripcion}"),
                  title: Text("${item.nombre ?? "Sin nombre"}"),
                  secondary: Column(
                    children: [
                      Icon(Icons.alarm),
                      Text("${item.date.hour}:${item.date.minute}"),
                    ],
                  ),
                  
                )).toList());
                return Column(
                  children: widgets,
                );
              },
            ),
          ],
        )
      ),
      
    );
  }
}

/*

    // cancelando alarma anterior
    // await AndroidAlarmManager.cancel(alarmID);
    AlarmModel model = new AlarmModel(
      new DateTime(date.year, date.month, date.day, time.hour, time.minute),
      title: "Alarma", description: "Body"
    );

    await model.save();

    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('La alarma sonara el ${date.day}/${date.month}/${date.year} a las ${time.hour}:${time.minute}')
    ));
  }
}*/
