/// ****************************************************************************
/// ### RegisterQR
/// * Fecha: 2025
/// * Descripción: Vista en donde se escanean los QR o se elije la asistencia manual.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Routes/route_names.dart';

class RegisterQR extends StatefulWidget {
  const RegisterQR({super.key, required this.title, required this.hourAndDate});

  final String title;
  final String hourAndDate;

  @override
  State<RegisterQR> createState() => _RegisterQRState();
}

class _RegisterQRState extends State<RegisterQR> {
  String rolApp = '';
  final List<String> _selectedDelegateId = [];
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

  Future<void> getRolUsuario() async {
    /*final prefs = await SharedPreferences.getInstance();
    rolApp = prefs.getString('rol')?.toLowerCase() ?? '';
    debugPrint('Rol obtenido de preferencias: $rolApp');*/
    rolApp = 'Administrativo'; // SOLO DE PRUEBA
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
        title: 'Registro asistencia por QR',
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
            _selectManualRegister(),
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
      // ... aquí puedes añadir otros widgets que irían arriba
    ],
  );

  // Método para el selector de delegado
  Widget _selectManualRegister() => Row(
      children: [
            Text(
        widget.hourAndDate,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: TipoColores.gris.value),
      ),
    CustomButton(color: TipoColores.pantone158C,
    text: 'Registrar asistencia manualmente',
    onPressed: () {

    },),
      ],
    );
}
