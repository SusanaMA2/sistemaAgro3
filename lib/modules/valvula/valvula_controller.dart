import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/valvula.dart';
import '../../models/dispositivo_temp.dart';
import '../../services/supabase_service.dart';

class ValvulaController {
  final client = SupabaseService.client;

  // Listar dispositivos temporales que sean actuadores (sin importar tildes o mayúsculas)
  Future<List<DispositivoTemp>> listarDispositivosActuador() async {
    final response = await client
        .from('dispositivosTemp')
        .select()
        .ilike('nombre', '%actuador%');
    return (response as List)
        .map((e) => DispositivoTemp.fromJson(e))
        .toList();
  }

  // Validar existencia en tabla real
  Future<bool> validarDispositivoReal(int idDispositivo) async {
    final response = await client
        .from('dispositivo')
        .select()
        .eq('id', idDispositivo)
        .maybeSingle();
    return response != null;
  }

  // Registrar válvula y eliminar de la tabla temporal
  Future<void> registrarValvula(Valvula valvula, int idTemp) async {
    await client.from('valvula').insert(valvula.toJson());
    await client.from('dispositivosTemp').delete().eq('id', idTemp);
  }

  // Listar válvulas registradas
  Future<List<Valvula>> listarValvulas() async {
    final response = await client.from('valvula').select();
    return (response as List).map((e) => Valvula.fromJson(e)).toList();
  }

  // Eliminar válvula
  Future<void> eliminarValvula(int idValvula) async {
    await client.from('valvula').delete().eq('id', idValvula);
  }
}
