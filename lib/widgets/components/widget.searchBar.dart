import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {

  final _controller = new TextEditingController();
  final List<String> elements;

  SearchBar({@required this.elements, Function(List<String>) sink, Function callback}){
    
    _controller.addListener(() {
      final replace = elements.where((ptrc)=>ptrc.toUpperCase().contains(_controller.text.toUpperCase())).toList();
        
      sink(_controller.text.isEmpty? elements:replace);
    });

    // It's a callback to do whatever you want
    if(callback != null) callback();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: TextFormField(
        controller: _controller,
        autocorrect: true,
        decoration: InputDecoration(
          hintText: "Escriba algo",
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            color: Theme.of(context).accentColor,
            onPressed: (){},
          )
        ),
      ),
    );
  }
}