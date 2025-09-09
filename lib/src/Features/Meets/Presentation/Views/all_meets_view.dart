/// ****************************************************************************
/// ### Meets
/// * Fecha: 2025
/// * Descripción: Vista de selección del encuentro al cual desea unirse.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Routes/route_names.dart';

class AllMeets extends StatefulWidget {
  const AllMeets({super.key});

  @override
  State<AllMeets> createState() => _AllMeetsState();
}

class _AllMeetsState extends State<AllMeets> {
  final List<Map<String, dynamic>> currentMeets = [
    {
      'id': 1,
      'title': 'Equipo de fútbol estudiantil',
      'description':
          'Horario de los entrenamientos: Lunes 07:00 pm - 10:00 pm, Sábado 08:00 am - 12:...',
    },
    {
      'id': 2,
      'title': 'Equipo de voleibol estudiantil',
      'description':
          'Horario de los entrenamientos: Martes 07:00 pm - 10:00 pm, Sábado 08:00 am - 12:...',
    },
    {
      'id': 3,
      'title': 'Equipo de bádminton estudiantil',
      'description':
          'Horario de los entrenamientos: Martes 06:00 pm - 09:00 pm, Sábado 09:00 am - 12:...',
    },
    {
      'id': 4,
      'title': 'Equipo de danza folclórica',
      'description':
          'Horario de los entrenamientos: Martes 07:00 pm - 10:00 pm, Jueves 06:00 pm - 09:...',
    },
    {
      'id': 5,
      'title': 'Clase administración de base de datos Grupo 1',
      'description': 'Clase administración de base de datos martes y jueves...',
    },
    {
      'id': 6,
      'title': 'Clase administración de base de datos Grupo 2',
      'description': 'Clase administración de base de datos lunes y jueves...',
    },
  ];

  // Getter para verificar si hay encuentros
  bool get hasMeets => currentMeets.isNotEmpty;

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
          title: 'Unirme a un grupo',
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

  Widget _portraitLayout() => hasMeets ? _showMeets() : _hasntMeets();

  // ### Widget que muestra los encuentros del día
  Widget _showMeets() => ListView.builder(
    itemCount: currentMeets.length,
    itemBuilder: (final context, final index) {
      final meet = currentMeets[index];
      final meetData = {
        'title': meet['title'].toString(),
        'description': meet['description'].toString(),
      };
      return Column(
        children: [
          CustomMainCard(
            title: meet['title'].toString(),
            description: meet['description'].toString(),
            actionCard: () {
              if (!mounted) {
                return;
              }
              debugPrint('Enviando datos: $meetData');
              context.goNamed(RouteNames.infoMeet, extra: meetData);
            },
          ),
          const SizedBox(height: 10),
        ],
      );
    },
  );

  /// ### Widget que muestra un aviso de que el usuario no tiene encuentros para hoy
  Widget _hasntMeets() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.warning_rounded,
        size: 50,
        color: TipoColores.pantoneBlackC.value,
      ),
      const SizedBox(height: 20),
      Text(
        'No tiene encuentros a los cuales asistir hoy.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: TipoColores.pantoneBlackC.value,
        ),
      ),
    ],
  );
}
