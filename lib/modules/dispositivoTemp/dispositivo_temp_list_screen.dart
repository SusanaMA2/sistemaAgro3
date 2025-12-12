import 'package:flutter/material.dart';
import '../../models/dispositivo_temp.dart';
import 'dispositivo_temp_controller.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/constants.dart';

class DispositivoTempListScreen extends StatefulWidget {
  const DispositivoTempListScreen({super.key});

  @override
  State<DispositivoTempListScreen> createState() => _DispositivoTempListScreenState();
}

class _DispositivoTempListScreenState extends State<DispositivoTempListScreen> {
  final controller = DispositivoTempController();
  List<DispositivoTemp> dispositivos = [];

  @override
  void initState() {
    super.initState();
    cargarDispositivos();
  }

  Future<void> cargarDispositivos() async {
    final data = await controller.listarDispositivosTemp();
    setState(() => dispositivos = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dispositivos Temporales')),
      body: RefreshIndicator(
        onRefresh: cargarDispositivos,
        child: dispositivos.isEmpty
            ? const EmptyState(message: 'No hay dispositivos pendientes')
            : ListView.builder(
          itemCount: dispositivos.length,
          itemBuilder: (context, index) {
            final d = dispositivos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: AppColors.verdeClaro,
              child: ListTile(
                title: Text(d.nombre),
                subtitle: Text(
                    'Tipo: ${d.tipo}\nID Dispositivo: ${d.idDispositivo}'),

              ),
            );
          },
        ),
      ),
    );
  }
}
