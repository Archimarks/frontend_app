/// *****************************************************************
/// * Nombre del Archivo: api_config.dart
/// * Ruta: lib/src/Core/Configs/api_config.dart
/// * Descripción:
/// * Define y centraliza la configuración de la API, incluyendo la URL base
/// * y los endpoints para acceder a funcionalidades del backend, como la
/// * obtención de usuarios por correo y la verificación de conexión a bases de datos.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// * Notas:
/// *      - Facilita el mantenimiento y reutilización de rutas del backend.
/// *
/// *****************************************************************
library;

import 'package:http/http.dart' as http;

/// Clase que contiene la configuración de endpoints y URLs base para la API.
class ApiConfig {
  /// Constructor privado para evitar instancias múltiples.
  const ApiConfig._internal(this.baseUrl);

  /// URL base del backend API.
  final String baseUrl;

  /// Instancia única de configuración.
  static const ApiConfig instance = ApiConfig._internal(
    'http://192.168.1.8:5009',
  );

  /// Retorna la URL para obtener un usuario por su correo electrónico.
  String usuarioPorCorreo(final String correo) =>
      '$baseUrl/api/Usuario/$correo';

  /// Retorna la URL para probar la conexión con SQL Server.
  String testConexionSqlServer() => '$baseUrl/api/_TestConexion/sqlserver';

  /// Retorna la URL para probar la conexión con Oracle.
  String testConexionOracle() => '$baseUrl/api/_TestConexion/oracle';

  /// Traer usuarios
  String getUsuarios() => '$baseUrl/api/Usuario/todos';

  /// Traer grupos que tiene asignado un docente
  String getGruposDocente() =>
      '$baseUrl/api/oracle/GrupoAsignado/TraerGruposAsignados';

  /// Traer ubicaciones
  String getUbicaciones() => '$baseUrl/api/oracle/ubicaciones';

  /// Traer tipos de repetición de los encuentros
  String getRepeticion() =>
      '$baseUrl/api/sqlserver/v1/repeticion';

  /// Traer tiempo permitido para asistencia
  String getTime() =>
      '$baseUrl/api/sqlserver/v1/tiempoasistencia';

  /// Traer roles para crear el encuentro
  String getRoleDirected() => '$baseUrl/api/sqlserver/v1/roldirigido';

  /// Traer todos los encuentros creados por un usuario
  String getMeeting(final int creadorId) =>
      '$baseUrl/api/sqlserver/v1/encuentro/creador/$creadorId';

  /// Eliminar un encuentro
  String deleteMeeting(final int id) =>
      '$baseUrl/api/sqlserver/Encuentro/$id';

  /// Crear un encuentro a partir de los datos ingresados por el usuario
  String postMeeting() => '$baseUrl/api/sqlserver/v1/encuentro';

  /// Traer tipos de eventos
  String getTypeEvents() => '$baseUrl/api/oracle/TipoEvento/GetAll';

  /// Traer funcionarios activos de la universidad
  String getUniversityWorkers() => '$baseUrl/api/oracle/Funcionario/GetAll';
}

/// Realizar llamadas HTTP GET a los endpoints de prueba de conexión de SQL Server y Oracle.
/// No se manejan respuestas aquí, ya que se delega la lógica de verificación al backend.
Future<void> probarConexiones() async {
  final sqlUrl = ApiConfig.instance.testConexionSqlServer();
  final oracleUrl = ApiConfig.instance.testConexionOracle();

  await http.get(Uri.parse(sqlUrl));
  await http.get(Uri.parse(oracleUrl));
}
