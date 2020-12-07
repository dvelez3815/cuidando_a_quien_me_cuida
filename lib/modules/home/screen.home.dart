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

    final color = Theme.of(context).brightness == Brightness.dark? Colors.white:Colors.indigo[900];

    return Container(
      height: size.height*0.35,
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
              "Cuidando a quién me cuida",
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
            _getOptCard("Actividades", "Sugerencias para ti", ACTIVIDADES, icon: Icons.access_time),
            _getOptCard("Música", "Reproducción a un click", MUSICA, icon: Icons.music_note),
          ]
        ),
        TableRow(
          children: [
            _getOptCard("Recetas", "Disfruta de grandes comidas", RECETAS, icon: Icons.fastfood),
            _getOptCard("Bienestar", "Tu bienestar es importante", CUIDADO, icon: Icons.medical_services),
          ]
        ),
        TableRow(
          children: [
            _getOptCard("Agua", "descripción aqyí", WATER, icon: Icons.bubble_chart),
            _getOptCard("Contactos", "descripción aquí", CONTACTS, icon: Icons.contact_phone)
          ]
        ),
      ],
    );
  }

  Widget _getOptCard(String title, String body, String route, {IconData icon}) {
    return GestureDetector(
      onTap: ()=>Navigator.of(context).pushNamed(route),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        height: 140,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
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
            Icon(icon ?? Icons.shield, size: 30.0,)
          ],
        ),
      ),
    );
  }
}