// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Core/Configs/api_config.dart';

/// Clase encargada de hacer la petición a la API para traer los usuarios de CHAIRÁ que tengan correo institucional
class UserService {
  /// Método que trae los usuarios
  Future<List<Map<String, String>>> fetchUsers() async {
    final url = ApiConfig.instance.getUsuarios();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Conversión del JSON al formato esperado
      return data
          .map<Map<String, String>>(
            (final user) => {
              'id': user['pege'].toString(),
              'textMain': user['nombre'],
              'textSecondary': user['email'],
            },
          )
          .toList();
    } else {
      throw Exception('Error al cargar los usuarios: ${response.statusCode}');
    }
  }
}
