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

class CreateMeeting extends StatefulWidget {
  const CreateMeeting({super.key});

  @override
  State<CreateMeeting> createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  String _selectedMeetType = 'Reunión administrativa';

  final List<String> _encounterTypes = [
    'Reunión administrativa',
    'Clases académicas',
    'Eventos de bienestar universitario',
  ];
  late final TextEditingController
  _asuntoController; // Controlador para el campo de asunto
  late final TextEditingController
  _descriptionController; // Controlador para el campo de descripción
  final String _selectedLeadingUser = 'Reunión administrativa';
  DateTime? _startDate; // Fecha de inicio por defecto
  TimeOfDay? _startTime; // Hora de inicio por defecto
  DateTime? _endDate; // Fecha de fin por defecto
  TimeOfDay? _endTime; // Hora de fin por defecto

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
          });
          print('Se seleccionó: $_selectedMeetType');
        },
      ),
      const SizedBox(height: 15),
      CustomTextField(
        labelText: 'Asunto',
        prefixIcon: Icons.edit_outlined,
        controller: _asuntoController,
        maxLength: 70,
        showCounter: true,
      ),
      const SizedBox(height: 15),
      CustomTextField(
        labelText: 'Descripción',
        prefixIcon: Icons.edit_note,
        controller: _descriptionController,
        maxLength: 150,
        showCounter: true,
      ),
      const SizedBox(height: 15),
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
          ),
          IconButton(
            icon: Icon(
              Icons.visibility_rounded,
              color: TipoColores
                  .pantoneCool
                  .value, // Color común para los iconos de acción
              size: 30, // Tamaño común para los iconos de acción
            ),
            onPressed: () {},
          ),
        ],
      ),
      const SizedBox(height: 20),
      _buildSpaceLeadingUser(),
      const SizedBox(height: 20),
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
      const SizedBox(height: 20),
      const Divider(),
      const SizedBox(height: 10),
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
      const Divider(),
      _buildSchedule(),
      CustomButton(
        color: TipoColores.pantone663C,
        colorIcon: TipoColores.pantoneBlackC,
        text: 'Agregar nuevo horario',
        icon: Icons.calendar_month,
        width:
            MediaQuery.of(context).size.width *
            0.75, // 75% del ancho de la pantalla,
      ),
    ],
  );

  // ***************************************************************************
  //                       Métodos visuales auxiliares                         *
  // ***************************************************************************

  ///---------------------------------------------------------------------------
  /// ### Método para construir el widget de líder de reunión.
  ///---------------------------------------------------------------------------
  Widget _buildSpaceLeadingUser() => GestureDetector(
    onTap: () {
      print('Se seleccionó: $_selectedMeetType');
    },
    child: Column(
      children: [
        Row(
          children: [
            const SizedBox(height: 10),
            Icon(
              Icons.person_add_alt_1,
              color: TipoColores.pantoneCool.value,
              size: 25,
            ),
            const SizedBox(width: 10),
            Text(
              'Líder del encuentro',
              style: TextStyle(
                color: TipoColores.pantoneBlackC.value,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 10),
            Text(
              _selectedLeadingUser, // Usuario seleccionado como líder
              style: TextStyle(
                color: TipoColores.pantoneBlackC.value,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Icon(
              Icons.expand_more_rounded,
              color: TipoColores.pantoneCool.value,
              size: 25,
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 10),
      ],
    ),
  );

  ///---------------------------------------------------------------------------
  /// ### Método para construir el widget de horario.
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
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
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
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
