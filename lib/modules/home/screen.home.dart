import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utm_vinculacion/modules/global/settings.dart';
import 'package:utm_vinculacion/modules/home/view.carousel.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/user_preferences.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';
import 'package:utm_vinculacion/widgets/widget.banner.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    _showTutorial();

    return Scaffold(
      body: Stack(
        children: [
          _getBanner(size),
          SingleChildScrollView(
            physics: ScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              children: [
                _getHeader(),
                CarouselWidget(),
                _getActivitiesButton(),
                SizedBox(height: 10.0,),
                _getOptions()
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget _getBanner(Size size) {

    final color = Theme.of(context).accentColor;

    return Container(
      height: size.height*0.41,
      width: size.width,
      child: CustomPaint(
        painter: BannerWidget(color)
      ),
    );
  }

  Widget _getHeader() {

    final textColor = Theme.of(context).brightness == Brightness.dark? Colors.black:Colors.white;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              setting.settings["app_name"],
              style: TextStyle(color: textColor, fontSize: 18.0),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_today, color: textColor),
                  onPressed: ()=>Navigator.of(context).pushNamed(CALENDAR),
                ),
                tresPuntos(context)
              ],
            )
          ],
        )
      ),
    );
  }

  Widget _getActivitiesButton() {
    return Container(
      width: MediaQuery.of(context).size.width*0.95,
      height: MediaQuery.of(context).size.height*0.15,
      child: FlatButton.icon(
        padding: EdgeInsets.all(15.0),
        color: Theme.of(context).bottomAppBarColor, // Colors.orange[400],
        icon: Image.asset("assets/icons/MIS EVENTOS.png"),
        label: Text(
          "MIS EVENTOS",
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.black,
            fontSize: 20.0
          ),
        ),
        onPressed: (){
          Navigator.of(context).pushNamed(EVENTS);
        },
      ),
    );
  }

  Widget _getOptions() {

    final List<Map<String, dynamic>> fullData = List<Map<String, dynamic>>.from(AppSettings().settings["menu_items"]);

    int rows = fullData.length ~/ 2;
    if(fullData.length.isOdd) ++rows;

    final elements = new List<TableRow>();

    // Mapping all elements
    for(int i=0; i<rows; ++i){

      elements.add(TableRow(
        children: [
          _getOptCard(fullData[i*2]["title"], fullData[i*2]["description"], fullData[i*2]["route"], icon: fullData[i*2]["icon_url"]),
          (i == rows - 1 && fullData.length.isOdd)? 
            Container():
            _getOptCard(fullData[i*2+1]["title"], fullData[i*2+1]["description"], fullData[i*2+1]["route"], icon: fullData[i*2+1]["icon_url"]),
        ]
      ));
    }

    return Table(            
      children: elements
    );
  }

  void _showTutorial() {
    if(UserPreferences().showTutorial) {
      // TODO
      // UserPreferences().showTutorial = false;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("¡Bienvenido!"),
            content: Text("En nuestro canal de YouTube puedes encontrar guías de cómo usar la app"),
            actions: [
              RaisedButton.icon(
                icon: Icon(Icons.play_arrow),
                label: Text("Abrir YouTube"),
                onPressed: ()=>launch("https://www.youtube.com/playlist?list=PLi78ev46WowcREuEyZ0GottgIijIkAo1n&fbclid=IwAR2GvoIfIxS8Ne9h95mVCWV2SiY2x4IgxjHBVzyias8HNvS7n0rNL3w7_Mo"),
              )
            ],
          );
        }
      );
    }
  }

  Widget _getOptCard(String title, String body, String route, {String icon, bool activado = true}) {
    return GestureDetector(
      onTap: ()=>activado?Navigator.of(context).pushNamed(route):{},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          border: Border.all(width: 2.0, color: Theme.of(context).bottomAppBarColor),
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                title.toUpperCase(), 
                style: TextStyle(fontWeight: FontWeight.bold),
              ), 
              subtitle: Text(body, style: TextStyle(fontSize: 10.0)),
            ),
            (icon == null)? Icon(Icons.shield, size: 80.0, color: Colors.grey):
                            Image.asset(
                              icon,
                              height: 120.0,
                              fit: BoxFit.cover,
                            )
          ],
        ),
      ),
    );
  }
}