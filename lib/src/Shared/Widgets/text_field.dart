/// ****************************************************************************
/// * Widget: CustomTextField
/// * Fecha: 2025
/// * Descripción: Widget de campo de texto reutilizable y personalizable.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';

/// Widget de campo de texto reutilizable.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.labelText,
    this.textColor = TipoColores.pantoneBlackC,
    this.prefixIcon,
    this.colorIcon = TipoColores.pantoneBlackC,
    this.controller,
    this.onChanged,
    this.validator,
  });

  /// Texto de etiqueta para el campo.
  final String? labelText;
  final TipoColores textColor;

  /// Icono al inicio del campo.
  final IconData? prefixIcon;
  final TipoColores colorIcon;

  /// Controlador para gestionar el texto.
  final TextEditingController? controller;

  /// Callback que se ejecuta cuando el texto cambia.
  final ValueChanged<String>? onChanged;

  /// Función para validar el contenido del campo.
  final String? Function(String?)? validator;

  @override
  Widget build(final BuildContext context) => TextFormField(
    // TextFormField para poder integrar validación si es necesario
    controller: controller,
    onChanged: onChanged,
    validator: validator,
    style: TextStyle(color: textColor.value),
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: textColor.value),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: colorIcon.value)
          : null,
      // Color de la barra inferior cuando el campo NO está enfocado
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: textColor.value),
      ),
      // Color de la barra inferior cuando el campo SÍ está enfocado
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: textColor.value),
      ),
      border: const UnderlineInputBorder(),
    ),
  );
}
