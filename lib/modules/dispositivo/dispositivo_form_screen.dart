import 'package:flutter/material.dart';
import '../../models/dispositivo.dart';
import 'dispositivo_controller.dart';

class DispositivoFormScreen extends StatefulWidget {
  final Dispositivo? dispositivo;
  const DispositivoFormScreen({super.key, this.dispositivo});

  @override
  State<DispositivoFormScreen> createState() => _DispositivoFormScreenState();
}

class _DispositivoFormScreenState extends State<DispositivoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = DispositivoController();

  final nombreCtrl = TextEditingController();
  final simImeiCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.dispositivo != null) {
      nombreCtrl.text = widget.dispositivo!.nombre;
      simImeiCtrl.text = widget.dispositivo!.simImei;
    }
  }

  Future<void> guardar() async {
    if (_formKey.currentState!.validate()) {
      final d = Dispositivo(
        nombre: nombreCtrl.text,
        simImei: simImeiCtrl.text,
        token: '', // será generado automáticamente
      );

      if (widget.dispositivo == null) {
        await controller.registrarDispositivo(d);
      } else {
        await controller.editarDispositivo(widget.dispositivo!.id!, d);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dispositivo == null
            ? 'Registrar Dispositivo'
            : 'Editar Dispositivo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: simImeiCtrl,
                decoration: const InputDecoration(labelText: 'SIM / IMEI'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: guardar,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
