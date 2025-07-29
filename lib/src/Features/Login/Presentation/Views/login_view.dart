/// **********************************************************************************************
/// * Nombre del Archivo: login_view.dart
/// * Ruta: lib\src\Features\Login\Presentation\Views\login_view.dart
/// * Descripción:
/// * Vista principal para el inicio de sesión. Implementa lógica reactiva para verificar
/// * conectividad a internet y conexión a base de datos, y muestra banners en caso de fallo.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// * Notas:
/// *     - Utiliza BlocListener y BlocSelector para respuestas reactivas.
/// *     - La UI muestra mensajes de error si no hay conexión a internet o con la BD.
/// **********************************************************************************************
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../Core/Barrels/base_cubit_barrel.dart';
import '../../../../Core/Barrels/configs_barrel.dart';
import '../../../../Core/Barrels/enums_barrel.dart';
import '../../../../Core/Barrels/widgets_shared_barrel.dart';

/// Vista principal del Login.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(final BuildContext context) =>
      // Listener para detectar cambios en la conectividad.
      BlocListener<ConnectivityCubit, ConnectivityState>(
        listener: (final context, final state) {
          final hasInternet = state is ConnectivityConnected;

          // Notifica al cubit de conexión a BD si hay o no internet.
          context.read<DatabaseConnectionCubit>().updateInternetStatus(
            connected: hasInternet,
          );
        },
        child: Scaffold(
          backgroundColor: TipoColores.seasalt.value,
          body: const Center(child: _LoginCard()),
        ),
      );
}

/// Contenedor principal del formulario de login (estilizado con Card).
class _LoginCard extends StatefulWidget {
  const _LoginCard();

  @override
  State<_LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<_LoginCard> {
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: TipoColores.pantone356C.value, width: 1.5),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 24),
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _ConnectionStatusBanner(),
          const _DatabaseStatusBanner(),
          const SizedBox(height: 8),
          const _Header(),
          const SizedBox(height: 24),
          CustomTextField(
            labelText: 'Nombre de usuario',
            prefixIcon: Icons.person_outline,
            controller: _usernameController,
          ),
          const SizedBox(height: 32),
          _LoginButton(controller: _usernameController),
        ],
      ),
    ),
  );
}

/// Encabezado del formulario con título y subtítulo.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(final BuildContext context) => Column(
    children: [
      const Text(
        'Iniciar sesión',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text(
        'Diligenciar los datos solicitados para iniciar sesión',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: TipoColores.pantoneBlackC.value),
      ),
    ],
  );
}

/// Banner que se muestra si no hay conexión a internet.
class _ConnectionStatusBanner extends StatelessWidget {
  const _ConnectionStatusBanner();

  @override
  Widget build(final BuildContext context) =>
      BlocSelector<ConnectivityCubit, ConnectivityState, bool>(
        selector: (final state) => state is ConnectivityDisconnected,
        builder: (final context, final isDisconnected) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isDisconnected
              ? CustomBanner(
                  icon: Icons.wifi_off,
                  text: 'Sin conexión a internet',
                  color: TipoColores.gris.value,
                )
              : const SizedBox.shrink(),
        ),
      );
}

/// Banner que se muestra si falla la conexión a la base de datos.
class _DatabaseStatusBanner extends StatelessWidget {
  const _DatabaseStatusBanner();

  @override
  Widget build(final BuildContext context) =>
      BlocSelector<DatabaseConnectionCubit, DatabaseConnectionState, bool>(
        selector: (final state) => state is DatabaseConnectionFailure,
        builder: (final context, final isDisconnected) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isDisconnected
              ? CustomBanner(
                  icon: Icons.cloud_off,
                  text: 'Fallo al conectar a la base de datos',
                  color: TipoColores.pantone7621C.value,
                )
              : const SizedBox.shrink(),
        ),
      );
}

/// Botón de login, habilitado solo si hay internet y conexión a la base de datos.
class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(
    final BuildContext context,
  ) => BlocSelector<ConnectivityCubit, ConnectivityState, bool>(
    selector: (final state) => state is ConnectivityConnected,
    builder: (final context, final hasInternet) =>
        BlocSelector<DatabaseConnectionCubit, DatabaseConnectionState, bool>(
          selector: (final state) => state is DatabaseConnectionSuccess,
          builder: (final context, final isDbConnected) {
            final canLogin = hasInternet && isDbConnected;

            return SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: canLogin
                    ? () async {
                        final username = controller.text.trim();
                        if (username.isEmpty) {
                          debugPrint('El campo de usuario está vacío');
                          return;
                        }

                        try {
                          final url = ApiConfig.instance.usuarioPorCorreo(
                            username,
                          );
                          final response = await http.get(Uri.parse(url));

                          if (response.statusCode == 200) {
                            final data = jsonDecode(response.body);
                            debugPrint('Usuario encontrado: $data');
                          } else if (response.statusCode == 404) {
                            debugPrint('Usuario no encontrado para: $username');
                          } else {
                            debugPrint(
                              'Error al obtener usuario. Código: ${response.statusCode}',
                            );
                          }
                          // ignore: avoid_catches_without_on_clauses
                        } catch (e) {
                          debugPrint('Error en la solicitud HTTP: $e');
                        }
                      }
                    : null,
                text: 'Ingresar',
                showDecoration: false,
                color: TipoColores.pantone158C,
              ),
            );
          },
        ),
  );
}
