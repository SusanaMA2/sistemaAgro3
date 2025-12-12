class Sensor {
  final int? id;
  final String titulo;
  final String tipo;
  final DateTime? fechaLectura;
  final String? lecturaDatos;
  final int idDispositivo;

  Sensor({
    this.id,
    required this.titulo,
    required this.tipo,
    this.fechaLectura,
    this.lecturaDatos,
    required this.idDispositivo,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'],
      titulo: json['titulo'],
      tipo: json['tipo'],
      fechaLectura: json['fechaLectura'] != null
          ? DateTime.parse(json['fechaLectura'])
          : null,
      lecturaDatos: json['lecturaDatos'],
      idDispositivo: json['idDispositivo'],
    );
  }

  Map<String, dynamic> toJson() => {
    'titulo': titulo,
    'tipo': tipo,
    'fechaLectura': fechaLectura?.toIso8601String(),
    'lecturaDatos': lecturaDatos,
    'idDispositivo': idDispositivo,
  };
}
