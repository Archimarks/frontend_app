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
import '../../../../Core/Barrels/models_barrel.dart';
import '../../../../Core/Barrels/services_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../../Core/Models/schedule_parser_data.dart';
import '../../../../Core/Routes/route_names.dart';

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
  List<Map<String, String>> _encounterTypes = [];

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
  List<Map<String, String>> allUsers = [];

  /// Lista de ubicaciones disponibles
  List<Map<String, String>> locations = [];

  /// Lista de grupos del docente
  List<Map<String, String>> groups = [];

  /// Lista con la información de los grupos
  List<Grupo> infoGroups = [];

  // ---------------------------------------------------------------------------
  // Horarios
  // ---------------------------------------------------------------------------

  /// Lista de horarios creados para el encuentro
  List<ScheduleData> _schedules = [];

  @override
  void initState() {
    super.initState();
    _asuntoController = TextEditingController();
    _descriptionController = TextEditingController();
    _loadUsers();
    _loadTypeEvents();
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

  /// Método que asigna los tipos de eventos a una lista local
  Future<void> _loadTypeEvents() async {
    try {
      final data = await TypeEventsService().fetchTypeEvents();
      setState(() {
        _encounterTypes = data;
      });
      print('Tipos de encuentros: $_encounterTypes');
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint('Error al traer los tipos de eventos: $e');
    }
  }

  /// Método que asigna los usuarios a una lista local
  Future<void> _loadUsers() async {
    try {
      final data = await UserService().fetchUsers();
      setState(() {
        allUsers = data;
        print('Usuarios: $allUsers');
      });
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint('Error al cargar los usuarios: $e');
    }
  }

  /// Método que asigna los grupos a una lista local
  Future<void> _loadGrupos() async {
    final pege = getString('pege') ?? '';

    try {
      final data = await GruposService().fetchGruposDocente(
        pegeld: int.parse(pege),
      );
      setState(() {
        infoGroups = data;
        groups = data
            .map(
              (final grupo) => {
                'id': grupo.id.toString(),
                'textMain': '${grupo.materia} - ${grupo.grupo}',
              },
            )
            .toList();
        print('Info grupos: $infoGroups');
        print('Grupos: $groups');
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
      print('Repeticion: $_optionsRepeat');
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
      print('Tiempos: $_optionsTime');
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

  /// Guardar horarios del grupo
  void _addGroupSchedules(final Grupo grupo) {
    // Variable para saber los días del horario del grupo
    final _ =
        {
          'lunes': grupo.lunes,
          'martes': grupo.martes,
          'miercoles': grupo.miercoles,
          'jueves': grupo.jueves,
          'viernes': grupo.viernes,
          'sabado': grupo.sabado,
          'domingo': grupo.domingo,
        }..forEach((final dia, final rawHorario) {
          final parsed = ScheduleParser.parseScheduleString(rawHorario);

          if (parsed != null) {
            final schedule = ScheduleData(
              startDate: DateTime.now(),
              startTime: parsed.startTime,
              endTime: parsed.endTime,
              selectedLocationName: parsed.location,
              selectedLocationID: grupo.id.toString(),
              selectedRepeat: 4, // Clase
              repeat: true,
            );

            _schedules.add(schedule);
          }
        });

    setState(() {
      _schedules = List.from(_schedules); // Forzar rebuild
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
            _selectedMeet =
                true; // Actualiza el estado de selección del encuentro
            isClass = _selectedMeetType == '4';

            print(_addParticipants);
            // Limpiar horarios y demás estados relacionados
            _schedules.clear();
            _selectedGroupId.clear();
            print(_addParticipants);
            _addParticipants = false;

            if (!isClass) {
              // Si NO es clase, crear al menos un horario vacío para empezar a editar
              _schedules.add(ScheduleData());
            }
          });
          _validatorButtonCreate();
        },
      ),
      if (_selectedMeet) ...[
        if (_selectedMeetType == '5') ...[
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
          text: _selectedMeetType == '4'
              ? 'Seleccionar grupo'
              : 'Agregar participantes',
          icon: Icons.group_add_outlined,
          width:
              MediaQuery.of(context).size.width *
              0.75, // 75% del ancho de la pantalla,
          onPressed: () {
            if (_selectedMeetType == '4') {
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
                onCheck: (final List<Map<String, String>> selectedGroup) {
                  setState(() {
                    _selectedGroupId = selectedGroup
                        .map((final group) => group['id']!)
                        .toList();
                    _addParticipants = selectedGroup.isNotEmpty;

                    if (_selectedGroupId.isNotEmpty) {
                      // Buscar el grupo seleccionado en la lista infoGroups
                      final infoSelectedGroup = infoGroups.firstWhere(
                        (final grupo) =>
                            grupo.id == int.parse(_selectedGroupId.first),
                      );
                      // Primero se limpia y luego se agregan los horarios del grupo
                      _schedules.clear();
                      // Llamar método para agregar los horarios del grupo
                      _addGroupSchedules(infoSelectedGroup);
                    }
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
                infoShowCards: allUsers,
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
                infoShowCards: allUsers,
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
        if (_selectedMeetType != '4' && _schedules.length < 3)
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
                  _schedules.add(ScheduleData());
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
        // ---------------------------
        // Título del horario
        // ---------------------------
        Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          decoration: BoxDecoration(
            color: TipoColores.pantone663C.value.withAlpha((0.7 * 255).toInt()),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Horario ${index + 1}',
                style: TextStyle(
                  color: TipoColores.pantoneBlackC.value,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (_schedules.length > 1)
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
                        context.pop();
                      },
                    );
                  },
                ),
            ],
          ),
        ),
        const Divider(),
        const SizedBox(height: 10),
        PickedDate(
          title: 'Fecha del encuentro',
          date: currentSchedule.startDate,
          onPressed: isClass
              ? null
              : () async {
                  final DateTime? picked = await PickedDate.showDate(context);
                  if (picked != null) {
                    setState(() {
                      currentSchedule.startDate = picked;
                      _validatorButtonCreate();
                    });
                  }
                },
        ),
        const SizedBox(height: 15),
        // Hora inicio
        PickedTime(
          title: 'Hora inicio',
          time: currentSchedule.startTime,
          onPressed: isClass
              ? null
              : () async {
                  final picked = await PickedTime.showTime(
                    context,
                    initialTime: currentSchedule.startTime,
                  );
                  if (picked != null) {
                    setState(() {
                      currentSchedule.startTime = picked;
                      _validatorButtonCreate();
                    });
                  }
                },
        ),
        const SizedBox(height: 15),
        // Hora final
        PickedTime(
          title: 'Hora final',
          time: currentSchedule.endTime,
          onPressed: isClass
              ? null
              : () async {
                  final picked = await PickedTime.showTime(
                    context,
                    initialTime: currentSchedule.endTime,
                  );
                  if (picked != null) {
                    setState(() {
                      currentSchedule.endTime = picked;
                      _validatorButtonCreate();
                    });
                  }
                },
        ),
        const SizedBox(height: 15),
        // ---------------------------
        // Ubicación
        // ---------------------------
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
        // ---------------------------
        // Repetir
        // ---------------------------
        SizedBox(
          width: double.infinity, // 👈 ocupa todo el ancho posible
          child: CustomDropdown(
            prefixIcon: Icons.repeat_rounded,
            title: 'Repetir',
            options: _optionsRepeat,
            initialValue: isClass
                ? '19'
                : currentSchedule.selectedRepeat.toString(),
            onChanged: isClass
                ? null
                : (final newValue) {
                    setState(() {
                      currentSchedule
                        ..selectedRepeat = int.parse(newValue!)
                        ..repeat = newValue != '21';
                      _validatorButtonCreate();
                    });
                  },
          ),
        ),
        // ---------------------------
        // Fecha de finalización si hay repetición
        // ---------------------------
        if (currentSchedule.repeat || _selectedMeetType == '4') ...[
          const SizedBox(height: 15),
          PickedDate(
            title: 'Finalizar repetición',
            date: currentSchedule.endDate,
            onPressed: () async {
              final DateTime? picked = await PickedDate.showDate(context);
              if (picked != null) {
                setState(() {
                  currentSchedule.endDate = picked;
                  _validatorButtonCreate();
                });
              }
            },
          ),
        ],
        const SizedBox(height: 15),
        // ---------------------------
        // Tiempo permitido asistencia
        // ---------------------------
        CustomDropdown(
          prefixIcon: Icons.watch_later_outlined,
          title: 'Tiempo permitido para registrar asistencia',
          options: _optionsTime,
          initialValue: currentSchedule.selectedTime.toString(),
          onChanged: (final newId) {
            setState(() {
              currentSchedule.selectedTime = int.parse(newId!);
              _validatorButtonCreate();
            });
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
