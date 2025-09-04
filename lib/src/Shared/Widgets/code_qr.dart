import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// ****************************************************************************
/// * Widget: CodeQR
/// * Fecha: 2025
/// * Descripción: Widget que permite generar un código QR a partir de un texto.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************

class CodeQR extends StatelessWidget {

  // Constructor que recibe el parámetro 'data'
  const CodeQR({super.key, required this.data});
  /// Parámetro para el dato que se codificará
  final String data;

  @override
  Widget build(final BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        QrImageView(
          data: data, // El parámetro que se usará para generar el QR
          version: 8, // Define la versión del QR
        size: MediaQuery.of(context).size.width * 0.85, // Tamaño del QR
          gapless: false, // Evita los espacios en blanco
          embeddedImage: const AssetImage('assets/images/UdlaColor.png'),
          embeddedImageStyle: QrEmbeddedImageStyle(size: Size(MediaQuery.of(context).size.width *
              0.10,
            MediaQuery.of(context).size.height * 0.07,
          )), // Imagen embebida en el centro del QR
          errorStateBuilder: (final cxt, final err) => const Center(
              child: Text(
                '¡Uhh! Algo salió mal...',
                textAlign: TextAlign.center,
              ),
            ),
        ),
      ],
    );
}
