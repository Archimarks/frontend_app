/// Modelo para manejar los atributos/datos de los encuentros
class MeetingModel {

  MeetingModel({
    required this.encuId,
    required this.encuTipoEncuentro,
    required this.encuEsenId,
    required this.encuAsunto,
    required this.encuDescripcion,
    required this.encuDuracionEncuentro,
    required this.encuAsistencias,
    required this.encuInasistencias,
    required this.encuActas,
    required this.encuRolDirigido,
    //required this.creador,
  });

  /// Crear objeto desde JSON
  factory MeetingModel.fromJson(final Map<String, dynamic> json) => MeetingModel(
        encuId: json['encU_ID'] ?? 0,
        encuTipoEncuentro: json['encU_TIPO_ENCUENTRO'] ?? '',
        encuEsenId: json['encU_ESEN_ID'] ?? 0,
        encuAsunto: json['encU_ASUNTO'] ?? '',
        encuDescripcion: json['encU_DESCRIPCION'] ?? '',
        encuDuracionEncuentro: json['encU_DURACION_ENCUENTRO'] ?? 0,
        encuAsistencias: json['encU_ASISTENCIAS'] ?? 0,
        encuInasistencias: json['encU_INASISTENCIAS'] ?? 0,
        encuActas: json['encU_ACTAS'] ?? false,
        encuRolDirigido: json['encU_ROL_DIRIGIDO'] ?? '',
      //creador: json['creador'] ?? 0,
    );
  final int encuId;
  final String encuTipoEncuentro;
  final int encuEsenId;
  final String encuAsunto;
  final String encuDescripcion;
  final int encuDuracionEncuentro;
  final int encuAsistencias;
  final int encuInasistencias;
  final bool encuActas;
  final String encuRolDirigido;
  //final int creador;

  /// Convertir objeto a JSON
  Map<String, dynamic> toJson() => {
      'encu_ID': encuId,
      'encu_TIPO_ENCUENTRO': encuTipoEncuentro,
      'encu_ESEN_ID': encuEsenId,
      'encu_ASUNTO': encuAsunto,
      'encu_DESCRIPCION': encuDescripcion,
      'encu_DURACION_ENCUENTRO': encuDuracionEncuentro,
      'encu_ASISTENCIAS': encuAsistencias,
      'encu_INASISTENCIAS': encuInasistencias,
      'encu_ACTAS': encuActas,
      'encu_ROL_DIRIGIDO': encuRolDirigido,
      //'creador': creador,
    };
}
