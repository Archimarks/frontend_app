/// ****************************************************************************
/// ### ReportsMeets
/// * Fecha: 2025
/// * Descripción: Vista de selección del encuentro del cual quiere ver el/los reportes.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Routes/route_names.dart';

class ReportsMeets extends StatefulWidget {
  const ReportsMeets({super.key});

  @override
  State<ReportsMeets> createState() => _ReportsMeetsState();
}

class _ReportsMeetsState extends State<ReportsMeets> {
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
          title: 'Reportes de encuentros',
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
      CustomMainCard(
        title: 'Encuentros como asistente',
        description: 'Reportes de las veces que ha asistido y a que...',
        actionCard: () {
          context.goNamed(RouteNames.allMeets);
        },
      ),
      const SizedBox(height: 15),
      CustomMainCard(
        title: 'Encuentros que he realizado',
        description:
            'Reportes de los fallas y asistencias de los encuentros que ha realizado.',
        actionCard: () {
          context.goNamed(RouteNames.allMeets);
        },
      ),
    ],
  );
}
