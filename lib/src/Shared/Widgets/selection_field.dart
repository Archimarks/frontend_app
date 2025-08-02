/// ****************************************************************************
/// * Widget: CustomSelectionField
/// * Fecha: 2025
/// * Descripción: Widget de selección que ejecuta una acción al ser presionado y
/// *              muestra un valor dinámico.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';

class CustomSelectionField extends StatelessWidget {
  const CustomSelectionField({
    super.key,
    required this.title,
    required this.displayValue, // El valor a mostrar
    required this.onPressed, // Callback que se ejecuta al presionar
    this.prefixIcon,
    this.iconColor = TipoColores.pantoneCool,
    this.backgroundColor = TipoColores.seasalt,
  });

  final String title;
  final String? displayValue;
  final VoidCallback onPressed;
  final IconData? prefixIcon;
  final TipoColores iconColor;
  final TipoColores backgroundColor;

  @override
  Widget build(final BuildContext context) {
    // Si el valor a mostrar es nulo, se muestra el título.
    final String textToDisplay = displayValue ?? title;

    return GestureDetector(
      onTap: onPressed, // Llama directamente a la función pasada por el padre
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor.value,
          border: const Border(
            bottom: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
        child: Row(
          children: [
            if (prefixIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(prefixIcon, color: iconColor.value),
              ),
            Expanded(
              child: Text(
                textToDisplay,
                style: TextStyle(
                  color: TipoColores.pantoneBlackC.value,
                  fontSize: 16,
                  fontWeight: displayValue != null
                      ? FontWeight.bold
                      : FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: iconColor.value),
          ],
        ),
      ),
    );
  }
}
