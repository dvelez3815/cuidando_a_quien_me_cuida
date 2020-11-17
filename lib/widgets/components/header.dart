import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/global/settings.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';
import '../widget.circular_banner.dart';

final setting = new AppSettings();

Widget getHeader(BuildContext context, Size size, String title){
  return Container(
      width: size.width,
      height: size.height*0.3,
      child: CustomPaint(
        painter: CircularBannerWidget(),
        child: Column(
          children: [
            SafeArea(
              child: ListTile(
                title: Text(setting.settings["app_name"], style: TextStyle(color: Colors.white)),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white), 
                  onPressed: ()=>Navigator.of(context).pop()
                ),
                trailing: tresPuntos(context),
              ),
            ),
            SizedBox(height: size.height*0.05),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 25.0, 
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            )
          ],
        ),
      ),
    );
}