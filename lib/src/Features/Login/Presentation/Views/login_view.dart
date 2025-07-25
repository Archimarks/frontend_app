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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Utils/Base/Cubit/Connectivity/connectivity_cubit.dart';
import '../../../../Utils/Base/Cubit/Database/database_connection_cubit.dart';

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
        child: const Scaffold(
          backgroundColor: Color(0xFFF5F5F5),
          body: Center(child: _LoginCard()),
        ),
      );
}

/// Contenedor principal del formulario de login (estilizado con Card).
class _LoginCard extends StatelessWidget {
  const _LoginCard();

  @override
  Widget build(final BuildContext context) => Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Colors.green, width: 1.5),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 24),
    child: const Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ConnectionStatusBanner(), // Banner si no hay internet
          _DatabaseStatusBanner(), // Banner si falla la conexión con BD
          SizedBox(height: 8),
          _Header(),
          SizedBox(height: 24),
          _UsernameField(),
          SizedBox(height: 32),
          _LoginButton(),
        ],
      ),
    ),
  );
}

/// Encabezado del formulario con título y subtítulo.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(final BuildContext context) => const Column(
    children: [
      Text(
        'Iniciar sesión',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      Text(
        'Diligenciar los datos solicitados para iniciar sesión',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: Colors.black54),
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
              ? _buildBanner(
                  icon: Icons.wifi_off,
                  text: 'Sin conexión a internet',
                  color: Colors.red,
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
              ? _buildBanner(
                  icon: Icons.cloud_off,
                  text: 'Fallo al conectar a la base de datos',
                  color: Colors.orange,
                )
              : const SizedBox.shrink(),
        ),
      );
}

/// Campo de texto para ingresar el nombre de usuario.
class _UsernameField extends StatelessWidget {
  const _UsernameField();

  @override
  Widget build(final BuildContext context) => const TextField(
    decoration: InputDecoration(
      labelText: 'Nombre de usuario',
      prefixIcon: Icon(Icons.person_outline),
      border: UnderlineInputBorder(),
    ),
  );
}

/// Botón de login, habilitado solo si hay internet y conexión a la base de datos.
class _LoginButton extends StatelessWidget {
  const _LoginButton();

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
              child: ElevatedButton(
                onPressed: canLogin ? () => debugPrint('Iniciar sesión...') : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Ingresar',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            );
          },
        ),
  );
}

/// Banner reutilizable para mostrar mensajes informativos o de error.
Widget _buildBanner({
  required final IconData icon,
  required final String text,
  required final Color color,
}) => Container(
  width: double.infinity,
  padding: const EdgeInsets.all(12),
  margin: const EdgeInsets.only(bottom: 16),
  decoration: BoxDecoration(
    color: color.withAlpha((0.1 * 255).toInt()),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: color),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: color),
      const SizedBox(width: 8),
      Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    ],
  ),
);
