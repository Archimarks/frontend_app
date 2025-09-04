/// ****************************************************************************
/// ### GenerateQR
/// * Fecha: 2025
/// * Descripción: Vista en donde se va a generar el QR para el registro de asistencia en X encuentro.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Routes/route_names.dart';

class GenerateQR extends StatefulWidget {
  const GenerateQR({super.key, required this.title, required this.hourAndDate});

  final String title;
  final String hourAndDate;

  @override
  State<GenerateQR> createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  String rolApp = '';
  List<String> _selectedDelegateId = [];
  String? _selectedDelegate; // Variable para almacenar al delegado seleccionado
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

  @override
  void initState() {
    super.initState();
    getRolUsuario();
  }

  /// Obtener rol del usuario desde SharedPreferences
  Future<void> getRolUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    rolApp = prefs.getString('rol')?.toLowerCase() ?? '';
    debugPrint('Rol obtenido de preferencias: $rolApp');
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
        title: 'QR de asistencia',
        onLeadingPressed: () async {
          if (!context.mounted) {
            return;
          }
          context.goNamed(RouteNames.attendMeet);
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
            // Widget inferior que permanece fijo abajo
            if (rolApp == 'Administrativo') _selectDelegate(),
          ],
        ),
      ),
    ),
  );

  // Método para el contenido principal
  Widget _mainContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        widget.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: TipoColores.pantoneBlackC.value,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        widget.hourAndDate,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: TipoColores.gris.value),
      ),
      const SizedBox(height: 20),
      CodeQR(data: widget.title),
      const SizedBox(height: 20),
      Text(
        'Coloque el código dentro del escáner para registrar su asistencia.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: TipoColores.pantoneBlackC.value),
      ),
    ],
  );

  // Método para el selector de delegado
  Widget _selectDelegate() => Padding(
    padding: const EdgeInsetsGeometry.only(bottom: 20),
    child: CustomSelectionField(
      title: 'Delegado asignado para esta reunión:',
      prefixIcon: Icons.person_add_alt_1,
      iconColor: TipoColores.gris,
      displayValue: _selectedDelegate,
      onPressed: () {
        CustomPopUp.show(
          context,
          title: 'Buscar mi delegado',
          showButtonCard: true,
          onClose: () {
            if (!context.mounted) {
              return;
            }
            context.pop();
          },
          onCheck: (final List<Map<String, String>> selectedCards) {
            setState(() {
              _selectedDelegate = selectedCards.isNotEmpty
                  ? selectedCards.first['textMain']
                  : null;
              _selectedDelegateId = selectedCards
                  .map((final card) => card['id']!)
                  .toList();
            });
            if (!context.mounted) {
              return;
            }
            context.pop();
          },
          showSearchBar: true,
          infoShowCards: myParticipants,
          initialSelectedIDs: _selectedDelegateId,
        );
      },
    ),
  );
}
