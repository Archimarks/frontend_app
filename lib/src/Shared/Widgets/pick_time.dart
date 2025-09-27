import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';
import '../../Core/Barrels/widgets_shared_barrel.dart';
import '../../Core/Models/schedule_parser_data.dart';

class PickedTime extends StatelessWidget {

  const PickedTime({super.key, required this.title, this.time, this.onPressed});
  final String title;
  final TimeOfDay? time;
  final VoidCallback? onPressed;

  /// Método estático para mostrar el selector de hora
  static Future<TimeOfDay?> showTime(
    final BuildContext context, {
    final TimeOfDay? initialTime,
  }) async {
    final ThemeData customTheme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: TipoColores.pantone634C.value,
        onSurface: TipoColores.pantoneBlackC.value,
        surface: TipoColores.seasalt.value,
        onPrimary: TipoColores.seasalt.value,
        onSecondary: TipoColores.seasalt.value,
        secondary: TipoColores.pantone634C.value,
      ),
      timePickerTheme: TimePickerThemeData(
        dialBackgroundColor: TipoColores.pantone663C.value,
      ),
    );

    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (final BuildContext context, final Widget? child) =>
          Theme(data: customTheme, child: child!),
    );
  }

  @override
  Widget build(final BuildContext context) => CustomSelectionField(
      title: title,
      prefixIcon: Icons.access_time_rounded,
      displayValue: time != null
          ? ScheduleParser.formatTimeOfDay(time!, context: context)
          : 'Seleccionar hora',
      onPressed: onPressed,
    );
}
