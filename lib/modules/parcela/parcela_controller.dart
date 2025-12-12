import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/parcela.dart';
import '../../services/supabase_service.dart';

class ParcelaController {
  final client = SupabaseService.client;

  Future<List<Parcela>> listarParcelas() async {
    final response = await client.from('parcela').select();
    return (response as List).map((e) => Parcela.fromJson(e)).toList();
  }

  Future<void> agregarParcela(Parcela parcela) async {
    await client.from('parcela').insert(parcela.toJson());
  }

  Future<void> editarParcela(int id, Parcela parcela) async {
    await client.from('parcela').update(parcela.toJson()).eq('id', id);
  }

  Future<void> eliminarParcela(int id) async {
    await client.from('parcela').delete().eq('id', id);
  }
}
