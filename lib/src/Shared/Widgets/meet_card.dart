/// ****************************************************************************
/// * Widget: CustomMeetCard
/// * Fecha: 2025
/// * Descripción: Widget de tarjeta para mostrar información del encuentro y botones de acción opcionales.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';

class CustomMeetCard extends StatelessWidget {
  const CustomMeetCard({
    super.key,
    required this.hourAndDate,
    required this.title,
    required this.description,
    this.showButtonDelete = false,
    required this.actionCard,
    this.onDeletePressed,
    this.actionIcon = Icons.delete,
    this.backgroundColor =
        TipoColores.pantone663C, // Color de fondo predeterminado
    this.dateColor = TipoColores.gris,
    this.titleColor =
        TipoColores.pantoneBlackC, // Color del título predeterminado
    this.descriptionColor =
        TipoColores.pantoneBlackC, // Color de la descripción predeterminado
    this.iconColor = TipoColores.seasalt, // Color del icono predeterminado
    this.buttonColor = TipoColores.pantone7621C, // Color del botón
  });

  /// El texto de la hora y fecha que se muestra en la tarjeta.
  final String hourAndDate;

  /// El titulo del encuentro que se muestra en la tarjeta.
  final String title;

  /// La descripción del encuentro.
  final String description;

  /// Indica si se debe mostrar el botón
  final bool showButtonDelete;

  /// El icono que se muestra en la parte derecha de la tarjeta.
  final IconData? actionIcon;

  /// La función que se ejecuta cuando se toca cualquier parte de la tarjeta.
  final VoidCallback? actionCard;

  /// La función que se ejecuta cuando se presiona el botón de eliminar.
  final VoidCallback? onDeletePressed;

  /// El color de fondo de la tarjeta.
  final TipoColores backgroundColor;

  /// El color del texto de la hora y fecha.
  final TipoColores dateColor;

  /// El color del texto del título.
  final TipoColores titleColor;

  /// El color del texto de la descripción.
  final TipoColores descriptionColor;

  /// El color del texto del icono.
  final TipoColores iconColor;

  /// El color del texto del botón.
  final TipoColores buttonColor;

  @override
  Widget build(final BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: TipoColores.pantoneCool.value,
          offset: const Offset(2, 2),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
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
                // Contenido de la tarjeta (textos)
                _infoCard(),
                ?_buttonDelete(),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _infoCard() => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hourAndDate,
            style: TextStyle(fontSize: 12, color: dateColor.value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: titleColor.value,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: descriptionColor.value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );

  Widget? _buttonDelete() {
    if (showButtonDelete) {
      return InkWell(
        onTap: onDeletePressed,
        child: Container(
          width: 40,
          color: buttonColor.value,
          child: Center(
            child: Icon(actionIcon, color: iconColor.value, size: 30),
          ),
        ),
      );
    } else {
      return null;
    }
  }
}
