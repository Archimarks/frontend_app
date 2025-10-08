import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// ****************************************************************************
/// ### ScheduleData
/// * Fecha: 2025
/// * Descripción: Clase de datos para manejar un solo horario
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
class ScheduleData {
  ScheduleData({
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.selectedLocationID,
    this.selectedRepeat = 1,
    this.selectedTime = 2,
    this.selectedLocationName,
    this.repeat = false,
    this.dayName,
  });

  /// Crea un objeto ScheduleData desde el JSON de la API (para leer)
  factory ScheduleData.fromJson(final Map<String, dynamic> json) {
    TimeOfDay? parseTime(final String? timeString) {
      if (timeString == null || timeString.isEmpty) {
        return null;
      }
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        return TimeOfDay(hour: hour, minute: minute);
      }
      return null;
    }

    return ScheduleData(
      startDate: json['HORA_FECHAINICIO'] != null
          ? DateTime.tryParse(json['HORA_FECHAINICIO'])
          : null,
      endDate: json['HORA_FECHAFIN'] != null
          ? DateTime.tryParse(json['HORA_FECHAFIN'])
          : null,
      startTime: parseTime(json['HORA_HORAINICIO']),
      endTime: parseTime(json['HORA_HORAFIN']),
      selectedLocationName: json['HORA_UBICACION'],
      selectedLocationID: json['HORA_ID']?.toString(),
    );
  }

  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;
  String? selectedLocationName;
  String? selectedLocationID;
  int? selectedRepeat;
  int selectedTime;
  bool repeat;
  String? dayName;

  /// Convierte el objeto local en un mapa JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    // Formato de fecha que .NET entiende
    final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

    String? fechaInicio;
    String? fechaFin;

    if (startDate != null && startTime != null) {
      final combinedStart = DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
        startTime!.hour,
        startTime!.minute,
      );
      fechaInicio = dateFormat.format(combinedStart);
    }

    if (endDate != null && endTime != null) {
      final combinedEnd = DateTime(
        endDate!.year,
        endDate!.month,
        endDate!.day,
        endTime!.hour,
        endTime!.minute,
      );
      fechaFin = dateFormat.format(combinedEnd);
    }

    return {
      'HORA_FECHAINICIO': fechaInicio ?? dateFormat.format(DateTime.now()),
      'HORA_FECHAFIN': fechaFin ?? dateFormat.format(DateTime.now()),
      'HORA_HORAINICIO': startTime != null
          ? "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}:00"
          : '00:00:00',
      'HORA_HORAFIN': endTime != null
          ? "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}:00"
          : '00:00:00',
      'HORA_DURACION': (startTime != null && endTime != null)
          ? ((endTime!.hour * 60 + endTime!.minute) -
                (startTime!.hour * 60 + startTime!.minute))
          : 0,
      'HORA_UBICACION': selectedLocationName ?? 'Sin ubicación',
    };
  }
}
