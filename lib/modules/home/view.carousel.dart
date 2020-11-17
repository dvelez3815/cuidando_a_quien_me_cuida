import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/home/view.carousel_content.dart';

class CarouselWidget extends StatefulWidget {

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    
    final List cardList = carouselContent(context);

    return Container(
      child: _getSlider(cardList),
    );
  }

  Widget _getSlider(List<Widget> cardList) {
    return Column(
      children: [
        CarouselSlider(                  
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: Duration(seconds: 10),
          aspectRatio: 2.0,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: cardList.map((card) {
            return Builder(builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(right: 10.0),
                child: Card(
                  color: Colors.green[300],
                  child: card,
                ),
              );
            });
          }).toList(),
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(cardList, (index, url) {
            return Container(
              width: 10.0,
              height: 10.0,
              margin:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Colors.blueAccent
                    : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
}