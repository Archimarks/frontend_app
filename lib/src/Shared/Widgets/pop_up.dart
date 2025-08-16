import 'package:flutter/material.dart';

import '../../Core/Barrels/enums_barrel.dart';
import 'users_card.dart';

/// ****************************************************************************
/// ### Widget: PopUp
/// * Fecha: 2025
/// * Descripción: Widget de pop up que presenta una ventana emergente con tarjetas para su posterior elección.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
class CustomPopUp extends StatefulWidget {
  const CustomPopUp({
    super.key,
    required this.onClose,
    required this.title,
    required this.infoShowCards,
    required this.onCheck,
    this.colorHeader = TipoColores.pantone7473C,
    this.colorSuportHeader = TipoColores.seasalt,
    this.showSearchBar = false,
    this.showButtonCard = false,
    this.onCardPressed,
    this.iconButtonCard = const Icon(Icons.check_box_outline_blank),
    this.colorButtonCard = TipoColores.pantone634C,
    this.isOneSelection = true,
    this.initialSelectedIDs = const [],
    this.searchHintText = 'Escribe un nombre o correo electrónico',
  });

  /// Título del pop-up.
  final String title;

  /// Color del fondo del encabezado.
  final TipoColores colorHeader;

  /// Color del texto y botones del encabezado.
  final TipoColores colorSuportHeader;

  /// Acción del botón cerrar.
  final VoidCallback onClose;

  /// Acción del botón confirmar.
  final Function(List<Map<String, String>>) onCheck;

  /// Indica si se debe mostrar la barra de búsqueda.
  final bool showSearchBar;

  /// Indica si se debe mostrar el botón de la tarjeta.
  final bool showButtonCard;

  /// Lista de la información a mostrar en las tarjetas del pop-up.
  final List<Map<String, String>> infoShowCards;

  /// Icono del botón de la tarjeta.
  final Icon iconButtonCard;

  /// Color del botón de la tarjeta.
  final TipoColores colorButtonCard;

  /// Callback para manejar los eventos al oprimir la tarjeta
  final void Function(int index)? onCardPressed;

  /// Variable que indica si se puede seleccionar una o varias tarjetas
  final bool isOneSelection;

  /// La lista de IDs únicos que deben estar seleccionados al inicio
  final List<String> initialSelectedIDs;

  /// Texto que se muestra en el buscador
  final String searchHintText;

  @override
  // ignore: library_private_types_in_public_api
  _CustomPopUpState createState() => _CustomPopUpState();

  // Método estático para mostrar el AlertDialog fácilmente
  static Future<void> show(
    final BuildContext context, {
    required final VoidCallback onClose,
    required final Function(List<Map<String, String>>) onCheck,
    required final String title,
    required final List<Map<String, String>> infoShowCards,
    final TipoColores colorHeader = TipoColores.pantone7473C,
    final TipoColores colorSuportHeader = TipoColores.seasalt,
    final bool showSearchBar = false,
    final bool showButtonCard = false,
    final Icon iconButtonCard = const Icon(Icons.check_box_outline_blank),
    final TipoColores colorButtonCard = TipoColores.pantone634C,
    final void Function(int index)? onCardPressed,
    final bool isOneSelection = true,
    final List<String> initialSelectedIDs = const [],
    final String searchHintText = 'Escribe un correo electrónico',
  }) async => showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (final BuildContext context) => CustomPopUp(
      title: title,
      colorHeader: colorHeader,
      onClose: onClose,
      onCheck: onCheck,
      colorSuportHeader: colorSuportHeader,
      showSearchBar: showSearchBar,
      showButtonCard: showButtonCard,
      infoShowCards: infoShowCards,
      iconButtonCard: iconButtonCard,
      colorButtonCard: colorButtonCard,
      onCardPressed: onCardPressed,
      isOneSelection: isOneSelection,
      initialSelectedIDs: initialSelectedIDs,
      searchHintText: searchHintText,
    ),
  );
}

class _CustomPopUpState extends State<CustomPopUp> {
  // Controlador para el campo de texto de la búsqueda
  final TextEditingController _searchController = TextEditingController();

  // Lista para rastrear los índices de las tarjetas seleccionadas (para selección múltiple)
  final List<int> _selectedIndices = [];

  // Lista para toda la información
  late List<Map<String, String>> _allInformation;

  // Lista para la información filtrada
  List<Map<String, String>> _filteredInformation = [];

  @override
  void initState() {
    super.initState();
    // Se inicializa la lista de todos los participantes con la que viene del widget
    _allInformation = widget.infoShowCards;

    // Se recorre la lista de IDs iniciales para encontrar sus índices y agregarlos
    // a la lista de seleccionados. Esto es importante para mantener el estado.
    for (final String id in widget.initialSelectedIDs) {
      final int index = _allInformation.indexWhere(
        (final card) => card['id'] == id,
      );
      if (index != -1) {
        _selectedIndices.add(index);
      }
    }

    // Si hay IDs seleccionados al inicio, se muestran solo esas tarjetas.
    if (_selectedIndices.isNotEmpty) {
      _filteredInformation = _getSelectedCardsInfo();
    } else {
      // Si no hay IDs seleccionados, la lista filtrada se inicializa como vacía.
      // Las tarjetas solo se mostrarán al buscar.
      _filteredInformation = [];
    }

    // Se escuchan los cambios en el campo de búsqueda para filtrar la lista
    _searchController.addListener(_filterListInformation);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// **************************************************************************
  /// *                         Métodos Privados                               *
  /// **************************************************************************

  /// ### Método que permite chequear o no una o varias tarjetas
  void _checkCard(final int filteredIndex) {
    // Obtenemos el ID de la tarjeta seleccionada en la lista filtrada.
    final String selectedId = _filteredInformation[filteredIndex]['id']!;

    // Buscamos el índice de esta tarjeta en la lista completa para asegurarnos de que el estado
    // de selección se mantiene incluso si la lista filtrada cambia.
    final int indexInAllInformation = _allInformation.indexWhere(
      (final card) => card['id'] == selectedId,
    );

    if (indexInAllInformation == -1) {
      return; // No se encontró el índice en la lista completa
    }

    setState(() {
      if (widget.isOneSelection) {
        if (_selectedIndices.contains(indexInAllInformation)) {
          _selectedIndices.clear();
        } else {
          _selectedIndices
            ..clear()
            ..add(indexInAllInformation);
        }
      } else {
        // Selección múltiple
        if (_selectedIndices.contains(indexInAllInformation)) {
          _selectedIndices.remove(indexInAllInformation);
        } else {
          _selectedIndices.add(indexInAllInformation);
        }
      }

      // Actualizamos la lista filtrada para que siempre muestre el estado correcto.
      // Si la búsqueda no está vacía, se mantiene el filtro.
      // Si la búsqueda está vacía, se muestran solo las seleccionadas.
      if (_searchController.text.isEmpty) {
        _filteredInformation = _getSelectedCardsInfo();
      } else {
        _filterListInformation();
      }
    });
  }

  /// ### Método que obtiene los id de las tarjetas seleccionadas.
  List<String> _getSelectedId() {
    final List<String> selectedId = [];
    for (final index in _selectedIndices) {
      // Usamos _allInformation porque _selectedIndices guarda los índices de esa lista
      final id = _allInformation[index]['id'];
      if (id != null) {
        selectedId.add(id);
      }
    }
    return selectedId;
  }

  /// ### Método que obtiene la información de las tarjetas seleccionadas.
  List<Map<String, String>> _getSelectedCardsInfo() {
    // Si no hay selecciones, se devuelve una lista vacía
    if (_selectedIndices.isEmpty) {
      return [];
    }

    // Se crea una lista para almacenar la información de las tarjetas seleccionadas
    final List<Map<String, String>> selectedCards = [];

    // Se recorren los índices seleccionados y se añade su información de la lista completa
    for (final index in _selectedIndices) {
      selectedCards.add(_allInformation[index]);
    }

    return selectedCards;
  }

  /// ### Método que se encarga de filtrar la lista de la información presentada
  void _filterListInformation() {
    final String query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        // Si la búsqueda está vacía, mostramos las tarjetas seleccionadas
        // o una lista vacía si no hay ninguna.
        _filteredInformation = _getSelectedCardsInfo();
      } else {
        // Si la búsqueda tiene texto, filtramos la lista completa
        _filteredInformation = _allInformation.where((final card) {
          final textMain = card['textMain']?.toLowerCase() ?? '';
          final textSecondary = card['textSecondary']?.toLowerCase() ?? '';
          return textMain.contains(query) || textSecondary.contains(query);
        }).toList();
      }
    });
  }

  // El resto del código `build` y los demás métodos quedan igual.
  @override
  Widget build(final BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    backgroundColor: TipoColores.seasalt.value,
    child: _portraitLayout(),
  );

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
          onPressed: () {
            // Obtenemos la información de las tarjetas seleccionadas
            final selectedCards = _getSelectedCardsInfo();
            // Llamamos a la función `onCheck` con la lista de tarjetas seleccionadas
            widget.onCheck(selectedCards);
          },
        ),
      ],
    ),
  );

  Widget _buildSearchBar() => TextField(
    controller: _searchController,
    decoration: InputDecoration(
      hintText: widget.searchHintText,
      hintStyle: TextStyle(color: TipoColores.pantoneCool.value, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      border: const OutlineInputBorder(borderSide: BorderSide.none),
      filled: true,
      fillColor: TipoColores.seasalt.value,
    ),
  );

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
                _filteredInformation.length, // Largo de la lista de datos
            itemBuilder: (final BuildContext context, final int index) {
              // Obtenemos el id de la tarjeta actual en la lista filtrada
              final String? currentId = _filteredInformation[index]['id'];

              // Verificar si este Id está en la lista de emails seleccionados
              // Esto mantendrá la consistencia entre las listas filtradas y no filtradas
              final bool isSelected = _getSelectedId().contains(currentId);

              // Elegimos el icono y color del botón basado en el estado de la tarjeta
              final IconData icon = isSelected
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank;
              final TipoColores colorIcon = isSelected
                  ? TipoColores.pantone356C
                  : TipoColores.gris;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomUsersCard(
                  textMain: _filteredInformation[index]['textMain']!,
                  textSecondary: _filteredInformation[index]['textSecondary'],
                  showButton: widget.showButtonCard,
                  actionCard: () {
                    _checkCard(index);
                  },
                  showNumber: false,
                  enableShadow: false,
                  actionIcon: icon,
                  buttonColor: colorIcon,
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
