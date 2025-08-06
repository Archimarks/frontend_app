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
    this.isChoose = true,
    this.isOneSelection = true,
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

  /// Variable que indica si el pop up se va a usar para eliminar o para elegir
  final bool isChoose;

  /// Variable que indica si se puede seleccionar una o varias tarjetas
  final bool isOneSelection;

  @override
  // ignore: library_private_types_in_public_api
  _CustomPopUpState createState() => _CustomPopUpState();

  // Método estático para mostrar el AlertDialog fácilmente
  static Future<void> show(
    final BuildContext context, {
    required final VoidCallback onClose,
    required final Function(List<Map<String, String>>) onCheck,
    required final String title,
    required final List<Map<String, String>> participants,
    final TipoColores colorHeader = TipoColores.pantone7473C,
    final TipoColores colorSuportHeader = TipoColores.seasalt,
    final bool showSearchBar = false,
    final bool showButtonCard = false,
    final Icon iconButtonCard = const Icon(Icons.check_box_outline_blank),
    final TipoColores colorButtonCard = TipoColores.pantone634C,
    final void Function(int index)? onCardPressed,
    final bool isChoose = true,
    final bool isOneSelection = true,
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
      infoShowCards: participants,
      iconButtonCard: iconButtonCard,
      colorButtonCard: colorButtonCard,
      onCardPressed: onCardPressed,
      isChoose: isChoose,
      isOneSelection: isOneSelection,
    ),
  );
}

class _CustomPopUpState extends State<CustomPopUp> {
  /// Controlador para el campo de texto de la búsqueda
  final TextEditingController _searchController = TextEditingController();

  /// Lista para rastrear los índices de las tarjetas seleccionadas (para selección múltiple)
  final List<int> _selectedIndices = [];

  /// Lista para toda la información
  late List<Map<String, String>> _allInformation;

  ///  Lista para la filtrados
  List<Map<String, String>> _filteredInformation = [];

  @override
  void initState() {
    super.initState();
    // Se inicializa la lista de todos los participantes con la que viene del widget
    _allInformation = widget.infoShowCards;
    // La lista filtrada inicialmente es igual a la lista completa
    _filteredInformation = _allInformation;

    // Se escuchan los cambios en el campo de búsqueda para filtrar la lista
    _searchController.addListener(_filterListInformation);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// **************************************************************************
  /// *                         Métodos Privados                               *
  /// **************************************************************************

  /// ### Método que permite chequer o no una o varias tarjetas
  /// Este método necesita el `index` de la tarjeta en la lista _filteredInformation.
  void _checkCard(final int index) {
    setState(() {
      if (widget.isOneSelection) { // Lógica para selección única

        // Si el índice ya está en la lista, significa que la tarjeta ya está seleccionada.
        if (_selectedIndices.contains(index)) {
          // La deseleccionamos vaciando la lista.
          _selectedIndices.clear();
        } else {
          // Si no está, deseleccionamos cualquier tarjeta anterior y seleccionamos la nueva.
          _selectedIndices..clear()
          ..add(index);
        }
      } else { // Lógica para selección múltiple

        // Si el índice ya está en la lista, lo eliminamos.
        if (_selectedIndices.contains(index)) {
          _selectedIndices.remove(index);
        } else {
          // Si no está, lo agregamos.
          _selectedIndices.add(index);
        }
      }
    });
  }

  /// ### Método que obtiene la información de las tarjetas seleccionadas.
  List<Map<String, String>> _getSelectedCardsInfo() {
    // Si no hay selecciones, se devuelve una lista vacía
    if (_selectedIndices.isEmpty) {
      return [];
    }

    // Se crea una lista para almacenar la información de las tarjetas seleccionadas
    final List<Map<String, String>> selectedCards = [];

    // Se recorren los índices seleccionados y se añade su información a la lista
    for (final index in _selectedIndices) {
      selectedCards.add(_filteredInformation[index]);
    }

    return selectedCards;
  }

  /// ### Método que se encarga de filtrar la lista de la información presentada
  void _filterListInformation() {
    final String query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        // Si la búsqueda está vacía, mostramos toda la información
        _filteredInformation = _allInformation;
      } else {
        // Filtramos la lista completa
        _filteredInformation = _allInformation.where((final nombre) {
          final name = nombre['name']!.toLowerCase();
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
                _filteredInformation.length, // Largo de la lista de datos
            itemBuilder: (final BuildContext context, final int index) {
              // Solo verificamos si el índice está en la lista.
              final bool isSelected = _selectedIndices.contains(index);

              // Elegimos el icono del botón basado en el estado de la tarjeta
              final IconData icon = isSelected
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank;
              final TipoColores colorIcon = isSelected
                  ? TipoColores.pantone356C
                  : TipoColores.gris;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomUsersCard(
                  textMain: _filteredInformation[index]['name']!,
                  textSecondary: _filteredInformation[index]['email'],
                  showButton: widget.showButtonCard,
                  actionCard: () {
                    if (widget.isChoose) {
                      // Llamamos a nuestro método _checkCard con el índice actual
                      _checkCard(index);
                    } else {
                      print('eliminar');
                    }
                  },
                  showNumber: false,
                  enableShadow: false,
                  actionIcon: widget.isChoose ? icon : Icons.close,
                  buttonColor: widget.isChoose
                      ? colorIcon
                      : TipoColores.pantone7621C,
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
