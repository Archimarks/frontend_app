// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// ****************************************************************************
/// * Widget: ScanQR
/// * Fecha: 2025
/// * Descripción: Widget que muestra un scanner que permite escanear un código QR.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************

class ScanQr extends StatefulWidget {
  const ScanQr({super.key, required this.onScan});
  final Function(Map<String, dynamic>) onScan;

  @override
  ScanQrState createState() => ScanQrState();
}

class ScanQrState extends State<ScanQr> {
  final Set<String> scannedCodes = {};

  @override
  Widget build(final BuildContext context) => Center(
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: MobileScanner(
          onDetect: (final capture) {
            for (final barcode in capture.barcodes) {
              final code = barcode.rawValue;
              if (code != null && !scannedCodes.contains(code)) {
                setState(() => scannedCodes.add(code));

                try {
                  // Intentar decodificar como JSON
                  final Map<String, dynamic> jsonData =
                      jsonDecode(code) as Map<String, dynamic>;
                  widget.onScan(jsonData);
                } catch (_) {
                  // Si no es JSON válido, devolver un "mapa inválido"
                  widget.onScan({
                    'valid': false,
                    'message': 'El QR no contiene un JSON válido',
                    'raw': code, // opcional: para mostrar qué llegó
                  });
                }
              }
            }
          },
        ),
      ),
    ),
  );
}
