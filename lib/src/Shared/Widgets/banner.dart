/// ****************************************************************************
/// * Widget: CustomBanner
/// * Fecha: 2025
/// * Descripción: Widget de banner reutilizable para mostrar mensajes informativos o de error.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

/// Widget de banner reutilizable para mostrar mensajes informativos o de error.
class CustomBanner extends StatelessWidget {
  const CustomBanner({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(final BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
}
