import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';

import '../../../../Core/Barrels/configs_barrel.dart';
import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Routes/route_names.dart';
import '../../Domain/card_info.dart';

/// ****************************************************************************
/// ### Home
/// * Descripción: Vista principal de la aplicación en donde se muestran las
/// diferentes opciones a las que puede acceder el usuario.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// * Fecha: 2025
/// ****************************************************************************

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String rolApp = '';

  /// Indica que está cargando los datos del JSON
  bool isLoading = true;
  // Lista para almacenar las tarjetas filtradas
  List<CardInfo> filteredCards = [];

  @override
  void initState() {
    super.initState();

    _getRolUser(); // Llamar la función para obtener el rol del usuario
    _loadCardsData(); // Llamar la función para cargar los datos de las tarjetas
  }

  Future<void> _getRolUser() async {
    final String? rol = getString('rol');
    if (rol != null) {
      rolApp = rol.toLowerCase();
      debugPrint('Rol de la aplicación configurado como: $rolApp');
    } else {
      debugPrint('No se encontró el rol del usuario en el almacenamiento.');
    }
  }

  Future<void> _loadCardsData() async {
    try {
      // Traer información del json de las tarjetas
      final String response = await rootBundle.loadString(
        'lib/i18n/Spanish/es_menu.json',
      );
      final Map<String, dynamic> data = json.decode(response);

      debugPrint(
        'JSON cargado exitosamente: $data',
      );
      debugPrint('Rol de la aplicación configurado como: $rolApp');

      final List<dynamic> rawCards = data['infoCards'];
      final List<CardInfo> allCards = rawCards
          .map((final json) => CardInfo.fromJson(json))
          .toList();

      final List<CardInfo> tempFilteredCards =
          []; // Usa una lista temporal para depurar

      for (final card in allCards) {
        final String? roleValue = card.rol[rolApp]
            ?.toString(); 
        debugPrint(
          'Tarjeta: ${card.titulo}, Valor del rol "$rolApp": "$roleValue"',
        );
        if (roleValue == 'true') {
          tempFilteredCards.add(card);
          debugPrint('--> Tarjeta "${card.titulo}" INCLUIDA.');
        } else {
          debugPrint(
            '--> Tarjeta "${card.titulo}" EXCLUIDA (valor no es "true").',
          );
        }
      }

      setState(() {
        filteredCards = tempFilteredCards;
        isLoading = false;
      });
      debugPrint('Número de tarjetas filtradas: ${filteredCards.length}');
    } on Exception catch (e) {
      debugPrint('Error al cargar o parsear el JSON desde i18n/spanish: $e');
      setState(() {
        isLoading = false;
      });
    }
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
          title: 'Encuentros',
          onLeadingPressed: () async {
            if (!context.mounted) {
              return;
            }
            context.goNamed(RouteNames.login);
          },
          backgroundColor:
              TipoColores.pantone356C.value, // Color de fondo de la AppBar
          leadingIconColor:
              TipoColores.seasalt.value, // Color del icono de retroceso
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: _portraitLayout(),
          ),
        ),
      ),
    );
  }

  Widget _portraitLayout() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ...filteredCards.map(
        (final card) => Column(
          children: [
            CustomMainCard(
              title: card.titulo,
              description: card.descripcion,
              actionCard: () {
                if (!context.mounted) {
                  return;
                }
                debugPrint('Se hizo clic en: ${card.titulo}');
                // Usar la propiedad 'route' de la tarjeta para navegar
                context.goNamed(card.route);
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    ],
  );
}
