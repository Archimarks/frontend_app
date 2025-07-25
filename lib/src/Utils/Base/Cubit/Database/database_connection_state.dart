/// *****************************************************************
/// * Nombre del Archivo: database_connection_state.dart
/// * Ruta: lib\src\Utils\Base\Cubit\Database\database_connection_state.dart
/// * Descripción:
/// * Define los posibles estados que puede emitir el [DatabaseConnectionCubit]
/// * durante el ciclo de verificación de conexión con las bases de datos (SQL Server y Oracle).
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// * Notas:
/// *      - Los estados son usados por la UI para mostrar indicadores visuales de conexión.
/// *
/// *****************************************************************

part of 'database_connection_cubit.dart';

/// Clase base abstracta para representar los diferentes estados de conexión con la base de datos.
abstract class DatabaseConnectionState {}

/// Estado inicial antes de iniciar cualquier verificación.
class DatabaseConnectionInitial extends DatabaseConnectionState {}

/// Estado emitido mientras se realiza la verificación de conexión.
class DatabaseConnectionLoading extends DatabaseConnectionState {}

/// Estado emitido cuando se confirma una conexión exitosa con ambas bases de datos.
class DatabaseConnectionSuccess extends DatabaseConnectionState {}

/// Estado emitido cuando la conexión con alguna base de datos ha fallado.
class DatabaseConnectionFailure extends DatabaseConnectionState {}
