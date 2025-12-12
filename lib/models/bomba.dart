class Bomba {
  final int? id;
  final String titulo;
  final String modelo;
  final DateTime fechaCreacion;
  final bool estado;
  final int? idUsuario;
  final int? idDispositivo;

  Bomba({
    this.id,
    required this.titulo,
    required this.modelo,
    required this.fechaCreacion,
    required this.estado,
    this.idUsuario,
    required this.idDispositivo,
  });

  factory Bomba.fromJson(Map<String, dynamic> json) {
    return Bomba(
      id: json['id'],
      titulo: json['titulo'],
      modelo: json['modelo'],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      estado: json['estado'] ?? false,
      idUsuario: json['idUsuario'],
      idDispositivo: json['idDispositivo']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'modelo': modelo,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'estado': estado,
      'idUsuario': idUsuario,
      'idDispositivo': idDispositivo
    };
  }
}
