import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/dispositivo_temp.dart';
import '../../services/supabase_service.dart';

class DispositivoTempController {
  final client = SupabaseService.client;


  Future<List<DispositivoTemp>> listarDispositivosTemp() async {
    final response = await client.from('dispositivosTemp').select();
    return (response as List).map((e) => DispositivoTemp.fromJson(e)).toList();
  }
}
