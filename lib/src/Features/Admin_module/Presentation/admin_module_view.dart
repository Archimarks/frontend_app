import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Core/Barrels/enums_barrel.dart';
import '../../../Core/Barrels/widgets_shared_barrel.dart';
import '../../../Core/Routes/route_names.dart';

/// ****************************************************************************
/// ### Módulo de Administración
/// * Descripción: Vista en donde el usuario administrador puede agregar nuevos valores en ciertas listas
/// *              desplegables que se usan en la aplicación.
/// * Autores: Geraldine Perilla Valderrama & Marcos Alejandro Collazos Marmolejo
/// * Fecha: 2025
/// ****************************************************************************

class AdminModule extends StatefulWidget {
  const AdminModule({super.key});

  @override
  State<AdminModule> createState() => _AdminModuleState();
}

class _AdminModuleState extends State<AdminModule> {
  String rolApp = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getRolUsuario();
  }

  Future<void> getRolUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    rolApp = prefs.getString('rol')?.toLowerCase() ?? '';
    debugPrint('Rol obtenido de preferencias: $rolApp');
  }

  @override
  Widget build(final BuildContext context) => PopScope(
    canPop: false,
    // ignore: deprecated_member_use
    onPopInvoked: (final bool didPop) {
      if (didPop) {
        return;
      }
    },
    child: Scaffold(
      backgroundColor: TipoColores.seasalt.value,
      appBar: customAppBar(
        context: context,
        title: 'Módulo de administrador',
        onLeadingPressed: () {
          if (!context.mounted) {
            return;
          }
          context.goNamed(RouteNames.login);
        },
        backgroundColor: TipoColores.pantone356C.value,
        leadingIconColor: TipoColores.seasalt.value,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _portraitLayout(),
              ),
            ),
    ),
  );

  Widget _portraitLayout() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
        Text('Bienvenido, en esta sección puedes agregar nuevos valores a las listas desplegables que se usan en la aplicación.',
          style: TextStyle(
            fontSize: 16,
            color: TipoColores.pantoneBlackC.value,
          ),
          textAlign: TextAlign.center,
        ),
        
    ],
  );
}
