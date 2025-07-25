import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Importa configuraciones y utilidades centrales de la app
import '../src/Core/Barrels/configs_barrel.dart';
// Importa cubits base como conectividad y conexión a base de datos
import 'src/Core/Barrels/base_cubit_barrel.dart';
// Listener global para reaccionar a estados de los cubits desde cualquier parte de la app
import 'app.dart';

/// Punto de entrada principal de la aplicación
void main() async {
  // Asegura que Flutter esté completamente inicializado antes de usar servicios asincrónicos
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa almacenamiento local (SharedPreferences)
  await initStorage();

  // Inicia la aplicación con múltiples BLoCs disponibles globalmente
  runApp(
    MultiBlocProvider(
      providers: [
        // Proveedor para detectar y manejar el estado de conexión a Internet
        BlocProvider(create: (_) => ConnectivityCubit()),

        // Proveedor para manejar la conexión con las bases de datos (SQL Server / Oracle)
        // Este cubit se autoinicia al crearse
        BlocProvider(create: (_) => DatabaseConnectionCubit()),
      ],

      // Widget raíz que envuelve la app y escucha los estados de los Cubits globales
      child: const AppWithGlobalListeners(),
    ),
  );
}
