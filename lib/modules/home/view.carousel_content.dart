import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/home/text.carousel.dart';

List<Widget> carouselContent (BuildContext context) {
  return carouselText().map((text){
    return Card(
      color: Colors.orange[400],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width*0.4,
              child: Text(
                text, 
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
            Container(
              child: Icon(
                Icons.wb_sunny,
                size: 50,
                color: Colors.black,
              )
            )
          ],
        ),
      ),
    );
  }).toList();
}