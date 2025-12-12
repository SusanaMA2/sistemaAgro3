import 'package:flutter/material.dart';
import '../../models/bomba.dart';
import 'bomba_controller.dart';

class BombaFormScreen extends StatefulWidget {
  final Bomba? bomba;
  const BombaFormScreen({super.key, this.bomba});

  @override
  State<BombaFormScreen> createState() => _BombaFormScreenState();
}

class _BombaFormScreenState extends State<BombaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = BombaController();

  final tituloCtrl = TextEditingController();
  final modeloCtrl = TextEditingController();

  List<Map<String, dynamic>> dispositivos = [];
  int? idDispositivoSeleccionado;

  @override
  void initState() {
    super.initState();

    tituloCtrl.text = widget.bomba?.titulo ?? '';
    modeloCtrl.text = widget.bomba?.modelo ?? '';

    idDispositivoSeleccionado = widget.bomba?.idDispositivo;
    cargarDispositivos();
  }

  Future<void> cargarDispositivos() async {
    final data = await controller.listarDispositivos();
    setState(() {
      dispositivos = data;
    });
  }

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (idDispositivoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione un dispositivo')));
      return;
    }

    final b = Bomba(
      id: widget.bomba?.id,
      titulo: tituloCtrl.text,
      modelo: modeloCtrl.text,
      fechaCreacion: widget.bomba?.fechaCreacion ?? DateTime.now(),
      estado: widget.bomba?.estado ?? true,
      idUsuario: widget.bomba?.idUsuario,
      idDispositivo: idDispositivoSeleccionado,
    );

    if (widget.bomba == null) {
      await controller.registrarBomba(b);
    } else {
      await controller.editarBomba(widget.bomba!.id!, b);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bomba == null ? 'Registrar Bomba' : 'Editar Bomba'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: tituloCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: modeloCtrl,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),

              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: idDispositivoSeleccionado,
                decoration: const InputDecoration(
                  labelText: "Seleccionar dispositivo",
                  border: OutlineInputBorder(),
                ),
                items: dispositivos.map((d) {
                  return DropdownMenuItem<int>(
                    value: int.parse(d['id'].toString()),
                    child: Text(d['nombre'].toString()),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    idDispositivoSeleccionado = valor;
                  });
                },
              ),



              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: guardar,
                child: const Text('Guardar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
