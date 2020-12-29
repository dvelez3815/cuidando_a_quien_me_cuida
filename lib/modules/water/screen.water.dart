import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/modules/water/widget.water_circular.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';


class WaterScreen extends StatefulWidget {
   

  @override
  _WaterScreenState createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {

  final DBProvider dbProvider = DBProvider.db;
  double dailyGoal;
  bool alarmsActivated;
  bool modifyMode;

  @override
  void initState() { 
    super.initState();
    alarmsActivated = true;
    modifyMode = false;
    dailyGoal = 3.5;
  }

  _WaterScreenState(){
    dbProvider.getComidas();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(      
      body: Column(
        children: [
          getHeader(context, size, "AGUA", transparent: true),
         _getBody(context, size),
        ],
      )
    );
  }

  Widget _getBody(BuildContext context, Size size) {
    return WaterCircular();
  }
}