/// ****************************************************************************
/// ### RegisterQR
/// * Fecha: 2025
/// * Descripción: Vista en donde se escanean los QR o se elije la asistencia manual.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Routes/route_names.dart';

class RegisterQR extends StatefulWidget {
  const RegisterQR({super.key, required this.title, required this.hourAndDate});

  final String title;
  final String hourAndDate;

  @override
  State<RegisterQR> createState() => _RegisterQRState();
}

class _RegisterQRState extends State<RegisterQR> {
  String rolApp = '';
  final List<String> _selectedDelegateId = [];
  String? _selectedDelegate; // Variable para almacenar al delegado seleccionado
  final List<Map<String, String>> myParticipants = [
    {
      'id': '1',
      'textMain': 'Fredy Antonio Verástegui González',
      'textSecondary': 'f.verastegui@udla.edu.co',
    },
    {
      'id': '2',
      'textMain': 'Marcos Alejandro Collazos Marmolejo',
      'textSecondary': 'marc.collazos@udla.edu.co',
    },
    {
      'id': '3',
      'textMain': 'Geraldine Perilla Valderrama',
      'textSecondary': 'g.perilla@udla.edu.co',
    },
    // ... más participantes
  ];

  @override
  Widget build(final BuildContext context) => PopScope(
    canPop: false,
    // ignore: deprecated_member_use
    onPopInvoked: (final bool didPop) {
      if (didPop) {
        return;
      }
    },
    child: Scaffold(
      backgroundColor: TipoColores.seasalt.value,
      appBar: customAppBar(
        context: context,
        title: 'Registro asistencia por QR',
        onLeadingPressed: () async {
          if (!context.mounted) {
            return;
          }
          context.goNamed(RouteNames.register);
        },
        backgroundColor: TipoColores.pantone356C.value,
        leadingIconColor: TipoColores.seasalt.value,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Contenido principal que puede desplazarse si es necesario
            Expanded(child: SingleChildScrollView(child: _mainContent())),
            // Widget inferior que permanece fijo abajo
            _selectManualRegister(),
          ],
        ),
      ),
    ),
  );

  /// Método para el contenido principal
  Widget _mainContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        widget.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: TipoColores.pantoneBlackC.value,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        widget.hourAndDate,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: TipoColores.gris.value),
      ),
      const SizedBox(height: 30),
      ScanQr(
        onScan: (final onScan) async {
          if (onScan.isNotEmpty && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(' Asistencia registrada para $onScan'),
                backgroundColor: TipoColores.pantone7621C.value,
              ),
            );
            // Esperar un momento antes de cerrar
            await Future.delayed(const Duration(seconds: 2));
            if (context.mounted) {
              // ignore: use_build_context_synchronously
              context.pop();
            }
          }
        },
      ),
      const SizedBox(height: 20),
      Text(
        'Coloque el código dentro del recuadro para registrar la asistencia.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: TipoColores.pantoneBlackC.value),
      ),
    ],
  );

  // Botón para registrar asistencia manualmente
  Widget _selectManualRegister() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'Invitados registrados  1/2',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: TipoColores.pantoneBlackC.value,
        ),
      ),
      const SizedBox(height: 15),
      CustomButton(
        color: TipoColores.pantone158C,
        text: 'Registrar asistencia manualmente',
        width: double.infinity,
        onPressed: () {
          context.goNamed(RouteNames.registerManual);
        },
      ),
    ],
  );
}
