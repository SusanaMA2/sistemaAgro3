import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/sensor.dart';
import '../../models/dispositivo_temp.dart';
import '../../services/supabase_service.dart';

class SensorController {
  final client = SupabaseService.client;

  // Obtener dispositivosTemp que contengan "sensor"
  Future<List<DispositivoTemp>> listarDispositivosSensor() async {
    final response = await client
        .from('dispositivosTemp')
        .select()
        .ilike('nombre', '%sensor%');
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

  // Registrar sensor y eliminar temporal
  Future<void> registrarSensor(Sensor sensor, int idTemp) async {
    await client.from('sensor').insert(sensor.toJson());
    await client.from('dispositivosTemp').delete().eq('id', idTemp);
  }


  Future<List<Sensor>> listarSensores() async {
    final response = await client.from('sensor').select();
    return (response as List).map((e) => Sensor.fromJson(e)).toList();
  }


  Future<void> eliminarSensor(int idSensor) async {
    await client.from('sensor').delete().eq('id', idSensor);
  }
}
