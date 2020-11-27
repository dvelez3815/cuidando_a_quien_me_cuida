// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

MusicModel productFromJson(String str) => MusicModel.fromJson(json.decode(str));

String productToJson(MusicModel data) => json.encode(data.toJson());

class MusicModel {
    MusicModel({
        this.id,
        this.title,
        this.description,
        this.image,
    });

    String id;
    String title;
    String description;
    String image;

    factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
    };
}
