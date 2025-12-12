import 'package:flutter/material.dart';
import '../../models/configurarRiego.dart';
import 'configurarRiego_controller.dart';

class ConfigurarRiegoFormScreen extends StatefulWidget {
  final ConfiguracionRiego? riego;

  const ConfigurarRiegoFormScreen({super.key, this.riego});

  @override
  State<ConfigurarRiegoFormScreen> createState() => _ConfigurarRiegoFormScreenState();
}

class _ConfigurarRiegoFormScreenState extends State<ConfigurarRiegoFormScreen> {
  final controller = ConfigurarRiegoController();
  final formKey = GlobalKey<FormState>();

  DateTime? fechaRiego;
  TimeOfDay? horaInicio;
  TimeOfDay? horaFin;
  String duracion = '';

  int? idDispositivo;
  int? idParcela;
  int? idValvula;

  List<Map<String, dynamic>> dispositivos = [];
  List<Map<String, dynamic>> parcelas = [];
  List<Map<String, dynamic>> valvulas = [];

  @override
  void initState() {
    super.initState();
    cargarDispositivos();

    if (widget.riego != null) {
      final r = widget.riego!;
      fechaRiego = r.fechaRiego;
      horaInicio = _parseTimeOfDay(r.horaInicio);
      horaFin = _parseTimeOfDay(r.horaFin);
      duracion = r.duracion;
      idDispositivo = r.idDispositivo;
      idParcela = r.idParcela;
      idValvula = r.idValvula;

      _cargarParcelasValvulas(idDispositivo!);
      _calcularDuracion();
    }
  }

  // Convertir String "hh:mm AM/PM" a TimeOfDay
  TimeOfDay _parseTimeOfDay(String t) {
    final parts = t.split(" ");
    final hm = parts[0].split(":");
    int hour = int.parse(hm[0]);
    int minute = int.parse(hm[1]);
    if (parts[1] == "PM" && hour < 12) hour += 12;
    if (parts[1] == "AM" && hour == 12) hour = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> cargarDispositivos() async {
    dispositivos = await controller.cargarDispositivos();
    setState(() {});
  }

  Future<void> _cargarParcelasValvulas(int idDispositivo) async {
    parcelas = await controller.cargarParcelasPorDispositivo(idDispositivo);
    valvulas = await controller.cargarValvulasPorDispositivo(idDispositivo);
    setState(() {});
  }

  Future<void> seleccionarDispositivo(int id) async {
    idDispositivo = id;
    idParcela = null;
    idValvula = null;
    parcelas = [];
    valvulas = [];
    await _cargarParcelasValvulas(id);
  }

  Future<void> seleccionarHoraInicio() async {
    final t = await showTimePicker(
      context: context,
      initialTime: horaInicio ?? TimeOfDay.now(),
    );
    if (t != null) {
      setState(() {
        horaInicio = t;
        if (horaFin != null) _calcularDuracion();
      });
    }
  }

  Future<void> seleccionarHoraFin() async {
    final t = await showTimePicker(
      context: context,
      initialTime: horaFin ?? TimeOfDay.now(),
    );
    if (t != null) {
      if (horaInicio != null) {
        final inicioMin = horaInicio!.hour * 60 + horaInicio!.minute;
        final finMin = t.hour * 60 + t.minute;
        if (finMin <= inicioMin) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Hora fin debe ser mayor a hora inicio")),
          );
          return;
        }
      }
      setState(() {
        horaFin = t;
        _calcularDuracion();
      });
    }
  }

  void _calcularDuracion() {
    if (horaInicio != null && horaFin != null) {
      int diffMin = (horaFin!.hour * 60 + horaFin!.minute) - (horaInicio!.hour * 60 + horaInicio!.minute);
      final h = diffMin ~/ 60;
      final m = diffMin % 60;
      duracion = "${h}h ${m}m";
    }
  }

  Future<void> guardar() async {
    if (!formKey.currentState!.validate()) return;
    if (fechaRiego == null || horaInicio == null || horaFin == null || idDispositivo == null || idParcela == null || idValvula == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    final r = ConfiguracionRiego(
      id: widget.riego?.id,
      fechaRiego: fechaRiego!,
      horaInicio: "${horaInicio!.hourOfPeriod}:${horaInicio!.minute.toString().padLeft(2,'0')} ${horaInicio!.period.name.toUpperCase()}",
      horaFin: "${horaFin!.hourOfPeriod}:${horaFin!.minute.toString().padLeft(2,'0')} ${horaFin!.period.name.toUpperCase()}",
      duracion: duracion,
      idParcela: idParcela!,
      idDispositivo: idDispositivo!,
      idValvula: idValvula!,
    );

    if (widget.riego == null) {
      await controller.registrar(r);
    } else {
      await controller.editar(widget.riego!.id!, r);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.riego == null ? "Registrar Riego" : "Editar Riego")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Dispositivo
                DropdownButtonFormField<int>(
                  value: idDispositivo,
                  decoration: const InputDecoration(labelText: "Dispositivo"),
                  items: dispositivos.map((d) => DropdownMenuItem<int>(
                    value: d['id'] as int,
                    child: Text(d['nombre']),
                  )).toList(),
                  onChanged: (v) => seleccionarDispositivo(v!),
                  validator: (v) => v == null ? "Selecciona un dispositivo" : null,
                ),
                const SizedBox(height: 20),

                // Parcela
                DropdownButtonFormField<int>(
                  value: idParcela,
                  decoration: const InputDecoration(labelText: "Parcela"),
                  items: parcelas.map((p) => DropdownMenuItem<int>(
                    value: p['id'] as int,
                    child: Text(p['nombre']),
                  )).toList(),
                  onChanged: (v) => setState(() => idParcela = v),
                  validator: (v) => v == null ? "Selecciona una parcela" : null,
                ),
                const SizedBox(height: 20),

                // Válvula
                DropdownButtonFormField<int>(
                  value: idValvula,
                  decoration: const InputDecoration(labelText: "Válvula"),
                  items: valvulas.map((v) => DropdownMenuItem<int>(
                    value: v['id'] as int,
                    child: Text(v['nombre']),
                  )).toList(),
                  onChanged: (v) => setState(() => idValvula = v),
                  validator: (v) => v == null ? "Selecciona una válvula" : null,
                ),
                const SizedBox(height: 20),

                // Fecha
                ElevatedButton(
                  onPressed: () async {
                    final f = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2035),
                      initialDate: fechaRiego ?? DateTime.now(),
                    );
                    if (f != null) setState(() => fechaRiego = f);
                  },
                  child: Text(fechaRiego == null
                      ? "Seleccionar fecha"
                      : "${fechaRiego!.day}/${fechaRiego!.month}/${fechaRiego!.year}"),
                ),
                const SizedBox(height: 20),

                // Hora inicio
                ElevatedButton(
                  onPressed: seleccionarHoraInicio,
                  child: Text(horaInicio == null ? "Seleccionar hora inicio" : "${horaInicio!.format(context)}"),
                ),
                const SizedBox(height: 10),

                // Hora fin
                ElevatedButton(
                  onPressed: seleccionarHoraFin,
                  child: Text(horaFin == null ? "Seleccionar hora fin" : "${horaFin!.format(context)}"),
                ),
                const SizedBox(height: 20),

                // Duración
                TextFormField(
                  decoration: const InputDecoration(labelText: "Duración"),
                  readOnly: true,
                  controller: TextEditingController(text: duracion),
                ),
                const SizedBox(height: 20),

                ElevatedButton(onPressed: guardar, child: const Text("Guardar")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
