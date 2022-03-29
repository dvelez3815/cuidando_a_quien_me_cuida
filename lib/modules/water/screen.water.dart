import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/global/settings.dart';
import 'package:utm_vinculacion/modules/water/widget.water_circular.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';

import 'model.water.dart';
import 'provider.water.dart';

class WaterScreen extends StatefulWidget {
  final _provider = new WaterProvider();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  _WaterScreenState createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        title: Text(
          AppSettings().settings['app_name'], 
          style: TextStyle(fontSize: 15.0, color: Theme.of(context).accentColor),          
        ),
        backgroundColor: Theme.of(context).canvasColor,
        actions: [tresPuntos(context, customColor: Theme.of(context).accentColor)],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
          children: [
            // getHeader(context, "AGUA", transparent: true),
            _getHeader(),
            _getBody(context, size)
          ],
        ),
      )
    );
  }

  Widget _getBody(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getProgressComponent(size),
        _getWaterGlassComponent(),
        // FlatButton(
        //   child: Icon(Icons.ac_unit),
        //   onPressed: ()=>WaterProvider().restoreProgress(),
        // )
      ],
    );
  }

  Widget _getWaterGlassComponent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _getTunedButton(
          "Beber un vaso de agua", 
          Icons.bubble_chart_rounded,
	  (){
	    if(widget._provider.model.progress >= 100){
	      widget._scaffoldKey.currentState.showSnackBar(new SnackBar(
		content: Text("No puedes agregar más vasos de agua :')"),
	      ));
	    }
	    else widget._provider.addWaterLts();
	  }
        ),
        _getTunedButton(
          "Quitar un vaso de agua", 
          Icons.delete_sweep,
          _getRemoveGlassEvent,
          minimalist: true
        ),
      ],
    );
  }

  Widget _getTunedButton(String text, IconData icon, Function onPress, {bool minimalist=false}) {
    return new RaisedButton.icon(
      padding: EdgeInsets.symmetric(
        vertical: minimalist?10.0:30.0, 
        horizontal: 20.0
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      icon: Icon(
        icon, size: minimalist? 15.0:20.0,
        color: minimalist?Theme.of(context).accentColor:Theme.of(context).canvasColor
      ),
      color: minimalist? Theme.of(context).canvasColor:Theme.of(context).accentColor,
      label: Text(
        text,
        style: TextStyle(
          fontSize: minimalist? 15.0:20.0,
          color: minimalist?Theme.of(context).accentColor:Theme.of(context).canvasColor
        ),
      ),
      onPressed: onPress
    );
  }

  StreamBuilder<WaterModel> _getProgressComponent(Size size) {
    return StreamBuilder(
      stream: widget._provider.modelStream,      
      builder: (BuildContext context, AsyncSnapshot<WaterModel> snapshot){

        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator()
          );
        }
        
        final WaterModel model = snapshot.data;

        return Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          children: [
            WaterCircular(
              progress: model.progress/model.goal,
              completed: model.progress>=model.goal,
            ),
            (model.progress>=model.goal)? Container(
              width: size.width*0.8,
              height: size.width*0.8,
              decoration: BoxDecoration(
                color:model.progress>6.0?
                      Colors.red.withOpacity(0.6):
                      Theme.of(context).canvasColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(size.width*0.8)
              ),
              child: Center(
                child: Text(
                  model.progress > 6.0 && model.progress < 40? "SOBREHIDRATACIÓN"
		    :model.progress >= 40 && model.progress < 60? "No lo haga compa"
		    :model.progress >= 60 && model.progress < 70? "Para, por favor :("
		    :model.progress >= 70 && model.progress < 75? "'tas bien?"
		    :model.progress >= 75 && model.progress < 80? "A conocer a \nMaradona :')"
		    :model.progress >= 80 && model.progress < 100? "Fuen un placer,\nsoldado"
		    :model.progress >= 100? "*se muere*":"COMPLETADO",
                  style: TextStyle(
                    fontSize: 25.0, 
                    color: model.progress > 6.0?Colors.white:Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold
                  ),
                )
              ),
            ):Container()
          ],
        );
      },
    );
  }

  Widget _getHeader() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Theme.of(context).accentColor
      ),
      child: StreamBuilder(
        stream: widget._provider.modelStream,
        builder: (BuildContext context, AsyncSnapshot<WaterModel> snapshot){
          
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          
          return Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Column(
                children: [
                  Text(
                    "Agua bebida hoy",
                    style: TextStyle(
                      color: Theme.of(context).canvasColor, 
                      fontSize: 15.0, fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "${snapshot.data.progress.toStringAsFixed(2)} lts",
                    style: TextStyle(
                      color: Theme.of(context).canvasColor, 
                      fontSize: 40.0, fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "Tu objetivo diario es de ${snapshot.data.goal.toStringAsFixed(2)} lts.\n"
                    "Debes beber ${snapshot.data.howManyGlassesLeft} vaso"
                    "${snapshot.data.howManyGlassesLeft == 1? "":"s"} más de agua",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).canvasColor, 
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.settings, color: Theme.of(context).canvasColor),
                    onPressed: ()=>Navigator.of(context).pushNamed(WATER_PREFERENCES),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }

  void _getRemoveGlassEvent() {

    final progress = widget._provider.model.progress;
    final glassSize = widget._provider.model.glassSize/1000;

    if(progress == 0) {
      widget._scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Text("¡No puedes quitar más vasos de agua!"),
      ));
    }
    else if(progress < glassSize){
      widget._provider.restoreProgress();
    }
    else{
      widget._provider.removeWaterGlasses();
    }
  }
} 
