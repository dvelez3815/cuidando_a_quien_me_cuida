import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/home/view.carousel.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
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

    return Scaffold(
      body: Stack(
        children: [
          _getBanner(size),
          SingleChildScrollView(
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
    return Container(
      height: size.height*0.35,
      width: size.width,
      child: CustomPaint(
        painter: BannerWidget()
      ),
    );
  }

  Widget _getHeader() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Cuidando a quién me cuida",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.white),
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
      child: MaterialButton(
        padding: EdgeInsets.all(15.0),
        color: Colors.orange[400],
        child: Text(
          "MIS EVENTOS",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        onPressed: (){
          Navigator.of(context).pushNamed(EVENTS);
        },
      ),
    );
  }

  Widget _getOptions() {
    return Table(            
      children: [
        TableRow(
          children: [
            _getOptCard("Actividades", "Sugerencias para ti", ACTIVIDADES),
            _getOptCard("Música", "Reproducción a un click", MUSICA),
          ]
        ),
        TableRow(
          children: [
            _getOptCard("Recetas", "Disfruta de grandes comidas", RECETAS),
            _getOptCard("Bienestar", "Tu bienestar es importante", CUIDADO),
          ]
        )
      ],
    );
  }

  Widget _getOptCard(String title, String body, String route) {
    return GestureDetector(
      onTap: ()=>Navigator.of(context).pushNamed(route),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        height: 140,
        decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: Colors.orange[400]),
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
            Icon(Icons.shield, size: 30.0,)
          ],
        ),
      ),
    );
  }
}