import 'package:flutter/material.dart';

/// ****************************************************************************
/// ### ScheduleData
/// * Fecha: 2025
/// * Descripción: Clase de datos para manejar un solo horario
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
class ScheduleData {
  ScheduleData({
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.selectedLocationName,
    this.selectedLocationID,
    this.selectedRepeat = 1,
    this.selectedTime = 3,
    this.repeat = false,
  });
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;
  String? selectedLocationName;
  String? selectedLocationID;
  int? selectedRepeat;
  int selectedTime;
  bool repeat;
}
