import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircularBannerWidget extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final painter = new Paint();

    painter.color = Colors.indigo[900];
    painter.style = PaintingStyle.fill;
    painter.strokeWidth = 1.0;

    final path = new Path();

    path.lineTo(0, size.height*0.9);
    path.quadraticBezierTo(size.width*0.1, size.height, size.width*0.4, size.height);
    path.lineTo(size.width*0.6, size.height);
    path.quadraticBezierTo(size.width*0.9, size.height, size.width, size.height*0.9);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, painter);
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}