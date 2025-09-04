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
  /// Variable para saber si hay encuentros creados
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
    {
      'id': 4,
      'hour': TimeOfDay.now(),
      'title': 'Clase diseño de base de datos',
      'description': 'Clase diseño de base de datos lunes y martes...',
    },
    {
      'id': 5,
      'hour': TimeOfDay.now(),
      'title': 'Clase administración de base de datos Grupo 1',
      'description': 'Clase administración de base de datos martes y jueves...',
    },
    {
      'id': 6,
      'hour': TimeOfDay.now(),
      'title': 'Clase administración de base de datos Grupo 2',
      'description': 'Clase administración de base de datos lunes y jueves...',
    },
    {
      'id': 7,
      'hour': TimeOfDay.now(),
      'title': 'Clase diseño de base de datos',
      'description': 'Clase diseño de base de datos lunes y martes...',
    },
  ];

  /// Getter para verificar si hay encuentros
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
          title: 'Crear encuentro',
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

  Widget _portraitLayout() => hasMeets ? showActiveMeets() : hasntMeets();

  /// ### Widget que muestra los encuentros existentes
  Widget showActiveMeets() => Column(
    children: [
      Expanded(
        child: Column(
          children: [
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
                      context.goNamed(RouteNames.generateQR, extra: meetData);
                    },
                    showButtonDelete: true,
                    onDeletePressed: () {
                      CustomAlertDialog.show(
                        context,
                        title: 'Eliminar encuentro',
                        message:
                            '¿Está seguro que desea eliminar este encuentro? Esta acción no se puede deshacer.',
                        confirmButtonText: 'Eliminar',
                        cancelButtonText: 'Cancelar',
                        colorButtonConfirm: TipoColores.pantone7621C,
                        onConfirm: () {
                          setState(() {
                            currentMeets.removeAt(entry.key);
                          });
                          if (!context.mounted) {
                            return;
                          }
                          context.pop();
                        },
                        onCancel: () {
                          if (!context.mounted) {
                            return;
                          }
                          context.pop();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              );
            }),
          ],
        ),
      ),
    ],
  );

  /// ### Widget que muestra un aviso de que el usuario no tiene encuentros creados
  Widget hasntMeets() => Column(
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
  );
}
