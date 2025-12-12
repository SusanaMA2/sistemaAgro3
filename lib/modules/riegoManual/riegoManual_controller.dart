import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/riegoManual.dart';

class RiegoManualController {
  final supabase = Supabase.instance.client;

  /// LISTAR todos los registros (devuelve lista vacía si no hay datos)
  Future<List<RiegoManual>> listar() async {
    try {
      final data = await supabase
          .from('configuracionManual')
          .select()
          .order('id', ascending: false);

      if (data == null) return [];
      return (data as List)
          .map<RiegoManual>((e) => RiegoManual.fromMap(e))
          .toList();
    } catch (e) {
      throw Exception("Error al listar registros: $e");
    }
  }

  /// REGISTRAR → retorna el registro insertado con su ID
  Future<RiegoManual> registrar(RiegoManual r) async {
    try {
      // Convertimos a map sin enviar id si es null
      final map = r.toMap();
      map.remove('id');

      final data = await supabase
          .from('configuracionManual')
          .insert(map)
          .select()
          .single(); // Devuelve el registro insertado con ID

      return RiegoManual.fromMap(data);
    } catch (e) {
      throw Exception("Error al registrar: $e");
    }
  }

  /// ACTUALIZAR → valida que el id no sea null
  Future<void> actualizar(int? id, RiegoManual r) async {
    if (id == null) {
      throw Exception("No se puede actualizar: ID es null");
    }

    try {
      final map = r.toMap();
      map.remove('id'); // Nunca actualizamos el ID

      await supabase
          .from('configuracionManual')
          .update(map)
          .eq('id', id);
    } catch (e) {
      throw Exception("Error al actualizar: $e");
    }
  }

  /// OBTENER ÚLTIMO → devuelve null si no hay registros
  Future<RiegoManual?> obtenerUltimo() async {
    try {
      final data = await supabase
          .from('configuracionManual')
          .select()
          .order('id', ascending: false)
          .limit(1);

      if (data == null || data.isEmpty) return null;

      return RiegoManual.fromMap(data.first);
    } catch (e) {
      throw Exception("Error al obtener último registro: $e");
    }
  }
}
