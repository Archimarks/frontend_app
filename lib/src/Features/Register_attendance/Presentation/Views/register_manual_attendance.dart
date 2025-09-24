/// ****************************************************************************
/// ### Register Manual Attendance View
/// * Fecha: 2025
/// * Descripción: Vista en donde se selecciona manualmente los asistentes.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Routes/route_names.dart';

class RegisterManualAttendance extends StatefulWidget {
  const RegisterManualAttendance({super.key});

  @override
  State<RegisterManualAttendance> createState() =>
      _RegisterManualAttendanceState();
}

class _RegisterManualAttendanceState extends State<RegisterManualAttendance> {
  // Lista de todos los usuarios
  final List<Map<String, String>> allPerson = [
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

  // Lista para rastrear los índices de las tarjetas seleccionadas (para selección múltiple)
  final List<int> _selectedIndices = [];

  @override
  void initState() {
    super.initState();
    // Se inicializa la lista de todos los participantes con la que viene del widget
    //allPerson = widget.infoShowCards;

    // Se recorre la lista de IDs iniciales para encontrar sus índices y agregarlos
    // a la lista de seleccionados. Esto es importante para mantener el estado.
    /*for (final String id in widget.initialSelectedIDs) {
      final int index = allPerson.indexWhere(
        (final card) => card['id'] == id,
      );
      if (index != -1) {
        _selectedIndices.add(index);
      }
    }*/
  }

  /// ### Método que obtiene los id de las tarjetas seleccionadas.
  List<String> _getSelectedId() {
    final List<String> selectedId = [];
    for (final index in _selectedIndices) {
      // Usamos allPerson porque _selectedIndices guarda los índices de esa lista
      final id = allPerson[index]['id'];
      if (id != null) {
        selectedId.add(id);
      }
    }
    return selectedId;
  }

  /// ### Método que permite chequear o no una o varias tarjetas
  void _checkCard(final int filteredIndex) {
    // Obtenemos el ID de la tarjeta seleccionada en la lista filtrada.
    final String selectedId = allPerson[filteredIndex]['id']!;

    // Buscamos el índice de esta tarjeta en la lista completa para asegurarnos de que el estado
    // de selección se mantiene incluso si la lista filtrada cambia.
    final int indexInAllInformation = allPerson.indexWhere(
      (final card) => card['id'] == selectedId,
    );

    if (indexInAllInformation == -1) {
      return; // No se encontró el índice en la lista completa
    }

    setState(() {
      // Selección múltiple
      if (_selectedIndices.contains(indexInAllInformation)) {
        _selectedIndices.remove(indexInAllInformation);
      } else {
        _selectedIndices.add(indexInAllInformation);
      }
    });
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
        title: 'Registro asistencia manual',
        onLeadingPressed: () async {
          if (!context.mounted) {
            return;
          }
          context.goNamed(RouteNames.scanerQR);
        },
        backgroundColor: TipoColores.pantone356C.value,
        leadingIconColor: TipoColores.seasalt.value,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Contenido principal que puede desplazarse si es necesario
            Expanded(child: SingleChildScrollView(child: _mainContent())),
            const SizedBox(height: 15),
            // Widget inferior que permanece fijo abajo
            _confirmButton(),
          ],
        ),
      ),
    ),
  );

  /// Método para el contenido principal
  Widget _mainContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ListView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // Evita scroll anidado
        itemCount: allPerson.length, // Largo de la lista de datos
        itemBuilder: (final BuildContext context, final int index) {
          // Verificar si este Id está en la lista de emails seleccionados
          // Esto mantendrá la consistencia entre las listas filtradas y no filtradas
          final bool isSelected = _getSelectedId().contains(
            allPerson[index]['id'],
          );

          // Elegimos el icono y color del botón basado en el estado de la tarjeta
          final IconData icon = isSelected
              ? Icons.check_box_outlined
              : Icons.check_box_outline_blank;
          final TipoColores colorIcon = isSelected
              ? TipoColores.pantone356C
              : TipoColores.gris;

          return CustomUsersCard(
              textMain: allPerson[index]['textMain']!,
              textSecondary: allPerson[index]['textSecondary'],
              showButton: true,
              actionCard: () {
                _checkCard(index);
              },
              showNumber: true,
              numberIndicator: index + 1,
              enableShadow: false,
              actionIcon: icon,
              buttonColor: colorIcon,

          );
        },
      ),
    ],
  );

  // Botón para registrar asistencia manualmente
  Widget _confirmButton() => CustomButton(
    color: TipoColores.pantone634C,
    text: 'Confirmar asistencia',
    width: double.infinity,
    onPressed: () {},
  );
}
