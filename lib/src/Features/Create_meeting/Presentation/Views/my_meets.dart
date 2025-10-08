/// ****************************************************************************
/// ### MyMeets
/// * Fecha: 2025
/// * Descripción: Vista de encuentros creados.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
// ignore_for_file: use_build_context_synchronously

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Core/Barrels/configs_barrel.dart';
import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/models_barrel.dart';
import '../../../../Core/Barrels/services_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Routes/route_names.dart';

class MyMeets extends StatefulWidget {
  const MyMeets({super.key});

  @override
  State<MyMeets> createState() => _MyMeetsState();
}

class _MyMeetsState extends State<MyMeets> {
  /// Lista de encuentros creados por mí
  List<MeetingModel> _meetings = [];
  bool _isLoading = true;
  final service = MeetingService();

  @override
  void initState() {
    super.initState();
    _loadMeetings();
  }

  /// Método que asigna los encuentros traídos a una lista local
  Future<void> _loadMeetings() async {
    final creadorIdString = getString('pege');
    final creadorId = int.tryParse(creadorIdString ?? '') ?? 0;
    final data = await service.fetchMeetings(creadorId);
    setState(() {
      _meetings = data;
      _isLoading = false;
    });
  }

  /// Getter para verificar si hay encuentros
  bool get hasMeets => _meetings.isNotEmpty;

  /// Método local que se encarga de eliminar un encuentro a partir del ID
  Future<bool> deleteMeetingforID(final int idEncuentro) async {
    final bool response = await service.deleteMeeting(idEncuentro);

    if (response) {
      await _loadMeetings(); // vuelve a traer la lista de la API
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response
                ? 'Encuentro eliminado correctamente.'
                : 'Ha ocurrido un error al eliminar el encuentro.',
            style: TextStyle(color: TipoColores.seasalt.value),
          ),
          backgroundColor: response
              ? TipoColores.calPolyGreen.value
              : TipoColores.pantone7621C.value,
        ),
      );
    }
    return response;
  }

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
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: TipoColores.calPolyGreen.value,
                ),
              )
            : LayoutBuilder(
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

  Widget _portraitLayout() =>
      hasMeets ? _showActiveMeets() : Center(child: _hasntMeets());

  /// ### Widget que muestra los encuentros existentes
  Widget _showActiveMeets() => Column(
    children: [
      Expanded(
        child: Column(
          children: [
            ..._meetings.asMap().entries.map((final entry) {
              final meet = entry.value; // Accedemos a la reunión actual
              // Variable para los datos del encuentro seleccionado
              final meetData = {
                'title': meet.encuAsunto,
                'hourAndDate': meet.encuRolDirigido,
              };
              return Column(
                children: [
                  CustomMeetCard(
                    hourAndDate: meet.encuRolDirigido,
                    title: meet.encuAsunto,
                    description: meet.encuDescripcion,
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
                        onConfirm: () async {
                          await deleteMeetingforID(_meetings[entry.key].encuId);
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
