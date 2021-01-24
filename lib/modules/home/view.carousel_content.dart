import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/home/text.carousel.dart';

List<Widget> carouselContent (BuildContext context) {
  var media = MediaQuery.of(context).size;
  return carouselText().map((text){
    return Card(
      color: Theme.of(context).backgroundColor, //Colors.orange[400],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Transform.translate(
                  offset: Offset(-media.width*0.15, 0),
                  child: Image.asset(
                    "assets/icons/Persona.png",
                    width: media.width*0.5,
                    height: media.width*0.5,
                  ),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }).toList();
}