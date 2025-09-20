// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../Core/Configs/api_config.dart';

/// Clase encargada de hacer la petición a la API para traer los tiempos permitidos para la toma de asistencia
class TimeService {

  /// Método que trae los tiempos permitidos y los devuelve en un Map
  Future<List<Map<String, String>>> fetchTime() async {
    final url = ApiConfig.instance.getTime();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Conversión del JSON al formato esperado
      return data
          .map<Map<String, String>>(
            (final time) => {
              'id': time['tiaS_ID'].toString(),
              'text': '${time['tiaS_TIEMPO_ESTABLECIDO'].toString()} minutos',
            },
          )
          .toList();
    } else {
      throw Exception('Error al cargar los tiempos: ${response.statusCode}');
    }
  }
}
