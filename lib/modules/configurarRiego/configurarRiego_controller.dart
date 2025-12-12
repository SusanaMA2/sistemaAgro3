import '../../models/configurarRiego.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase_service.dart';

class ConfigurarRiegoController {
  final client = SupabaseService.client;

  // ----------------------------
  // LISTAR
  // ----------------------------
  Future<List<ConfiguracionRiego>> listar() async {
    final data = await client.from('configuracionRiego').select();
    return (data as List).map((e) => ConfiguracionRiego.fromJson(e)).toList();
  }

  // ----------------------------
  // Registrar riego
  // ----------------------------
  Future<void> registrar(ConfiguracionRiego r) async {
    await client.from('configuracionRiego').insert(r.toJson());
  }

  // ----------------------------
  // Editar riego
  // ----------------------------
  Future<void> editar(int id, ConfiguracionRiego r) async {
    await client.from('configuracionRiego').update(r.toJson()).eq('id', id);
  }

  // ----------------------------
  // Eliminar riego
  // ----------------------------
  Future<void> eliminar(int id) async {
    await client.from('configuracionRiego').delete().eq('id', id);
  }

  // ----------------------------
  // Cargar dispositivos
  // ----------------------------
  Future<List<Map<String, dynamic>>> cargarDispositivos() async {
    final data = await client.from('dispositivo').select('id, nombre');
    return List<Map<String, dynamic>>.from(data);
  }

  // ----------------------------
  // Cargar parcelas por dispositivo
  // ----------------------------
  Future<List<Map<String, dynamic>>> cargarParcelasPorDispositivo(int idDispositivo) async {
    final res = await client
        .from('dispositivo')
        .select('idParcela, parcela: idParcela (id, nombre)')
        .eq('id', idDispositivo);

    if (res != null && res is List && res.isNotEmpty) {
      final parcela = res[0]['parcela'];
      if (parcela != null) {
        return [parcela];
      }
    }

    return [];
  }


  // ----------------------------
  // Cargar válvulas por dispositivo
  // ----------------------------
  Future<List<Map<String, dynamic>>> cargarValvulasPorDispositivo(int idDispositivo) async {
    final res = await client
        .from('valvula')
        .select('id, nombre')
        .eq('idDispositivo', idDispositivo);
    if (res != null) return List<Map<String, dynamic>>.from(res);
    return [];
  }
}
