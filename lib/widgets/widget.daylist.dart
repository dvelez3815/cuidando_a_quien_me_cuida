import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/activity/model.activity.dart';

class DayList extends StatelessWidget {

  final Actividad activity;

  const DayList({Key key, @required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: activity.daysToNotify.map((day){
          return Container(
            margin: EdgeInsets.only(right: 5.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              radius: 12.0,            
              child: Text(
                day != "miercoles"? day[0].toUpperCase(): "X", 
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 10.0
                ),
              )
            ),
          );
        }).toList(),
      ),
    );
  }
}