import 'package:flutter/material.dart';
import 'valvula_controller.dart';
import '../../models/dispositivo_temp.dart';
import '../../models/valvula.dart';
import '../../core/constants.dart';

class ValvulaFormScreen extends StatefulWidget {
  const ValvulaFormScreen({super.key});

  @override
  State<ValvulaFormScreen> createState() => _ValvulaFormScreenState();
}

class _ValvulaFormScreenState extends State<ValvulaFormScreen> {
  final controller = ValvulaController();
  List<DispositivoTemp> dispositivos = [];
  DispositivoTemp? seleccionado;

  final nombreCtrl = TextEditingController();
  final ubicacionCtrl = TextEditingController();
  final idDispositivoCtrl = TextEditingController();

  int? idDispositivoReal;
  int? idTemp;

  @override
  void initState() {
    super.initState();
    cargarDispositivos();
  }

  Future<void> cargarDispositivos() async {
    final data = await controller.listarDispositivosActuador();
    setState(() => dispositivos = data);
  }

  Future<void> guardar() async {
    if (seleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione un dispositivo')),
      );
      return;
    }

    if (nombreCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese un nombre para la válvula')),
      );
      return;
    }

    // Validar existencia en tabla real
    final existe = await controller.validarDispositivoReal(idDispositivoReal!);
    if (!existe) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dispositivo no encontrado',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              'El dispositivo con ID $idDispositivoReal no está registrado.\nRegístrelo antes de continuar.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Aceptar')),
          ],
        ),
      );
      return;
    }

    await controller.registrarValvula(
      Valvula(
        nombre: nombreCtrl.text,
        ubicacion: ubicacionCtrl.text,
        fechaCreacion: DateTime.now(),
        estado: false,
        idDispositivo: idDispositivoReal!,
      ),
      idTemp!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Válvula registrada correctamente')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Válvula')),
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
                child: Text('(ID Dispositivo: ${d.idDispositivo ?? "—"})'),
              ))
                  .toList(),
              onChanged: (d) {
                setState(() {
                  seleccionado = d;
                  ubicacionCtrl.text = '';
                  idDispositivoReal = d!.idDispositivo;
                  idTemp = d.id;
                  idDispositivoCtrl.text = d.idDispositivo?.toString() ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: ubicacionCtrl,
              decoration: const InputDecoration(labelText: 'Ubicación'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: idDispositivoCtrl,
              decoration: const InputDecoration(
                  labelText: 'ID Dispositivo (real)',
                  hintText: 'Autocompletado desde el dispositivo'),
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
