import 'dart:convert';
import 'package:effective_mobile_test/core/store/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hero_model.dart';
import 'package:http/http.dart' as http;

final heroRepositoryProvider = Provider((ref) => HeroRepository());

class HeroRepository {
  final dbHelper = CharacterDb.instance;
  static const String _baseUrl = 'https://rickandmortyapi.com/api/character';

  Future<Map<String, dynamic>> getCharacters({int page = 1}) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?page=$page'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> results = body['results'];

        final characters = results
            .map((json) => HeroModel.fromJson(json))
            .toList();

        final List<Map<String, dynamic>> mapsToSave = characters
            .map((hero) => hero.toMap())
            .toList();
        await dbHelper.upsertCharacters(mapsToSave);

        return {
          'characters': characters,
          'info': body['info'],
          'currentPage': page,
          'isOffline': false,
        };
      } else {
        throw Exception('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      final localData = await dbHelper.getAllCharacters();

      if (localData.isNotEmpty) {
        final characters = localData
            .map((map) => HeroModel.fromMap(map))
            .toList();

        return {
          'characters': characters,
          'info': {'pages': 1, 'next': null, 'prev': null},
          'currentPage': page,
          'isOffline': true,
        };
      }

      throw Exception('Нет сети и данных в кэше: $e');
    }
  }

  Future<void> toggleFavorite(HeroModel hero) async {
    final newStatus = !hero.isFavorite;
    await dbHelper.updateFavoriteStatus(hero.id, newStatus);
  }

  Future<List<HeroModel>> getFavoriteCharacters() async {
    final data = await dbHelper.getFavoriteCharacters();
    return data.map((map) => HeroModel.fromMap(map)).toList();
  }
}
