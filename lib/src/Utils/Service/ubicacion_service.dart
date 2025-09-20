// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Core/Configs/api_config.dart';

/// Clase encargada de hacer la petición a la API para traer las ubicaciones
class UbicacionService {
  /// Método que trae las ubicaciones y las devuelve en un Map
  Future<List<Map<String, String>>> fetchUbicaciones() async {
    final url = ApiConfig.instance.getUbicaciones();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Conversión del JSON al formato esperado
      return data
          .map<Map<String, String>>(
            (final ubicacion) => {
              // Se construye un id para cada ubicación
              'id':
                  '${ubicacion['localidadId'].toString()}${ubicacion['espacioFisicoId'].toString()}${ubicacion['recursoFisicoId'].toString()}',
              'textMain': ubicacion['nombreCompleto'] ?? 'Sin nombre',
            },
          )
          .toList();
    } else {
      throw Exception('Error al cargar ubicaciones: ${response.statusCode}');
    }
  }
}
