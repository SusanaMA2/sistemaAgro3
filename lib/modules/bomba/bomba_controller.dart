
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/bomba.dart';
import '../../services/supabase_service.dart';


class BombaController {
  final client = SupabaseService.client;

  Future<List<Bomba>> listarBombas() async {
    final response = await client.from('bomba').select();
    return (response as List).map((e) => Bomba.fromJson(e)).toList();
  }

  Future<void> registrarBomba(Bomba bomba) async {
    await client.from('bomba').insert(bomba.toJson());
  }

  Future<void> editarBomba(int idBomba, Bomba bomba) async {
    await client.from('bomba').update(bomba.toJson()).eq('id', idBomba);
  }

  Future<void> eliminarBomba(int idBomba) async {
    await client.from('bomba').delete().eq('id', idBomba);
  }


  Future<List<Map<String, dynamic>>> listarDispositivos() async {
    final data = await client.from('dispositivo').select('id, nombre');
    return data as List<Map<String, dynamic>>;
  }
}
