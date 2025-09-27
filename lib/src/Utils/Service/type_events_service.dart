// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Core/Configs/api_config.dart';

/// Clase encargada de hacer la petición a la API para traer los tipos de eventos disponibles
class TypeEventsService {
  /// Método que trae los tipos de eventos disponibles para crear encuentros
  Future<List<Map<String, String>>> fetchTypeEvents() async {
    final url = ApiConfig.instance.getTypeEvents();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Conversión del JSON al formato esperado
      return data
          .map<Map<String, String>>(
            (final type) => {
              'id': type['evtI_ID'].toString(),
              'text': type['evtI_DECRIPCION'],
            },
          )
          .toList();
    } else {
      throw Exception('Error al cargar los tipos de eventos: ${response.statusCode}');
    }
  }
}
