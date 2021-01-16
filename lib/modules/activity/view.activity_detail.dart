import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/activity/model.activity.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';

class ActivityDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final model = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          getHeader(context, "Detalle de actividad"),
          Expanded(
            child: ListView(
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
              children: _getBody(context, model)
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _getBody(BuildContext context, Actividad model) {

    return [
      ListTile(
        leading: Icon(Icons.info),
        title: Text("Nombre"),
        subtitle: Text(model.nombre),
      ),
      ListTile(
        leading: Icon(Icons.info),
        title: Text("Descripción"),
        subtitle: Text(model.descripcion, textAlign: TextAlign.justify,),
      ),
      ListTile(
        title: Text("Hora para notificar"),
        subtitle: Text("${model.time.format(context)}")
      ),
      ListTile(
        title: Text("Días para notificar"),
        subtitle: _daysListView(model, context)
      ),
      Divider(),
      _getImages(context, model),
      Divider(),
      ExpansionTile(
        title: Text("Materiales"),
        children: model.complements.isEmpty?
              <Widget>[ListTile(title: Text("No hay materiales"))]:
              model.complements.map((item){
                return ListTile(
                  leading: Icon(Icons.sports_baseball),
                  title: Text(item["title"])
                );
              }).toList(),
      ),
      Divider(),
      FutureBuilder(
        future: DBProvider.db.loadActivityProcedure(model.id),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          
          switch(snapshot.connectionState){
            
            case ConnectionState.none:
              return ListTile(title: Text("No existe un procedimiento"));
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(),);
            case ConnectionState.active:
              return Center(child: CircularProgressIndicator(),);
            case ConnectionState.done:
            default:
              if(snapshot.data == "" || snapshot.data == null) return ListTile(title: Text("No existe un procedimiento"));

              return ListTile(
                leading: Icon(Icons.info),
                title: Text("Procedimiento"),
                subtitle: Text(snapshot.data, textAlign: TextAlign.justify,),
              );
          }
        },
      ),
      SizedBox(height: 20.0,)
    ];
  }

  Widget _getImages(BuildContext context, Actividad model) {

    return FutureBuilder(
      future: DBProvider.db.loadActivityImages(model.id),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }

        if(snapshot.data.isEmpty){
          return ListTile(title: Text("No hay imágenes"));
        }  

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: snapshot.data.map((url)=>FadeInImage(
                placeholder: AssetImage("assets/loader.gif"),
                image: AssetImage(
                  url,
                ),
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width*0.85,
                height: MediaQuery.of(context).size.width,
              )).toList()
          ),
        );
      },
    );

  }

  Widget _daysListView(Actividad item, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: item.daysToNotify.map((day){
          return Container(
            margin: EdgeInsets.only(right: 5.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              radius: 12.0,            
              child: Text(
                day != "miercoles"? day[0].toUpperCase(): "X", 
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 10.0
                ),
              )
            ),
          );
        }).toList(),
      ),
    );
  }
}