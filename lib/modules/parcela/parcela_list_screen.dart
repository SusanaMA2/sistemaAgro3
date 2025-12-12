import 'package:flutter/material.dart';
import '../../models/parcela.dart';
import 'parcela_controller.dart';
import 'parcela_form_screen.dart';
import '../../core/widgets/parcela_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/constants.dart';

class ParcelaListScreen extends StatefulWidget {
  const ParcelaListScreen({super.key});

  @override
  State<ParcelaListScreen> createState() => _ParcelaListScreenState();
}

class _ParcelaListScreenState extends State<ParcelaListScreen> {
  final controller = ParcelaController();
  List<Parcela> parcelas = [];

  @override
  void initState() {
    super.initState();
    cargarParcelas();
  }

  Future<void> cargarParcelas() async {
    final data = await controller.listarParcelas();
    setState(() => parcelas = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Parcelas')),
      body: RefreshIndicator(
        onRefresh: cargarParcelas,
        child: parcelas.isEmpty
            ? const EmptyState(message: 'No hay parcelas registradas')
            : ListView.builder(
          itemCount: parcelas.length,
          itemBuilder: (context, index) {
            final p = parcelas[index];
            return ParcelaCard(
              parcela: p,
              onDelete: () async {
                final confirmar = await showConfirmDialog(
                  context,
                  'Eliminar parcela',
                  '¿Deseas eliminar la parcela "${p.nombre}"?',
                );
                if (confirmar) {
                  await controller.eliminarParcela(p.id!);
                  cargarParcelas();
                }
              },
              onEdit: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ParcelaFormScreen(parcela: p),
                  ),
                );
                cargarParcelas();
              },
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
            MaterialPageRoute(builder: (_) => const ParcelaFormScreen()),
          );
          cargarParcelas();
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar Parcela'),
      ),
    );
  }
}
