/// *****************************************************************
/// * Nombre del Archivo: connectivity_cubit.dart
/// * Ruta: lib\src\Utils\Base\Cubit\Connectivity\connectivity_cubit.dart
/// * Descripción:
/// * Define un Cubit responsable de monitorear continuamente el estado de la conexión
/// * a Internet utilizando el paquete connectivity_plus. Emite estados según haya o no conectividad.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// * Notas:
/// *      - Emite [ConnectivityConnected] si hay conexión.
/// *      - Emite [ConnectivityDisconnected] si no hay ningún tipo de conexión.
/// *      - Debe cerrarse correctamente para evitar fugas de memoria.
/// *
/// *****************************************************************
library;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'connectivity_state.dart';

/// Cubit que gestiona el estado de conectividad a Internet.
class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit() : super(ConnectivityInitial()) {
    _initConnectivity();
  }

  /// Instancia del plugin de conectividad.
  final Connectivity _connectivity = Connectivity();

  /// Suscripción al stream de cambios de conectividad.
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  /// Inicializa la verificación de conectividad y escucha los cambios.
  void _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _emitConnectivity(result);

    _subscription = _connectivity.onConnectivityChanged.listen(
      _emitConnectivity,
    );
  }

  /// Emite el estado correspondiente según los resultados de conectividad.
  void _emitConnectivity(final List<ConnectivityResult> results) {
    if (results.isEmpty ||
        results.every((final r) => r == ConnectivityResult.none)) {
      emit(ConnectivityDisconnected());
    } else {
      emit(ConnectivityConnected());
    }
  }

  /// Cancela la suscripción al stream al cerrar el cubit.
  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
