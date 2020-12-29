import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/global/settings.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';
import '../widget.circular_banner.dart';

final setting = new AppSettings();

Widget getHeader(BuildContext context, Size size, String title, {bool transparent}){

  final color = (transparent ?? false)? Theme.of(context).canvasColor:Theme.of(context).accentColor; // brightness == Brightness.dark? Colors.white:Colors.indigo[900];
  final textColor = (transparent ?? false)?Theme.of(context).accentColor:Theme.of(context).brightness == Brightness.dark? Colors.black:Colors.white;

  return Container(
      width: size.width,
      height: size.height*0.3,
      child: CustomPaint(
        painter: CircularBannerWidget(color),
        child: Column(
          children: [
            SafeArea(
              child: ListTile(
                title: Text(setting.settings["app_name"], style: TextStyle(color: textColor)),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: textColor), 
                  onPressed: ()=>Navigator.of(context).pop()
                ),
                trailing: tresPuntos(context, customColor: textColor),
              ),
            ),
            SizedBox(height: size.height*0.05),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 25.0, 
                fontWeight: FontWeight.bold,
                color: textColor
              ),
            )
          ],
        ),
      ),
    );
}