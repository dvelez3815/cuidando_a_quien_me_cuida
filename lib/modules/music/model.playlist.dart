
class PlayList {

  final String _id;
  final String _image;
  final String _title;
  final String _description; // How many music are there?

  PlayList(this._id, this._title, this._description, this._image);

  String get image => this._image;
  String get title => this._title;
  String get description => this._description;
  String get id => this._id;

}