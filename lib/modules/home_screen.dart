import 'package:flutter/material.dart';
import '../modules/bomba/bomba_list_screen.dart';
import '../modules/dispositivo/dispositivo_list_screen.dart';
import '../modules/parcela/parcela_list_screen.dart';
import '../modules/sensor/sensor_list_screen.dart';
import '../modules/valvula/valvula_list_screen.dart';
import '../modules/configurarRiego/configurarRiego_list_screen.dart';
import '../modules/riegoManual/riegoManual_list_screen.dart';
import '../modules/riegoManual/riegoManual_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sistema de Riego"),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF50AA81)),
              child: Text(
                'Menú Principal',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),

             //BOMBA
            ListTile(
              leading: const Icon(Icons.water),
              title: const Text("Bombas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BombaListScreen()),
                );
              },
            ),

            // DISPOSITIVOS
            ListTile(
              leading: const Icon(Icons.developer_board),
              title: const Text("Dispositivos"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DispositivoListScreen()),
                );
              },
            ),

            // SENSOR
            ListTile(
              leading: const Icon(Icons.sensors),
              title: const Text("Sensores"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SensorListScreen()),
                );
              },
            ),

            // PARCELAS
            ListTile(
              leading: const Icon(Icons.landscape),
              title: const Text("Parcelas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ParcelaListScreen()),
                );
              },
            ),

            // VÁLVULAS
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Válvulas"),

              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ValvulaListScreen()),
                );
              },
            ),

            // CONFIGURAR RIEGO
            ListTile(
              leading: const Icon(Icons.settings_applications),
              title: const Text("Configurar Riego"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ConfigurarRiegoListScreen()),
                );
              },
            ),
            //CONFIGURARMANUAL
            ListTile(
              leading: const Icon(Icons.settings_applications),
              title: const Text("Configuracion Manual"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RiegoManualFormScreen()),
                );
              },
            ),

          ],
        ),
      ),

      body: const Center(
        child: Text(
          "Bienvenido al Sistema de Riego",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
