import 'package:flutter/material.dart';
import '../../models/parcela.dart';
import 'parcela_controller.dart';

class ParcelaFormScreen extends StatefulWidget {
  final Parcela? parcela;
  const ParcelaFormScreen({super.key, this.parcela});

  @override
  State<ParcelaFormScreen> createState() => _ParcelaFormScreenState();
}

class _ParcelaFormScreenState extends State<ParcelaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = ParcelaController();

  final nombreCtrl = TextEditingController();
  final asociacionCtrl = TextEditingController();


  @override
  void initState() {
    super.initState();
    if (widget.parcela != null) {
      nombreCtrl.text = widget.parcela!.nombre;
      asociacionCtrl.text = widget.parcela!.asociacion;
    }
  }

  Future<void> guardar() async {
    if (_formKey.currentState!.validate()) {
      final p = Parcela(
        nombre: nombreCtrl.text,
        asociacion: asociacionCtrl.text,
      );

      if (widget.parcela == null) {
        await controller.agregarParcela(p);
      } else {
        await controller.editarParcela(widget.parcela!.id!, p);
      }
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.parcela == null ? 'Registrar Parcela' : 'Editar Parcela'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: asociacionCtrl,
              decoration: const InputDecoration(labelText: 'Asociacion'),
            ),

            const SizedBox(height: 20),
            ElevatedButton(onPressed: guardar, child: const Text('Guardar'))
          ]),
        ),
      ),
    );
  }
}
