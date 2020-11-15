import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/routes/const_rutas.dart';
import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';
import 'package:utm_vinculacion/widgets/widget.circular_banner.dart';

import 'model.food.dart';

class Recetas extends StatefulWidget {
   

  @override
  _RecetasState createState() => _RecetasState();
}

class _RecetasState extends State<Recetas> {

  final DBProvider dbProvider = DBProvider.db;

  _RecetasState(){
    dbProvider.getComidas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Column(
        children: [
          _getBanner(MediaQuery.of(context).size),
          listaContenido(),
        ],
      )
    );
  }

  Widget _getBanner(Size size) {
    return Container(
      width: size.width,
      height: size.height*0.3,
      child: CustomPaint(
        painter: CircularBannerWidget(),
        child: Column(
          children: [
            SafeArea(
              child: ListTile(
                title: Text("Cuidando a quien me cuida", style: TextStyle(color: Colors.white)),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white), 
                  onPressed: ()=>Navigator.of(context).pop()
                ),
                trailing: tresPuntos(context),
              ),
            ),
            SizedBox(height: size.height*0.05),
            Text(
              "RECETAS",
              style: TextStyle(
                fontSize: 25.0, 
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            )
          ],
        ),
      ),
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