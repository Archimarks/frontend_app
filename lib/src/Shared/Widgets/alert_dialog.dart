/// ****************************************************************************
/// * Widget: AlertDialog
/// * Fecha: 2025
/// * Descripción: Widget que muestra una ventana emergente en la cual se confirma o no una acción.
///   - Recibe el mensaje de la acción que se desea realizar.
///   - Tiene dos botones, uno para confirmar y otro para cancelar, ambos reciben sus acciones por parámetro.
///   - Es totalmente configurable
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

import '../../Utils/Enums/list_color.dart';
import '../Widgets/button.dart';

class CustomAlertDialog extends StatefulWidget {

  const CustomAlertDialog({
    super.key,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
    this.title = 'Alert',
    this.colorHeader = TipoColores.pantone663C,
    this.colorButtonConfirm = TipoColores.pantone7473C,
    this.confirmButtonText = 'Confirm',
    this.cancelButtonText = 'Cancel',
  });
  final String? title;
  final TipoColores colorHeader;
  final TipoColores colorButtonConfirm;
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  // ignore: library_private_types_in_public_api
  _CustomAlertDialogState createState() => _CustomAlertDialogState();

  // Método estático para mostrar el AlertDialog fácilmente
  static Future<void> show(
    final BuildContext context, {
    required final String message,
    required final VoidCallback onConfirm,
    required final VoidCallback onCancel,
    final String? title,
    final TipoColores colorHeader = TipoColores.pantone663C,
    final TipoColores colorButtonConfirm = TipoColores.pantone7473C,
    final String confirmButtonText = 'Confirm',
    final String cancelButtonText = 'Cancel',
  }) async => showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (final BuildContext context) => CustomAlertDialog(
          message: message,
          onConfirm: onConfirm,
          onCancel: onCancel,
          title: title,
          colorHeader: colorHeader,
          colorButtonConfirm: colorButtonConfirm,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
        ),
    );
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  // Variable de estado para controlar si los botones están habilitados
  bool _buttonsEnabled = true;

  @override
  Widget build(final BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: TipoColores.pantone663C.value,
      contentPadding: EdgeInsets.zero,
      content: _portraitLayout(),
    );

  /// --------------------------------------------------------------------------
  /// Texto que muestra el título del widget.
  /// --------------------------------------------------------------------------
  Widget _buildHeader() => Container(
      decoration: BoxDecoration(
        color: widget.colorHeader.value,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(17),
          topRight: Radius.circular(17),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              widget.title!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: TipoColores.pantoneBlackC.value,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

  /// --------------------------------------------------------------------------
  /// Row que contiene los botones.
  /// --------------------------------------------------------------------------
  Widget _buildButtons() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Button(
          color: widget.colorButtonConfirm,
          text: widget.confirmButtonText,
          width: 100,
          showDecoration: false,
          enabled: _buttonsEnabled, // Controlado por el estado local
          onPressed: _buttonsEnabled
              ? () {
                  setState(() {
                    _buttonsEnabled = false; // Deshabilita los botones
                  });
                  widget.onConfirm(); // Ejecuta la acción original
                }
              : null,
        ),
        Button(
          color: TipoColores.pantoneCool,
          text: widget.cancelButtonText, // Usamos widget.cancelButtonText
          width: 100,
          showDecoration: false,
          enabled: _buttonsEnabled, // Controlado por el estado local
          onPressed: _buttonsEnabled
              ? () {
                  setState(() {
                    _buttonsEnabled = false; // Deshabilita los botones
                  });
                  widget.onCancel(); // Ejecuta la acción original
                }
              : null,
        ),
      ],
    );

  /// --------------------------------------------------------------------------
  /// Construye la vista del alert dialog
  /// --------------------------------------------------------------------------
  Widget _portraitLayout() => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.title != null)
          _buildHeader(), // Solo muestra el header si hay un título
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.message, //Descripción que tendrá el alert dialog
            style: TextStyle(
              fontFamily: 'Libre Franklin',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: TipoColores.pantoneBlackC.value,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 30),
        _buildButtons(),
        const SizedBox(height: 20),
      ],
    );
}
