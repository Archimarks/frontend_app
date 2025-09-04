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

class CustomSelectionField extends StatefulWidget {
  const CustomSelectionField({
    super.key,
    required this.title,
    required this.displayValue, // El valor a mostrar
    required this.onPressed, // Callback que se ejecuta al presionar
    required this.prefixIcon,
    this.iconColor = TipoColores.pantoneCool,
    this.backgroundColor = TipoColores.seasalt,
  });

  final String title;
  final String? displayValue;
  final VoidCallback? onPressed;
  final IconData? prefixIcon;
  final TipoColores iconColor;
  final TipoColores backgroundColor;

  @override
  // ignore: library_private_types_in_public_api
  _CustomSelectionFieldState createState() => _CustomSelectionFieldState();
}

class _CustomSelectionFieldState extends State<CustomSelectionField> {
  @override
  Widget build(final BuildContext context) => GestureDetector(
    onTap: widget.onPressed, // Llama a la función del widget padre
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.backgroundColor.value,
        border: Border(bottom: BorderSide(color: widget.iconColor.value)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35, bottom: 5),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.iconColor.value,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (widget.prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 11),
                  child: Icon(widget.prefixIcon, color: widget.iconColor.value),
                ),
              Expanded(
                child: Text(
                  widget.displayValue ??
                      '', // Muestra un valor por defecto si es nulo
                  style: TextStyle(
                    color: TipoColores.pantoneBlackC.value,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
