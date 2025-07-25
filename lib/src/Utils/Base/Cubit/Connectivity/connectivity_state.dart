/// *****************************************************************
/// * Nombre del Archivo: connectivity_state.dart
/// * Ruta: lib\src\Utils\Base\Cubit\Connectivity\connectivity_state.dart
/// * Descripción:
/// * Define los diferentes estados que puede emitir el [ConnectivityCubit]
/// * dependiendo del estado de conexión a Internet del dispositivo.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// * Notas:
/// *      - Usado como parte del cubit connectivity_cubit.dart.
/// *      - Se recomienda usar estos estados para mostrar banners o mensajes en la UI.
/// *
/// *****************************************************************

part of 'connectivity_cubit.dart';

/// Clase base abstracta para representar los posibles estados de conectividad.
abstract class ConnectivityState {}

/// Estado inicial antes de comprobar la conectividad.
class ConnectivityInitial extends ConnectivityState {}

/// Estado emitido cuando el dispositivo tiene conexión a Internet (Wi-Fi, datos móviles, etc.).
class ConnectivityConnected extends ConnectivityState {}

/// Estado emitido cuando no hay ningún tipo de conexión disponible.
class ConnectivityDisconnected extends ConnectivityState {}
