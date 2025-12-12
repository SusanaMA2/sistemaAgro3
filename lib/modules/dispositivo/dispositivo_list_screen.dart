import 'package:flutter/material.dart';
import '../../models/dispositivo.dart';
import 'dispositivo_controller.dart';
import 'dispositivo_form_screen.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/constants.dart';

class DispositivoListScreen extends StatefulWidget {
  const DispositivoListScreen({super.key});

  @override
  State<DispositivoListScreen> createState() => _DispositivoListScreenState();
}

class _DispositivoListScreenState extends State<DispositivoListScreen> {
  final controller = DispositivoController();
  List<Dispositivo> dispositivos = [];

  @override
  void initState() {
    super.initState();
    cargarDispositivos();
  }

  Future<void> cargarDispositivos() async {
    final data = await controller.listarDispositivos();
    setState(() => dispositivos = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dispositivos')),
      body: RefreshIndicator(
        onRefresh: cargarDispositivos,
        child: dispositivos.isEmpty
            ? const EmptyState(message: 'No hay dispositivos registrados')
            : ListView.builder(
          itemCount: dispositivos.length,
          itemBuilder: (context, index) {
            final d = dispositivos[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              color: AppColors.verdeClaro,
              child: ListTile(
                title: Text(d.nombre),
                subtitle: Text('SIM/IMEI: ${d.simImei}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DispositivoFormScreen(dispositivo: d),
                          ),
                        );
                        cargarDispositivos();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirmar = await showConfirmDialog(
                            context,
                            'Eliminar dispositivo',
                            '¿Deseas eliminar el dispositivo "${d.nombre}"?');
                        if (confirmar) {
                          await controller.eliminarDispositivo(d.id!);
                          cargarDispositivos();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.cafeClaro,
        foregroundColor: AppColors.textoOscuro,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DispositivoFormScreen()),
          );
          cargarDispositivos();
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar Dispositivo'),
      ),
    );
  }
}
