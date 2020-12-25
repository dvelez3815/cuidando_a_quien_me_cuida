extension StringExt on String{
  String capitalize() => this[0].toUpperCase() + this.substring(1).toLowerCase();
}