/// ****************************************************************************
/// ### InfoMeet
/// * Fecha: 2025
/// * Descripción: Vista en donde se va a mostrar la información de un encuentro y se decide si unirse o no.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Routes/route_names.dart';

class InfoMeet extends StatefulWidget {
  const InfoMeet({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  State<InfoMeet> createState() => _InfoMeetState();
}

class _InfoMeetState extends State<InfoMeet> {
  final List<Map<String, String>> myParticipants = [
    {
      'id': '1',
      'textMain': 'Fredy Antonio Verástegui González',
      'textSecondary': 'f.verastegui@udla.edu.co',
    },
    {
      'id': '2',
      'textMain': 'Marcos Alejandro Collazos Marmolejo',
      'textSecondary': 'marc.collazos@udla.edu.co',
    },
    {
      'id': '3',
      'textMain': 'Geraldine Perilla Valderrama',
      'textSecondary': 'g.perilla@udla.edu.co',
    },
    // ... más participantes
  ];
  final List<String> horarios = [
    'Lunes 07:00 pm - 10:00 pm',
    'Martes 06:00 pm - 09:00 pm',
  ];

  final String lugar = 'Campus Florencia - El Porvenir Cubierta Amazónica';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => PopScope(
    canPop: false,
    // ignore: deprecated_member_use
    onPopInvoked: (final bool didPop) {
      if (didPop) {
        return;
      }
    },
    child: Scaffold(
      backgroundColor: TipoColores.seasalt.value,
      appBar: customAppBar(
        context: context,
        title: 'Unirme al grupo',
        onLeadingPressed: () async {
          if (!context.mounted) {
            return;
          }
          context.goNamed(RouteNames.allMeets);
        },
        backgroundColor: TipoColores.pantone356C.value,
        leadingIconColor: TipoColores.seasalt.value,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Contenido principal que puede desplazarse si es necesario
            Expanded(child: SingleChildScrollView(child: _mainContent())),
            const SizedBox(height: 20),
            _joinButton(),
          ],
        ),
      ),
    ),
  );

  // Método para el contenido principal
  Widget _mainContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsetsGeometry.only(top: 20),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: TipoColores.pantone356C.value,
          ),
        ),
      ),
      const SizedBox(height: 30),
      Text(
        widget.description,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: TipoColores.gris.value),
      ),
      const SizedBox(height: 30),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: TipoColores.pantone663C.value.withAlpha((0.7 * 255).toInt()),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Horarios de entrenamiento: ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: TipoColores.pantone158C.value,
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: TipoColores.gris.value),

            // Lista de horarios
            ...horarios.map(
              (final hora) => Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.watch_later_rounded,
                        color: TipoColores.pantoneBlackC.value,
                        size: 30,
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: Text(
                          hora,
                          style: TextStyle(
                            fontSize: 16,
                            color: TipoColores.pantoneBlackC.value,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: TipoColores.gris.value),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: TipoColores.pantoneBlackC.value,
                  size: 30,
                ),
                const SizedBox(width: 20),
                Flexible(
                  child: Text(
                    lugar,
                    style: TextStyle(
                      fontSize: 16,
                      color: TipoColores.pantoneBlackC.value,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ],
  );

  // Botón para unirse al encuentro
  Widget _joinButton() => CustomButton(
    color: TipoColores.pantone158C,
    text: 'Unirme a este grupo',
    onPressed: () {
      CustomAlertDialog.show(
        context,
        title: 'Unirme a este grupo',
        message: '¿Estás seguro que quieres unirte a este grupo?',
        confirmButtonText: 'Unirme',
        cancelButtonText: 'Cancelar',
        colorButtonConfirm: TipoColores.pantone356C,
        onConfirm: () {
          if (!context.mounted) {
            return;
          }
          context.pop();
        },
        onCancel: () {
          if (!context.mounted) {
            return;
          }
          context.pop(); // Cierra el diálogo sin hacer nada
        },
      );
    },
  );
}
