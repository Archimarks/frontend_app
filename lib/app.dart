// src/Utils/Base/global_bloc_listeners.dart

import 'package:flutter/material.dart';

import 'src/Core/Routes/app_router.dart';

/// Widget raíz de la aplicación que configura el enrutador global.
///
/// Aquí es donde se puede agregar cualquier listener o lógica global (por ejemplo,
/// para reaccionar a cambios en cubits como conexión a Internet o base de datos).
class AppWithGlobalListeners extends StatelessWidget {
  const AppWithGlobalListeners({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp.router(
    // Usa el enrutador definido en la app para manejar la navegación
    routerConfig: appRouter,

    // Oculta el banner de "debug" en la esquina superior derecha
    debugShowCheckedModeBanner: false,
  );
}
