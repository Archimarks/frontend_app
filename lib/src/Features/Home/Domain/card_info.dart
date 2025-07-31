// Clase para modelar la información de cada tarjeta
class CardInfo {

  CardInfo({
    required this.codigoCard,
    required this.titulo,
    required this.descripcion,
    required this.rol,
  });

  factory CardInfo.fromJson(final Map<String, dynamic> json) => CardInfo(
      codigoCard: json['codigoCard'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      rol: json['rol'] as Map<String, dynamic>,
    );
  final int codigoCard;
  final String titulo;
  final String descripcion;
  final Map<String, dynamic> rol;
}
