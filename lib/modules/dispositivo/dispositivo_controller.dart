import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/dispositivo.dart';
import '../../services/supabase_service.dart';
import 'package:uuid/uuid.dart';

class DispositivoController {
  final client = SupabaseService.client;


  Future<List<Dispositivo>> listarDispositivos() async {
    final response = await client.from('dispositivo').select();
    return (response as List).map((e) => Dispositivo.fromJson(e)).toList();
  }


  Future<void> registrarDispositivo(Dispositivo dispositivo) async {
    final uuid = Uuid();
    final nuevoDispositivo = Dispositivo(
      nombre: dispositivo.nombre,
      simImei: dispositivo.simImei,
      token: uuid.v4(),
      idParcela: null,
    );
    await client.from('dispositivo').insert(nuevoDispositivo.toJson());
  }

  Future<void> editarDispositivo(int id, Dispositivo dispositivo) async {
    await client.from('dispositivo')
        .update({
      'nombre': dispositivo.nombre,
      'sim_imei': dispositivo.simImei,
    })
        .eq('id', id);
  }


  Future<void> eliminarDispositivo(int id) async {
    await client.from('dispositivo').delete().eq('id', id);
  }
}
