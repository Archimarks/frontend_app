/// ****************************************************************************
/// * Widget: CustomUsersCard
/// * Fecha: 2025
/// * Descripción: Widget de tarjeta para mostrar información de los usuarios y botones de acción opcionales.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';

class CustomUsersCard extends StatelessWidget {
  const CustomUsersCard({
    super.key,
    required this.nameUser,
    this.emailUser,
    required this.showButton,
    required this.actionCard,
    required this.onButtonPressed,
    required this.showNumber,
    this.buttonColor = TipoColores.pantone634C, // Color del botón
    this.numberIndicator = 1,
    this.actionIcon = Icons.check_box_outline_blank,
    this.backgroundColor =
        TipoColores.pantone663C, // Color de fondo predeterminado
    this.numberColor = TipoColores.pantone634C,
    this.textColor =
        TipoColores.pantoneBlackC, // Color del texto predeterminado
    this.numberTextColor =
        TipoColores.seasalt, // Color del número predeterminado
    this.enableShadow = true,
  });

  /// El nombre del usuario.
  final int numberIndicator;

  /// El nombre del usuario.
  final String nameUser;

  /// El email del usuario.
  final String? emailUser;

  /// Indica si se debe mostrar el botón
  final bool showButton;

  /// Indica si se debe mostrar el número indicativo
  final bool showNumber;

  /// El icono que se muestra en la parte derecha de la tarjeta.
  final IconData? actionIcon;

  /// La función que se ejecuta cuando se toca cualquier parte de la tarjeta.
  final VoidCallback? actionCard;

  /// La función que se ejecuta cuando se presiona el botón de eliminar.
  final VoidCallback? onButtonPressed;

  /// El color de fondo de la tarjeta.
  final TipoColores backgroundColor;

  /// El color del container del número indicativo.
  final TipoColores numberColor;

  /// El color del texto de la tarjeta.
  final TipoColores textColor;

  /// El color del texto del número indicativo.
  final TipoColores numberTextColor;

  /// El color del botón.
  final TipoColores buttonColor;

  /// Habilitar sombra
  final bool enableShadow;

  @override
  Widget build(final BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: enableShadow
          ? [
              BoxShadow(
                color: TipoColores.pantoneCool.value,
                offset: const Offset(0.5, 0.5),
                blurRadius: 10,
                spreadRadius: 0.5,
              ),
            ]
          : null,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Material(
        color: backgroundColor.value,
        child: InkWell(
          onTap: actionCard,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Contenido de la tarjeta
                // Número indicativo
                ?_numberIndicator(),
                // Información del usuario
                _infoCard(),
                // Botón de acción
                ?_buttonCheck(),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget? _numberIndicator() {
    if (showNumber) {
      return InkWell(
        onTap: actionCard,
        child: Container(
          width: 35,
          color: numberColor.value,
          child: Center(
            child: Text(
              numberIndicator.toString(),
              style: TextStyle(
                color: numberTextColor.value,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    } else {
      return null;
    }
  }

  Widget _infoCard() => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nameUser,
            style: TextStyle(fontSize: 13, color: textColor.value),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          if (emailUser != null && emailUser!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              emailUser!,
              style: TextStyle(fontSize: 12, color: textColor.value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ),
  );

  Widget? _buttonCheck() {
    if (showButton) {
      return InkWell(
        onTap: onButtonPressed,
        child: Container(
          padding: const EdgeInsets.only(right: 10),
          width: 40,
          color: backgroundColor.value,
          child: Center(
            child: Icon(actionIcon, color: buttonColor.value, size: 30),
          ),
        ),
      );
    } else {
      return null;
    }
  }
}
