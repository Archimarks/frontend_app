/// ****************************************************************************
/// * Widget: Card
/// * Fecha: 2025
/// * Descripción: Widget de tarjeta que muestra información y contiene uno u varios botones;
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';

class CustomCard extends StatelessWidget { // Para los botones en la parte inferior

  const CustomCard({
    super.key,
    required this.content,
    this.title,
    this.padding = 10,
    this.codigo,
    this.backgroundColor = TipoColores.seasalt,
    this.onTap,
    this.actions,
    this.colorHeader,
    this.leading,
    this.trailing,
    this.headerAlignment = MainAxisAlignment.spaceBetween,
  });

  final String? title;
  final String? codigo;
  final double padding;
  final Widget content;
  final TipoColores backgroundColor;
  final TipoColores? colorHeader; // Ahora puede ser nulo
  final VoidCallback? onTap;
  final List<Widget>? actions;
  final Widget? leading; // Widget inicial
  final Widget? trailing; // Widget final
  final MainAxisAlignment headerAlignment;

  @override
  Widget build(final BuildContext context) => Card(
      color: backgroundColor.value.withAlpha((0.7 * 255).toInt()),
      margin: const EdgeInsets.all(8.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) _buildHeader(),
            SizedBox(height: padding),
            Padding(
              // Este padding es para el contenido inferior
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ), // Ajusta según necesites
              child: Column(
                children: [
                  content, // Aquí se inyecta el contenido específico de cada tarjeta
                  SizedBox(height: padding),
                ],
              ),
            ),
            if (actions != null && actions!.isNotEmpty) ...[
              SizedBox(height: padding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: actions!,
              ),
            ],
            SizedBox(height: padding), // Padding inferior para la tarjeta
          ],
        ),
      ),
    );

  /// --------------------------------------------------------------------------
  /// Texto que muestra el título del widget.
  /// --------------------------------------------------------------------------
  Widget _buildHeader() => Container(
      decoration: BoxDecoration(
        color: colorHeader?.value, // El color de fondo de tu encabezado
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(
            8.0,
          ), // Redondea la esquina superior izquierda
          topRight: Radius.circular(
            8.0,
          ), // Redondea la esquina superior derecha
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ), // Padding interno para el texto
      child: Row(
        mainAxisAlignment: codigo == null
            ? MainAxisAlignment
                  .center // Centra si no hay código
            : MainAxisAlignment.spaceBetween, // Espacio entre título y código
        children: [
          Expanded(
            // Usamos Expanded para que el título ocupe el espacio disponible
            child: Text(
              title ?? '',
              style: TextStyle(
                fontFamily: 'Libre Franklin',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: TipoColores.pantoneBlackC.value,
              ),
              textAlign: codigo == null
                  ? TextAlign.center
                  : TextAlign.start, // Alinea el texto si está centrado
            ),
          ),
          if (codigo != null)
            Text(
              codigo!,
              style: TextStyle(
                fontFamily: 'Libre Franklin',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: TipoColores.pantoneBlackC.value,
              ),
            ),
        ],
      ),
    );
}
