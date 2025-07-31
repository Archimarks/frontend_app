/// ****************************************************************************
/// * Widget: AppBar
/// * Descripción: AppBar reutilizable y personalizable.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';

AppBar customAppBar({
  required final BuildContext context,
  required final String title,
  final List<Widget>? actions,
  final bool showLeading = true,
  final VoidCallback? onLeadingPressed,
  final Color? backgroundColor,
  final Color? colorText,
  final IconData? iconAppBar,
  final Color? leadingIconColor, // Color del icono de retroceso
  final double? sizeTitle,
  final bool showPlus = false,
  final VoidCallback? onPlusPressed, // Callback para el botón de más
  final bool showSave = false,
  final VoidCallback? onSavePressed, // Callback para el botón de guardar
  final bool showFilter = false,
  final VoidCallback? onFilterPressed, // Callback para el botón de filtrar
}) {
  /// Función auxiliar para construir los IconButtons con padding y estilos comunes
  Widget buildActionButton({
    required final IconData icon,
    required final VoidCallback? onPressed,
  }) => Padding(
    padding: const EdgeInsets.only(right: 15),
    child: IconButton(
      icon: Icon(
        icon,
        color:
            TipoColores.seasalt.value, // Color común para los iconos de acción
        size: 30, // Tamaño común para los iconos de acción
      ),
      onPressed: onPressed,
    ),
  );

  return AppBar(
    leading: showLeading
        ? IconButton(
            icon: Icon(iconAppBar ?? Icons.arrow_back, weight: 400, size: 30),
            color: leadingIconColor, // Usar el color del icono
            onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
          )
        : const SizedBox(width: 56.0), // Mantiene el espacio del leading
    title: Text(
      title,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: sizeTitle ?? 24,
        color:
            colorText ??
            TipoColores.seasalt.value, // Usar el color de texto personalizado
      ),
    ),
    centerTitle: false,
    backgroundColor:
        backgroundColor ??
        Colors.transparent, // Usar el color de fondo personalizado
    actions: [
      ...?actions,
      // Añadir los botones condicionales usando la función auxiliar
      if (showPlus)
        buildActionButton(icon: Icons.add, onPressed: onPlusPressed),
      if (showSave)
        buildActionButton(icon: Icons.save_alt, onPressed: onSavePressed),
      if (showFilter)
        buildActionButton(icon: Icons.filter_list, onPressed: onFilterPressed),
    ],
    elevation: 0,
  );
}
