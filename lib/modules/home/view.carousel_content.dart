import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/home/text.carousel.dart';

List<Widget> carouselContent (BuildContext context) {
  return carouselText().map((e){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(width: MediaQuery.of(context).size.width*0.4,child: Text(e, textAlign: TextAlign.justify,)),
          Container(
              child: Icon(
            Icons.wb_sunny,
            size: 50,
            color: Colors.black,
          ))
        ],
      ),
    );
  }).toList();
}