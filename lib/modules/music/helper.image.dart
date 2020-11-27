import 'package:flutter/material.dart';

Widget getImage(String image) {
  return FadeInImage(
    placeholder: AssetImage("assets/loader.gif"), 
    image: NetworkImage(image)
  );
}