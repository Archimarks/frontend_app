///*****************************************************************
/// * Nombre del Archivo: `list_color.dart`
/// * Descripción: Listado de colores para usar en los diferentes widgets.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
///*****************************************************************
library;

import 'package:flutter/material.dart';

import '../../Shared/Themes/colors_app.dart';

enum TipoColores {
  // Principales
  calPolyGreen,
  pantone356C,
  pantone158C,
  pantone634C,

  //Secundarios
  pantone7621C,
  pantone7473C,
  airBlue,

  //Grises
  pantoneBlackC,
  gris,
  pantoneCool,
  pantone663C,
  seasalt;

  /// Obtiene el color principal correspondiente.
  /// Si el color no existe en el mapa, devuelve un color de respaldo (negro en este caso).
  Color get value => ColorsApp.colorMap[this] ?? Colors.black;
}
