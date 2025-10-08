/// Modelo para manejar los atributos/datos de los encuentros
class MeetingModel {
  MeetingModel({
    required this.encuId,
    required this.encuTipoEncuentro,
    required this.encuEsenId,
    required this.encuIdGrupo,
    required this.encuAsunto,
    required this.encuDescripcion,
    required this.encuDuracionEncuentro,
    required this.encuAsistencias,
    required this.encuInasistencias,
    required this.encuActas,
    required this.encuRolDirigido,
    required this.encuLiderEncuentro,
    required this.encuEstado,
    required this.creador,
  });

  /// Crear objeto desde JSON
  factory MeetingModel.fromJson(final Map<String, dynamic> json) =>
      MeetingModel(
        encuId: json['ENCU_ID'] ?? 0,
        encuEsenId: json['ENCU_ESENID'] ?? 0,
        encuRolDirigido: json['ENCU_ROLDIRIGIDOID'] ?? '',
        encuTipoEncuentro: json['ENCU_TIPOENCUENTRO'] ?? '',
        encuIdGrupo: json['ENCU_IDGRUPO'] ?? 0,
        encuAsunto: json['ENCU_ASUNTO'] ?? '',
        encuDescripcion: json['ENCU_DESCRIPCION'] ?? '',
        encuDuracionEncuentro: json['ENCU_DURACIONTOTALENCUENTRO'] ?? 0,
        encuAsistencias: json['ENCU_ASISTENCIAS'] ?? 0,
        encuInasistencias: json['ENCU_INASISTENCIAS'] ?? 0,
        creador: json['ENCU_CREADOPOR'] ?? 0,
        encuLiderEncuentro: json['ENCU_LIDERENCUENTRO'] ?? 0,
        encuActas: json['ENCU_ACTAS'] ?? false,
        encuEstado: json['ENCU_ESTADO'] ?? '',
      );
  final int encuId;
  final String encuTipoEncuentro;
  final int encuIdGrupo;
  final int encuEsenId;
  final String encuAsunto;
  final String encuDescripcion;
  final int encuDuracionEncuentro;
  final int encuAsistencias;
  final int encuInasistencias;
  final bool encuActas;
  final String encuRolDirigido;
  final String encuLiderEncuentro;
  final String encuEstado;
  final int creador;

  /// Convertir objeto a JSON
  Map<String, dynamic> toJson() => {
    'ENCU_ID': encuId,
    'ENCU_ESENID': encuEsenId,
    'ENCU_ROLDIRIGIDOID': encuRolDirigido,
    'ENCU_TIPOENCUENTRO': encuTipoEncuentro,
    'ENCU_IDGRUPO': encuIdGrupo,
    'ENCU_ASUNTO': encuAsunto,
    'ENCU_DESCRIPCION': encuDescripcion,
    'ENCU_DURACIONTOTALENCUENTRO': encuDuracionEncuentro,
    'ENCU_ASISTENCIAS': encuAsistencias,
    'ENCU_INASISTENCIAS': encuInasistencias,
    'ENCU_CREADOPOR': creador,
    'ENCU_LIDERENCUENTRO': encuLiderEncuentro,
    'ENCU_ESTADO': encuEstado,
    'ENCU_ACTAS': encuActas,
  };
}
