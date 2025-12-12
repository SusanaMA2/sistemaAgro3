import 'package:flutter/material.dart';
import '../../models/riegoManual.dart';
import 'riegoManual_controller.dart';

class RiegoManualListScreen extends StatefulWidget {
  const RiegoManualListScreen({super.key});

  @override
  State<RiegoManualListScreen> createState() => _RiegoManualListScreenState();
}

class _RiegoManualListScreenState extends State<RiegoManualListScreen> {
  final controller = RiegoManualController();
  List<RiegoManual> lista = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    final data = await controller.listar();
    setState(() => lista = data);
  }

  String _formatFecha(DateTime value) =>
      "${value.year}-${value.month.toString().padLeft(2,'0')}-${value.day.toString().padLeft(2,'0')}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historial de Riegos")),
      body: lista.isEmpty
          ? const Center(child: Text("Sin registros"))
          : RefreshIndicator(
        onRefresh: cargar,
        child: ListView.builder(
          itemCount: lista.length,
          itemBuilder: (_, i) {
            final r = lista[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fecha: ${_formatFecha(r.fechaRiego)}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                        "Inicio: ${r.horaInicio} | Fin: ${r.horaFin.isEmpty ? '---' : r.horaFin}"),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
