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

import '../../Features/Attend_meeting/Presentation/Views/attend_meeting_view.dart';
import '../../Features/Attend_meeting/Presentation/Views/generate_qr.dart';
import '../../Features/Create_meeting/Presentation/Views/create_meeting_view.dart';
import '../../Features/Create_meeting/Presentation/Views/my_meets.dart';
import '../../Features/Home/Presentation/Views/home.dart';
import '../../Features/Login/Presentation/Views/login_view.dart';
import '../../Features/Meets/Presentation/Views/all_meets_view.dart';
import '../../Features/Meets/Presentation/Views/info_meet.dart';
import '../../Features/Register_attendance/Presentation/Views/register_attendance_view.dart';
import '../../Features/Register_attendance/Presentation/Views/register_manual_attendance.dart';
import '../../Features/Register_attendance/Presentation/Views/register_qr.dart';
import '../../Features/Reports_meets/Presentation/Views/reports_meets_view.dart';
import 'route_names.dart';

/// Lista de rutas disponibles en la aplicación.
/// [GoRoute] para declarar la ruta, su nombre y la vista correspondiente.
final List<GoRoute> appRoutes = [
  GoRoute(
    path: '/login',
    name: RouteNames.login,
    builder: (final context, final state) => const LoginView(),
  ),

GoRoute(
    path: '/home',
    name: RouteNames.home,
    builder: (final context, final state) => const Home(),
  ),

GoRoute(
    path: '/myMeets',
    name: RouteNames.myMeets,
    builder: (final context, final state) => const MyMeets(),
  ),

  GoRoute(
    path: '/createMeet',
    name: RouteNames.createMeet,
    builder: (final context, final state) => const CreateMeeting(),
  ),

  GoRoute(
    path: '/attendMeet',
    name: RouteNames.attendMeet,
    builder: (final context, final state) => const AttendMeeting(),
  ),

  GoRoute(
    path: '/register',
    name: RouteNames.register,
    builder: (final context, final state) => const RegisterAttendance(),
  ),

  GoRoute(
    path: '/typeReports',
    name: RouteNames.typeReports,
    builder: (final context, final state) => const ReportsMeets(),
  ),

  GoRoute(
    path: '/allMeets',
    name: RouteNames.allMeets,
    builder: (final context, final state) => const AllMeets(),
  ),

  GoRoute(
    path: '/generateQR',
    name: RouteNames.generateQR,
    builder: (final context, final state) {
      // Extraemos los datos de `state.extra`
      final meetData = state.extra as Map<String, dynamic>;
      final title = meetData['title']!;
      final hourAndDate = meetData['hourAndDate']!;

      return GenerateQR(title: title, hourAndDate: hourAndDate);
    },
  ),

  GoRoute(
    path: '/scanerQR',
    name: RouteNames.scanerQR,
    builder: (final context, final state) {
      // Extraemos los datos de `state.extra`
      final meetData = state.extra as Map<String, dynamic>;
      final title = meetData['title']!;
      final hourAndDate = meetData['hourAndDate']!;

      return RegisterQR(title: title, hourAndDate: hourAndDate);
    },
  ),

  GoRoute(
    path: '/registerManual',
    name: RouteNames.registerManual,
    builder: (final context, final state) => const RegisterManualAttendance(),
  ),

  GoRoute(
    path: '/infoMeet',
    name: RouteNames.infoMeet,
    builder: (final context, final state) {
      // Extraemos los datos de `state.extra`
      final meetData = state.extra as Map<String, dynamic>;
      final title = meetData['title']!;
      final description = meetData['description']!;

      return InfoMeet(title: title, description: description);
    },
  ),
];
