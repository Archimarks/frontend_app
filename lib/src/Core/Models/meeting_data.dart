import '../Barrels/models_barrel.dart';

/// Modelo para manejar los atributos/datos de los encuentros
class MeetingModel {

  MeetingModel({
    required this.id,
    required this.asunto,
    required this.descripcion,
    required this.duracionTotal,
    required this.asistencias,
    required this.inasistencias,
    required this.esenId,
    required this.rolDirigidoId,
    required this.tipoEncuentro,
    required this.liderEncuentro,
    required this.horarios,
  });

  factory MeetingModel.fromJson(final Map<String, dynamic> json) => MeetingModel(
      id: json['ENCU_ID'] ?? 0,
      asunto: json['ENCU_ASUNTO'] ?? '',
      descripcion: json['ENCU_DESCRIPCION'] ?? '',
      duracionTotal: json['ENCU_DURACIONTOTALENCUENTRO'] ?? 0,
      asistencias: json['ENCU_ASISTENCIAS'] ?? 0,
      inasistencias: json['ENCU_INASISTENCIAS'] ?? 0,
      esenId: json['ENCU_ESENID'] ?? 0,
      rolDirigidoId: json['ENCU_ROLDIRIGIDOID'] ?? 0,
      tipoEncuentro: json['ENCU_TIPOENCUENTRO'] ?? 0,
      liderEncuentro: json['ENCU_LIDERENCUENTRO'] ?? 0,
      horarios:
          (json['Horarios'] as List<dynamic>?)
              ?.map((final h) => ScheduleData.fromJson(h))
              .toList() ??
          [],
    );
  final int id;
  final String asunto;
  final String descripcion;
  final int duracionTotal;
  final int asistencias;
  final int inasistencias;
  final int esenId;
  final int rolDirigidoId;
  final int tipoEncuentro;
  final int liderEncuentro;
  final List<ScheduleData> horarios;
}
