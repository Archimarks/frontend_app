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
  final Function(List<String>) onScan;

  @override
  ScanQrState createState() => ScanQrState();
}

class ScanQrState extends State<ScanQr> {
  List<String> scannedCodes = [];

  @override
  Widget build(final BuildContext context) => Center(
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: MobileScanner(
          onDetect: (final capture) {
            final barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              final code = barcode.rawValue;
              if (code != null && !scannedCodes.contains(code)) {
                setState(() => scannedCodes.add(code));
                widget.onScan(scannedCodes);
              }
            }
          },
        ),
      ),
    ),
  );
}
