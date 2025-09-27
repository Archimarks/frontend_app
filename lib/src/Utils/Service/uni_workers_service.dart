// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Core/Configs/api_config.dart';

/// Clase encargada de hacer la petición a la API para traer los funcionarios de la universidad
class UniversityWorkersService {

  /// Método que trae los funcionarios de la universidad para elección de delegado (Si aplica)
  Future<List<Map<String, String>>> fetchUniversityWorkers() async {
    final url = ApiConfig.instance.getUniversityWorkers();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Conversión del JSON al formato esperado
      return data
          .map<Map<String, String>>(
            (final worker) => {
              'id': worker['pegE_ID'].toString(),
              'textMain': worker['nombre'],
              'textSecondary': worker['emailinstitucional'],
            },
          )
          .toList();
    } else {
      throw Exception(
        'Error al cargar los funcionarios: ${response.statusCode}',
      );
    }
  }
}
