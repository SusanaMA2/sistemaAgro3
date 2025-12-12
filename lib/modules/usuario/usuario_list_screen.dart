import 'package:flutter/material.dart';
import '../../models/usuario.dart';
import 'usuario_controller.dart';
import 'usuario_form_screen.dart';

class UsuarioListScreen extends StatefulWidget {
  const UsuarioListScreen({super.key});

  @override
  State<UsuarioListScreen> createState() => _UsuarioListScreenState();
}

class _UsuarioListScreenState extends State<UsuarioListScreen> {
  final controller = UsuarioController();
  List<Usuario> usuarios = [];

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    usuarios = await controller.listarUsuarios();
    setState(() {});
  }

  Future<void> eliminar(int id) async {
    await controller.eliminarUsuario(id);
    await cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const UsuarioFormScreen(),
            ),
          );
          cargarUsuarios();
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final u = usuarios[index];
          return Card(
            child: ListTile(
              title: Text("${u.nombre} ${u.apellido}"),
              subtitle: Text("Email: ${u.email}\nRol: ${u.rol}"),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UsuarioFormScreen(usuario: u),
                        ),
                      );
                      cargarUsuarios();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => eliminar(u.id!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
