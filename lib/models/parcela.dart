class Parcela {
  final int? id;
  final String nombre;
  final String asociacion;
  final int? idUsuario;

  Parcela({
    this.id,
    required this.nombre,
    required this.asociacion,
    this.idUsuario,
  });

  factory Parcela.fromJson(Map<String, dynamic> json) {
    return Parcela(
      id: json['id'],
      nombre: json['nombre'],
      asociacion: json['asociacion'],
      idUsuario: json['idUsuario']?? json['idUsuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'asociacion': asociacion,
      'idUsuario': idUsuario,
    };
  }
}
