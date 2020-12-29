import 'package:flutter/material.dart';

class WaterCircular extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      height: size.width*0.8,
      width: size.width*0.8,
      margin: EdgeInsets.all(20.0),
      child: CustomPaint(
        painter: _CircularCounter(),
        child: Icon(Icons.bubble_chart, size: size.width*0.5,),
      ),
    );
  }
}

class _CircularCounter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    
    final painter = new Paint();

    painter.color = Colors.grey[350];
    painter.style = PaintingStyle.fill;
    painter.strokeWidth = 1.0;

    canvas.drawCircle(Offset(size.width/2, size.width/2), size.width*0.5, painter);

    
    painter.color = Colors.white;    
    canvas.drawCircle(Offset(size.width/2, size.width/2), size.width*0.5-size.width*0.1, painter);
    

  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}