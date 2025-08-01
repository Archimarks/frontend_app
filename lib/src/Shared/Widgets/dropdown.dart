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
  });
  final String title;
  final List<String> options;
  final TipoColores dropdownColor;
  final Function(String?) onChanged;
  final String? initialValue;

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
  Widget build(final BuildContext context) => DropdownButtonFormField<String>(
      value: _selectedValue,
      onChanged: (final newValue) {
        setState(() {
          _selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
      decoration: InputDecoration(
        labelText: widget.title,
        filled: true,
        fillColor: widget.dropdownColor.value,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      items: widget.options.map((final String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
    );
}
