/// Modelo de grupo para manejar los datos completos
class Grupo {
  Grupo({
    required this.id,
    required this.materia,
    required this.grupo,
    required this.periodo,
    this.lunes,
    this.martes,
    this.miercoles,
    this.jueves,
    this.viernes,
    this.sabado,
    this.domingo,
  });

  factory Grupo.fromJson(final Map<String, dynamic> json) => Grupo(
    id: json['GRUPO_ID'],
    materia: json['MATERIA'],
    grupo: json['GRUPO'],
    periodo: json['PERIODO'],
    lunes: json['LUNES'],
    martes: json['MARTES'],
    miercoles: json['MIERCOLES'],
    jueves: json['JUEVES'],
    viernes: json['VIERNES'],
    sabado: json['SABADO'],
    domingo: json['DOMINGO'],
  );

  final int id;
  final String materia;
  final String grupo;
  final String periodo;
  final String? lunes;
  final String? martes;
  final String? miercoles;
  final String? jueves;
  final String? viernes;
  final String? sabado;
  final String? domingo;
}
