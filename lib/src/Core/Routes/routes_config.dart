/// *****************************************************************
/// * Nombre del Archivo: routes_config.dart
/// * Ruta: lib\src\Core\Routes\routes_config.dart
/// * Descripción:
/// * Define y centraliza la configuración de rutas de la aplicación utilizando
/// * el paquete go_router. Cada ruta se asocia a un nombre lógico y a una vista.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// * Notas:
/// *      - Para agregar nuevas rutas, incluir una nueva entrada en la lista [appRoutes].
/// *      - La navegación se debe hacer preferiblemente usando el nombre de la ruta.
/// *
/// *****************************************************************
library;

import 'package:go_router/go_router.dart';

import '../../Features/Login/Presentation/Views/login_view.dart';
import '../../Features/Home/Presentation/Views/meet_options_view.dart';
import 'route_names.dart';

/// Lista de rutas disponibles en la aplicación.
/// Utiliza [GoRoute] para declarar la ruta, su nombre y la vista correspondiente.
final List<GoRoute> appRoutes = [
  GoRoute(
    path: '/login',
    name: RouteNames.login,
    builder: (final context, final state) => const LoginView(),
  ),

GoRoute(
    path: '/meetOptions',
    name: RouteNames.meetOptions,
    builder: (final context, final state) => const Home(),
  ),

  // Ruta comentada de ejemplo para futuras implementaciones:
  // GoRoute(
  //   path: '/home',
  //   name: RouteNames.home,
  //   builder: (context, state) => const HomePage(),
  // ),
];
