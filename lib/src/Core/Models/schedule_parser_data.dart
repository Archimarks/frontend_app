// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

class ScheduleParserResult {

/// Guardar el resultado del parseo realizado a atributos del grupo
  ScheduleParserResult({
    required this.startTime,
    required this.endTime,
    required this.location,
  });
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String location;
}

class ScheduleParser {

  /// Convierte "1400" → TimeOfDay(14:00)
  static TimeOfDay parseHourString(final String text) {
    final hour = int.parse(text.substring(0, 2));
    final minute = int.parse(text.substring(2, 4));
    return TimeOfDay(hour: hour, minute: minute);
  }

  /// Convierte "<b>1400 - 1659</b><BR/>Salón: 7203" → objeto con horaInicio, horaFin y ubicación
  static ScheduleParserResult? parseScheduleString(final String? text) {
    if (text == null || text.isEmpty) {
      return null;
    }

    final cleaned = text
        .replaceAll('<b>', '')
        .replaceAll('</b>', '')
        .replaceAll('<BR/>', ' ')
        .trim();

    final parts = cleaned.split(RegExp(r'\s+'));

    final start = parseHourString(parts[0]); // 1400 → 14:00
    final end = parseHourString(parts[2]); // 1659 → 16:59

    final locationIndex = parts.indexOf('Salón:');
    final location = locationIndex != -1
        ? parts.sublist(locationIndex).join(' ')
        : 'Ubicación no definida';

    return ScheduleParserResult(
      startTime: start,
      endTime: end,
      location: location,
    );
  }

  // -------------------------
  // Métodos de formateo
  // -------------------------

  /// Formatea un TimeOfDay a String.
  /// Si se pasa [context], usa time.format(context) (localizado).
  /// Si no, usa un formateo 12h manual "h:mm AM/PM".
  static String formatTimeOfDay(final TimeOfDay time, {final BuildContext? context}) {
    if (context != null) {
      return time.format(context);
    }

    // Formateo manual a 12h "h:mm AM/PM"
    final hourOfPeriod = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hourOfPeriod:$minute $period';
  }

  /// Igual que formatTimeOfDay pero acepta nullable y devuelve un texto por defecto
  static String formatTimeNullable(
    final TimeOfDay? time, {
    final BuildContext? context,
    final String nullText = '--:--',
  }) {
    if (time == null) {
      return nullText;
    }
    return formatTimeOfDay(time, context: context);
  }

  /// Formatea un rango (start - end) cómodo para mostrar en la UI.
  static String formatRange(
    final TimeOfDay? start,
    final TimeOfDay? end, {
    final BuildContext? context,
    final String nullText = '--:--',
  }) {
    final startStr = formatTimeNullable(
      start,
      context: context,
      nullText: nullText,
    );
    final endStr = formatTimeNullable(
      end,
      context: context,
      nullText: nullText,
    );
    return '$startStr - $endStr';
  }

  /// Formatea un ScheduleParserResult a texto como "2:00 PM - 4:59 PM (Salón: 7203)"
  static String formatParsedResult(
    final ScheduleParserResult parsed, {
    final BuildContext? context,
  }) {
    final range = formatRange(
      parsed.startTime,
      parsed.endTime,
      context: context,
    );
    return '$range (${parsed.location})';
  }
}
