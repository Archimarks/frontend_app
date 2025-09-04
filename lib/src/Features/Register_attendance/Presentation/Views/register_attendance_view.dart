/// ****************************************************************************
/// ### RegisterAttendance
/// * Fecha: 2025
/// * Descripción: Vista de selección del encuentro al que desea registrar asistencia.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Routes/route_names.dart';

class RegisterAttendance extends StatefulWidget {
  const RegisterAttendance({super.key});

  @override
  State<RegisterAttendance> createState() => _RegisterAttendanceState();
}

class _RegisterAttendanceState extends State<RegisterAttendance> {
  // Fecha actual para mostrar los encuentros de ese día
  DateTime currentDay = DateTime.now();
  // Lista de encuentros
  final List<Map<String, dynamic>> currentMeets = [
    {
      'id': 1,
      'hour': TimeOfDay.now(),
      'title': 'Clase diseño de base de datos',
      'description': 'Clase diseño de base de datos lunes y martes...',
    },
    {
      'id': 2,
      'hour': TimeOfDay.now(),
      'title': 'Clase administración de base de datos Grupo 1',
      'description': 'Clase administración de base de datos martes y jueves...',
    },
    {
      'id': 3,
      'hour': TimeOfDay.now(),
      'title': 'Clase administración de base de datos Grupo 2',
      'description': 'Clase administración de base de datos lunes y jueves...',
    },
  ];

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(final BuildContext context) {
    // Envuelve el Scaffold con PopScope para interceptar el botón de retroceso del hardware
    return PopScope(
      canPop: false, // Evita que la ruta se "popee" automáticamente
      // ignore: deprecated_member_use
      onPopInvoked: (final bool didPop) {
        if (didPop) {
          return; // Si el pop ya fue manejado por el sistema, no se hace nada.
        }
      },
      child: Scaffold(
        backgroundColor:
            TipoColores.seasalt.value, // Color de fondo para toda la vista
        appBar: customAppBar(
          context: context,
          title: 'Encuentros actuales',
          onLeadingPressed: () async {
            if (!context.mounted) {
              return;
            }
            context.goNamed(RouteNames.home);
          },
          backgroundColor:
              TipoColores.pantone356C.value, // Color de fondo de la AppBar
          leadingIconColor:
              TipoColores.seasalt.value, // Color del icono de retroceso
        ),
        body: Stack(
          children: [
            /// Contenido central con diseño responsive
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _portraitLayout(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _portraitLayout() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Encuentros del día ${currentDay.day} de ${DateFormat.MMMM().format(currentDay)}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: TipoColores.pantoneBlackC.value,
          ),
        ),
      ),
      ...currentMeets.asMap().entries.map((final entry) {
        final meet = entry.value; // Accedemos a la reunión actual
        // Variable para los datos del encuentro seleccionado
        final meetData = {
          'title': meet['title'].toString(),
          'hourAndDate': '${meet['hour'].hour}:${meet['hour'].minute}',
        };
        return Column(
          children: [
            CustomMeetCard(
              hourAndDate: '${meet['hour'].hour}:${meet['hour'].minute}',
              title: meet['title'].toString(),
              description: meet['description'].toString(),
              actionCard: () {
                if (!mounted) {
                  return;
                }
                debugPrint('Enviando datos: $meetData');
                context.goNamed(RouteNames.scanerQR, extra: meetData);
              },
            ),
            const SizedBox(height: 15),
          ],
        );
      }),
    ],
  );
}
