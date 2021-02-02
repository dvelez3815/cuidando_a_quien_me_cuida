import 'package:flutter/material.dart';

class TunnedExpansion extends StatelessWidget {

  final ExpansionTile expansionTile;

  const TunnedExpansion({Key key, this.expansionTile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: this.expansionTile,
      ),
    );
  }
}