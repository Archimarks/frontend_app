class CardInfo {
  CardInfo({
    required this.codigoCard,
    required this.titulo,
    required this.descripcion,
    required this.rol,
    this.route,
  });

  factory CardInfo.fromJson(final Map<String, dynamic> json) => CardInfo(
      codigoCard: json['codigoCard'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      rol: json['rol'] as Map<String, dynamic>,
    route: json['route'] as String?, // <-- opcional
  );

  final int codigoCard;
  final String titulo;
  final String descripcion;
  final Map<String, dynamic> rol;
  final String? route; // <-- opcional
}
