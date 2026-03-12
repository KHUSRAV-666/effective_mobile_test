import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/hero_model.dart';
import 'package:http/http.dart' as http;

final heroRepositoryProvider = Provider((ref) => HeroRepository());

class HeroRepository {
  static const String _baseUrl = 'https://rickandmortyapi.com/api/character';

  Future<Map<String, dynamic>> getAllCharacters({int page = 1}) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?page=$page'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> results = body['results'];

        final characters = results
            .map((json) => HeroModel.fromJson(json))
            .toList();

        return {
          'characters': characters,
          'info': body['info'],
          'currentPage': page,
        };
      } else {
        throw Exception('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Проблема с сетью: $e');
    }
  }

  Future<List<HeroModel>> getMultipleCharacters(List<String> ids) async {
    if (ids.isEmpty) return [];

    try {
      final idsString = ids.join(',');
      final response = await http.get(Uri.parse('$_baseUrl/$idsString'));

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);

        if (body is List) {
          return body.map((json) => HeroModel.fromJson(json)).toList();
        } else {
          return [HeroModel.fromJson(body)];
        }
      } else {
        throw Exception('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Проблема с сетью: $e');
    }
  }
}
