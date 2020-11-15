import 'package:flutter/material.dart';
import 'package:utm_vinculacion/texto_app/const_textos.dart';

class Item1 extends StatelessWidget {
  const Item1({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width*0.4,
            child: Text(
              PUBLICIDAD1,
              textAlign: TextAlign.justify,              
            )
          ),
          Container(
              child: Icon(
            Icons.wb_sunny,
            size: 50,
            color: Colors.black,
          ))
        ],
      ),
    );
  }
}

class Item2 extends StatelessWidget {
  const Item2({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(width: MediaQuery.of(context).size.width*0.4,child: Text(PUBLICIDAD2,textAlign: TextAlign.justify,)),
          Container(
              child: Icon(
            Icons.wb_sunny,
            size: 50,
            color: Colors.black,
          ))
        ],
      ),
    );
  }
}

class Item3 extends StatelessWidget {
  const Item3({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(width: MediaQuery.of(context).size.width*0.4,child: Text(PUBLICIDAD3,textAlign: TextAlign.justify,)),
          Container(
              child: Icon(
            Icons.wb_sunny,
            size: 50,
            color: Colors.black,
          ))
        ],
      ),
    );
  }
}

class Item4 extends StatelessWidget {
  const Item4({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(width: MediaQuery.of(context).size.width*0.4,child: Text(PUBLICIDAD4,textAlign: TextAlign.justify,)),
          Container(
              child: Icon(
            Icons.wb_sunny,
            size: 50,
            color: Colors.black,
          ))
        ],
      ),
    );
  }
}
