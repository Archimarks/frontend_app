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
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(encuentro.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Encuentro creado correctamente: ${response.body}');
        return true;
      } else {
        debugPrint(
          '❌ Error al crear encuentro: ${response.statusCode} ${response.body}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('⚠️ Excepción: $e');
      return false;
    }
  }

  /// Método que trae todos los encuentros
  Future<List<MeetingModel>> fetchMeetings() async {
    final baseUrl = ApiConfig.instance.getMeeting();

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Mapear cada item del JSON a un objeto MeetingModel
        return data.map((e) => MeetingModel.fromJson(e)).toList();
      } else {
        debugPrint('❌ Error al traer encuentros: ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('⚠️ Excepción en fetchMeetings: $e');
      return [];
    }
  }

  /// Método para eliminar un encuentro mediante el ID
  Future <bool> deleteMeeting(final int idEncuentro) async {
    final baseUrl = ApiConfig.instance.deleteMeeting(idEncuentro);
    try {
      final response = await http.delete(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('✅ Encuentro eliminado correctamente');
        return true;
      } else {
        debugPrint(
          '❌ Error al eliminar encuentro: ${response.statusCode} ${response.body}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('⚠️ Excepción en deleteMeeting: $e');
      return false;
    }
  }
}
