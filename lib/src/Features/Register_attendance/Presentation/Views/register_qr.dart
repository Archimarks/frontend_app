/// ****************************************************************************
/// ### RegisterQR
/// * Fecha: 2025
/// * Descripción: Vista en donde se escanean los QR o se elije la asistencia manual.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
// ignore_for_file: avoid_catches_without_on_clauses

library;

import 'dart:convert';

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

  /// Códigos QR válidos
  final Set<String> validCodes = {};

  /// Códigos QR incorrectos
  final Set<String> invalidCodes = {};

  /// Método para procesar el QR ya decodificado
  Map<String, dynamic> processQR(
    final dynamic scannedData,
    final String expectedTitle,
  ) {
    try {
      // Obtener el "raw" del código para registrar
      final raw = scannedData is String ? scannedData : jsonEncode(scannedData);

      // 0. Revisar si ya fue procesado antes
      if (validCodes.contains(raw)) {
        return {
          'valid': false,
          'message': 'Este QR ya fue escaneado y validado correctamente',
        };
      }
      if (invalidCodes.contains(raw)) {
        return {
          'valid': false,
          'message': 'Este QR ya fue escaneado previamente y es inválido',
        };
      }

      // 1. Validar que el QR venga como Map
      if (scannedData is! Map<String, dynamic>) {
        invalidCodes.add(raw);
        return {'valid': false, 'message': 'El QR escaneado no es válido'};
      }
      final qrData = scannedData;

      // 2. Extraer datos
      final title = qrData['titulo']?.toString();
      final dateString = qrData['fecha']?.toString();
      final correo = qrData['correo']?.toString();

      if (title == null || dateString == null) {
        invalidCodes.add(raw);
        return {
          'valid': false,
          'message': 'El QR no contiene los datos requeridos',
        };
      }

      // 3. Validar fecha
      late final DateTime qrDate;
      try {
        qrDate = DateTime.parse(dateString);
      } catch (_) {
        invalidCodes.add(raw);
        return {'valid': false, 'message': 'Fecha inválida en el QR'};
      }

      final now = DateTime.now();
      final isToday =
          qrDate.year == now.year &&
          qrDate.month == now.month &&
          qrDate.day == now.day;

      if (!isToday) {
        invalidCodes.add(raw);
        return {
          'valid': false,
          'message': 'El QR no corresponde a la fecha de hoy',
        };
      }

      // 4. Validar título
      if (title != expectedTitle) {
        invalidCodes.add(raw);
        return {
          'valid': false,
          'message': 'El QR no pertenece a este encuentro',
        };
      }

      // ✅ Todo correcto → agregar a válidos
      validCodes.add(raw);
      return {
        'valid': true,
        'title': title,
        'date': qrDate.toIso8601String().split('T').first, // yyyy-MM-dd
        if (correo != null) 'correo': correo,
        'message': 'QR válido',
      };
    } catch (e, st) {
      debugPrint('Error en processQR: $e\n$st');
      return {'valid': false, 'message': 'Error inesperado al procesar el QR'};
    }
  }

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
            Expanded(child: SingleChildScrollView(child: _mainContent())),
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
        onScan: (final code) async {
          final result = processQR(code, widget.title);
          if (result['valid'] == true) {
            // QR válido
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Asistencia registrada para ${result['title']}'),
                backgroundColor: TipoColores.calPolyGreen.value,
              ),
            );
          } else {
            // QR inválido
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${result['message']}'),
                backgroundColor: TipoColores.pantone7621C.value,
              ),
            );
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

  /// Espacio de botón para asistencia manual y cantidad de registrados
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
