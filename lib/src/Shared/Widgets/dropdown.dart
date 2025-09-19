/// ****************************************************************************
/// * Widget: CustomDropdown
/// * Fecha: 2025
/// * Descripción: Widget desplegable personalizado para mostrar opciones.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.title,
    required this.options,
    this.dropdownColor = TipoColores.seasalt,
    required this.onChanged,
    this.initialValue,
    this.prefixIcon,
    this.iconColor = TipoColores.pantoneCool,
    this.borderColor = TipoColores.pantoneCool,
    this.focusedBorderColor = TipoColores.pantone634C,
  });

  final String title;
  final List<String> options;
  final TipoColores dropdownColor;
  final Function(String?)? onChanged;
  final String? initialValue;
  final IconData? prefixIcon;
  final TipoColores iconColor; // Color para el ícono y el título
  final TipoColores borderColor;
  final TipoColores focusedBorderColor;

  @override
  // ignore: library_private_types_in_public_api
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(final BuildContext context) {
    // Definimos los estilos de texto usando el color proporcionado
    final TextStyle labelTextStyle = TextStyle(
      fontSize: 18,
      color: widget.iconColor.value,
    );

    final TextStyle optionTextStyle = TextStyle(
      fontSize: 16,
      color: TipoColores
          .pantoneBlackC
          .value, // Color por defecto para las opciones
      fontWeight: FontWeight.w400,
    );

    // Helper function para crear el borde de línea inferior
    InputBorder buildUnderlineBorder({required final Color color}) =>
        UnderlineInputBorder(borderSide: BorderSide(color: color));

    return DropdownButtonFormField<String>(
      value: _selectedValue,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.title,
        labelStyle: labelTextStyle,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: widget.iconColor.value)
            : null,
        filled: true,
        fillColor: widget.dropdownColor.value,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor.value),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor.value),
        ),
        focusedBorder: buildUnderlineBorder(
          color: widget.focusedBorderColor.value,
        ),
      ),
      style: optionTextStyle,
      items: widget.options
          .map(
            (final String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: optionTextStyle),
            ),
          )
          .toList(),
    );
  }
}
