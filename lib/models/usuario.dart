class Usuario {
  final int? id;
  final String nombre;
  final String apellido;
  final String email;
  final String password;
  final String celular;
  final String distrito;
  final String departamento;
  final String rol;

  Usuario({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.password,
    required this.celular,
    required this.distrito,
    required this.departamento,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json['id'],
    nombre: json['nombre'],
    apellido: json['apellido'],
    email: json['email'],
    password: json['password'],
    celular: json['celular'],
    distrito: json['distrito'],
    departamento: json['departamento'],
    rol: json['rol'],
  );

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'password': password,
      'celular': celular,
      'distrito': distrito,
      'departamento': departamento,
      'rol': rol,
    };
  }
}
