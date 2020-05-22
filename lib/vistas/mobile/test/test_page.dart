import 'package:flutter/material.dart';
import 'package:utm_vinculacion/models/comida_model.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';

class TestPage extends StatelessWidget {

  final provider = DBProvider.db;

  TestPage(){
    provider.getComidas().then((value)async{
      await provider.getToDos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Página de testeo')
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Actividades'),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: (){
                  provider.nuevaActividad(new Actividad(
                    estado: false,
                    hora: "25H00",
                    icono: "no_idea",
                    nombre: "No dejarlo pestañear",
                    rutaImagen: "tortura.jpg"
                  ));
                },
              )
            ),
            Divider(),
            StreamBuilder(
              stream: provider.actividadStream,
              builder: (BuildContext context, AsyncSnapshot<List<Actividad>> snapshot){

                if(!snapshot.hasData){
                  return Container();
                }

                return Column(
                  children: snapshot.data.map((item)=>ListTile(
                    title: Text(item.nombre),
                    subtitle: Text(item.hora),
                  )).toList() 
                );

              },
            ),
            ListTile(
              title: Text('Comidas'),
              leading: IconButton(
                icon: Icon(Icons.add_box),
                onPressed: (){
                  provider.nuevaComida(new Comida(
                    calorias: "-10000",
                    coccion: "0.01h",
                    comensales: "No sé qué es esto",
                    descripcion: "Pues eso, fideos",
                    ingredientes: ["Una persona", "Un agujero negro", "Suerte"],
                    nombre: "Fideos",
                    preparacion: "Coja una persona o un objeto muy grande, llévelo"
                                 "hasta el horizonte de eventos del agujero negro y "
                                 "déjelo allí. Después de unos años el cuerpo se estirará"
                                 " y se realizará el proceso de espaguetización, es aquí "
                                 "cuando usa la suerte y le quita el fideo ese al agujero "
                                 "negro. Disfrute.",
                    rutaVista: "No tiene",
                    tipo: "Comida",
                    total: "¿Total de qué?",
                    urlImagen: "espaguetización.jpg"
                  ));
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: (){
                  provider.nuevaComida(new Comida(
                    calorias: "-10000",
                    coccion: "0.01h",
                    comensales: "No sé qué es esto",
                    descripcion: "Agua sin oxígeno",
                    ingredientes: ["Agua"],
                    nombre: "Agua desoxigenada",
                    preparacion: "Coja un poco de agua y quítele el oxígeno",
                    rutaVista: "No tiene",
                    tipo: "bebida",
                    total: "¿Total de qué?",
                    urlImagen: "imagen.jpg"
                  ));
                },
              )
            ),
            StreamBuilder(
              stream: provider.comidaStream,
              builder: (BuildContext context, AsyncSnapshot<List<Comida>> snapshot){

                if(!snapshot.hasData){
                  return Container();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data.map((item)=>Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    color: Colors.greenAccent,
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Nombre: ${item.nombre}"),
                          Text("Descripción: ${item.descripcion}"),
                          Text("Preparación: ${item.preparacion}"),
                          Text('Ingredientes: '),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: item.ingredientes.map((i)=>Text(i)).toList()
                      )
                    ),
                  )).toList()
                );

              },
            ),
          ],
        ),
      )
    );
  }
}