
class AlarmModel {
  int _id;
  String title;
  String description;
  DateTime time;

  AlarmModel(this.time, {this.title, this.description}) {
    _id = DateTime.now().hashCode;
  }

  Map<String, dynamic> toJson()=>{
    "id":    _id,
    "title": title,
    "body":  description
  };

  AlarmModel.fromJson(Map<String, dynamic> json) {
    this._id = json["id"];
    this.title = json["title"];
    this.description = json["body"];
  }

  int get id =>_id;
}