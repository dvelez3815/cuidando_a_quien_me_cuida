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
    widget._provider.init();
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
      children: [
        IconButton(
          icon: Icon(Icons.restore),
          onPressed: ()=>widget._provider.restoreProgress()
        ),
        _getProgressComponent(size),
        _getWaterGlassComponent(),
        FlatButton.icon(
          icon: Icon(Icons.settings),
          label: Text("Editar preferencias"),
          onPressed: ()=>Navigator.of(context).pushNamed(WATER_PREFERENCES),
        )
      ],
    );
  }

  Center _getWaterGlassComponent() {
    return Center(
        child: FlatButton.icon(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          icon: Icon(Icons.bubble_chart_rounded, size: 20.0, color: Theme.of(context).canvasColor),
          color: Theme.of(context).accentColor,
          label: Text(
            "Beber agua",
            style: TextStyle(fontSize: 20.0, color: Theme.of(context).canvasColor),
          ),
          onPressed: ()=>widget._provider.addWaterLts(),
        ),
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
                  model.progress > 6.0? "SOBREHIDRATACIÓN":"COMPLETADO",
                  style: TextStyle(
                    fontSize: 25.0, 
                    color: Theme.of(context).accentColor,
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
          
          return Column(
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
                "Tu objetivo diario es de ${snapshot.data.goal.toStringAsFixed(2)} lts",
                style: TextStyle(
                  color: Theme.of(context).canvasColor, 
                  fontSize: 15.0,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

} 