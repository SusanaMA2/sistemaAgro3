import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase_service.dart';
import '../../models/usuario.dart';

class UsuarioController {
  final client = SupabaseService.client;

  // Listar usuarios
  Future<List<Usuario>> listarUsuarios() async {
    final respuesta = await client.from('bomba').select().order('id');
    return (respuesta as List)
        .map((e) => Usuario.fromJson(e))
        .toList();
  }

  // Registrar bomba
  Future<void> registrarUsuario(Usuario usuario) async {
    await client.from('bomba').insert(usuario.toJson());
  }

  // Editar bomba
  Future<void> editarUsuario(int id, Usuario usuario) async {
    await client.from('bomba').update(usuario.toJson()).eq('id', id);
  }

  // Eliminar bomba
  Future<void> eliminarUsuario(int id) async {
    await client.from('bomba').delete().eq('id', id);
  }

  // Cargar roles (admin/user)
  List<String> obtenerRoles() => ["admin", "user"];
}
