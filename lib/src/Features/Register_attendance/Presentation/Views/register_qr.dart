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
  // Listas de QRs ya procesados
  final Set<String> validCodes = {};
  final Set<String> invalidCodes = {};

  /// Método para procesar el resultado de un QR
  Map<String, dynamic> processQR(
    final dynamic scannedData, // puede ser String o List<String>
    final String expectedTitle,
  ) {
    try {
      // 1. Asegurar de que siempre se trabaje con un String
      String? scannedText;

      if (scannedData is String) {
        scannedText = scannedData;
      } else if (scannedData is List<String> && scannedData.isNotEmpty) {
        scannedText = scannedData.last; // Siempre validar el último escaneo
      }

      if (scannedText == null || scannedText.isEmpty) {
        return {'valid': false, 'message': 'El QR está vacío o no es válido'};
      }

      debugPrint('VALIDOS: ${validCodes.toString()}');
      debugPrint('INVALIDOS: ${invalidCodes.toString()}');

      // 2. Revisar si ya fue procesado antes
      if (validCodes.contains(scannedText)) {
        debugPrint('Este QR ya fue escaneado y validado correctamente');
        return {
          'valid': false,
          'message': 'Este QR ya fue escaneado y validado correctamente',
        };
      }
      if (invalidCodes.contains(scannedText)) {
        debugPrint('Este QR ya fue escaneado y NO ES valido');
        return {
          'valid': false,
          'message': 'Este QR ya fue escaneado pero es incorrecto',
        };
      }

      // 3. Dividir el texto del QR
      final parts = scannedText.split(' - ');
      if (parts.length != 2) {
        invalidCodes.add(scannedText); // guardar como inválido
        return {'valid': false, 'message': 'Formato inválido de QR'};
      }

      final String title = parts[0].trim();
      final String dateString = parts[1].trim();

      // 4. Validar la fecha
      final dateParts = dateString.split('/');
      if (dateParts.length != 3) {
        invalidCodes.add(scannedText);
        return {'valid': false, 'message': 'Fecha inválida en el QR'};
      }

      final int day = int.tryParse(dateParts[0]) ?? 0;
      final int month = int.tryParse(dateParts[1]) ?? 0;
      final int year = int.tryParse(dateParts[2]) ?? 0;

      final qrDate = DateTime(year, month, day);
      final now = DateTime.now();

      // 5. Comparar la fecha (solo día, mes y año)
      final bool isToday =
          qrDate.year == now.year &&
          qrDate.month == now.month &&
          qrDate.day == now.day;

      if (!isToday) {
        invalidCodes.add(scannedText);
        return {
          'valid': false,
          'message': 'El QR no corresponde a la fecha de hoy',
        };
      }

      // 6. Validar el nombre del encuentro
      if (title != expectedTitle) {
        invalidCodes.add(scannedText);
        debugPrint('ESCANEO DONDE NO ES');
        debugPrint(invalidCodes.toString());
        return {
          'valid': false,
          'message': 'El QR no pertenece a este encuentro',
        };
      }

      // Si todo está bien, se marca como válido
      validCodes.add(scannedText);
      return {
        'valid': true,
        'title': title,
        'date': qrDate,
        'message': 'QR válido',
      };
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return {'valid': false, 'message': 'Error al procesar el QR: $e'};
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
        onScan: (final code) async {
          final result = processQR(code, widget.title);
          if (result['valid'] == true) {
            // QR válido
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(' Asistencia registrada para ${result['title']}'),
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

  /// Espacio de botón para asistencia manualmente y cantidad de registrados
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
