import 'package:flutter/material.dart';
import 'sensor_controller.dart';
import '../../models/dispositivo_temp.dart';
import '../../models/sensor.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/constants.dart';

class SensorFormScreen extends StatefulWidget {
  const SensorFormScreen({super.key});

  @override
  State<SensorFormScreen> createState() => _SensorFormScreenState();
}

class _SensorFormScreenState extends State<SensorFormScreen> {
  final controller = SensorController();
  List<DispositivoTemp> dispositivos = [];
  DispositivoTemp? seleccionado;

  final tituloCtrl = TextEditingController();
  final tipoCtrl = TextEditingController();
  final idDispositivoCtrl = TextEditingController(); // 👈 Nuevo controller

  int? idDispositivoReal; // ID real del dispositivo
  int? idTemp; // ID temporal

  @override
  void initState() {
    super.initState();
    cargarDispositivos();
  }

  Future<void> cargarDispositivos() async {
    final data = await controller.listarDispositivosSensor();
    setState(() => dispositivos = data);
  }

  Future<void> guardar() async {
    if (seleccionado == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Seleccione un sensor')));
      return;
    }

    // Validar existencia en tabla real
    final existe = await controller.validarDispositivoReal(idDispositivoReal!);
    if (!existe) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Dispositivo no encontrado',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'El dispositivo con ID $idDispositivoReal no está registrado.\n'
                'Por favor, registra el dispositivo.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      return;
    }

    // Registrar sensor y eliminar temporal
    await controller.registrarSensor(
      Sensor(
        titulo: tituloCtrl.text,
        tipo: tipoCtrl.text,
        idDispositivo: idDispositivoReal!,
        fechaLectura: null,
        lecturaDatos: null,
      ),
      idTemp!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sensor registrado correctamente')),
    );

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Sensor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<DispositivoTemp>(
              hint: const Text('Seleccione un dispositivo'),
              value: seleccionado,
              isExpanded: true,
              items: dispositivos
                  .map((d) => DropdownMenuItem(
                value: d,
                child: Text(
                    '${d.nombre} (ID Dispositivo: ${d.idDispositivo ?? "—"})'),
              ))
                  .toList(),
              onChanged: (d) {
                setState(() {
                  seleccionado = d;
                  tituloCtrl.text = d!.nombre; // se guarda como título
                  tipoCtrl.text = d.tipo;
                  idDispositivoReal = d.idDispositivo;
                  idTemp = d.id;
                  idDispositivoCtrl.text =
                      d.idDispositivo?.toString() ?? ''; // 👈 aquí se actualiza
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: tituloCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: tipoCtrl,
              decoration: const InputDecoration(labelText: 'Tipo'),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: idDispositivoCtrl,
              decoration: const InputDecoration(
                labelText: 'ID Dispositivo (real)',
                hintText: 'Se muestra si falta en la tabla real',
              ),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: guardar, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
