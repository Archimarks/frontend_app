// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Core/Configs/api_config.dart';

/// Clase encargada de hacer la petición a la API para traer los tipos de repetición de los encuentros
class RepeatService {
  /// Método que trae las ubicaciones y las devuelve en un Map
  Future<List<Map<String, String>>> fetchRepeats() async {
    final url = ApiConfig.instance.getRepeticion();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Conversión del JSON al formato esperado
      return data
          .map<Map<String, String>>(
            (final time) => {
              'id': time['REPE_ID'].toString(),
              'text': time['REPE_NOMBREREPETICION'].toString(),
            },
          )
          .toList();
    } else {
      throw Exception('Error al cargar las repeticiones: ${response.statusCode}');
    }
  }
}
