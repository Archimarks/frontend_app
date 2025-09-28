// ignore_for_file: avoid_dynamic_calls, avoid_catches_without_on_clauses

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Core/Barrels/models_barrel.dart';
import '../../Core/Configs/api_config.dart';

/// Clase encargada de hacer la petición a la API para crear, eliminar, actualizar e insertar Encuentros
class MeetingService {

  /// Método para crear un encuentro a partir de los datos de `MeetingModel`
  Future<bool> createMeeting(final MeetingModel encuentro) async {
    final baseUrl = ApiConfig.instance.postMeeting(encuentro);
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(encuentro.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Encuentro creado correctamente: ${response.body}');
        return true;
      } else {
        debugPrint('❌ Error al crear encuentro: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('⚠️ Excepción: $e');
      return false;
    }
  }

  /// Método que trae información de los encuentros
  Future<List<Grupo>> fetchMeetings({
    required final int pegeld,
    final int periodo = 550,
  }) async {
    final baseUrl = ApiConfig.instance.getMeeting();

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
