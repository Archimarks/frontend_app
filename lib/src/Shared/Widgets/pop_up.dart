/// ****************************************************************************
/// * Widget: CustomSelectionField
/// * Fecha: 2025
/// * Descripción: Widget de selección que ejecuta una acción al ser presionado y
/// *              muestra un valor dinámico.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';
import 'users_card.dart';

class CustomPopUp extends StatefulWidget {
  const CustomPopUp({
    super.key,
    required this.onClose,
    required this.title,
    required this.onButtonPressed,
    required this.participants,
    this.onCheck,
    this.colorHeader = TipoColores.pantone7473C,
    this.colorSuportHeader = TipoColores.seasalt,
    this.showSearchBar = false,
    this.showButtonCheck = false,
    this.iconButtonCard = const Icon(Icons.check_box_outline_blank),
    this.colorButtonCard = TipoColores.pantone634C,
  });
  final String title;
  final TipoColores colorHeader;
  final TipoColores colorSuportHeader;
  final VoidCallback onClose;
  final VoidCallback? onCheck;
  final bool showSearchBar;
  final bool showButtonCheck;
  final VoidCallback onButtonPressed;
  final List<Map<String, String>> participants;
  final Icon iconButtonCard;
  final TipoColores colorButtonCard;

  @override
  // ignore: library_private_types_in_public_api
  _CustomPopUp createState() => _CustomPopUp();

  // Método estático para mostrar el AlertDialog fácilmente
  static Future<void> show(
    final BuildContext context, {
    required final VoidCallback onClose,
    required final String title,
    required final VoidCallback onButtonPressed,
    required final List<Map<String, String>> participants,
    final TipoColores colorHeader = TipoColores.pantone7473C,
    final TipoColores colorSuportHeader = TipoColores.seasalt,
    final bool showSearchBar = false,
    final bool showButtonCheck = false,
    final VoidCallback? onCheck,
    final Icon iconButtonCard = const Icon(Icons.check_box_outline_blank),
    final TipoColores colorButtonCard = TipoColores.pantone634C,
  }) async => showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (final BuildContext context) => CustomPopUp(
      title: title,
      colorHeader: colorHeader,
      onButtonPressed: onButtonPressed,
      onClose: onClose,
      onCheck: onCheck,
      colorSuportHeader: colorSuportHeader,
      showSearchBar: showSearchBar,
      showButtonCheck: showButtonCheck,
      participants: participants,
      iconButtonCard: iconButtonCard,
      colorButtonCard: colorButtonCard,
    ),
  );
}

class _CustomPopUp extends State<CustomPopUp> {
  // Controlador para el campo de texto de la búsqueda
  final TextEditingController _searchController = TextEditingController();

  // Dos listas: una para todos los participantes y otra para los filtrados
  late List<Map<String, String>> _allParticipants;
  List<Map<String, String>> _filteredParticipants = [];

  @override
  void initState() {
    super.initState();
    // Se inicializa la lista de todos los participantes con la que viene del widget
    _allParticipants = widget.participants;
    // La lista filtrada inicialmente es igual a la lista completa
    _filteredParticipants = _allParticipants;

    // Se escuchan los cambios en el campo de búsqueda para filtrar la lista
    _searchController.addListener(_filterParticipants);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// ### Método que se encarga de filtrar la lista de participantes
  void _filterParticipants() {
    final String query = _searchController.text.toLowerCase();

    // Usamos setState para notificar a Flutter que el estado ha cambiado
    setState(() {
      if (query.isEmpty) {
        // Si la búsqueda está vacía, mostramos todos los participantes
        _filteredParticipants = _allParticipants;
      } else {
        // Filtramos la lista completa
        _filteredParticipants = _allParticipants.where((final participant) {
          final name = participant['name']!.toLowerCase();
          return name.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(final BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    backgroundColor: TipoColores.seasalt.value,
    child: _portraitLayout(),
  );

  /// --------------------------------------------------------------------------
  /// Texto que muestra el título del widget.
  /// --------------------------------------------------------------------------
  Widget _buildHeader() => Container(
    decoration: BoxDecoration(
      color: widget.colorHeader.value,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(17),
        topRight: Radius.circular(17),
      ),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botón de cerrar
        IconButton(
          icon: Icon(
            Icons.close,
            color: widget.colorSuportHeader.value,
            size: 30,
          ),
          onPressed: widget.onClose,
        ),
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: widget.colorSuportHeader.value,
          ),
          textAlign: TextAlign.center,
        ),
        // Botón de confirmar
        IconButton(
          icon: Icon(
            Icons.check,
            color: widget.colorSuportHeader.value,
            size: 30,
          ),
          onPressed: widget.onCheck,
        ),
      ],
    ),
  );

  /// --------------------------------------------------------------------------
  /// Widget para la barra de búsqueda
  /// --------------------------------------------------------------------------
  Widget _buildSearchBar() => TextField(
    controller: _searchController,
    decoration: InputDecoration(
      hintText: 'Escribe un nombre o correo electrónico',
      hintStyle: TextStyle(color: TipoColores.pantoneCool.value, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      border: const OutlineInputBorder(borderSide: BorderSide.none),
      filled: true,
      fillColor: TipoColores.seasalt.value,
    ),
  );

  /// --------------------------------------------------------------------------
  /// Construye la vista del alert dialog
  /// --------------------------------------------------------------------------
  Widget _portraitLayout() => SizedBox(
    height: MediaQuery.of(context).size.height * 0.60,
    width: MediaQuery.of(context).size.width * 0.90,

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        if (widget.showSearchBar) ...[
          _buildSearchBar(),
          Divider(color: TipoColores.pantoneCool.value),
        ],
        // Lista de usuarios
        Expanded(
          child: ListView.builder(
            itemCount:
                _filteredParticipants.length, // Largo de la lista de datos
            itemBuilder: (final BuildContext context, final int index) {
              // Obtenemos el participante actual
              final participant = _filteredParticipants[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomUsersCard(
                  nameUser: participant['name']!,
                  emailUser: participant['email'],
                  showButton: !widget.showSearchBar,
                  actionCard: widget.onButtonPressed,
                  onButtonPressed: widget.onButtonPressed,
                  showNumber: false,
                  enableShadow: false,
                  actionIcon: widget.iconButtonCard.icon!,
                  buttonColor: widget.colorButtonCard,
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
