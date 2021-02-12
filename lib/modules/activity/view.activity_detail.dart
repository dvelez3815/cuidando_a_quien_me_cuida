import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/activity/model.activity.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/widget.tunned_expansion.dart';
import 'package:utm_vinculacion/widgets/widget.tunned_listtile.dart';

class ActivityDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // This will be given in the previous screen, in the doure
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

  /// This is the body of this widget.
  /// 
  /// The [model] will be given in the previous route. It's obtained from
  /// the settings of ModalRoute Flutter object
  List<Widget> _getBody(BuildContext context, Actividad model) {

    return <Widget>[
      ListTile(
        leading: Icon(Icons.adjust_rounded),
        title: Text("Nombre"),
        subtitle: Text(model.nombre),
      ),
      TunnedListTile(
        activity: null, 
        trailing: null,
        leadingIcon: Icons.info,
        title: Text("Descripción"),
        subtitle: Text(model.descripcion, textAlign: TextAlign.justify,),
      ),
      TunnedListTile(
        activity: null, 
        trailing: null,
        leadingIcon: Icons.access_time_rounded,
        title: Text("Hora para notificar"),
        subtitle: Text("${model.time.format(context)}")
      ),
      TunnedListTile(
        activity: null, 
        trailing: null,
        leadingIcon: Icons.calendar_today,
        title: Text("Días para notificar"),
        subtitle: _daysListView(model, context)
      ),
      _getImagesWidget(context, model),
      _getComplements(context, model),
      _getProcedureWidget(context, model),
      SizedBox(height: 20.0,)
    ];
  }

  /// Works with [_getImages] and [_getImageContainer], both previous methods are
  /// to process the image, one a time; this method will show all images already
  /// processed.
  TunnedExpansion _getImagesWidget(BuildContext context, Actividad model) {
    return TunnedExpansion(
      expansionTile: ExpansionTile(
        textColor: Theme.of(context).canvasColor,
        tileColor: Theme.of(context).accentColor,
        initiallyExpanded: true,
        title: Text("Imágenes"),
        subtitle: Text("\nPuede arrastrar la imágen a la derecha o izquierda para ver más."),
        leading: Icon(Icons.image, color: Theme.of(context).canvasColor),
        children: [
          _getImages(context, model),
        ],
      ),
    );
  }

  /// Shows all complements of [model] in a caroussel way
  TunnedExpansion _getComplements(BuildContext context, Actividad model) {
    return TunnedExpansion(
      expansionTile: ExpansionTile(
        title: Text("Materiales"),
        textColor: Theme.of(context).canvasColor,
        tileColor: Theme.of(context).accentColor,
        initiallyExpanded: true,
        leading: Icon(Icons.view_comfortable_sharp, color: Theme.of(context).canvasColor),
        children: model.complements.isEmpty?
              <Widget>[ListTile(title: Text("No hay materiales"))]:
              model.complements.map((item){
                return ListTile(
                  leading: Icon(Icons.sports_baseball),
                  title: Text(item["title"])
                );
              }).toList(),
      ),
    );
  }

  /// All of this code is just to show the activity procedure.
  /// 
  /// [model] comes from modal route, and it's passed from previous route.
  TunnedExpansion _getProcedureWidget(BuildContext context, Actividad model) {
    return TunnedExpansion(
      expansionTile: ExpansionTile(
        title: Text("Procedimiento"),
        textColor: Theme.of(context).canvasColor,
        tileColor: Theme.of(context).accentColor,
        initiallyExpanded: true,
        leading: Icon(Icons.toc_outlined, color: Theme.of(context).canvasColor),
        children: [FutureBuilder(
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
                  title: Text(snapshot.data, textAlign: TextAlign.justify,),
                );
            }
          }),
        ]
      )
    );
  }

  /// This will process all images of [model] in caroussel
  Widget _getImages(BuildContext context, Actividad model) {

    return FutureBuilder(
      future: DBProvider.db.loadActivityImages(model.id),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }

        if(snapshot.data.isEmpty){
          return ListTile(
            leading: Icon(Icons.image_not_supported),
            title: Text("No hay imágenes")
          );
        }  

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: ScrollPhysics(parent: BouncingScrollPhysics()),
          child: Row(
              children: snapshot.data.map((url)=>_getImageContainer(context, url)).toList()
          ),
        );
      },
    );

  }

  /// Works with [_getImages] method. Its goal is to fit the image
  /// in a box
  Container _getImageContainer(BuildContext context, String url) {

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor)
      ),
      child: FadeInImage(
        placeholder: AssetImage("assets/loader.gif"),
        image: AssetImage(
          url,
        ),
        fit: BoxFit.fitHeight,
        imageSemanticLabel: "Imágen de la actividad",
        height: MediaQuery.of(context).size.width,
      ),
    );
  }

  /// Shows all days where the [item] should be performed in a caroussel way
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