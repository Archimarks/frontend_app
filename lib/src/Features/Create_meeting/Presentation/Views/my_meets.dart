/// ****************************************************************************
/// ### MyMeets
/// * Fecha: 2025
/// * Descripción: Vista de encuentros creados.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Routes/route_names.dart';

class MyMeets extends StatefulWidget {
  const MyMeets({super.key});

  @override
  State<MyMeets> createState() => _MyMeetsState();
}

class _MyMeetsState extends State<MyMeets> {
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
          title: 'Crear encuentro',
          onLeadingPressed: () async {
            if (!context.mounted) {
              return;
            }
            context.goNamed(RouteNames.home);
            print('Saliendo de mis reuniones');
          },
          backgroundColor:
              TipoColores.pantone356C.value, // Color de fondo de la AppBar
          leadingIconColor:
              TipoColores.seasalt.value, // Color del icono de retroceso
          showPlus: true, // Mostrar el botón de agregar
          onPlusPressed: () async {
            if (!context.mounted) {
              return;
            }
            context.goNamed(RouteNames.createMeet);
          },
        ),
        body: LayoutBuilder(
          builder:
              (
                final BuildContext context,
                final BoxConstraints viewportConstraints,
              ) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: _portraitLayout(),
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Widget _portraitLayout() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_rounded,
                size: 50,
                color: TipoColores.pantoneBlackC.value,
              ),
              const SizedBox(height: 20),
              Text(
                'No tiene encuentros creados.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: TipoColores.pantoneBlackC.value,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
