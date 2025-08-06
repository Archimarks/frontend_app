/// ****************************************************************************
/// * Widget: CustomTextField
/// * Fecha: 2025
/// * Descripción: Widget de campo de texto reutilizable y personalizable.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';

/// ### Widget de campo de texto reutilizable.
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    this.activeColor = TipoColores.airBlue,
    this.inactiveColor = TipoColores.pantoneCool,
    this.onChanged,
    this.validator,
    this.maxLength = 100,
    this.showCounter = false,
  });

  /// Texto de etiqueta para el campo.
  final String? labelText;

  /// Icono al inicio del campo.
  final IconData? prefixIcon;

  final TipoColores activeColor; // Color para cuando está enfocado
  final TipoColores inactiveColor; // Color para cuando no está enfocado

  /// Controlador para gestionar el texto.
  final TextEditingController? controller;

  /// Callback que se ejecuta cuando el texto cambia.
  final ValueChanged<String>? onChanged;

  /// Función para validar el contenido del campo.
  final String? Function(String?)? validator;

  /// Longitud máxima del texto permitido.
  final int? maxLength;

  /// Mostrar el contador de caracteres.
  final bool showCounter;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // Un FocusNode para detectar el enfoque
  late FocusNode _focusNode;
  bool _isFocused = false; // Estado para saber si el campo está enfocado

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Listener para saber cuándo cambia el enfoque
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // Actualiza el estado cuando el enfoque cambia
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(final BuildContext context) {
    // Color gris para el estado inactivo
    final Color inactiveColor = widget.inactiveColor.value;
    // Color azul para el estado activo
    final Color activeColor = widget.activeColor.value;

    return TextFormField(
      focusNode: _focusNode, // Asignar el FocusNode al TextFormField
      controller: widget.controller,
      onChanged: (final String value) {
        // Llamar al onChanged original si existe
        widget.onChanged?.call(value);
        // Actualizar el estado para que se redibuje el widget con el nuevo contador
        setState(() {});
      },
      validator: widget.validator,
      maxLength: widget.maxLength,
      // Color del texto ingresado: activo si está enfocado, inactivo si no lo está
      style: TextStyle(
        color: TipoColores.pantoneBlackC.value,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        // Color de la etiqueta: activo si está enfocado, inactivo si no lo está
        labelStyle: TextStyle(color: _isFocused ? activeColor : inactiveColor),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                // Color del icono: activo si está enfocado, inactivo si no lo está
                color: _isFocused ? activeColor : inactiveColor,
              )
            : null,
        // Color de la barra inferior cuando el campo NO está enfocado
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: inactiveColor), // Color gris
        ),
        // Color de la barra inferior cuando el campo SÍ está enfocado
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: activeColor), // Color azul
        ),
        border: const UnderlineInputBorder(), // Borde por defecto
        // Contador de caracteres
        counterText: widget.showCounter
            ? widget.maxLength != null
                  ? '${widget.controller?.text.length ?? 0}/${widget.maxLength}'
                  : null
            : null,
      ),
    );
  }
}
