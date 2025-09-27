import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';
import '../../Core/Barrels/widgets_shared_barrel.dart';
import '../../Core/Models/schedule_parser_data.dart';

/// Widget y lógica para seleccionar una fecha
class PickedDate extends StatelessWidget {

  const PickedDate({super.key, required this.title, this.date, this.onPressed});
  final String title;
  final DateTime? date;
  final VoidCallback? onPressed;

  /// Método estático para mostrar el selector de fecha
  static Future<DateTime?> showDate(
    final BuildContext context, {
    final DateTime? initialDate,
    final DateTime? firstDate,
    final DateTime? lastDate,
  }) async {
    final ThemeData customTheme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        surface: TipoColores.seasalt.value,
        primary: TipoColores.pantone634C.value,
        onPrimary: TipoColores.seasalt.value,
        onSurfaceVariant: TipoColores.pantone634C.value,
      ),
    );

    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime(2030),
      builder: (final BuildContext context, final Widget? child) => Theme(data: customTheme, child: child!),
    );
  }

  @override
  Widget build(final BuildContext context) => CustomSelectionField(
      title: title,
      prefixIcon: Icons.calendar_today_rounded,
      displayValue: date != null
          ? ScheduleParser.formatDate(date!)
          : 'Seleccionar fecha',
      onPressed: onPressed,
    );
}
