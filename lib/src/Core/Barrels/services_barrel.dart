/// *****************************************************************
/// * Descripción:
/// * Este archivo funciona como barrel file para centralizar las exportaciones
/// * de servicios de la aplicación.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// * Notas:
/// *      - Facilita la importación organizada de los servicios usados en el proyecto,
///          estos servicios son las consultas a la API.
/// *
/// *****************************************************************
library;

/// Servicio que trae la información de los grupos del docente
export '../../Utils/Service/groups_service.dart';

/// Servicio que trae las ubicaciones de la universidad
export '../../Utils/Service/location_service.dart';

/// Servicio para los encuentros
export '../../Utils/Service/meeting_service.dart';
/// Servicio que trae la información de los tipos de repetición de un encuentro
export '../../Utils/Service/repetition_service.dart';
/// Servicio que trae la información de los tiempos permitidos para asistencia
export '../../Utils/Service/time_service.dart';
/// Servicio que trae los tipos de eventos
export '../../Utils/Service/type_events_service.dart';
/// Servicio que trae los funcionarios
export '../../Utils/Service/uni_workers_service.dart';
/// Servicio que trae los usuarios de la universidad
export '../../Utils/Service/users_service.dart';
