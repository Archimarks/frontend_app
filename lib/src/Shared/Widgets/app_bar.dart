/// ****************************************************************************
/// * Widget: AppBar
/// * Descripción: AppBar reutilizable y personalizable.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';
import '../../Utils/Enums/list_color.dart';

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
}) => AppBar(
    leading: showLeading
        ? IconButton(
            icon: Icon(iconAppBar ?? Icons.arrow_back, weight: 400, size: 30),
            color: leadingIconColor, // Usar el color del icono
            onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
          )
        : const SizedBox(width: 56.0),
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: sizeTitle ?? 20,
        color:
            colorText ??
            TipoColores.seasalt.value, // Usar el color de texto personalizado
      ),
    ),
    centerTitle: true,
    backgroundColor:
        backgroundColor ??
        Colors.transparent, // Usar el color de fondo personalizado
    actions: [
      ...?actions,
    ],
    elevation: 0,
  );
