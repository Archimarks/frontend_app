// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Core/Configs/api_config.dart';
import '../../Core/Models/grupos_data.dart';

/// Clase encargada de hacer la petición a la API para traer los grupos que tiene un docente
class GruposService {
  /// Método que trae información de los grupos del docente
  Future<List<Grupo>> fetchGruposDocente({
    required final String pegeld,
    final int periodo = 550,
  }) async {
    final baseUrl = ApiConfig.instance.getGruposDocente();

    // Construir la URI con parámetros en query
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'pegeId': pegeld.toString(),
        'periodo': periodo.toString(),
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Retorna un mapa del modelo de grupos
      return data.map((final json) => Grupo.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar grupos: ${response.statusCode}');
    }
  }
}
