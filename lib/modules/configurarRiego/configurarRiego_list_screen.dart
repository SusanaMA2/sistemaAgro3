import 'package:flutter/material.dart';
import '../../models/configurarRiego.dart';
import 'configurarRiego_controller.dart';
import 'configurarRiego_form_screen.dart';

class ConfigurarRiegoListScreen extends StatefulWidget {
  const ConfigurarRiegoListScreen({super.key});

  @override
  State<ConfigurarRiegoListScreen> createState() => _ConfigurarRiegoListScreenState();
}

class _ConfigurarRiegoListScreenState extends State<ConfigurarRiegoListScreen> {
  final controller = ConfigurarRiegoController();
  List<ConfiguracionRiego> lista = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    final data = await controller.listar();
    setState(() => lista = data);
  }

  Future<void> eliminarRiego(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar"),
        content: const Text("¿Deseas eliminar este riego?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Eliminar")),
        ],
      ),
    );
    if (confirm == true) {
      await controller.eliminar(id);
      cargar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuraciones de Riego')),
      body: lista.isEmpty
          ? const Center(child: Text("No existen registros"))
          : ListView.builder(
        itemCount: lista.length,
        itemBuilder: (_, i) {
          final r = lista[i];
          return Card(
            child: ListTile(
              title: Text("Riego ${r.id}"),
              subtitle: Text("${r.fechaRiego.day}/${r.fechaRiego.month}/${r.fechaRiego.year} - ${r.horaInicio} a ${r.horaFin}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => eliminarRiego(r.id!),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfigurarRiegoFormScreen(riego: r),
                  ),
                );
                cargar();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ConfigurarRiegoFormScreen()),
          );
          cargar();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
