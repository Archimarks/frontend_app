import 'package:flutter/material.dart';

import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        backgroundColor: TipoColores
            .seasalt
            .value, // Color de fondo para toda la vista
        appBar: customAppBar(
          context: context,
          title: 'Encuentros',
          onLeadingPressed: () async {},
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
                padding: const EdgeInsets.all(15.0),
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
        title: 'Crear encuentro',
        description: 'Invitar personas, definir horario y fecha.',
        actionCard: () {},
      ),
      const SizedBox(height: 20),
      CustomMainCard(
        title: 'Registrar asistencia',
        description: 'Activar escaneo del QR de los invitados o registro manual de asistencia.',
        actionCard: () {},
      ),
      const SizedBox(height: 20),
      CustomMainCard(
        title: 'Asistir a un encuentro',
        description: 'Generar mi QR para registro de mi asistencia.',
        actionCard: () {},
      ),
      const SizedBox(height: 20),
      CustomMainCard(
        title: 'Reportes',
        description: 'Reportes de los encuentros.',
        actionCard: () {},
      ),
      const SizedBox(height: 20),
      CustomMainCard(
        title: 'Encuentros',
        description: 'Encuentros informales a los que se puede unir.',
        actionCard: () {},
      ),
    ],
  );
}
