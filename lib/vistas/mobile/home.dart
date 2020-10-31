import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:utm_vinculacion/models/actividades_model.dart';
import 'package:utm_vinculacion/models/alarma_model.dart';
import 'package:utm_vinculacion/models/cuidado_model.dart';
import 'package:utm_vinculacion/models/global_activity.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/rutas/const_rutas.dart' as constantesRutas;
import 'package:utm_vinculacion/rutas/const_rutas.dart';
import 'package:utm_vinculacion/texto_app/const_textos.dart';
import 'package:utm_vinculacion/vistas/mobile/ver_contenido/publicidades.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';


const double pWidth = 392.7;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
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
  /*
    Calendario
  */
  
  /// Boolean to handle calendar expansion
  bool _expanded;

  /// The height of an individual week row
  double collapsedHeightFactor;

  /// The y coordinate of the active week row
  double activeRowYPosition;

  /// The date var that handles the changing months on click
  DateTime displayDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  /// The date that is shown as Month , Year between the arrows
  DateTime showDate;

  /// The row that contains the current week withing the list of rows generated
  int activeRow;

  /// The list that stores the week rows of the month
  List<Widget> calList;

  /// PageController to handle the changing month views on click
  PageController pageController = PageController(initialPage: 0);

  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeInOut);

  /// Animation controller that handles the calendar expansion event and the 
  /// expand_more icon rotation event
  /// 
  AnimationController _controller;

  /// Animation controller that handles the expand_more icon fading in/out event 
  /// based on if the current month is being displayed 
  AnimationController _monthController;

  /// The animation for the changing height with the y coordinates in calendar expansion
  Animation<double> _anim;

  /// Color animation for the -> and <- arrows that change the month view
  Animation<Color> _arrowColor;

  /// Animation for the rotating expand_more/less icon
  Animation<double> _iconTurns;

  /// Color animation for the ^ arrow that handles expansion of view
  Animation<Color> _monthColor;

  /// Animation duration
  static const Duration _kExpand = Duration(milliseconds: 300);

  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);
  
  // Boolean to handle what to do when calendar is expanded or contracted
  ValueChanged<bool> onExpansionChanged;

  /// Color tween for -> and <- icons
  Animatable<Color> _arrowColorTween =
      ColorTween(begin: Color(0x00FFA68A), end: Color(0xffFFA68A));

  /// Color tween for expand_less icon
  Animatable<Color> _monthColorTween =
      ColorTween(begin: Color(0xffEC520B), end: Color(0x00EC520B));

  DBProvider dbProvider = DBProvider.db;
  @override
  void initState() {
    dbProvider = DBProvider.db;
    // calendar is not expanded initially
    _expanded = false;
    showDate = displayDate;

    // [returnRowList] called and stored in [rowListReturned] to make use of in the next occurrences
    List<Widget> rowListReturned = returnRowList(DateTime(displayDate.year, displayDate.month, 1));
    
    //Determine the height of one week row
    collapsedHeightFactor = 1 / rowListReturned.length;

    //Determine the y coordinate of the current week row with this formula
    activeRowYPosition = ((2 / (rowListReturned.length - 1)) * getActiveRow()) - 1;

    //Initialize animation controllers
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _monthController = AnimationController(duration: _kExpand, vsync: this);
    _anim = _controller.drive(_easeInTween);
    _arrowColor = _controller.drive(_arrowColorTween.chain(_easeInTween));
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _monthColor = _monthController.drive(_monthColorTween.chain(_easeInTween));

    //initial value = false
    _expanded = PageStorage.of(context)?.readState(context) ?? false;
    if (_expanded) _controller.value = 1.0;

    //calList contains the list of week Rows of the displayed month
    calList = [
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: rowListReturned)
    ];
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    _monthController.dispose();
    super.dispose();
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
    
    double scaleFactor = MediaQuery.of(context).size.width / pWidth;
    double calendarWidth = MediaQuery.of(context).size.width * 0.85;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 13*scaleFactor, bottom: 8*scaleFactor, left: 16*scaleFactor, right: 16*scaleFactor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          enableFeedback: _expanded,
                          splashRadius: _expanded ? 15.0 : 0.001,
                          icon: AnimatedBuilder(
                            animation: _arrowColor,
                            builder: (BuildContext context, Widget child) =>
                                SvgPicture.asset(
                              'assets/imagenes/izquierda.svg',
                              color: _arrowColor.value,
                            ),
                          ),
                          onPressed: () {
                            if (_expanded) {
                              DateTime curr = showDate;
                              setState(() {
                                //set calList to previous month to showDate and showDate
                                calList = [
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: returnRowList(DateTime(
                                          showDate.year,
                                          showDate.month - 1,
                                          1))),
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: returnRowList(DateTime(
                                          showDate.year, showDate.month, 1))),
                                ];
                                //Decrement the showDate by 1 month
                                showDate = DateTime(
                                    showDate.year, showDate.month - 1, 1);
                              });

                              //Fade in/out the expand icon if current month is not displayed month
                              if (areMonthsSame(curr, DateTime.now())) {
                                _monthController.forward();
                                Future.delayed(Duration(milliseconds: 1), () {
                                  setState(() {});
                                });
                              } else if (areMonthsSame(
                                  showDate, DateTime.now())) {
                                _monthController.reverse();
                                Future.delayed(_kExpand, () {
                                  setState(() {});
                                });
                              }
                              pageController.jumpToPage(1);
                              pageController.previousPage(
                                  duration: _kExpand, curve: Curves.easeInOut);
                            }
                          },
                        ),
                      ),
                      // Displayed Month, Displayed Year
                      Text(formatDate(showDate),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        textScaleFactor: scaleFactor,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          enableFeedback: _expanded,
                          splashRadius: _expanded ? 15.0 : 0.001,
                          icon: AnimatedBuilder(
                            animation: _arrowColor,
                            builder: (BuildContext context, Widget child) =>
                                SvgPicture.asset(
                              'assets/imagenes/derecha.svg',
                              color: _arrowColor.value,
                            ),
                          ),
                          onPressed: () {
                            if (_expanded) {
                              DateTime curr = showDate;
                              setState(() {
                                //set calList to showDate and showDate incremented by 1 month
                                calList = [
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: returnRowList(DateTime(
                                          showDate.year, showDate.month, 1))),
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: returnRowList(DateTime(
                                          showDate.year,
                                          showDate.month + 1,
                                          1))),
                                ];
                                //Increment showDate by a month
                                showDate = DateTime(
                                    showDate.year, showDate.month + 1, 1);
                              });
                              
                              //Fade in/out the expand icon if current month is not displayed month
                              if (areMonthsSame(curr, DateTime.now())) {
                                _monthController.forward();
                                Future.delayed(Duration(milliseconds: 1), () {
                                  setState(() {});
                                });
                              } else if (areMonthsSame(
                                  showDate, DateTime.now())) {
                                _monthController.reverse();
                                Future.delayed(_kExpand, () {
                                  setState(() {});
                                });
                              }
                              pageController.jumpToPage(0);
                              pageController.nextPage(
                                  duration: _kExpand, curve: Curves.easeInOut);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _controller.view,
                builder: (BuildContext context, Widget child) => Container(
                    child: ClipRect(
                  child: Align(
                    alignment: Alignment(0.5, activeRowYPosition),
                    heightFactor: _anim.value * (1 - collapsedHeightFactor) +
                        collapsedHeightFactor,
                    child: Container(
                      width: calendarWidth,
                      height: calendarWidth * 0.76,
                      child: PageView(
                        controller: pageController,
                        scrollDirection: Axis.horizontal,
                        children: calList,
                        //the pageview is not swipable as this affects the changing months
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    ),
                  ),
                )),
              )
            ],
          ),
        ),
        IconButton(
          //The splash effect is only visible when the animation has been completed
          splashRadius: _monthController.view.value == 0.0 ? 18.0 : 0.001,
          //[handleTap] only works when the animation has been completed
          onPressed: _monthController.view.value == 0.0 ? _handleTap : null,
          enableFeedback: _monthController.view.value == 0.0,
          icon: AnimatedBuilder(
            animation: _monthColor,
            builder: (BuildContext context, Widget child) =>
                RotationTransition(
              turns: _iconTurns,
              child: Icon(
                Icons.expand_more,
                size: 35*scaleFactor,
                color: _monthColor.value,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  //Format the received date into full month and year format
  String formatDate(DateTime date) => new DateFormat("MMMM yyyy").format(date);

  // Used to handle calendar expansion and icon rotation events 
  void _handleTap() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _expanded);
    });
    if (onExpansionChanged != null) onExpansionChanged(_expanded);
  }

  //Get the current week row from the list of all the rows per current month
  int getActiveRow() {
    List<List<int>> rowValueList =
        generateMonth(DateTime(displayDate.year, displayDate.month, 1));
    for (int i = 0; i < rowValueList.length; i++) {
      if (displayDate.month == DateTime.now().month &&
          rowValueList[i].contains(DateTime.now().day)) {
        activeRow = i + 1;
      }
    }
    return activeRow;
  }

  ///Generate a month given the start date of month as a list of list of integers
  /// e.g. [[30, 1, 2, 3, 4, 5, 6], [7, 8, 9, 10, 11, 12, 13],..]. Weeks start
  /// from Monday.
  List<List<int>> generateMonth(DateTime firstOfMonth) {
    List<List<int>> rowValueList = [];

    //Adding the first week
    DateTime endWeek =
        firstOfMonth.add(Duration(days: 7 - firstOfMonth.weekday));
    DateTime startWeek = endWeek.subtract(Duration(days: 6));
    List<int> first = [];
    for (DateTime j = startWeek;
        j.compareTo(endWeek) <= 0;
        j = j.add(Duration(days: 1))) {
      first.add(j.day);
    }
    rowValueList.add(first);

    //Moving the counters
    int i = endWeek.day + 1;
    endWeek = endWeek.add(Duration(days: 7));

    //Looping to add the other weeks inside the month
    while (endWeek.month == firstOfMonth.month) {
      List<int> temp = [];
      for (int j = i; j <= endWeek.day; j++) {
        temp.add(j);
      }
      rowValueList.add(temp);
      i = 1 + endWeek.day;
      endWeek = endWeek.add(Duration(days: 7));
    }

    //Adding the last week
    List<int> last = [];
    startWeek = endWeek.subtract(Duration(days: 6));
    for (DateTime j = startWeek;
        j.compareTo(endWeek) <= 0;
        j = j.add(Duration(days: 1))) {
      last.add(j.day);
    }
    rowValueList.add(last);
    return rowValueList;
  }

  // Returns a list of Rows containing the weeks of a month
  List<Widget> returnRowList(DateTime start) {
    List<Widget> rowList = <Widget>[
      Padding(
        //do not change this padding
        padding: EdgeInsets.only(bottom: 22, left: 36, right: 36,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            calendarWeekday('Lun'),
            calendarWeekday('Mar'),
            calendarWeekday('Mie'),
            calendarWeekday('Jue'),
            calendarWeekday('Vie'),
            calendarWeekday('Sab'),
            calendarWeekday('Dom'),
          ],
        ),
      ),
    ];
    List<List<int>> rowValueList = generateMonth(start);
    for (int i = 0; i < rowValueList.length; i++) {
      List<Widget> itemList = [];
      for (int j = 0; j < rowValueList[i].length; j++) {
        itemList.add(Expanded(
          child: Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: rowValueList[i][j] == DateTime.now().day &&
                          start.month == DateTime.now().month &&
                          start.year == DateTime.now().year &&
                      !((i == 0 && rowValueList[i][j] > 7) ||
                          (i >= 4 && rowValueList[i][j] < 7))
                      ? Color(0xffFFA68A)
                      : Colors.transparent),
              child: Center(
                child:GestureDetector(
                  onTap: ()async {
                    final DBProvider _db = DBProvider.db;
                    int mes = showDate.month;
                    int anio = showDate.year;
                    int dia = rowValueList[i][j];
                    
                    DateTime actual = DateTime(anio, mes,dia);

                    int dSemana = actual.weekday;
                    List<GlobalActivity> actividadesGenerales = new List<GlobalActivity>();
                    List<Actividad> actividadesDB = (await _db.getActividades()) ?? [];
                    List<Cuidado> cuidadosDB = (await _db.getCuidados()) ?? [];
                    

                    if(actividadesDB.length > 0)
                      actividadesGenerales.addAll(actividadesDB);
                    if(cuidadosDB.length > 0)
                      actividadesGenerales.addAll(cuidadosDB);

                      List<AlarmModel> actividades  = new List<AlarmModel>();
                      actividades.addAll(await _db.eventsByWeekday(dSemana));

                      actividades.forEach((element) {
                        print(element.title);
                      });
                    
                  },
                  child: Text( //Rojo si tiene actividades
                      rowValueList[i][j].toString(),
                      style: (rowValueList[i][j] == DateTime.now().day &&
                              start.month == DateTime.now().month &&
                              start.year == DateTime.now().year) &&
                              !((i == 0 && rowValueList[i][j] > 7) || (i >= 4 && rowValueList[i][j] < 7))
                          ? TextStyle(
                              fontWeight: FontWeight.bold,
                            )
                          //Grey out the previous month's and next month's values or dates
                          : TextStyle(
                              fontWeight: FontWeight.normal,
                              color: ((i == 0 && rowValueList[i][j] > 7) ||
                                      (i >= 4 && rowValueList[i][j] < 7))
                                  ? Colors.grey
                                  : Colors.black),
                      textAlign: TextAlign.center,
                    ),
                ),
                ),
              )),
        );
      }
      Widget temp = Padding(
          //this padding seems important
          padding: EdgeInsets.only(bottom: 12, left: 36, right: 36),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: itemList,
          ));
      rowList.add(temp);
    }
    return rowList;
  }

  //Return a Text with Style according to input String, used for the days
  Widget calendarWeekday(String day) {
    return Text(
      day,
      style: TextStyle(fontSize: 11, color: Color(0xff828282)),
    );
  }

  // Utility functions to compare Dates:
  bool areDaysSame(DateTime a, DateTime b) {
    return areMonthsSame(a, b) && a.day == b.day;
  }

  bool areMonthsSame(DateTime a, DateTime b) {
    return areYearsSame(a, b) && a.month == b.month;
  }

  bool areYearsSame(DateTime a, DateTime b) {
    return a.year == b.year;
  }
}




