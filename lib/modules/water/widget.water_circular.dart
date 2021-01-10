import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaterCircular extends StatelessWidget {

  final double progress;
  final bool completed;

  const WaterCircular({Key key, this.progress, this.completed = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      height: size.width*0.8,
      width: size.width*0.8,
      margin: EdgeInsets.all(20.0),
      child: CustomPaint(
        painter: _CircularCounter(progress, context),
        child: Center(
          child: Container(
            width: size.width*0.5,
            height: size.width*0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.width*0.5),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey[300], offset: Offset(0, 2.5), spreadRadius: 3.0, blurRadius: 1.5)
              ]
            ),
            child: Icon(
              completed? Icons.check:Icons.bubble_chart,
              size: size.width*0.4, 
              color: Theme.of(context).accentColor
            ),
          )
        ),
      ),
    );
  }
}

class _CircularCounter extends CustomPainter {

  final double angleFilled;
  final BuildContext context;

  _CircularCounter(this.angleFilled, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    
    final painter = new Paint();

    painter.style = PaintingStyle.fill;
    painter.strokeWidth = 1.0;

    painter.color = Colors.grey[350];
    canvas.drawCircle(Offset(size.width/2, size.width/2), size.width*0.5, painter);
    
    painter.color = Theme.of(context).accentColor;
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
      size.width*0.4, painter
    );

  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}