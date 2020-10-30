
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart' as constantesRutas;
import 'package:utm_vinculacion/rutas/const_rutas.dart';
import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';
class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<bool> isSelected = [true,false];
  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text(NOMBREAPP), actions: <Widget>[
        tresPuntos(context),
      ],),
      body: ListView(
        children: <Widget>[
          Column(
        children: <Widget>[
          cambioDePestanas(mediaQuery), //Inicio-Calendario
          opciones(mediaQuery),
        ],
      )
        ],
      )
    );
  }
Widget cambioDePestanas(Size mediaQuery){
  return ToggleButtons(
    borderColor: Colors.black,
    fillColor: Colors.blue,
    selectedBorderColor: Colors.black,
    selectedColor: Colors.white,
    children: <Widget>[
      Container(width: mediaQuery.width*0.49,child: Container(child: Center(child: Text('INICIO',))),),
      Container(width: mediaQuery.width*0.5,child: Container(child: Center(child: Text('CALENDARIO',))),),
      ],isSelected: isSelected,onPressed: (int index){
        setState(() {
          for (var i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
            }
          });
        }
  );
}
  Widget opciones(Size mediaQuery){
    return isSelected[0]?opcion1(mediaQuery):opcion2(mediaQuery);
  }
  Widget opcion1(Size mediaQuery){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 40),
            height: mediaQuery.height*0.15,
            color: Colors.black54,
            child: Center(
              child: Row(
                children: <Widget>[
                  Container(width: mediaQuery.width*0.40, child: Text('No deje ningún tipo de objeto cerca del alcance del paciente',style: TextStyle(color: Colors.white),),),
                  Container(width: mediaQuery.width*0.40, child: Icon(Icons.group, size: 50,color: Colors.orangeAccent,))
                ],
              ),
            ),
          ),
          Container(
            width: mediaQuery.width*1,
            child: RaisedButton(child: Text('VER TODO EL CONTENIDO',),color: Colors.blue,onPressed: (){
              Navigator.pushNamed(context, CONTENIDO);
            }),
          ),
          Container(
            width: mediaQuery.width*1,
            height: mediaQuery.height*0.04,
            child: Text(""+DateFormat('EEEE', 'es').format(DateTime.now()).toString().toUpperCase()+" "+DateTime.now().day.toString()),
          ),
          FlatButton(onPressed: (){Navigator.pushNamed(context, constantesRutas.RUTINA);}, color: Colors.green, child: Container(width: mediaQuery.width,height: mediaQuery.height*0.45,child: Center(child: Text('COMENZAR', style: TextStyle(fontSize: 20,color: Colors.white),)),)),
        ],
      ),
    );
    
  }
  Widget opcion2(Size mediaQuery){
    return Container(
      width: mediaQuery.width,
      height: mediaQuery.height*0.5,

      child: Center(child: Text('VISTA CALENDARIO'),),
    );
  }  
}