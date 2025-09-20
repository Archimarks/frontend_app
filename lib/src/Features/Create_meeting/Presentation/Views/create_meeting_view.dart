/// ****************************************************************************
/// ### CreateMeeting
/// * Fecha: 2025
/// * Descripción: Vista de crear encuentros.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// ****************************************************************************
// ignore_for_file: unrelated_type_equality_checks

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/Barrels/configs_barrel.dart';
import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Routes/route_names.dart';
import '../../Domain/Models/schedule_data.dart';
import '../../Domain/Service/grupos_service.dart';
import '../../Domain/Service/repeticion_service.dart';
import '../../Domain/Service/tiempo_service.dart';
import '../../Domain/Service/ubicacion_service.dart';

class CreateMeeting extends StatefulWidget {
  const CreateMeeting({super.key});

  @override
  State<CreateMeeting> createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  // ---------------------------------------------------------------------------
  // Estados principales del formulario
  // ---------------------------------------------------------------------------

  /// Indica si el botón de "Crear encuentro" está habilitado
  bool _isCreateButtonEnabled = false;

  /// Indica si se han agregado participantes
  bool _addParticipants = false;

  /// Indica si ya se seleccionó un tipo de encuentro
  bool _selectedMeet = false;

  /// Indica el tipo de encuentro seleccionado
  String? _selectedMeetType;

  /// Indica si el encuentro seleccionado es una clase
  bool isClass = false;

  /// Indica si se seleccionó un rol de usuario
  bool _selectedRolUser = false;

  /// Tipo de rol de usuario seleccionado
  String? _selectedTypeRolUser;

  /// Indica si se debe generar acta
  bool certificate = false;

  /// Indica si el encuentro es repetitivo
  bool repeat = false;

  /// Indica si se seleccionó tiempo permitido
  bool time = false;

  // ---------------------------------------------------------------------------
  // Controladores de texto
  // ---------------------------------------------------------------------------

  /// Controlador del campo "Asunto"
  late final TextEditingController _asuntoController;

  /// Controlador del campo "Descripción"
  late final TextEditingController _descriptionController;

  // ---------------------------------------------------------------------------
  // Selecciones y asignaciones de usuario
  // ---------------------------------------------------------------------------

  /// ID del líder seleccionado para el encuentro
  String? _selectedLeadingUser;

  /// IDs de participantes seleccionados
  List<String> _selectedParticipantId = [];

  /// ID de grupo seleccionado (Debe recibir solo un valor)
  List<String> _selectedGroupId = [];

  /// ID de líder seleccionado (Debe recibir solo un valor)
  List<String> _selectedLeaderId = [];

  /// Participantes agregados
  List<Map<String, String>> addedParticipants = [];

  // ---------------------------------------------------------------------------
  // Listas temporales (luego serán reemplazadas por datos de la API)
  // ---------------------------------------------------------------------------

  /// Tipos de encuentros disponibles
  final List<Map<String, String>> _encounterTypes = [
    {'id': '1', 'text': 'Reunión administrativa'},
    {'id': '2', 'text': 'Clases académicas'},
    {'id': '3', 'text': 'Entrenamiento de equipos'},
  ];

  /// Roles de usuario invitados
  final List<Map<String, String>> _rolUser = [
    {'id': '1', 'text': 'Docentes'},
    {'id': '2', 'text': 'Administrativos'},
    {'id': '3', 'text': 'Estudiantes'},
  ];

  /// Opciones de tiempo asistencia para los encuentros
  List<Map<String, String>> _optionsTime = [];

  /// Opciones de repetición de los encuentros
  List<Map<String, String>> _optionsRepeat = [];

  /// Lista de todas las personas disponibles
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

  /// Lista de ubicaciones disponibles
  List<Map<String, String>> locations = [];

  /// Lista de grupos disponibles
  List<Map<String, String>> groups = [];

  // ---------------------------------------------------------------------------
  // Horarios
  // ---------------------------------------------------------------------------

  /// Lista de horarios creados para el encuentro
  final List<ScheduleData> _schedules = [ScheduleData()];

  @override
  void initState() {
    super.initState();
    _asuntoController = TextEditingController();
    _descriptionController = TextEditingController();
    _loadGrupos();
    _loadUbicaciones();
    _loadRepeat();
    _loadTime();
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

  /// Método que asigna los grupos a una lista local
  Future<void> _loadGrupos() async {
    final pege = getString('pege') ?? '';

    try {
      final data = await GruposService().fetchGruposDocente(
        pegeld: int.parse(pege),
      );
      setState(() {
        groups = data;
      });
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint('Error al cargar los grupos: $e');
    }
  }

  /// Método que asigna las ubicaciones a una lista local
  Future<void> _loadUbicaciones() async {
    try {
      final data = await UbicacionService().fetchUbicaciones();
      setState(() {
        locations = data;
      });
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint('Error al cargar ubicaciones: $e');
    }
  }

  /// Método que asigna los tipos de repetición a una lista local
  Future<void> _loadRepeat() async {
    try {
      final data = await RepeatService().fetchRepeats();
      setState(() {
        _optionsRepeat = data;
      });
      print(_optionsRepeat);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint('Error al cargar las repeticiones: $e');
    }
  }

  /// Método que asigna los tiempos a una lista local
  Future<void> _loadTime() async {
    try {
      final data = await TimeService().fetchTime();
      setState(() {
        _optionsTime = data;
      });
      print(_optionsTime);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint('Error al cargar los tiempos permitidos: $e');
    }
  }

  ///---------------------------------------------------------------------------
  /// ### Método para validar que los horarios agregados estén completos.
  ///---------------------------------------------------------------------------
  String? _validateSchedules() {
    // Itera sobre la lista de horarios
    for (final schedule in _schedules) {
      // 1. Validar que los campos obligatorios del horario no sean nulos.
      if (schedule.startDate == null ||
          schedule.startTime == null ||
          schedule.endTime == null ||
          schedule.selectedLocationID == null) {
        // Si alguno de los campos de fecha u hora es nulo.
        return '';
      }

      // 2. Si el horario se repite, verifica que la fecha de finalización esté seleccionada.
      if (schedule.repeat && schedule.endDate == null) {
        return 'No se ha seleccionado fecha de finalización para el horario repetido.';
      }

      // 3. Comparar que la hora de inicio no sea posterior a la hora de finalización.
      final int startTimeInMinutes = _toMinutes(schedule.startTime!);
      final int endTimeInMinutes = _toMinutes(schedule.endTime!);
      if (startTimeInMinutes >= endTimeInMinutes) {
        return 'La hora de inicio debe ser anterior a la hora de finalización.';
      }

      // 4. Si la fecha de inicio es posterior o igual a la fecha de fin de repetición, no es válido.
      if (schedule.repeat && schedule.startDate!.isAfter(schedule.endDate!)) {
        return 'La fecha de finalización debe ser posterior a la fecha de inicio.';
      }

      // 5. Si el horario se repite, validar que la fecha de fin no sea igual o anterior a la de inicio.
      if (schedule.repeat && schedule.endDate!.isBefore(schedule.startDate!)) {
        return 'La fecha de finalización debe ser posterior a la fecha de inicio.';
      }

      // 6. Validar que la hora de inicio no sea anterior a la hora actual para el mismo día.
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Verificar si la fecha de inicio es hoy
      if (schedule.startDate != null &&
          schedule.startDate!.isAtSameMomentAs(today)) {
        final nowInMinutes = (now.hour * 60) + now.minute;
        final startTimeInMinutes = _toMinutes(schedule.startTime!);

        // Compara la hora de inicio con la hora actual
        if (startTimeInMinutes < nowInMinutes) {
          return 'No puedes programar una reunión con una hora de inicio anterior a la actual para el día de hoy.';
        }
      }
    }

    // Si todos los horarios son válidos, retorna null.
    return null;
  }

  ///---------------------------------------------------------------------------
  /// ### Método auxiliar para convertir TimeOfDay a minutos y compararlo
  ///---------------------------------------------------------------------------
  int _toMinutes(final TimeOfDay time) => time.hour * 60 + time.minute;

  ///---------------------------------------------------------------------------
  /// ### Método que valida los campos y habilita el botón de crear encuentro
  ///---------------------------------------------------------------------------
  void _validatorButtonCreate() {
    final String? validationError = _validateSchedules();

    if (validationError != null && validationError.isNotEmpty) {
      // Se muestra el SnackBar de advertencia cuando falta o está mal algún parámetro del horario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: TipoColores.pantone7621C.value,
        ),
      );
      setState(() {
        _isCreateButtonEnabled = false;
      });
      return;
    }

    // Validar que todos los campos obligatorios estén llenos
    final bool isAsuntoNotEmpty =
        (_asuntoController.text.trim().isNotEmpty &&
        _asuntoController.text != '');
    final bool isDescriptionNotEmpty =
        (_descriptionController.text.trim().isNotEmpty &&
        _descriptionController.text != '');
    final bool isSchedulesValid = _validateSchedules() == null;
    final bool isLeaderSelected =
        _selectedMeetType != 'Reunión administrativa' ||
        _selectedLeadingUser != null;
    final bool isRolUserSelected =
        _selectedMeetType != 'Entrenamiento de equipos' || _selectedRolUser;

    setState(() {
      _isCreateButtonEnabled =
          isRolUserSelected &&
          _selectedMeet &&
          isAsuntoNotEmpty &&
          isDescriptionNotEmpty &&
          _addParticipants &&
          isSchedulesValid &&
          isLeaderSelected;
    });
  }

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(final BuildContext context) {
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
            child: Builder(
              builder: (final BuildContext builderContext) => _portraitLayout(),
            ),
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
            print(_selectedMeetType);
            _selectedMeet =
                true; // Actualiza el estado de selección del encuentro
            isClass = _selectedMeetType == '2';
          });
          _validatorButtonCreate();
        },
      ),
      if (_selectedMeet) ...[
        if (_selectedMeetType == '3') ...[
          const SizedBox(height: 15),
          CustomDropdown(
            prefixIcon: Icons.sports_kabaddi_rounded,
            title: 'Dirigido a:',
            options: _rolUser,
            initialValue: _selectedTypeRolUser,
            onChanged: (final newValue) {
              setState(() {
                _selectedTypeRolUser = newValue!;
                _selectedRolUser =
                    true; // Actualiza el estado de selección del rol
              });
              _validatorButtonCreate();
            },
          ),
        ],
        const SizedBox(height: 15),
        CustomTextField(
          labelText: 'Asunto *',
          prefixIcon: Icons.edit_outlined,
          controller: _asuntoController,
          maxLength: 70,
          showCounter: true,
          onChanged: (final value) => _validatorButtonCreate(),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          labelText: 'Descripción *',
          prefixIcon: Icons.edit_note,
          controller: _descriptionController,
          maxLength: 150,
          showCounter: true,
          onChanged: (final value) => _validatorButtonCreate(),
        ),
        const SizedBox(height: 15),
        // Espacio de agregar participantes
        CustomButton(
          color: TipoColores.pantone663C,
          colorIcon: TipoColores.pantone634C,
          text: _selectedMeetType == '2'
              ? 'Seleccionar grupo'
              : 'Agregar participantes',
          icon: Icons.group_add_outlined,
          width:
              MediaQuery.of(context).size.width *
              0.75, // 75% del ancho de la pantalla,
          onPressed: () {
            if (_selectedMeetType == '2') {
              // Se muestran los grupos si son clases académicas
              CustomPopUp.show(
                context,
                title: 'Grupos',
                showButtonCard: true,
                onClose: () {
                  if (!context.mounted) {
                    return;
                  }
                  context.pop();
                },
                onCheck: (final List<Map<String, String>> selectedCards) {
                  setState(() {
                    _selectedGroupId = selectedCards
                        .map((final card) => card['id']!)
                        .toList();
                    _addParticipants = selectedCards.isNotEmpty;
                  });

                  if (!context.mounted) {
                    return;
                  }
                  context.pop();
                  _validatorButtonCreate();
                },
                infoShowCards: groups,
                showAllDataInitially: true,
                initialSelectedIDs: _selectedGroupId,
              );
            } else {
              // Se muestran los participantes para los otros tipos de encuentro
              CustomPopUp.show(
                context,
                title: 'Agregar participantes',
                showButtonCard: true,
                isOneSelection: false,
                onClose: () {
                  if (!context.mounted) {
                    return;
                  }
                  context.pop();
                },
                onCheck: (final List<Map<String, String>> selectedCards) {
                  // Aquí se actualiza la lista de participantes
                  setState(() {
                    addedParticipants = selectedCards;
                    _selectedParticipantId = selectedCards
                        .map((final card) => card['id']!)
                        .toList();
                    _addParticipants = selectedCards.isNotEmpty;
                  });
                  if (!context.mounted) {
                    return;
                  }
                  context.pop();
                  _validatorButtonCreate();
                },

                showSearchBar: true,
                infoShowCards: allPerson,
                initialSelectedIDs: _selectedParticipantId,
              );
            }
          },
        ),
        // Espacio de selección del líder del encuentro
        if (_selectedMeetType == '1') ...[
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
                  // Aquí se actualiza el líder seleccionado
                  setState(
                    () {
                      _selectedLeadingUser = selectedCards.isNotEmpty
                          ? selectedCards.first['textMain']
                          : null; // Actualiza el nombre del líder seleccionado

                      _selectedLeaderId = selectedCards
                          .map((final card) => card['id']!)
                          .toList();
                    },
                  ); // Forzar una reconstrucción del padre para que el CustomSelectionField se actualice
                  if (!context.mounted) {
                    return;
                  }
                  context.pop();
                  _validatorButtonCreate();
                },
                showSearchBar: true,
                showButtonCard: true,
                infoShowCards: allPerson,
                initialSelectedIDs: _selectedLeaderId,
              );
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
              'Configurar horario(s) del encuentro',
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
        // Itera sobre la lista de horarios y construye un widget para cada uno
        ..._schedules.asMap().entries.map((final entry) {
          final int index = entry.key;
          return _buildScheduleWidget(index);
        }),
        // Botón "Agregar nuevo horario" después de todos los horarios
        if (_selectedMeetType != '2' && _schedules.length < 3)
          CustomButton(
            color: TipoColores.pantone663C,
            colorIcon: TipoColores.pantoneBlackC,
            text: 'Agregar nuevo horario',
            icon: Icons.calendar_month,
            width: MediaQuery.of(context).size.width * 0.90,
            onPressed: () {
              if (_validateSchedules() != null) {
                // Si hay un error de validación en los campos del horario
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Faltan campos obligatorios en el horario o no son válidos.',
                    ),
                    backgroundColor: TipoColores.pantone7621C.value,
                  ),
                );
              } else {
                // Si no hay errores, se agrega un nuevo horario.
                setState(() {
                  _schedules.add(ScheduleData(selectedRepeat: isClass ? 4 : 1));
                  _validatorButtonCreate();
                });
              }
            },
          ),
        // Espacio para decidir si se quiere generar acta
        if (_selectedMeetType == '1') ...[
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
            onPressed: () {
              if (!context.mounted) {
                return;
              }
              context.goNamed(RouteNames.myMeets);
            },
          ),
      ],
    ],
  );

  // ***************************************************************************
  //                       Métodos visuales auxiliares                         *
  // ***************************************************************************
  ///---------------------------------------------------------------------------
  /// ## Método para construir el widget de horario completo.
  /// Se construye un widget que incluye:
  /// * Fecha
  /// * Hora inicio y hora fin
  /// * Ubicación
  /// * Si se repite o no
  /// * Tiempo permitido para el registro de asistencia
  /// - Si el tipo de encuentro es clase, solo se dejan editar los campos de fecha fin repetición y tiempo permitido
  ///---------------------------------------------------------------------------
  Widget _buildScheduleWidget(final int index) {
    final ScheduleData currentSchedule = _schedules[index];

    return Column(
      children: [
        // Espacio de selección de la fecha del encuentro
        Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          decoration: BoxDecoration(
            color: TipoColores.pantone663C.value.withAlpha((0.7 * 255).toInt()),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Titulo del horario
              Text(
                'Horario ${index + 1}',
                style: TextStyle(
                  color: TipoColores.pantoneBlackC.value,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (_schedules.length >
                  1) // Solo muestra el botón de eliminar si hay más de un horario
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: TipoColores.pantone7621C.value,
                    size: 30,
                  ),
                  onPressed: () {
                    CustomAlertDialog.show(
                      context,
                      title: 'Eliminar horario',
                      message:
                          '¿Estás seguro que quieres eliminar este horario?',
                      confirmButtonText: 'Eliminar',
                      cancelButtonText: 'Cancelar',
                      colorButtonConfirm: TipoColores.pantone7621C,
                      onConfirm: () {
                        setState(() {
                          _schedules.removeAt(index);
                        });
                        _validatorButtonCreate();
                        if (!context.mounted) {
                          return;
                        }
                        context.pop();
                      },
                      onCancel: () {
                        if (!context.mounted) {
                          return;
                        }
                        context.pop(); // Cierra el diálogo sin hacer nada
                      },
                    );
                  },
                ),
            ],
          ),
        ),
        const Divider(),
        const SizedBox(height: 10),
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
              initialDateString: isClass
                  ? DateTime.now().toString()
                  : 'Seleccionar fecha',
              date: currentSchedule.startDate,
              onDatePressed: isClass ? null : () => _pickDate(index, true),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(), // Línea divisoria
        const SizedBox(height: 10),
        // Espacio de selección de la hora de inicio y hora final del encuentro
        _buildScheduleRow(
          context: context,
          label: 'Hora inicio',
          initialTimeString: isClass
              ? TimeOfDay.now().toString()
              : 'Seleccionar hora',
          time: currentSchedule.startTime,
          onTimePressed: isClass ? null : () => _pickTime(index, true),
        ),
        const SizedBox(height: 10),
        const Divider(), // Línea divisoria
        const SizedBox(height: 10),
        _buildScheduleRow(
          context: context,
          label: 'Hora final',
          initialTimeString: isClass
              ? TimeOfDay.now().toString()
              : 'Seleccionar hora',
          time: currentSchedule.endTime,
          onTimePressed: isClass ? null : () => _pickTime(index, false),
        ),
        const SizedBox(height: 10),
        const Divider(),
        // Espacio de selección de la ubicación del encuentro
        CustomSelectionField(
          title: 'Ubicación',
          prefixIcon: Icons.location_on_outlined,
          displayValue: currentSchedule.selectedLocationName,
          onPressed: isClass
              ? null
              : () {
                  CustomPopUp.show(
                    context,
                    onCheck: (final List<Map<String, String>> selectedCards) {
                      setState(() {
                        currentSchedule
                          ..selectedLocationName = selectedCards.isNotEmpty
                              ? selectedCards.first['textMain']
                              : null
                          ..selectedLocationID = selectedCards.isNotEmpty
                              ? selectedCards.first['id']
                              : null;
                        _validatorButtonCreate();
                      });
                      if (!context.mounted) {
                        return;
                      }
                      context.pop();
                    },
                    title: 'Seleccionar ubicación',
                    searchHintText: 'Escribe el nombre de la ubicación...',
                    showButtonCard: true,
                    showSearchBar: true,
                    showAllDataInitially: true,
                    infoShowCards: locations,
                    initialSelectedIDs:
                        currentSchedule.selectedLocationID != null
                        ? [currentSchedule.selectedLocationID!]
                        : [],
                    onClose: () {
                      if (!context.mounted) {
                        return;
                      }
                      context.pop();
                    },
                  );
                },
        ),
        const SizedBox(height: 15),
        CustomDropdown(
          prefixIcon: Icons.repeat_rounded,
          title: 'Repetir',
          options: _optionsRepeat,
          initialValue: isClass
              ? '4'
              : currentSchedule.selectedRepeat.toString(),
          onChanged: isClass
              ? null
              : (final newValue) {
                  setState(() {
                    currentSchedule
                      ..selectedRepeat = int.parse(newValue!)
                      ..repeat = newValue != '1';
                    _validatorButtonCreate();
                  });
                },
        ),
        if (currentSchedule.repeat || _selectedMeetType == '2') ...[
          const SizedBox(height: 15),
          CustomSelectionField(
            prefixIcon: Icons.event_rounded,
            title: 'Finalizar repetición',
            displayValue: currentSchedule.endDate != null
                ? _formatDate(currentSchedule.endDate!)
                : DateTime.now().toIso8601String().substring(0, 10),
            onPressed: () {
              _pickDate(index, false);
            },
          ),
        ],
        const SizedBox(height: 15),
        CustomDropdown(
          prefixIcon: Icons.watch_later_outlined,
          title: 'Tiempo permitido para registrar asistencia',
          options: _optionsTime,
          initialValue: currentSchedule.selectedTime.toString(),
          onChanged: (final newId) {
            setState(() {
              currentSchedule.selectedTime = int.parse(newId!); // Guardar id
              _validatorButtonCreate();
            });
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  ///---------------------------------------------------------------------------
  /// ### Método auxiliar para construir el botón de fecha.
  ///---------------------------------------------------------------------------
  Widget _buildButtonDate({
    required final String initialDateString,
    required final DateTime? date,
    required final VoidCallback? onDatePressed,
  }) {
    final String formattedDate = date != null
        ? _formatDate(date)
        : initialDateString; // Formato YYYY-MM-DD
    return CustomButton(
      onPressed: onDatePressed,
      text: formattedDate,
      color: TipoColores.pantone634C,
      disabledColor: TipoColores.pantone634C,
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
    required final String initialTimeString,
    required final TimeOfDay? time,
    required final VoidCallback? onTimePressed,
  }) {
    // Definimos el estilo para los textos dentro del Row
    final TextStyle labelStyle = TextStyle(
      color: TipoColores.pantoneBlackC.value,
      fontSize: 16,
    );

    final String formattedTime = time != null
        ? time.format(context)
        : initialTimeString;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(label, style: labelStyle),
        CustomButton(
          onPressed: onTimePressed,
          text: formattedTime,
          color: TipoColores.pantone634C,
          disabledColor: TipoColores.pantone634C,
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
  Future<void> _pickDate(final int index, final bool isStart) async {
    final ThemeData customTheme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        surface: TipoColores.seasalt.value,
        primary: TipoColores.pantone634C.value,
        onPrimary: TipoColores.seasalt.value,
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
          _schedules[index].startDate = pickedDate;
        } else {
          _schedules[index].endDate = pickedDate;
        }
        _validatorButtonCreate();
      });
    }
  }

  /// --------------------------------------------------------------------------
  /// ### Método para mostrar el selector de hora.
  ///---------------------------------------------------------------------------
  Future<void> _pickTime(final int index, final bool isStart) async {
    final ThemeData customTheme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: TipoColores.pantone634C.value,
        onSurface: TipoColores.pantoneBlackC.value,
        surface: TipoColores.seasalt.value,
        onPrimary: TipoColores.seasalt.value,
        onSecondary: TipoColores.seasalt.value,
        secondary: TipoColores.pantone634C.value,
      ),
      timePickerTheme: TimePickerThemeData(
        dialBackgroundColor: TipoColores.pantone663C.value,
      ),
    );

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (final BuildContext context, final Widget? child) =>
          Theme(data: customTheme, child: child!),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _schedules[index].startTime = pickedTime;
        } else {
          _schedules[index].endTime = pickedTime;
        }
        _validatorButtonCreate();
      });
    }
  }
}
