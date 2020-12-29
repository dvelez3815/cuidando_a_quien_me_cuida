import 'package:flutter/material.dart';
import 'package:utm_vinculacion/routes/route.names.dart';

Widget tresPuntos(context, {Color customColor}) {

  final color = customColor ?? ((Theme.of(context).brightness == Brightness.dark)? Colors.black:Colors.white);

  return PopupMenuButton<String>(
    icon: Icon(Icons.settings, color: color),
    onSelected: (val) => handleClick(val, context),
    itemBuilder: (BuildContext context) {
      return ['Configuraciones'].map((String choice) {
        return PopupMenuItem<String>(
          value: choice,
          child: Text(choice),
        );
      }).toList();
    },
  );
}

 handleClick(String value, context) {
  switch (value) {
    case 'Configuraciones':
    Navigator.pushNamed(context, SETTINGS);
      
  }
}


Icon convertirStringIcono(String icono){
  switch (icono) {
    case "favorite":
      return Icon(Icons.favorite);
      break;
    case "fastfood":
      return Icon(Icons.fastfood);
    default:
      return Icon(Icons.favorite_border);
  }
}
void mostrarActividades(List<String> actv, context){
  showDialog(context: context,barrierDismissible: true,
  builder: (BuildContext context){
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text("Mensaje"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: actividades(actv)
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){Navigator.pop(context);}, child: Text("Ok"))
      ],
    );
  });  
}

List<Widget> actividades(List<String> actv){
  print(actv.toString());
  List<Widget> actvi = List<Widget>(); 

  actv.forEach((e) {
    actvi.add(Container(child: Text(e),));
  });
  
  return actvi;
}

void mostrarAlerta(mensaje, context, {titulo = "Mensaje"}){

  showDialog(context: context,barrierDismissible: true,
  builder: (BuildContext context){
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(titulo),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(mensaje+"\n\n"),
          Image.asset('assets/imagenes/alert.png',width: 100,height: 100,)
        ],
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){Navigator.pop(context);}, child: Text("Ok"))
      ],
    );
  });
}

ListTile sinDatos()=>ListTile(
  leading: Icon(Icons.do_not_disturb_alt),
  title: Text('No hay datos que cargar'),
  trailing: Icon(Icons.speaker_notes_off),
);