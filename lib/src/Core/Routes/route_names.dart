/// *****************************************************************
/// * Nombre del Archivo: route_names.dart
/// * Ruta: lib\src\Core\Routes\route_names.dart
/// * Descripción:
/// * Define constantes con los nombres lógicos de las rutas utilizadas en la aplicación.
/// * Estos nombres se utilizan para facilitar la navegación y evitar errores por strings duplicados.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// * Notas:
/// *      - Se recomienda usar estos nombres en lugar de strings directos para mantener consistencia.
/// *
/// *****************************************************************
library;

/// Clase abstracta que agrupa los nombres lógicos de las rutas.
abstract class RouteNames {
  /// Nombre de la ruta para la vista de Login.
  static const login = 'login';

  /// Nombre de la ruta para la vista de Home.
  static const home = 'home';

  /// Nombre de la ruta para la vista de encuentros creados.
  static const myMeets = 'myMeets';

  /// Nombre de la ruta para la vista de crear encuentros.
  static const createMeet = 'createMeet';

  /// Nombre de la ruta para la vista de asistir a un encuentro.
  static const attendMeet = 'attendMeet';

  /// Nombre de la ruta para la vista de registrar asistencia a un encuentro.
  static const register = 'register';

  /// Nombre de la ruta para la vista de selección de encuentro para reportes.
  static const typeReports = 'typeReports';

  /// Nombre de la ruta para la vista de encuentros para unirse.
  static const meets = 'meets';

  /// Nombre de la ruta para la vista de generación de QR.
  static const generateQR = 'generateQR';

  /// Nombre de la ruta para la vista de escaneo de QR.
  static const scanerQR = 'scanerQR';

  /// Nombre de la ruta para la vista de registro manual.
  static const registerManual = 'registerManual';
}
