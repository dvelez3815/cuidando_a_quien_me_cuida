import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/water/widget.water_circular.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';

import 'provider.water.dart';


class WaterScreen extends StatefulWidget {
  final _provider = new WaterProvider();

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
      body: Container(
        child: SingleChildScrollView(
          physics: ScrollPhysics(parent: BouncingScrollPhysics()),
          child: Column(
            children: [
              getHeader(context, size, "AGUA", transparent: true),
              _getBody(context, size)
            ],
          )
        ),
      )
    );
  }

  Widget _getBody(BuildContext context, Size size) {
    return Column(
      children: [
        Center(
          child: IconButton(
            icon: Icon(Icons.bubble_chart_rounded),
            onPressed: ()=>widget._provider.addWaterLts(0.02/widget._provider.goalValue),
          ),
        ),
        _getProgressComponent(),
        _getGoalComponent()
      ],
    );
  }

  StreamBuilder<double> _getGoalComponent() {
    return StreamBuilder(
      stream: widget._provider.goalStream,
      initialData: 0.0,
      builder: (context, AsyncSnapshot<double> snapshot) {
        return ListTile(
          title: Text("Objetivo diario"),
          subtitle: Text("Tu objetivo diario es beber ${snapshot.data} lts de agua"),
        );
      },

    );
  }

  StreamBuilder<double> _getProgressComponent() {
    return StreamBuilder(
      stream: widget._provider.progressStream,
      initialData: 0.0,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot){
        return Column(
          children: [
            WaterCircular(progress: snapshot.data),
            Divider(),
            ListTile(
              title: Text("Progreso de hoy"),
              subtitle: Text("Hoy has tomado "+snapshot.data.toStringAsFixed(2)+" lts de agua"),
            )
          ],
        );
      },
    );
  }
}