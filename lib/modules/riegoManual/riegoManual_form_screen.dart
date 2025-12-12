import 'package:flutter/material.dart';
import '../../models/riegoManual.dart';
import 'riegoManual_controller.dart';

class RiegoManualFormScreen extends StatefulWidget {
  const RiegoManualFormScreen({super.key});

  @override
  State<RiegoManualFormScreen> createState() => _RiegoManualFormScreenState();
}

class _RiegoManualFormScreenState extends State<RiegoManualFormScreen> {
  final controller = RiegoManualController();
  bool encendido = false;
  RiegoManual? ultimoRiego;
  List<RiegoManual> historial = [];

  @override
  void initState() {
    super.initState();
    cargarEstado();
    cargarHistorial();
  }

  Future<void> cargarEstado() async {
    ultimoRiego = await controller.obtenerUltimo();
    if (ultimoRiego != null) {
      setState(() {
        encendido = ultimoRiego!.estado;
      });
    }
  }

  Future<void> cargarHistorial() async {
    final lista = await controller.listar();
    setState(() {
      historial = lista.take(5).toList(); // últimas 5 activaciones
    });
  }

  String _hora(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour >= 12 ? "PM" : "AM";
    return "$h:$m $ampm";
  }

  Future<void> activar() async {
    final ahora = DateTime.now();
    final nuevo = RiegoManual(
      fechaRiego: ahora,
      horaInicio: _hora(ahora),
      horaFin: "",
      estado: true,
    );
    final creado = await controller.registrar(nuevo);
    setState(() {
      ultimoRiego = creado;
      encendido = true;
      historial.insert(0, creado);
      if (historial.length > 5) historial = historial.sublist(0, 5);
    });
  }

  Future<void> desactivar() async {
    if (ultimoRiego == null) return;
    final ahora = DateTime.now();
    ultimoRiego!.estado = false;
    ultimoRiego!.horaFin = _hora(ahora);
    await controller.actualizar(ultimoRiego!.id, ultimoRiego!);

    setState(() {
      encendido = false;

      // Actualiza historial pero limpia la vista principal
      historial[0] = ultimoRiego!;
      ultimoRiego = null; // aquí se vacían los campos de fecha/hora
    });
  }

  String _formatFecha(DateTime value) =>
      "${value.year}-${value.month.toString().padLeft(2,'0')}-${value.day.toString().padLeft(2,'0')}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riego Manual")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // TARJETA PRINCIPAL
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Riego Manual",
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          encendido ? "Encendido" : "Apagado",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: encendido ? Colors.green : Colors.red,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            encendido ? Icons.power : Icons.power_off,
                            color: encendido ? Colors.green : Colors.red,
                            size: 36,
                          ),
                          onPressed: () {
                            if (encendido) {
                              desactivar();
                            } else {
                              activar();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (ultimoRiego != null) ...[
                      Text(
                          "Fecha: ${_formatFecha(ultimoRiego!.fechaRiego.toLocal())}"),
                      const SizedBox(height: 6),
                      Text("Hora Inicio: ${ultimoRiego!.horaInicio}"),
                      const SizedBox(height: 6),
                      Text(
                          "Hora Fin: ${ultimoRiego!.horaFin.isEmpty ? '---' : ultimoRiego!.horaFin}"),
                    ] else
                      const Text("No hay registros aún"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 2),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Últimas 5 activaciones",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[700]),
              ),
            ),
            const SizedBox(height: 10),
            historial.isEmpty
                ? const Text("No hay registros aún")
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historial.length,
              itemBuilder: (_, i) {
                final r = historial[i];
                return Card(
                  color: Colors.grey[100],
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Fecha: ${_formatFecha(r.fechaRiego)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                            "Inicio: ${r.horaInicio} | Fin: ${r.horaFin.isEmpty ? '---' : r.horaFin}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
