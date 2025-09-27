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
export '../../Utils/Service/grupos_service.dart';
/// Servicio que trae la información de los tipos de repetición de un encuentro
export '../../Utils/Service/repeticion_service.dart';
/// Servicio que trae la información de los tiempos permitidos para asistencia
export '../../Utils/Service/tiempo_service.dart';
/// Servicio que trae las ubicaciones de la universidad
export '../../Utils/Service/ubicacion_service.dart';
/// Servicio que trae los usuarios de la universidad
export '../../Utils/Service/usuarios_service.dart';
/// Servicio que trae los tipos de eventos
export '../../Utils/Service/type_events_service.dart';
/// Servicio que trae los funcionarios
export '../../Utils/Service/uni_workers_service.dart';
