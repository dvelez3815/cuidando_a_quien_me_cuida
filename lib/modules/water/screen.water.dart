import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
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
          getHeader(context, size, "AGUA"),
          Expanded(child: _getBody(context, size)),
        ],
      )
    );
  }

  Widget _getBody(BuildContext context, Size size) {
    return ListView(
      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
      children:[
        SizedBox(height: 10.0,),
        _alarmTile(),
        Divider(),
        CheckboxListTile(
          value: modifyMode ?? false,
          title: Text("Modo edición"),
          onChanged: (alarmsActivated ?? true)? (value)=>setState((){modifyMode=value;}):null,
        ),
        _getDailyGoalTile(context),
        _titleTile(),
        Divider(),
        SizedBox(height: 15.0,),
        _glassesInfo(),
        Divider(),
        _getSaveBtn()
      ],
    );
  }

  Widget _getDailyGoalTile(BuildContext context) {

    const double fontSize = 20.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Objetivo diario", style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
              Text("${dailyGoal ?? 0.0} lts", style: TextStyle(fontSize:fontSize, fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: dailyGoal,
            min: 0.0,
            max: 5.0,
            divisions: 20,
            onChanged: (modifyMode && alarmsActivated ?? false)? (value)=>setState((){dailyGoal=value;}):null,
          ),
          _getWaterSliderText()
        ],
      ),
    );
  }

  Widget _titleTile() {
    return GestureDetector(
      child: Text(
        "¿Cuántos litros de agua debo tomar?",
        style: TextStyle(fontSize: 14.0, decoration: TextDecoration.underline, color: Colors.lightBlue),
        textAlign: TextAlign.center,
      ),
      onTap: (){
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("¿Cuántos vasos de agua al día debo tomar?"),
              content: Text.rich(
                TextSpan(
                  text: "\Existen muchos factores que influyen en la cantidad de agua"
                        " que se debe tomar al día, tales como si es usted una persona "
                        "físicamente activa, su edad, sexo, o incluso si sigue algún tipo"
                        " de dieta o no. Sin embargo, en términos generales se recomienda tomar ",
                  children: [
                    TextSpan(
                      text: "3.7 litros de agua al día en el caso de los hombres",
                      style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                    TextSpan(text: " y "),
                    TextSpan(
                      text: "2.7 litros en el caso de las mujeres.",
                      style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                  ]
                )
              ),
              actions: [
                FlatButton.icon(
                  icon: Icon(Icons.check_circle),
                  label: Text("Ok"),
                  onPressed: ()=>Navigator.of(context).pop(),
                )
              ],
            );
          }
        );
      },
    );
  }

  Widget _getWaterSliderText() {
    
    String response;
    Color color = Theme.of(context).textTheme.bodyText1.color;
    
    if(dailyGoal <= 1.0) {
      response = "¡Debes tomar más agua!";
      color = Colors.yellow[900];
    }
    else if(dailyGoal > 1.0 && dailyGoal < 2.5) {
      response = "Aceptable";
    }
    else if(dailyGoal >=2.5 && dailyGoal <= 4.0) {
      response = "¡Perfecto!";
      color = Colors.green;
    }
    else if(dailyGoal >4) {
      response = "¡Sobrehidratación!";
      color = Colors.yellow[900];
    }

    return Text(
      response, 
      style: TextStyle(
        color: color,
        fontSize: 17.0,
        fontWeight: FontWeight.bold
      ),
    );
  }

  Widget _glassesInfo() {
    return ListTile(
      leading: Icon(Icons.local_drink),
      // title: Text("Vasos de agua al día"),
      title: Text(
        "Para cumplir tu objetivo de $dailyGoal litros de agua"
        " al día, deberás tomar aproximadamente ${(dailyGoal~/0.24)} vasos de agua hoy.",
        textAlign: TextAlign.justify,
      ),
      trailing: Icon(Icons.info),
    );
  }

  Widget _alarmTile() {
    return Column(
      children: [
        SwitchListTile(
          secondary: Icon(Icons.alarm),
          title: Text("¿Activar módulo de agua?"),
          subtitle: Text("Recibirás una notificación por cada vaso de agua que debas tomar"),
          value: alarmsActivated ?? true,
          onChanged: (state)=>setState((){alarmsActivated=state;}),
        ),
        ListTile(
          leading: Icon(Icons.alarm_rounded),
          title: Text("Hora de inicio"),
          trailing: Text("07:00"),
        ),
        ListTile(
          leading: Icon(Icons.alarm_rounded),
          title: Text("Hora de la última alarma"),
          trailing: Text("22:00"),
        ),
      ],
    );
  }

  Widget _getSaveBtn() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60.0),
      child: FlatButton.icon(
        icon: Icon(Icons.save, color: Theme.of(context).canvasColor),
        label: Text("Guardar cambios", style: TextStyle(color: Theme.of(context).canvasColor)),
        color: Theme.of(context).accentColor,
        onPressed: alarmsActivated ?? false ? (){}:null,
      ),
    );
  }
}