class DispositivoTemp {
  final int id;
  final String nombre;
  final String tipo;
  final int idDispositivo;

  DispositivoTemp({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.idDispositivo,
  });

  factory DispositivoTemp.fromJson(Map<String, dynamic> json) {
    return DispositivoTemp(
      id: json['id'],
      nombre: json['nombre'],
      tipo: json['tipo'],
      idDispositivo: json['idDispositivo'],
    );
  }
}
