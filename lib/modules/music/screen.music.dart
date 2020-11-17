import 'package:flutter/material.dart';

import 'package:utm_vinculacion/widgets/components/header.dart' as component;

class MusicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          component.getHeader(context, size, "MÚSICA")
        ],
      )
    );
  }
}