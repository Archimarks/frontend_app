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
    id: json['grupO_ID'],
    materia: json['materia'],
    grupo: json['grupo'],
    periodo: json['periodo'],
    lunes: json['lunes'],
    martes: json['martes'],
    miercoles: json['miercoles'],
    jueves: json['jueves'],
    viernes: json['viernes'],
    sabado: json['sabado'],
    domingo: json['domingo'],
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
