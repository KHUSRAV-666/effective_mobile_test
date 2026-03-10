import 'dart:convert';
import '../models/hero_model.dart';
import 'package:http/http.dart' as http;

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

  // Получение одного персонажа по ID
  Future<HeroModel> getCharacterById(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$id'));

      if (response.statusCode == 200) {
        return HeroModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Персонаж с ID $id не найден');
      } else {
        throw Exception('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Проблема с сетью: $e');
    }
  }

  // Получение нескольких персонажей по массиву ID
  Future<List<HeroModel>> getMultipleCharacters(List<int> ids) async {
    if (ids.isEmpty) return [];

    try {
      final idsString = ids.join(',');
      final response = await http.get(Uri.parse('$_baseUrl/$idsString'));

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);

        // API возвращает массив если запрошено несколько персонажей
        if (body is List) {
          return body.map((json) => HeroModel.fromJson(json)).toList();
        } else {
          // Если вернулся один объект
          return [HeroModel.fromJson(body)];
        }
      } else {
        throw Exception('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Проблема с сетью: $e');
    }
  }

  // Поиск персонажей по параметрам
  Future<List<HeroModel>> searchCharacters({
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (name != null && name.isNotEmpty) queryParams['name'] = name;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (species != null && species.isNotEmpty)
        queryParams['species'] = species;
      if (type != null && type.isNotEmpty) queryParams['type'] = type;
      if (gender != null && gender.isNotEmpty) queryParams['gender'] = gender;

      final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> results = body['results'];

        return results.map((json) => HeroModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return []; // Ничего не найдено
      } else {
        throw Exception('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Проблема с сетью: $e');
    }
  }
}
