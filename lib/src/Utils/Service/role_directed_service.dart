// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Core/Configs/api_config.dart';

/// Clase encargada de hacer la petición a la API para traer los roles para la creación de los encuentros
class RoleDirectedService {
  /// Método que trae los roles a quien va dirigido el encuentro
  Future<List<Map<String, String>>> fetchRoleDirected() async {
    final url = ApiConfig.instance.getRoleDirected();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Conversión del JSON al formato esperado
      return data
          .map<Map<String, String>>(
            (final roleDirected) => {
              'id': roleDirected['RODI_ID'].toString(),
              'text': roleDirected['RODI_NOMBRE'].toString(),
            },
          )
          .toList();
    } else {
      throw Exception('Error al cargar los roles dirigidos: ${response.statusCode}');
    }
  }
}
