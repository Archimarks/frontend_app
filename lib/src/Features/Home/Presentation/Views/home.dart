import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isLoading = true;

  List<CardInfo> filteredCards = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getRolUsuario();
    await _loadCardsData();
  }

  Future<void> getRolUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    rolApp = prefs.getString('rol')?.toLowerCase() ?? '';
    debugPrint('Rol obtenido de preferencias: $rolApp');
  }

  Future<void> _loadCardsData() async {
    try {
      final String response = await rootBundle.loadString(
        'lib/i18n/Spanish/es_menu.json',
      );
      final Map<String, dynamic> data = json.decode(response);

      debugPrint('JSON cargado exitosamente');
      debugPrint('Rol configurado: $rolApp');

      final List<dynamic> rawCards = data['infoCards'];
      final List<CardInfo> allCards = [];

      for (final jsonCard in rawCards) {
        try {
          allCards.add(CardInfo.fromJson(jsonCard));
        // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          debugPrint('Error al parsear tarjeta individual: $e');
        }
      }

      final List<CardInfo> tempFilteredCards = [];

      for (final card in allCards) {
        final String? roleValue = card.rol[rolApp]?.toString();
        debugPrint(
          'Tarjeta: ${card.titulo}, Valor del rol "$rolApp": "$roleValue"',
        );

        if (roleValue == 'true') {
          tempFilteredCards.add(card);
          debugPrint('--> Tarjeta "${card.titulo}" INCLUIDA.');
        } else {
          debugPrint('--> Tarjeta "${card.titulo}" EXCLUIDA.');
        }
      }

      setState(() {
        filteredCards = tempFilteredCards;
        isLoading = false;
      });
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint('Error al cargar o parsear el JSON: $e');
      setState(() {
        isLoading = false;
      });
    }
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
          title: 'Encuentros',
        onLeadingPressed: () {
          if (!context.mounted) {
            return;
          }
            context.goNamed(RouteNames.login);
          },
        backgroundColor: TipoColores.pantone356C.value,
        leadingIconColor: TipoColores.seasalt.value,
        ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _portraitLayout(),
              ),
            ),
      ),
  );

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
                if (!context.mounted || card.route == null) {
                  return;
                }

                debugPrint('Se hizo clic en: ${card.titulo}');
                context.goNamed(card.route!);
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    ],
  );
}
