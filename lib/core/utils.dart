import 'package:flutter/material.dart';
import 'constants.dart';

/// 📢 Muestra un mensaje tipo SnackBar (verde para éxito, rojo para error)
void mostrarMensaje(
    BuildContext context,
    String mensaje, {
      bool esError = false,
    }) {
  final colorFondo = esError ? Colors.red[400] : AppColors.verdeOscuro;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensaje,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: colorFondo,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}

/// ⚠️ Cuadro de diálogo para confirmar una acción
/// Retorna `true` si el bomba presiona “Sí”
Future<bool> confirmarAccion(
    BuildContext context, {
      required String titulo,
      required String mensaje,
    }) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        titulo,
        style: const TextStyle(
          color: AppColors.verdeOscuro,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        mensaje,
        style: const TextStyle(color: AppColors.textoOscuro),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            'No',
            style: TextStyle(color: AppColors.plomoClaro),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cafeClaro,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Sí',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
  return resultado ?? false;
}

/// ⏳ Indicador de carga reutilizable
Widget mostrarCargando() {
  return const Center(
    child: CircularProgressIndicator(
      color: AppColors.verdeOscuro,
      strokeWidth: 3,
    ),
  );
}

/// 📅 Formatea una fecha como “dd/mm/yyyy”
String formatearFecha(DateTime fecha) {
  return '${fecha.day.toString().padLeft(2, '0')}/'
      '${fecha.month.toString().padLeft(2, '0')}/'
      '${fecha.year}';
}
