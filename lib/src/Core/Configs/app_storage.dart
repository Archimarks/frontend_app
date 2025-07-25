/// *****************************************************************
/// * Nombre del Archivo: app_storage.dart
/// * Ruta: lib\src\Core\Configs\app_storage.dart
/// * Descripción:
/// * Este archivo encapsula el uso de SharedPreferences para el almacenamiento
/// * persistente de datos simples en el dispositivo, como cadenas clave-valor.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// * Notas:
/// *      - Requiere inicialización previa mediante [initStorage] antes de usar.
/// *      - Utilizado comúnmente para guardar configuraciones o datos de sesión.
/// *
/// *****************************************************************
library;

import 'package:shared_preferences/shared_preferences.dart';

/// Instancia global de SharedPreferences.
/// Debe ser inicializada previamente mediante [initStorage].
late SharedPreferences _prefs;

/// Inicializa SharedPreferences para permitir el acceso a almacenamiento persistente.
/// Debe ser llamada antes de acceder a cualquier método de almacenamiento.
Future<void> initStorage() async {
  _prefs = await SharedPreferences.getInstance();
}

/// Guarda un valor de tipo [String] asociado a una clave dada.
Future<void> saveString(final String key, final String value) async {
  await _prefs.setString(key, value);
}

/// Recupera un valor de tipo [String] asociado a una clave dada.
/// Retorna null si la clave no existe.
String? getString(final String key) => _prefs.getString(key);

/// Elimina todos los datos almacenados en SharedPreferences.
Future<void> clearStorage() async {
  await _prefs.clear();
}
