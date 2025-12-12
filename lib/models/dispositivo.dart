class Dispositivo {
  final int? id;
  final String nombre;
  final String simImei;
  final String token;
  final int? idParcela;

  Dispositivo({
    this.id,
    required this.nombre,
    required this.simImei,
    required this.token,
    this.idParcela,
  });

  factory Dispositivo.fromJson(Map<String, dynamic> json) {
    return Dispositivo(
      id: json['id'],
      nombre: json['nombre'],
      simImei: json['sim_imei'],
      token: json['token'],
      idParcela: json['idParcela'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'sim_imei': simImei,
      'token': token,
      'idParcela': idParcela, // Puede ser null al registrar
    };
  }
}
