
class Valvula {
  final int? id;
  final String nombre;
  final String ubicacion;
  final DateTime? fechaCreacion;
  final bool estado;
  final int idDispositivo;

  Valvula({
    this.id,
    required this.nombre,
    required this.ubicacion,
    this.fechaCreacion,
    required this.estado,
    required this.idDispositivo,
  });

  factory Valvula.fromJson(Map<String, dynamic> json) => Valvula(
    id: json['id'],
    nombre: json['nombre'],
    ubicacion: json['ubicacion'] ?? '',
    fechaCreacion: json['fechaCreacion'] != null
        ? DateTime.parse(json['fechaCreacion'])
        : null,
    estado: json['estado'],
    idDispositivo: json['idDispositivo'],
  );

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'ubicacion': ubicacion,
    'fechaCreacion': fechaCreacion?.toIso8601String(),
    'estado': estado,
    'idDispositivo': idDispositivo,
  };
}
