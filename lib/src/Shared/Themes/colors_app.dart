/// *****************************************************************
/// * Nombre del Archivo: colors_app.dart
/// * Descripción: Definición de la paleta de colores de la aplicación.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// *****************************************************************
library;

import 'package:flutter/material.dart';

import '../../Utils/Enums/list_color.dart';

// ignore: avoid_classes_with_only_static_members
class ColorsApp {
  static const Map<TipoColores, Color> colorMap = {
    // Mapeo de colores definidos para la aplicación.

    // Colores principales
    TipoColores.calPolyGreen: Color.fromARGB(255, 7, 88, 9),
    TipoColores.pantone356C: Color.fromARGB(255, 11, 117, 14),
    TipoColores.pantone158C: Color.fromARGB(255, 228, 113, 19),
    TipoColores.pantone634C: Color.fromARGB(255, 0, 90, 126),

    // Colores secundarios
    TipoColores.pantone7621C: Color.fromARGB(255, 166, 20, 29),
    TipoColores.pantone7473C: Color.fromARGB(255, 22, 149, 134),
    TipoColores.airBlue: Color.fromARGB(255, 75, 132, 155),

    // Escala de grises
    TipoColores.pantoneBlackC: Color.fromARGB(255, 34, 34, 34),
    TipoColores.gris: Color.fromARGB(255, 117, 117, 117),
    TipoColores.pantoneCool: Color.fromARGB(255, 161, 164, 166),
    TipoColores.pantone663C: Color.fromARGB(255, 225, 221, 228),
    TipoColores.seasalt: Color.fromARGB(255, 250, 250, 250),

  };

  // ignore: prefer_expression_function_bodies
  static Color _applyGlow(final Color baseColor) {
    // ignore: deprecated_member_use
    return baseColor.withOpacity(
      0.6,
    ); // Genera automáticamente el color con brillo
  }

  static final Map<TipoColores, Color> glowMap = {
    for (var entry in colorMap.entries) entry.key: _applyGlow(entry.value),
  };
}
