import 'package:flutter/material.dart';
import '../../models/usuario.dart';
import 'usuario_controller.dart';

class UsuarioFormScreen extends StatefulWidget {
  final Usuario? usuario;
  const UsuarioFormScreen({super.key, this.usuario});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  final formKey = GlobalKey<FormState>();
  final controller = UsuarioController();

  final nombreCtrl = TextEditingController();
  final apellidoCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final celularCtrl = TextEditingController();
  final distritoCtrl = TextEditingController();
  final departamentoCtrl = TextEditingController();
  String rol = "user";

  @override
  void initState() {
    super.initState();

    if (widget.usuario != null) {
      final u = widget.usuario!;
      nombreCtrl.text = u.nombre;
      apellidoCtrl.text = u.apellido;
      emailCtrl.text = u.email;
      passwordCtrl.text = u.password;
      celularCtrl.text = u.celular;
      distritoCtrl.text = u.distrito;
      departamentoCtrl.text = u.departamento;
      rol = u.rol;
    }
  }

  Future<void> guardar() async {
    if (!formKey.currentState!.validate()) return;

    final usuario = Usuario(
      id: widget.usuario?.id,
      nombre: nombreCtrl.text,
      apellido: apellidoCtrl.text,
      email: emailCtrl.text,
      password: passwordCtrl.text,
      celular: celularCtrl.text,
      distrito: distritoCtrl.text,
      departamento: departamentoCtrl.text,
      rol: rol,
    );

    if (widget.usuario == null) {
      await controller.registrarUsuario(usuario);
    } else {
      await controller.editarUsuario(widget.usuario!.id!, usuario);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usuario == null ? "Registrar Usuario" : "Editar Usuario"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              TextFormField(
                controller: apellidoCtrl,
                decoration: const InputDecoration(labelText: "Apellido"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              TextFormField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              TextFormField(
                controller: celularCtrl,
                decoration: const InputDecoration(labelText: "Celular"),
              ),
              TextFormField(
                controller: distritoCtrl,
                decoration: const InputDecoration(labelText: "Distrito"),
              ),
              TextFormField(
                controller: departamentoCtrl,
                decoration: const InputDecoration(labelText: "Departamento"),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: rol,
                decoration: const InputDecoration(labelText: "Rol"),
                items: ["admin", "user"].map((r) {
                  return DropdownMenuItem(
                    value: r,
                    child: Text(r),
                  );
                }).toList(),
                onChanged: (v) => setState(() => rol = v!),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: guardar,
                child: const Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
