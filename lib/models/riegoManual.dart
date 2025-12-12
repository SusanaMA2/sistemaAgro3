class RiegoManual {
  int? id;
  DateTime fechaRiego;   // cuando inicia según estado = true
  String horaInicio;     // formato 12h (ej: "08:30 PM")
  String horaFin;        // cuando estado cambia a false
  bool estado;           // true = activo, false = terminado

  RiegoManual({
    this.id,
    required this.fechaRiego,
    required this.horaInicio,
    required this.horaFin,
    required this.estado,
  });

  factory RiegoManual.fromMap(Map<String, dynamic> map) {
    return RiegoManual(
      id: map['id'],
      fechaRiego: DateTime.parse(map['fecha_riego']),
      horaInicio: map['hora_inicio'],
      horaFin: map['hora_fin'],
      estado: map['estado'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha_riego': fechaRiego.toIso8601String(),
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'estado': estado,
    };
  }
}
