/// ****************************************************************************
/// * Widget: Button
/// * Descripción: Botón reutilizable con sombra, estilos personalizados y opción para deshabilitar con color específico.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';

typedef _ButtonContent = ({Widget? child, String semanticLabel});

class CustomButton extends StatelessWidget {

  const CustomButton({
    super.key,
    required this.color,
    this.text,
    this.icon,
    this.onPressed,
    this.colorIcon = TipoColores.seasalt, // Color por defecto del ícono
    this.width = 250,
    this.height = 50,
    this.sizeIcon = 30, // Tamaño por defecto del ícono
    this.borderRadius = 15, // Radio de borde por defecto
    this.enabled = true, // Por defecto el botón está habilitado
    this.showDecoration = true, // Por defecto se muestra la decoración
    this.disabledColor =
        TipoColores.pantoneCool, // Color por defecto cuando está deshabilitado
  });

  final String? text;
  final IconData? icon;
  final TipoColores color;
  final TipoColores colorIcon;
  final VoidCallback? onPressed; // Es nulo si el botón está deshabilitado
  final double width;
  final double height;
  final double sizeIcon;
  final double borderRadius;
  final bool enabled; // Parámetro para controlar si el botón está habilitado
  final TipoColores?
  disabledColor; // Parámetro para el color cuando está deshabilitado
  final bool showDecoration;

  @override
  Widget build(final BuildContext context) => Container(
      width: width,
      height: height,
      decoration: showDecoration
          ? BoxDecoration(
              boxShadow: enabled
                  ? [
                      BoxShadow(
                      color: TipoColores.pantone663C.value.withAlpha(
                        (0.4 * 255).toInt(),
                      ),
                        blurRadius: 10,
                      spreadRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            )
          : null, // Solo aplica decoración si showDecoration es true
      child: ElevatedButton(
        onPressed: enabled
            ? onPressed
            : null, // Solo llama a onPressed si enabled es true
        style: _buttonStyle(),
        child: Semantics(
          label: _buildContentAndSemanticLabel()
              .semanticLabel, // Usa la etiqueta semántica determinada
          child: _buildContentAndSemanticLabel()
              .child, // El widget hijo ya está determinado
        ),
      ),
    );

  // Método auxiliar para construir el widget hijo y obtener la etiqueta semántica
  _ButtonContent _buildContentAndSemanticLabel() {
    Widget? buttonChild;
    String finalSemanticLabel = '';

    if (text != null && icon != null) {
      // Caso: Texto Y Ícono combinados
      buttonChild = Row(
        mainAxisSize:
            MainAxisSize.min, // El Row solo ocupa el espacio necesario
        mainAxisAlignment:
            MainAxisAlignment.center, // Centra el contenido horizontalmente
        children: [
          Icon(icon!, color: colorIcon.value, size: sizeIcon),
          const SizedBox(width: 20), // Espacio entre ícono y texto
          Text(
            text!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorIcon.value,
            ),
          ),
        ],
      );
      finalSemanticLabel =
          '$text (Ícono)'; // Etiqueta combinada para accesibilidad
    } else if (text != null) {
      // Caso: Solo Texto
      buttonChild = Text(
        text!,
        style: TextStyle(
          fontFamily: 'Libre Franklin',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorIcon.value,
        ),
      );
      finalSemanticLabel = text!;
    } else if (icon != null) {
      // Caso: Solo Ícono
      buttonChild = Icon(icon!, color: colorIcon.value, size: sizeIcon);
      finalSemanticLabel = 'Ícono de botón'; // Etiqueta por defecto para ícono
    } else {
      // Esto no debería ocurrir debido al assert en el constructor,
      // pero es bueno tener un fallback.
      buttonChild = Container();
      finalSemanticLabel = 'Botón';
    }

    return (child: buttonChild, semanticLabel: finalSemanticLabel);
  }

  /// Método para centralizar el estilo del botón y mejorar la modularidad.
  ButtonStyle _buttonStyle() => ElevatedButton.styleFrom(
    backgroundColor: color.value, // Usa el color específico
    disabledBackgroundColor:
        disabledColor?.value ??
        TipoColores
            .pantoneCool
            .value, // Usa el color específico o un gris si es nulo
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
}
