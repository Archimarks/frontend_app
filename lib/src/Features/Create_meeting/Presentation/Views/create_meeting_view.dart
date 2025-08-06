/// ****************************************************************************
/// ### CreateMeeting
/// * Fecha: 2025
/// * Descripción: Vista de crear encuentros.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Routes/route_names.dart';
import '../../../../Shared/Widgets/pop_up.dart';

class CreateMeeting extends StatefulWidget {
  const CreateMeeting({super.key});

  @override
  State<CreateMeeting> createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  bool _isCreateButtonEnabled =
      false; // Variable para manejar el estado del botón de crear encuentro
  final bool _isSelectedLeanding =
      false; // Variable para manejar el estado de selección del líder del encuentro
  bool _addParticipants =
      false; // Variable para manejar si se han agregado participantes
  bool _selectedMeet =
      false; // Variable para manejar el estado de selección de un encuentro
  String? _selectedMeetType; // Tipo de encuentro seleccionado por defecto
  /// Lista de tipos de encuentros disponibles
  final List<String> _encounterTypes = [
    'Reunión administrativa',
    'Clases académicas',
    'Eventos de bienestar universitario',
  ];
  String _selectedTime =
      '15 minutos'; // Variable para que almacena el tiempo seleccionado
  /// Lista de tipos de tiempo disponibles
  final List<String> _optionsTime = [
    '15 minutos',
    '30 minutos',
    '45 minutos',
    '1 hora',
    '2 horas',
    '3 horas',
  ];
  bool certificate =
      false; // Variable que indica si se va a generar acta (true) o no (false por defecto)
  bool repeat =
      false; // Variable que indica si el encuentro se repite (true) o no (false por defecto)
  String _selectedRepeat =
      'Nunca'; // Variable para que almacena el tipo de repetición seleccionado
  /// Lista de tipos de repetición disponibles
  final List<String> _optionsRepeat = [
    'Nunca',
    'Cada día',
    'Cada día laborable (lun - vie)',
    'Cada semana',
    'Cada mes',
  ];
  late final TextEditingController
  _asuntoController; // Controlador para el campo de asunto
  late final TextEditingController
  _descriptionController; // Controlador para el campo de descripción
  String?
  _selectedLeadingUser; // Variable para almacenar al líder del encuentro
  String?
  _selectedLocation; // Variable para almacenar la ubicación seleccionada
  DateTime? _startDate; // Fecha de inicio por defecto
  TimeOfDay? _startTime; // Hora de inicio
  DateTime? _endDate; // Fecha de fin por defecto
  TimeOfDay? _endTime; // Hora de fin
  // Lista de usuarios
  final List<Map<String, String>> myParticipants = [
    {
      'name': 'Fredy Antonio Verástegui González',
      'email': 'f.verastegui@udla.edu.co',
    },
    {
      'name': 'Marcos Alejandro Collazos Marmolejo',
      'email': 'marc.collazos@udla.edu.co',
    },
    // ... más participantes
  ];
  // Lista de ubicaciones
  final List<Map<String, String>> myLocations = [
    {
      'name':
          'CAMPUS ALBANIA: SEDE ALBANIA COLEGIO DE ESTA LOCALIDAD: ALABINA-NO SNIES',
      'email': '',
    },
    {
      'name':
          'CAMPUS ALTAMIRA: COLEGIO EN CALIDAD DE PRESTAMO PARA DICTAR CLASES: COL01',
      'email': '',
    },
    {'name': 'CAMPUS CENTRO: BLOQUE DE AULAS: BIENESTAR'},
    {'name': 'CAMPUS CENTRO: BLOQUE DE AULAS: CANCHA DE FUTBOL', 'email': ''},
    // ... más participantes
  ];

  @override
  void initState() {
    super.initState();
    _asuntoController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _asuntoController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ****************************************************
  // *             Metodos Privados                     *
  // ****************************************************

  /// ### Método que valida los campos y habilita el botón de crear encuentro
  void _validatorButtonCreate() {
    // Validar que todos los campos obligatorios estén llenos
    final bool isAsuntoNotEmpty =
        (_asuntoController.text.trim().isNotEmpty &&
        _asuntoController.text != '');
    final bool isDescriptionNotEmpty =
        (_descriptionController.text.trim().isNotEmpty &&
        _descriptionController.text != '');
    setState(() {
      _isCreateButtonEnabled =
          _selectedMeet &&
          isAsuntoNotEmpty &&
          isDescriptionNotEmpty &&
          _addParticipants;
      print('Encuentro: $_isCreateButtonEnabled');
      print('Participantes: $_isCreateButtonEnabled');
      print('Mostar botón de crear: $_isCreateButtonEnabled');
    });
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
            context.goNamed(RouteNames.myMeets);
          },
          backgroundColor:
              TipoColores.pantone356C.value, // Color de fondo de la AppBar
          leadingIconColor:
              TipoColores.seasalt.value, // Color del icono de retroceso
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: _portraitLayout(),
          ),
        ),
      ),
    );
  }

  Widget _portraitLayout() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      CustomDropdown(
        prefixIcon: Icons.event_note_outlined,
        title: 'Tipo de encuentro',
        options: _encounterTypes,
        initialValue: _selectedMeetType,
        onChanged: (final newValue) {
          setState(() {
            _selectedMeetType = newValue!;
            _selectedMeet =
                true; // Actualiza el estado de selección del encuentro
          });
          _validatorButtonCreate();
        },
      ),
      if (_selectedMeet) ...[
        const SizedBox(height: 15),
        CustomTextField(
          labelText: 'Asunto',
          prefixIcon: Icons.edit_outlined,
          controller: _asuntoController,
          maxLength: 70,
          showCounter: true,
        ),
        const SizedBox(height: 5),
        CustomTextField(
          labelText: 'Descripción',
          prefixIcon: Icons.edit_note,
          controller: _descriptionController,
          maxLength: 150,
          showCounter: true,
        ),
        const SizedBox(height: 15),
        // Espacio de agregar participantes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              color: TipoColores.pantone663C,
              colorIcon: TipoColores.pantone634C,
              text: 'Agregar participantes',
              icon: Icons.group_add_outlined,
              width:
                  MediaQuery.of(context).size.width *
                  0.75, // 75% del ancho de la pantalla,
              onPressed: () {
                setState(() {
                  _addParticipants =
                      true; // Actualiza el estado de agregar participantes
                });
                if (_selectedMeetType == 'Clases académicas') {
                  CustomPopUp.show(
                    context,
                    title: 'Grupos',
                    onClose: () {
                      if (!context.mounted) {
                        return;
                      }
                      context.pop();
                    },
                    onCheck: (final List<Map<String, String>> selectedCards) {
                      if (!context.mounted) {
                        return;
                      }
                      context.pop();
                    },
                    onCardPressed: (final int index) {
                      // Acción del botón dentro del pop-up
                      print('Botón de agregar grupos presionado');
                    },
                    participants: myParticipants,
                  );
                } else {
                  CustomPopUp.show(
                    context,
                    title: 'Agregar participantes',
                    onClose: () {
                      if (!context.mounted) {
                        return;
                      }
                      context.pop();
                    },
                    onCheck: (final List<Map<String, String>> selectedCards) {
                      if (!context.mounted) {
                        return;
                      }
                      context.pop();
                    },
                    showSearchBar: true,
                    onCardPressed: (final int index) {
                      // Acción del botón dentro del pop-up
                      print('Botón de agregar participantes presionado');
                    },
                    participants: myParticipants,
                  );
                }
                _validatorButtonCreate();
              },
            ),
            // Ver / eliminar participantes
            if (_addParticipants)
              IconButton(
                icon: Icon(
                  Icons.visibility_rounded,
                  color: TipoColores
                      .pantoneCool
                      .value, // Color común para los iconos de acción
                  size: 30, // Tamaño común para los iconos de acción
                ),
                onPressed: () {
                  CustomPopUp.show(
                    context,
                    title: 'Participantes',
                    onClose: () {
                      if (!context.mounted) {
                        return;
                      }
                      context.pop();
                    },
                    onCheck: (final List<Map<String, String>> selectedCards) {
                      if (!context.mounted) {
                        return;
                      }
                      context.pop();
                    },
                    onCardPressed: (final int index) {
                      // Acción del botón dentro del pop-up
                      print('Participante eliminado');
                    },
                    showButtonCard: true,
                    isChoose: false,
                    participants: myParticipants,
                    iconButtonCard: const Icon(Icons.close),
                    colorButtonCard: TipoColores.pantone7621C,
                  );
                },
              ),
          ],
        ),
        // Espacio de selección del líder del encuentro
        if (_selectedMeetType == 'Reunión administrativa') ...[
          const SizedBox(height: 15),
          CustomSelectionField(
            title: 'Líder del encuentro',
            prefixIcon: Icons.person_add_alt_1,
            displayValue:
                _selectedLeadingUser, // Variable que contiene el nombre del líder elegido
            onPressed: () {
              CustomPopUp.show(
                context,
                title: 'Elegir líder de reunión',
                onClose: () {
                  if (!context.mounted) {
                    return;
                  }
                  context.pop();
                },
                onCheck: (final List<Map<String, String>> selectedCards) {
                  if (!context.mounted) {
                    return;
                  }
                  context.pop();
                  setState(
                    () {},
                  ); // Forzar una reconstrucción del padre para que el CustomSelectionField se actualice
                },
                showButtonCard: true,
                iconButtonCard: _isSelectedLeanding
                    ? const Icon(Icons.check_box_outlined)
                    : const Icon(Icons.check_box_outline_blank_rounded),
                colorButtonCard: _isSelectedLeanding
                    ? TipoColores.pantone356C
                    : TipoColores.pantone634C,
                participants: myParticipants,
              );
              _validatorButtonCreate();
            },
          ),
        ],
        const SizedBox(height: 30),
        Row(
          children: [
            const SizedBox(height: 10),
            Icon(
              Icons.edit_calendar_rounded,
              color: TipoColores.pantoneCool.value,
              size: 25,
            ),
            const SizedBox(width: 10),
            Text(
              'Configurar fecha y hora',
              style: TextStyle(
                color: TipoColores.pantoneBlackC.value,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Divider(color: TipoColores.pantoneCool.value),
        const SizedBox(height: 10),
        _buildFullSchedule(), // Método que construye el widget de hora inicio y fin del encuentro
        // Espacio para decidir si se quiere generar acta
        if (_selectedMeetType == 'Reunión administrativa') ...[
          const SizedBox(height: 15),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: IconButton(
                  icon: Icon(
                    certificate
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank_rounded,
                    color: certificate
                        ? TipoColores.pantone356C.value
                        : TipoColores
                              .pantoneCool
                              .value, // Color común para los iconos de acción
                    size: 30, // Tamaño común para los iconos de acción
                  ),
                  onPressed: () {
                    setState(() {
                      certificate = !certificate;
                    });
                    print(certificate);
                  },
                ),
              ),
              Text(
                'Generar acta',
                style: TextStyle(
                  color: TipoColores.pantoneBlackC.value,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 15),
        // Espacio de botón para finalizar la creación del encuentro
        if (_isCreateButtonEnabled)
          CustomButton(
            color: TipoColores.pantone158C,
            text: 'Crear encuentro',
            width:
                MediaQuery.of(context).size.width *
                0.80, // 80% del ancho de la pantalla
            onPressed: () {},
          ),
      ],
    ],
  );

  // ***************************************************************************
  //                       Métodos visuales auxiliares                         *
  // ***************************************************************************
  ///---------------------------------------------------------------------------
  /// ### Método para construir el widget de hora inicio y fin del encuentro.
  ///---------------------------------------------------------------------------
  Widget _buildFullSchedule() => Column(
    children: [
      // Espacio de selección de la fecha del encuentro
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Fecha del encuentro',
            style: TextStyle(
              color: TipoColores.pantoneBlackC.value,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 10),
          _buildButtonDate(
            date: _startDate,
            onDatePressed: () => _pickDate(true),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Divider(color: TipoColores.pantoneCool.value),
      _buildSchedule(), // Espacio de hora inicio y fin del encuentro
      // Selección de ubicación
      CustomSelectionField(
        title: 'Ubicación',
        prefixIcon: Icons.location_on_outlined,
        displayValue:
            _selectedLocation, // Variable que contiene la ubicación elegida
        onPressed: () {
          CustomPopUp.show(
            context,
            onClose: () {
              if (!context.mounted) {
                return;
              }
              context.pop();
            },
            title: 'Seleccionar ubicación',
            showButtonCard: true,
            onCheck: (final List<Map<String, String>> selectedCards) {
              print(selectedCards);
              if (!context.mounted) {
                return;
              }
              context.pop();
            },
            showSearchBar: true,
            // ignore: avoid_print
            onCardPressed: (final int index) => print('Ubicación seleccionada'),
            participants: myLocations,
          );
        },
      ),
      const SizedBox(height: 15),
      // Espacio de selección de repetición del encuentro
      CustomDropdown(
        prefixIcon: Icons.repeat_rounded,
        title: 'Repetir',
        options: _optionsRepeat,
        initialValue: _selectedRepeat,
        onChanged: (final newValue) {
          setState(() {
            _selectedRepeat = newValue!;
            repeat = newValue != 'Nunca';
            print(repeat);
            repeat
                ? _endDate
                : _endDate =
                      null; // Reinicia la fecha de fin si se cambia a nunca
          });
        },
      ),
      if (repeat) ...[
        const SizedBox(height: 15),
        CustomSelectionField(
          prefixIcon: Icons.event_rounded,
          title: 'Finalizar repetición',
          displayValue: _endDate != null
              ? _formatDate(_endDate!)
              : DateTime.now().toIso8601String().substring(
                  0,
                  10,
                ), // Muestra la fecha de fin o la actual si no se ha seleccionado
          onPressed: () {
            _pickDate(
              false,
            ); // Cambiado a false para que se guarde la fecha en _endDate
            print(_endDate);
          },
        ),
      ],
      const SizedBox(height: 15),
      // Espacio de selección del tiempo permitido de espera
      CustomDropdown(
        prefixIcon: Icons.watch_later_outlined,
        title: 'Tiempo permitido para registrar asistencia',
        options: _optionsTime,
        initialValue: _selectedTime,
        onChanged: (final newValue) {
          setState(() {
            _selectedTime = newValue!;
          });
        },
      ),
      const SizedBox(height: 15),
      // Espacio de botón por si se quiere agregar más horarios
      CustomButton(
        color: TipoColores.pantone663C,
        colorIcon: TipoColores.pantoneBlackC,
        text: 'Agregar nuevo horario',
        icon: Icons.calendar_month,
        width:
            MediaQuery.of(context).size.width *
            0.90, // 90% del ancho de la pantalla,
      ),
    ],
  );

  ///---------------------------------------------------------------------------
  /// ### Método para construir el widget de hora inicio y fin del encuentro.
  ///---------------------------------------------------------------------------
  Widget _buildSchedule() {
    // Estilo para los textos de encabezado
    final TextStyle scheduleLabelStyle = TextStyle(
      color: TipoColores.pantoneBlackC.value,
      fontWeight: FontWeight.bold,
    );

    return Card(
      elevation: 0,
      color: TipoColores.seasalt.value,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: TipoColores.pantone663C.value.withAlpha(
                  (0.7 * 255).toInt(),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Horario 1',
                  style: scheduleLabelStyle.copyWith(fontSize: 16),
                ),
              ),
            ),

            const Divider(), // Línea divisoria
            const SizedBox(height: 10),
            _buildScheduleRow(
              context: context,
              label: 'Hora inicio',
              time: _startTime,
              onTimePressed: () => _pickTime(true),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            _buildScheduleRow(
              context: context,
              label: 'Hora final',
              time: _endTime,
              onTimePressed: () => _pickTime(false),
            ),
            const SizedBox(height: 10),
            const Divider(), // Línea divisoria
          ],
        ),
      ),
    );
  }

  ///---------------------------------------------------------------------------
  /// ### Método auxiliar para construir el botón de fecha.
  ///---------------------------------------------------------------------------
  Widget _buildButtonDate({
    required final DateTime? date,
    required final VoidCallback onDatePressed,
  }) {
    final String formattedDate = date != null
        ? _formatDate(date)
        : 'Seleccionar fecha';
    return CustomButton(
      onPressed: onDatePressed,
      text: formattedDate,
      color: TipoColores.pantone634C,
      width:
          MediaQuery.of(context).size.width *
          0.40, // 40% del ancho de la pantalla,
    );
  }

  ///---------------------------------------------------------------------------
  /// ### Método auxiliar para construir una fila de horario con fecha y hora.
  ///---------------------------------------------------------------------------
  Widget _buildScheduleRow({
    required final BuildContext context,
    required final String label,

    required final TimeOfDay? time,

    required final VoidCallback onTimePressed,
  }) {
    // Definimos el estilo para los textos dentro del Row
    final TextStyle labelStyle = TextStyle(
      color: TipoColores.pantoneBlackC.value,
      fontSize: 16,
    );

    final String formattedTime = time != null
        ? time.format(context)
        : 'Seleccionar hora';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(label, style: labelStyle),
        CustomButton(
          onPressed: onTimePressed,
          text: formattedTime,
          color: TipoColores.pantone634C,
          width:
              MediaQuery.of(context).size.width *
              0.40, // 40% del ancho de la pantalla,
        ),
      ],
    );
  }

  /// --------------------------------------------------------------------------
  /// ### *Método que formatea la fecha*
  /// --------------------------------------------------------------------------
  String _formatDate(final DateTime date) {
    String twoDigits(final int n) => n.toString().padLeft(2, '0');
    final year = date.year;
    final month = twoDigits(date.month);
    final day = twoDigits(date.day);
    return '$year-$month-$day';
  }

  /// --------------------------------------------------------------------------
  /// ### Método para mostrar el selector de fecha.
  /// --------------------------------------------------------------------------
  Future<void> _pickDate(final bool isStart) async {
    // ThemeData personalizado para el showDatePicker
    final ThemeData customTheme = Theme.of(context).copyWith(
      // Colores del tema principal
      colorScheme: ColorScheme.light(
        // Fondo del pop-up del calendario.
        surface: TipoColores.seasalt.value,
        // Color del fondo de los botones "Cancelar" y "Aceptar" y del día seleccionado
        primary: TipoColores.pantone634C.value,
        // Color del texto del día seleccionado
        onPrimary: TipoColores.seasalt.value,
        // Color del texto de la barra superior
        onSurfaceVariant: TipoColores.pantone634C.value,
      ),
    );

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (final BuildContext context, final Widget? child) =>
          Theme(data: customTheme, child: child!),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  /// --------------------------------------------------------------------------
  /// ### Método para mostrar el selector de hora.
  ///---------------------------------------------------------------------------
  Future<void> _pickTime(final bool isStart) async {
    // ThemeData personalizado para el showTimePicker
    final ThemeData customTheme = Theme.of(context).copyWith(
      // Colores del tema principal
      colorScheme: ColorScheme.light(
        // Color del círculo, el número y los botones
        primary: TipoColores.pantone634C.value,
        // Color del texto no seleccionado
        onSurface: TipoColores.pantoneBlackC.value,
        // Color de fondo del pop up
        surface: TipoColores.seasalt.value,
        // Color del número seleccionado
        onPrimary: TipoColores.seasalt.value,
        // Color del número sin seleccionar
        onSecondary: TipoColores.seasalt.value,
        // Color del fondo del círculo del reloj
        secondary: TipoColores.pantone634C.value,
      ),
      // TimePickerThemeData para un control más preciso
      timePickerTheme: TimePickerThemeData(
        dialBackgroundColor:
            TipoColores.pantone663C.value, // Color del dial del reloj
      ),
    );

    // Envolver showTimePicker en el Theme para que use el tema personalizado
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (final BuildContext context, final Widget? child) =>
          Theme(data: customTheme, child: child!),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }
}
