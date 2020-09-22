import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/comida_model.dart';
// import 'package:utm_vinculacion/providers/comidas_json_provider.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/providers/json_db.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class Recetas extends StatefulWidget {
  
  const Recetas({Key key}) : super(key: key);

  @override
  _RecetasState createState() => _RecetasState();
}

class _RecetasState extends State<Recetas> {

  DBProvider dbProvider = DBProvider.db;
  JsonToDBProvider jsonProvider = JsonToDBProvider();

  _RecetasState(){
    dbProvider.getComidas();    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Nombre de la app'), 
        actions: <Widget>[
          tresPuntos(),
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: ()async{
              final List<Map<String, dynamic>> data = await jsonProvider.cargaDatosDelJson('recursosexternos/comidas.json');
              for(Map<String, dynamic> item in data){
                Comida comida = Comida.fromJson(item);
                comida.urlImagen = item['url-imagen'];
                await dbProvider.nuevaComida(comida);
              }

            },
          ),
          IconButton(
            icon: Icon(Icons.delete), 
            onPressed: ()async{
              await dbProvider.eliminarComidas();
            }
          )  
        ],
      ),
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
                  "Mis recetas",
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add), 
                  onPressed: (){
                    Navigator.pushNamed(context, ADDPLATOS);
                  }
                )
              ],
            ),
            StreamBuilder(
              stream: dbProvider.comidaStream,
              builder: (BuildContext context, AsyncSnapshot<List<Comida>> snapshot){
                
                if(!snapshot.hasData) return sinDatos();

                final List<Widget> widgets = new List<Widget>();

                widgets.addAll(snapshot.data.map((item)=>ListTile(
                  onTap: (){
                    //Aca mando los datos de la comida que desea ver y los muestros en info comida
                    Comida comida = item;
                    Navigator.pushNamed(context, INFO_COMIDA, arguments: comida);
                    },            
                  leading: Container(
                    width: MediaQuery.of(context).size.width*0.2,
                    child: item.urlImagen != null?Image.asset(item.urlImagen):Container()
                  ),
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