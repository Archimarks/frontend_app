/// *****************************************************************
/// * Nombre del Archivo: base_cubit_barrel.dart
/// * Ruta: lib\src\Core\Barrels\base_cubit_barrel.dart
/// * Descripción:
/// * Este archivo sirve como barrel file para centralizar las exportaciones
/// * de cubits base del sistema, incluyendo la gestión de conectividad a
/// * internet, conexión a bases de datos y MultiBlocBuilder personalizado.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// * Notas:
/// *      - Este archivo permite importar múltiples cubits desde un único punto,
/// *        mejorando la organización y facilitando el mantenimiento del código.
/// *
/// *****************************************************************
library;

// Exporta el Cubit responsable de monitorear la conectividad a Internet.
export '../../Utils/Base/Cubit/Connectivity/connectivity_cubit.dart';
// Exporta el Cubit responsable de validar la conexión con bases de datos
// (SQL Server u Oracle) de forma continua y reactiva.
export '../../Utils/Base/Cubit/Database/database_connection_cubit.dart';
// Exporta el widget MultiBlocBuilder personalizado para construir múltiples BlocBuilders
// en una sola estructura, facilitando la composición de estados múltiples.
export '../../Utils/Base/Cubit/multi_bloc_builder.dart';
