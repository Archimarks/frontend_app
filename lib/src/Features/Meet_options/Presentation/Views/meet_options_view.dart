import 'package:flutter/material.dart';

import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';

class MeetOptions extends StatefulWidget {
  const MeetOptions({super.key});

  @override
  State<MeetOptions> createState() => _MeetOptionsState();
}

class _MeetOptionsState extends State<MeetOptions> {
  @override
  // ignore: prefer_expression_function_bodies
  Widget build(final BuildContext context) {
    // Envuelve el Scaffold con PopScope para interceptar el botón de retroceso del hardware
    return PopScope(
      canPop: false, // Evita que la ruta se "popee" automáticamente
      onPopInvoked: (final bool didPop) {
        if (didPop) {
          return; // Si el pop ya fue manejado por el sistema, no hacemos nada.
        }
      },
      child: Scaffold(
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
        actionIcon: Icons.list,
        actionCard: () {},
      ),
    ],
  );
}
