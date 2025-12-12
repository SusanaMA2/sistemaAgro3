import 'package:flutter/material.dart';
import '../../models/bomba.dart';
import 'bomba_controller.dart';
import 'bomba_form_screen.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/constants.dart';

class BombaListScreen extends StatefulWidget {
  const BombaListScreen({super.key});

  @override
  State<BombaListScreen> createState() => _BombaListScreenState();
}

class _BombaListScreenState extends State<BombaListScreen> {
  final controller = BombaController();
  List<Bomba> bombas = [];

  @override
  void initState() {
    super.initState();
    cargarBombas();
  }

  Future<void> cargarBombas() async {
    final data = await controller.listarBombas();
    setState(() => bombas = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bombas')),
      body: RefreshIndicator(
        onRefresh: cargarBombas,
        child: bombas.isEmpty
            ? const EmptyState(message: 'No hay bombas registradas')
            : ListView.builder(
          itemCount: bombas.length,
          itemBuilder: (context, index) {
            final b = bombas[index];
            return Card(
              margin:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: AppColors.verdeClaro,
              child: ListTile(
                title: Text(b.titulo),
                subtitle: Text('Modelo: ${b.modelo}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      b.estado ? Icons.power : Icons.power_off,
                      color: b.estado ? Colors.green : Colors.grey,
                      size: 28,
                    ),


                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BombaFormScreen(bomba: b),
                          ),
                        );
                        cargarBombas();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirmar = await showConfirmDialog(
                          context,
                          'Eliminar bomba',
                          '¿Deseas eliminar la bomba "${b.titulo}"?',
                        );
                        if (confirmar) {
                          await controller.eliminarBomba(b.id!);
                          cargarBombas();
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
            MaterialPageRoute(builder: (_) => const BombaFormScreen()),
          );
          cargarBombas();
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar Bomba'),
      ),
    );
  }
}