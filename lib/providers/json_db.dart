
import 'dart:convert';

import 'package:flutter/services.dart';

class JsonToDBProvider {


  Future<List<Map<String, dynamic>>> cargaDatosDelJson(String rutaJson) async {    

    final _json = await rootBundle.loadString(rutaJson);
    final decode = json.decode(_json);
    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(decode['data']);
    
    return data;

  }

}