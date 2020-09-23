class Cuidado {

  int idCuidado;
  String nombre;
  String descripcion;

  Cuidado({this.idCuidado, this.nombre, this.descripcion});

  Cuidado.fromJson(Map<String, dynamic> json){

    idCuidado = json['id'];
    nombre = json['nombre'];
    descripcion = json['descripcion'];

  }

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      "idCuidado": idCuidado,
      "nombre": nombre,
      "descripcion": descripcion,
    };
  }

}