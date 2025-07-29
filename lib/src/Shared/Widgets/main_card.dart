/// ****************************************************************************
/// * Widget: CustomMainCard
/// * Fecha: 2025
/// * Descripción: Widget de tarjeta para mostrar título, descripción y un ícono de acción.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';

class CustomMainCard extends StatelessWidget {
  const CustomMainCard({
    super.key,
    required this.title,
    required this.description,
    this.actionIcon = Icons.list,
    required this.actionCard,
    this.backgroundColor = TipoColores.seasalt, // Color de fondo predeterminado
    this.titleColor =
        TipoColores.pantone634C, // Color del título predeterminado
    this.descriptionColor =
        TipoColores.airBlue, // Color de la descripción predeterminado
  });

  /// El texto principal que se muestra en la tarjeta.
  final String title;

  /// El texto secundario que proporciona una descripción.
  final String description;

  /// El icono que se muestra en la parte derecha de la tarjeta.
  final IconData? actionIcon;

  /// La función que se ejecuta cuando se toca cualquier parte de la tarjeta.
  final VoidCallback? actionCard;

  /// El color de fondo de la tarjeta.
  final TipoColores backgroundColor;

  /// El color del texto del título.
  final TipoColores titleColor;

  /// El color del texto de la descripción.
  final TipoColores descriptionColor;

  @override
  Widget build(final BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: TipoColores.pantone663C.value, // Color de la sombra
          offset: const Offset(
            4,
            4,
          ), // Desplazamiento: 4 a la derecha, 4 hacia abajo
          blurRadius: 8, // Qué tan difuminada está la sombra
          spreadRadius: 1, // Qué tan extendida está la sombra
        ),
      ],
    ),
    child: Card(
      color: backgroundColor.value,
      margin: EdgeInsets
          .zero, // Eliminar el margin del Card para que el Container lo controle
      elevation: 0, // Quitar la elevación por defecto de la Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: actionCard,
        borderRadius: BorderRadius.circular(
          8.0,
        ), // Para que el InkWell respete el borde del Card
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: titleColor.value,
                      ),
                      maxLines: 1, // Para evitar que el título se desborde
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: descriptionColor.value,
                      ),
                      maxLines: 1, // Para evitar que la descripción se desborde
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (actionIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  //Icono de la tarjeta
                  child: IconButton(
                    icon: Icon(
                      actionIcon,
                      size: 30,
                      color: TipoColores.airBlue.value,
                    ),
                    onPressed: actionCard,
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
