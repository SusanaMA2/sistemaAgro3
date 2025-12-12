class ConfiguracionRiego {
  final int? id;
  final DateTime fechaRiego;
  final String horaInicio;
  final String horaFin;
  final String duracion;
  final int idParcela;
  final int idDispositivo;
  final int idValvula;

  ConfiguracionRiego({
    this.id,
    required this.fechaRiego,
    required this.horaInicio,
    required this.horaFin,
    required this.duracion,
    required this.idParcela,
    required this.idDispositivo,
    required this.idValvula,
  });

  factory ConfiguracionRiego.fromJson(Map<String, dynamic> json) {
    return ConfiguracionRiego(
      id: json['id'],
      fechaRiego: DateTime.parse(json['fechaRiego']),
      horaInicio: json['horaInicio'],
      horaFin: json['horaFin'],
      duracion: json['duracion'],
      idParcela: json['idParcela'],
      idDispositivo: json['idDispositivo'],
      idValvula: json['idValvula'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fechaRiego': fechaRiego.toIso8601String(),
      'horaInicio': horaInicio,
      'horaFin': horaFin,
      'duracion': duracion,
      'idParcela': idParcela,
      'idDispositivo': idDispositivo,
      'idValvula': idValvula,
    };
  }
}

