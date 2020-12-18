import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:utm_vinculacion/modules/alarms/model.alarm.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';

class CalendarScreen extends StatefulWidget {
  final double pWidth = 392.7; 

  /// Animation duration
  final Duration _kExpand = Duration(milliseconds: 300);

  final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeInOut);
  final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with TickerProviderStateMixin{

  ValueChanged<bool> onExpansionChanged;
  AnimationController _monthController; // Animation controller that handles the expand_more icon fading in/out event 
  Animatable<Color> _arrowColorTween;   // Color tween for -> and <- icons
  Animatable<Color> _monthColorTween;   // Color tween for expand_less icon
  AnimationController _controller;      // Animation controller that handles the calendar expansion event and the expand_more icon rotation event
  PageController pageController;        // PageController to handle the changing month views on click
  double collapsedHeightFactor;         // The height of an individual week row
  Animation<double> _iconTurns;         // Animation for the rotating expand_more/less icon
  Animation<Color> _arrowColor;         // Color animation for the -> and <- arrows that change the month view
  Animation<Color> _monthColor;         // Color animation for the ^ arrow that handles expansion of view
  double activeRowYPosition;            // The y coordinate of the active week row
  Animation<double> _anim;              // The animation for the changing height with the y coordinates in calendar expansion
  List<Widget> calList;                 // The list that stores the week rows of the month
  DateTime displayDate;                 // The date var that handles the changing months on click
  DateTime showDate;                    // The date that is shown as Month , Year between the arrows
  bool _expanded;                       // Boolean to handle calendar expansion
  int activeRow;                        // The row that contains the current week withing the list of rows generated

  _CalendarScreenState(){
    displayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _monthColorTween = ColorTween(begin: Color(0xffEC520B), end: Color(0x00EC520B));
    _arrowColorTween = ColorTween(begin: Color(0x00FFA68A), end: Color(0xffFFA68A));
    pageController = PageController(initialPage: 0);
  }

  @override
  void initState() { 
    _expanded = false;
    showDate = displayDate;

    // [returnRowList] called and stored in [rowListReturned] to make use of in the next occurrences
    List<Widget> rowListReturned = returnRowList(DateTime(displayDate.year, displayDate.month, 1));
    
    //Determine the height of one week row
    collapsedHeightFactor = 1 / rowListReturned.length;

    //Determine the y coordinate of the current week row with this formula
    activeRowYPosition = ((2 / (rowListReturned.length - 1)) * getActiveRow()) - 1;

    //Initialize animation controllers
    _controller = AnimationController(duration: widget._kExpand, vsync: this);
    _monthController = AnimationController(duration: widget._kExpand, vsync: this);
    _anim = _controller.drive(widget._easeInTween);
    _arrowColor = _controller.drive(_arrowColorTween.chain(widget._easeInTween));
    _iconTurns = _controller.drive(widget._halfTween.chain(widget._easeInTween));
    _monthColor = _monthController.drive(_monthColorTween.chain(widget._easeInTween));

    //initial value = false
    _expanded = PageStorage.of(context)?.readState(context) ?? false;
    if (_expanded) _controller.value = 1.0;

    //calList contains the list of week Rows of the displayed month
    calList = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: rowListReturned
      )
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double scaleFactor = MediaQuery.of(context).size.width / widget.pWidth;
    double calendarWidth = MediaQuery.of(context).size.width * 0.85;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          getHeader(context, size, "CALENDARIO"),
          SizedBox(height: 15.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  // height: 50,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 13*scaleFactor, bottom: 8*scaleFactor, 
                      left: 16*scaleFactor, right: 16*scaleFactor
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         _getExpandedButton(),
                        _getFormattedDate(scaleFactor), // Displayed Month, Displayed Year                      
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                            enableFeedback: _expanded,
                            splashRadius: _expanded ? 15.0 : 0.001,
                            icon: _leftRightArrow(),
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
                                  Future.delayed(widget._kExpand, () {
                                    setState(() {});
                                  });
                                }
                                pageController.jumpToPage(0);
                                pageController.nextPage(
                                    duration: widget._kExpand, curve: Curves.easeInOut);
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
      ),
    );
  }

  AnimatedBuilder _leftRightArrow() {
    return AnimatedBuilder(
      animation: _arrowColor,
      builder: (BuildContext context, Widget child) =>
          SvgPicture.asset(
        'assets/imagenes/derecha.svg',
        color: _arrowColor.value,
      ),
    );
  }

  Widget _getFormattedDate(double scaleFactor) {
    return Text(
      formatDate(showDate),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
      textScaleFactor: scaleFactor,
    );
  }

  IconButton _getExpandedButton() {
    return IconButton(
      enableFeedback: _expanded,
      splashRadius: _expanded ? 15.0 : 0.001,
      icon: _getLeftAnimation(),
      onPressed: () {
        if (_expanded) {
          DateTime curr = showDate;

          setState(() {
            //set calList to previous month to showDate and showDate
            calList = _getMonthCallList();
            //Decrement the showDate by 1 month
            showDate = DateTime(showDate.year, showDate.month - 1, 1);
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
            Future.delayed(widget._kExpand, () {
              setState(() {});
            });
          }
          pageController.jumpToPage(1);
          pageController.previousPage(
            duration: widget._kExpand, curve: Curves.easeInOut
          );
        }
      },
    );
  }

  List<Widget> _getMonthCallList() {
    return [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: returnRowList(
                DateTime(
                  showDate.year,
                  showDate.month - 1,
                  1
                )
              )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: returnRowList(
                DateTime(
                  showDate.year, showDate.month, 1
                )
              )
            ),
          ];
  }

  AnimatedBuilder _getLeftAnimation() {
    return AnimatedBuilder(
      animation: _arrowColor,
      builder: (BuildContext context, Widget child) =>
        SvgPicture.asset(
          'assets/imagenes/izquierda.svg',
          color: _arrowColor.value,
        ),
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
                    // List<Actividad> actividadesDB = (await _db.getActivities()) ?? [];
                    
                    List<AlarmModel> activities = await _db.eventsByWeekday(dSemana) ?? [];

                    activities.forEach((element) {
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