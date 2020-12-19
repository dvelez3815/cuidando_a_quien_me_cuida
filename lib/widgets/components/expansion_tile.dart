import 'package:flutter/material.dart';

Widget getExpansionTile({String title, List<Map<String, dynamic>> items, TextEditingController controller, Function onPressed, Function setState}) {

  return ExpansionTile(
    title: Text(title),
    children: _getExpansionItems(items, setState),
    leading: IconButton(
      icon: Icon(Icons.add),
      onPressed: onPressed
    ),
  );
}

List<Widget> _getExpansionItems(List<Map<String, dynamic>> items, Function setState) {

    if(items.isEmpty){
      return [ListTile(
        leading: Icon(Icons.sentiment_dissatisfied),
        title: Text("Sin materiales")
      )];
    }

    return items.map((complement)=>ListTile(
      title: Text((complement["title"] ?? "") == ""? "Sin nombre": complement["title"]),
      leading: Icon(Icons.emoji_objects),
      trailing: IconButton(
        icon: Icon(Icons.delete_forever),
        onPressed: ()=>setState((){
          items.removeWhere((element) => element["title"] == complement["title"]);
        }),
      ),
    )).toList();

  }
