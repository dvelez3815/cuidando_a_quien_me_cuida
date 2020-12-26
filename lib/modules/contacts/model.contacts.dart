// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:utm_vinculacion/modules/global/helpers.dart';

Contact welcomeFromJson(String str) => Contact.fromJson(json.decode(str));

String welcomeToJson(Contact data) => json.encode(data.toJson());

class Contact {
    Contact({
        this.id,
        this.title,
        this.description,
        this.phone,
    }){
      assert(this.phone != null);
      this.id = this.id ?? generateID();
    }

    int id;
    String title;
    String description;
    String phone;

    factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        title: json["name"],
        description: json["description"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": title,
        "description": description,
        "phone": phone,
    };
}
