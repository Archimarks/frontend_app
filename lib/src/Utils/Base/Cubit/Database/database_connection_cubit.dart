/// *****************************************************************
/// * Nombre del Archivo: database_connection_cubit.dart
/// * Ruta: lib\src\Utils\Base\Cubit\Database\database_connection_cubit.dart
/// * Descripción:
/// * Este Cubit verifica de forma periódica la conectividad con bases de datos (SQL Server y Oracle)
/// * a través de peticiones HTTP al backend. Solo realiza validaciones si hay conexión a Internet.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// * Notas:
/// *      - Emite estados reactivos ante cambios en la conectividad de bases de datos.
/// *      - Usa un temporizador para validar constantemente cuando hay conexión a Internet.
/// *      - Se recomienda cerrar el Cubit adecuadamente para evitar fugas de memoria.
/// *****************************************************************
library;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../Core/Barrels/configs_barrel.dart';

part 'database_connection_state.dart';

/// Cubit que gestiona la verificación de conexión con bases de datos.
class DatabaseConnectionCubit extends Cubit<DatabaseConnectionState> {
  DatabaseConnectionCubit() : super(DatabaseConnectionLoading()) {
    _iniciarVerificacionPeriodica();
  }

  /// Estado actual de conectividad a Internet (debe actualizarse externamente).
  bool _hasInternet = false;

  /// Temporizador para ejecutar la verificación periódica.
  Timer? _timer;

  /// Guarda el último estado emitido para evitar emisiones repetidas.
  DatabaseConnectionState _previousState = DatabaseConnectionInitial();

  /// Tiempo máximo de espera por una respuesta del backend.
  static const Duration timeout = Duration(seconds: 2);

  /// Actualiza el estado de conexión a Internet.
  /// Si hay conexión, dispara una verificación inmediata a las bases de datos.
void updateInternetStatus({required final bool connected}) {
    _hasInternet = connected;

    if (connected) {
      _verificarConexion(); // Verificación inmediata al reconectar
    } else {
      _emitIfChanged(DatabaseConnectionFailure());
    }
  }


  /// Inicia el ciclo de verificación periódica cada 3 segundos (si hay Internet).
  void _iniciarVerificacionPeriodica() {
    if (_hasInternet) {
      _verificarConexion(); // Verifica de inmediato
    }

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_hasInternet) {
        _verificarConexion();
      }
    });
  }

  /// Verifica el estado de conexión con SQL Server y Oracle a través del backend.
  /// Si ambas respuestas son exitosas (status 200), emite éxito; de lo contrario, error.
  Future<void> _verificarConexion() async {
    try {
      final sqlUrl = ApiConfig.instance.testConexionSqlServer();
      final oracleUrl = ApiConfig.instance.testConexionOracle();

      final sqlResponse = await http
          .get(Uri.parse(sqlUrl))
          .timeout(timeout, onTimeout: () => http.Response('Timeout', 500));
      final oracleResponse = await http
          .get(Uri.parse(oracleUrl))
          .timeout(timeout, onTimeout: () => http.Response('Timeout', 500));

      final success =
          sqlResponse.statusCode == 200 && oracleResponse.statusCode == 200;

      final newState = success
          ? DatabaseConnectionSuccess()
          : DatabaseConnectionFailure();

      _emitIfChanged(newState);
    } on Exception catch (_) {
      _emitIfChanged(DatabaseConnectionFailure());
    }
  }

  /// Emite el nuevo estado solo si es diferente al estado anterior.
  void _emitIfChanged(final DatabaseConnectionState newState) {
    if (newState.runtimeType != _previousState.runtimeType) {
      _previousState = newState;
      emit(newState);
    }
  }

  /// Cancela el temporizador al cerrar el Cubit para evitar fugas.
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
