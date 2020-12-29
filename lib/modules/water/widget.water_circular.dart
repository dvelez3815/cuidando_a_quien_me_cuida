import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaterCircular extends StatelessWidget {

  final double progress;

  const WaterCircular({Key key, this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      height: size.width*0.8,
      width: size.width*0.8,
      margin: EdgeInsets.all(20.0),
      child: CustomPaint(
        painter: _CircularCounter(progress),
        child: Icon(Icons.bubble_chart, size: size.width*0.5, color: Colors.blue),
      )
    );
  }
}

class _CircularCounter extends CustomPainter {

  final double angleFilled;

  _CircularCounter(this.angleFilled);

  @override
  void paint(Canvas canvas, Size size) {
    
    final painter = new Paint();

    painter.color = Colors.grey[350];
    painter.style = PaintingStyle.fill;
    painter.strokeWidth = 1.0;

    canvas.drawCircle(Offset(size.width/2, size.width/2), size.width*0.5, painter);
    
    painter.color = Colors.blue;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width/2, size.width/2), 
        radius: size.width*0.5
      ),
      -math.pi/2, 2*angleFilled*math.pi, true, painter
    );
    
    painter.color = Colors.white;    
    canvas.drawCircle(
      Offset(size.width/2, size.width/2), 
      size.width*0.5-size.width*0.1, painter
    );

  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}