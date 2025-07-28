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

  /// Nombre de la ruta para la vista Splash o de carga inicial.
  static const splash = 'splash';

  /// Nombre de la ruta para la vista inicial.
  static const meetOptions = 'meetOptions';
}
