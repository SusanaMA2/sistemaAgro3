import 'package:flutter/material.dart';
import 'valvula_controller.dart';
import 'valvula_form_screen.dart';
import '../../models/valvula.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/constants.dart';
import '../../core/widgets/confirm_dialog.dart';

class ValvulaListScreen extends StatefulWidget {
  const ValvulaListScreen({super.key});

  @override
  State<ValvulaListScreen> createState() => _ValvulaListScreenState();
}

class _ValvulaListScreenState extends State<ValvulaListScreen> {
  final controller = ValvulaController();
  List<Valvula> valvulas = [];

  @override
  void initState() {
    super.initState();
    cargarValvulas();
  }

  Future<void> cargarValvulas() async {
    final data = await controller.listarValvulas();
    setState(() => valvulas = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Válvulas')),
      body: RefreshIndicator(
        onRefresh: cargarValvulas,
        child: valvulas.isEmpty
            ? const EmptyState(message: 'No hay válvulas registradas')
            : ListView.builder(
          itemCount: valvulas.length,
          itemBuilder: (context, index) {
            final v = valvulas[index];
            return Card(
              color: AppColors.verdeClaro,
              margin:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                title: Text(v.nombre),
                subtitle: Text(
                    'Ubicación: ${v.ubicacion} | ID Dispositivo: ${v.idDispositivo} | Estado: ${v.estado ? "Abierta" : "Cerrada"}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirmar = await showConfirmDialog(
                        context,
                        'Eliminar válvula',
                        '¿Desea eliminar la válvula "${v.nombre}"?');
                    if (confirmar) {
                      await controller.eliminarValvula(v.id!);
                      cargarValvulas();
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
            MaterialPageRoute(builder: (_) => const ValvulaFormScreen()),
          );
          cargarValvulas();
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar Válvula'),
        backgroundColor: AppColors.cafeClaro,
        foregroundColor: AppColors.textoOscuro,
      ),
    );
  }
}
