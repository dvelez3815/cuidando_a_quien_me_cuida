import 'package:flutter/material.dart';

class NoSirveEsteWidget extends StatelessWidget {
  const NoSirveEsteWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){Navigator.pop(context);}),
      body: Center(
        child: Text("Nueva vista"),
      ),
    );
  }
}