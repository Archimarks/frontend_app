/// *****************************************************************
/// * Nombre del Archivo: app_router.dart
/// * Ruta: lib\src\Core\Routes\app_router.dart
/// * Descripción:
/// * Configura e instancia el objeto GoRouter principal de la aplicación,
/// * definiendo la navegación a través de la lista de rutas provista por el archivo routes_config.dart.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// * Notas:
/// *      - Se establece '/login' como ruta inicial.
/// *      - La propiedad debugLogDiagnostics está habilitada para facilitar el debug de navegación.
/// *
/// *****************************************************************
library;

import 'package:go_router/go_router.dart';

import 'routes_config.dart';

/// Instancia global del router de navegación para la aplicación.
/// Utiliza las rutas definidas en [appRoutes] y establece la vista de login como inicial.
final GoRouter appRouter = GoRouter(
  routes: appRoutes,
  initialLocation: '/myMeets',
  debugLogDiagnostics: true,
);
