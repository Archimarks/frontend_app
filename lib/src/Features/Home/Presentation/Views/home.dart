import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
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
  String rolApp = 'administrador';
  bool isLoading = true;
  // Lista para almacenar las tarjetas filtradas
  List<CardInfo> filteredCards = [];

  @override
  void initState() {
    super.initState();
    _loadCardsData(); // Llamar la función para cargar los datos de las tarjetas
  }

  Future<void> _loadCardsData() async {
    try {
      // Traer información del json de las tarjetas
      final String response = await rootBundle.loadString(
        'lib/i18n/Spanish/es_menu.json',
      );
      final Map<String, dynamic> data = json.decode(response);

      print('JSON cargado exitosamente: $data'); // ¡Imprime el JSON completo!
      print('Rol de la aplicación configurado como: $rolApp');

      final List<dynamic> rawCards = data['infoCards'];
      final List<CardInfo> allCards = rawCards
          .map((final json) => CardInfo.fromJson(json))
          .toList();

      final List<CardInfo> tempFilteredCards =
          []; // Usa una lista temporal para depurar

      for (final card in allCards) {
        final String? roleValue = card.rol[rolApp]
            ?.toString(); // Asegúrate de que sea un String
        print('Tarjeta: ${card.titulo}, Valor del rol "$rolApp": "$roleValue"');
        if (roleValue == 'true') {
          tempFilteredCards.add(card);
          print('--> Tarjeta "${card.titulo}" INCLUIDA.');
        } else {
          print('--> Tarjeta "${card.titulo}" EXCLUIDA (valor no es "true").');
        }
      }

      setState(() {
        filteredCards = tempFilteredCards;
        isLoading = false;
      });
      print('Número de tarjetas filtradas: ${filteredCards.length}');
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
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
      ...filteredCards.map(
        (final card) => Column(
          children: [
            CustomMainCard(
              title: card.titulo,
              description: card.descripcion,
              actionCard: () {
                debugPrint('Se hizo clic en: ${card.titulo}');
              },
            ),
            const SizedBox(height: 15),
          ],
          // ignore: unnecessary_to_list_in_spreads
        ),
      ),
      CustomMeetCard(
        hourAndDate: '08:00 - 10:00 a.m. lun. (07/10/2024)',
        title: 'Clase diseño de base de datos',
        description:
            'Reportes de los fallas y asistencias de los encuentros que ha realizado.',
        actionCard: null,
        showButton: true,
        onDeletePressed: () {
          debugPrint('ELIMINADO');
        },
      ),
      const SizedBox(height: 15),
      CustomMeetCard(
        hourAndDate: '08:00 - 10:00 a.m. lun. (07/10/2024)',
        title: 'Clase diseño de base de datos',
        description:
            'Reportes de los fallas y asistencias de los encuentros que ha realizado.',
        actionCard: null,
        showButton: true,
        onDeletePressed: () {
          debugPrint('ELIMINADO');
        },
      ),
      const SizedBox(height: 15),
      CustomUsersCard(
        nameUser: 'Collazos Marmolejo Marcos Alejandro',
        emailUser: 'marc.collazos@udla.edu.co',
        showButton: true,
        actionCard: () {
          debugPrint('SELECCIONADO');
        },
        onButtonPressed: () {
          debugPrint('SELECCIONADO CHECK');
        },
        showNumber: true,
        buttonColor: TipoColores.pantone634C,
        buttonCheckedColor: TipoColores.pantone356C,
      ),
      const SizedBox(height: 15),
      CustomUsersCard(
        nameUser: 'Perilla Valderrama Geraldine',
        emailUser: 'g.perilla@udla.edu.co',
        numberIndicator: 2,
        showButton: true,
        actionCard: () {
          debugPrint('SELECCIONADO');
        },
        onButtonPressed: () {
          debugPrint('SELECCIONADO CHECK');
        },
        showNumber: true,
        buttonColor: TipoColores.pantone634C,
        buttonCheckedColor: TipoColores.pantone356C,
      ),
    ],
  );
}
