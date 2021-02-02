import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/activity/model.activity.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/widget.daylist.dart';

class TunnedListTile extends StatefulWidget {

  final Actividad activity;
  final Widget trailing;
  final IconData leadingIcon;
  final Function leadingEvent;
  final Widget title;
  final Widget subtitle;

  const TunnedListTile({
    Key key, 
    @required this.activity, 
    @required this.trailing, 
    this.leadingEvent, 
    this.leadingIcon, this.title, this.subtitle
  }) : super(key: key);

  @override
  _TunnedListTileState createState() => _TunnedListTileState();
}

class _TunnedListTileState extends State<TunnedListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(widget.leadingIcon ?? Icons.settings),
        padding: EdgeInsets.zero,
        onPressed: widget.leadingEvent,
      ),
      title: widget.title ?? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( widget.activity.nombre, style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.alarm, color: Theme.of(context).canvasColor, size: 13.0,),
                SizedBox(width: 5.0,),
                Text(
                  widget.activity.time.format(context), 
                  style: TextStyle(color: Theme.of(context).canvasColor, fontSize: 13.0)
                )
              ],
            )
          )
        ],
      ),
      subtitle: widget.subtitle ?? DayList(activity: widget.activity),
      trailing: widget.trailing,
      onTap: (widget.activity == null)?null:()=>Navigator.pushNamed(context, ACTIVITY_DETAIL, arguments: widget.activity),
    );
  }

}