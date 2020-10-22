import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/cuidado_model.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class Cuidados extends StatefulWidget {
  
  Cuidados({Key key}) : super(key: key);

  @override
  
  _CuidadosState createState() => _CuidadosState();
}


class _CuidadosState extends State<Cuidados> {

  final DBProvider dbProvider = DBProvider.db;

  @override
  void initState() {
    dbProvider.getCuidados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text('Nombre de la app'), actions: <Widget>[
        tresPuntos()        
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
                  "Cuidados",
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add), 
                  onPressed: (){
                    Navigator.pushNamed(context, ADDCUIDADOS);
                  },
                )
              ],
            ),
            StreamBuilder(
              stream: dbProvider.cuidadoStream,
              builder: (BuildContext context, AsyncSnapshot<List<Cuidado>> snapshot){

                if(!snapshot.hasData) return sinDatos();

                final List<Widget> widgets = new List<Widget>();

                widgets.addAll(snapshot.data.map((item)=>ListTile(
                  onTap: (){},
                  subtitle: Text(item.descripcion),
                  title: Text(item.nombre),
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