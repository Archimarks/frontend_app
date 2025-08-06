/// ****************************************************************************
/// * Widget: CustomUsersCard
/// * Fecha: 2025
/// * Descripción: Widget de tarjeta para mostrar información de los usuarios
/// * y botones de acción opcionales.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';

class CustomUsersCard extends StatefulWidget {
  const CustomUsersCard({
    super.key,
    required this.textMain,
    this.textSecondary,
    required this.showButton,
    required this.actionCard,
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

  /// Número indicador de la tarjeta.
  final int numberIndicator;

  /// Texto principal de la tarjeta.
  final String textMain;

  /// Texto secundario de la tarjeta (opcional).
  final String? textSecondary;

  /// Indica si se debe mostrar el botón de acción.
  final bool showButton;

  /// Indica si se debe mostrar el número indicativo
  final bool showNumber;

  /// El icono del botón de acción.
  final IconData? actionIcon;

  /// La función que se ejecuta cuando se toca cualquier parte de la tarjeta.
  final VoidCallback? actionCard;

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
  State<CustomUsersCard> createState() => _CustomUsersCardState();
}

class _CustomUsersCardState extends State<CustomUsersCard> {
  @override
  Widget build(final BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: widget.enableShadow
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
        color: widget.backgroundColor.value,
        child: InkWell(
          onTap: widget.actionCard,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Contenido de la tarjeta
                // Número indicativo
                if (widget.showNumber) _numberIndicator(),
                // Información del usuario
                _infoCard(),
                // Botón de acción
                if (widget.showButton) _buttonCheck(),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _numberIndicator() => InkWell(
    onTap: widget.actionCard,
    child: Container(
      width: 35,
      color: widget.numberColor.value,
      child: Center(
        child: Text(
          widget.numberIndicator.toString(),
          style: TextStyle(
            color: widget.numberTextColor.value,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );

  Widget _infoCard() => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.textMain,
            style: TextStyle(fontSize: 13, color: widget.textColor.value),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.textSecondary != null &&
              widget.textSecondary!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              widget.textSecondary!,
              style: TextStyle(fontSize: 12, color: widget.textColor.value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ),
  );

  Widget _buttonCheck() => InkWell(
    onTap: widget.actionCard,
    child: Container(
      padding: const EdgeInsets.only(right: 10),
      width: 40,
      color: widget.backgroundColor.value,
      child: Center(
        child: Icon(
          widget.actionIcon,
          color: widget.buttonColor.value,
          size: 30,
        ),
      ),
    ),
  );
}
