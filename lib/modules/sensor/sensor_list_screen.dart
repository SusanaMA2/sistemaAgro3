import 'package:flutter/material.dart';
import 'sensor_controller.dart';
import 'sensor_form_screen.dart';
import '../../models/sensor.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/constants.dart';
import '../../core/widgets/confirm_dialog.dart';

class SensorListScreen extends StatefulWidget {
  const SensorListScreen({super.key});

  @override
  State<SensorListScreen> createState() => _SensorListScreenState();
}

class _SensorListScreenState extends State<SensorListScreen> {
  final controller = SensorController();
  List<Sensor> sensores = [];

  @override
  void initState() {
    super.initState();
    cargarSensores();
  }

  Future<void> cargarSensores() async {
    final data = await controller.listarSensores();
    setState(() => sensores = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sensores')),
      body: RefreshIndicator(
        onRefresh: cargarSensores,
        child: sensores.isEmpty
            ? const EmptyState(message: 'No hay sensores registrados')
            : ListView.builder(
          itemCount: sensores.length,
          itemBuilder: (context, index) {
            final s = sensores[index];
            return Card(
              color: AppColors.verdeClaro,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                title: Text(s.titulo),
                subtitle: Text('Tipo: ${s.tipo} | ID real: ${s.idDispositivo}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirmar = await showConfirmDialog(
                        context,
                        'Eliminar sensor',
                        '¿Desea eliminar el sensor "${s.titulo}"?');
                    if (confirmar) {
                      await controller.eliminarSensor(s.id!);
                      cargarSensores();
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SensorFormScreen()),
          );
          cargarSensores();
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar Sensor'),
        backgroundColor: AppColors.cafeClaro,
        foregroundColor: AppColors.textoOscuro,
      ),
    );
  }
}
