import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/calendar_week.dart';
import 'package:flutter_calendar_week/model/decoration_item.dart';
import 'package:intl/intl.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart' as constantesRutas;
import 'package:utm_vinculacion/rutas/const_rutas.dart';
import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/ver_contenido/publicidades.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<bool> isSelected = [true, false];
  int _currentIndex = 0;
  List cardList = [Item1(), Item2(), Item3(), Item4()];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(NOMBREAPP),
          actions: <Widget>[
            tresPuntos(context),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                cambioDePestanas(mediaQuery), //Inicio-Calendario
                opciones(mediaQuery),
              ],
            )
          ],
        ));
  }

  Widget cambioDePestanas(Size mediaQuery) {
    return ToggleButtons(
        borderColor: Colors.black,
        fillColor: Colors.blue,
        selectedBorderColor: Colors.black,
        selectedColor: Colors.white,
        children: <Widget>[
          Container(
            width: mediaQuery.width * 0.49,
            child: Container(
                child: Center(
                    child: Text(
              'INICIO',
            ))),
          ),
          Container(
            width: mediaQuery.width * 0.5,
            child: Container(
                child: Center(
                    child: Text(
              'CALENDARIO',
            ))),
          ),
        ],
        isSelected: isSelected,
        onPressed: (int index) {
          setState(() {
            for (var i = 0; i < isSelected.length; i++) {
              isSelected[i] = i == index;
            }
          });
        });
  }

  Widget opciones(Size mediaQuery) {
    return isSelected[0] ? opcion1(mediaQuery) : opcion2(mediaQuery);
  }

  Widget opcion1(Size mediaQuery) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            
            child: Center(
                child: Column(
              children: <Widget>[
                CarouselSlider(
                  
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: Duration(seconds: 10),
                  aspectRatio: 2.0,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: cardList.map((card) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: Colors.deepPurple[100],
                          child: card,
                        ),
                      );
                    });
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: map<Widget>(cardList, (index, url) {
                    return Container(
                      width: 10.0,
                      height: 10.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? Colors.blueAccent
                            : Colors.grey,
                      ),
                    );
                  }),
                ),
              ],
            )

                ),
          ),
          Container(
            width: mediaQuery.width * 1,
            child: RaisedButton(
                child: Text(
                  'VER TODO EL CONTENIDO',
                ),
                color: Colors.blue,
                onPressed: () {
                  Navigator.pushNamed(context, CONTENIDO);
                }),
          ),
          Container(
            width: mediaQuery.width * 1,
            height: mediaQuery.height * 0.04,
            child: Text("" +
                DateFormat('EEEE', 'es')
                    .format(DateTime.now())
                    .toString()
                    .toUpperCase() +
                " " +
                DateTime.now().day.toString()),
          ),
          FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, constantesRutas.RUTINA);
              },
              color: Colors.green,
              child: Container(
                width: mediaQuery.width,
                height: mediaQuery.height * 0.45,
                child: Center(
                    child: Text(
                  'COMENZAR',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
              )),
        ],
      ),
    );
  }

  Widget opcion2(Size mediaQuery) {
    var _selectedDate;
    return Container(
      width: mediaQuery.width,
      height: mediaQuery.height * 0.5,
      child: CalendarWeek(
              height: 80,
              minDate: DateTime.now().add(
                Duration(days: -365),
              ),
              maxDate: DateTime.now().add(
                Duration(days: 365),
              ),
              onDatePressed: (DateTime datetime) {
                setState(() {
                  _selectedDate = datetime;
                });
              },
              onDateLongPressed: (DateTime datetime) {
                setState(() {
                  _selectedDate = datetime;
                });
              },
              dayOfWeekStyle:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              dayOfWeekAlignment: FractionalOffset.bottomCenter,
              dateStyle:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.w400),
              dateAlignment: FractionalOffset.topCenter,
              todayDateStyle:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.w400),
              todayBackgroundColor: Colors.black.withOpacity(0.15),
              pressedDateBackgroundColor: Colors.blue,
              pressedDateStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              dateBackgroundColor: Colors.transparent,
              backgroundColor: Colors.white,
              dayOfWeek: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
              spaceBetweenLabelAndDate: 0,
              dayShapeBorder: CircleBorder(),
              decorations: [
                DecorationItem(
                    decorationAlignment: FractionalOffset.bottomRight,
                    date: DateTime.now(),
                    decoration: Icon(
                      Icons.today,
                      color: Colors.blue,
                    )),
                DecorationItem(
                    date: DateTime.now().add(Duration(days: 3)),
                    decoration: Text(
                      'Holiday',
                      style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            )
    );
  }
}
