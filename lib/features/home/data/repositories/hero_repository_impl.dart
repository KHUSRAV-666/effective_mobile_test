import 'dart:convert';
import 'package:effective_mobile_test/core/store/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hero_model.dart';
import 'package:http/http.dart' as http;

final heroRepositoryProvider = Provider((ref) => HeroRepository());

class HeroRepository {
  final dbHelper = CharacterDb.instance;
  static const String _baseUrl = 'https://rickandmortyapi.com/api/character';

  Future<Map<String, dynamic>> getCharacters({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    try {
      if (forceRefresh && page == 1) {
        return await _fetchFromNetwork(page, forceRefresh);
      }

      final response = await http.get(Uri.parse('$_baseUrl?page=$page'));

      if (response.statusCode == 200) {
        return await _processNetworkResponse(response, page);
      } else {
        throw Exception('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      return await _getFromCache(page, e);
    }
  }

  Future<Map<String, dynamic>> _fetchFromNetwork(
    int page,
    bool forceRefresh,
  ) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?page=$page'));

      if (response.statusCode == 200) {
        if (forceRefresh) {
          await dbHelper.clearAllCharacters();
        }

        return await _processNetworkResponse(response, page, forceRefresh);
      } else {
        throw Exception('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  Future<Map<String, dynamic>> _processNetworkResponse(
    http.Response response,
    int page, [
    bool forceRefresh = false,
  ]) async {
    final Map<String, dynamic> body = jsonDecode(response.body);
    final List<dynamic> results = body['results'];

    final characters = results.map((json) => HeroModel.fromJson(json)).toList();

    final existingFavorites = await dbHelper.getFavoriteCharacters();
    final favoriteIds = existingFavorites
        .map((map) => map['id'] as int)
        .toSet();

    final charactersWithFavorites = characters.map((hero) {
      return favoriteIds.contains(hero.id)
          ? hero.copyWith(isFavorite: true)
          : hero;
    }).toList();

    final List<Map<String, dynamic>> mapsToSave = charactersWithFavorites
        .map((hero) => hero.toMap())
        .toList();

    if (forceRefresh && page == 1) {
      await dbHelper.replaceAllCharacters(mapsToSave);
    } else {
      await dbHelper.upsertCharacters(mapsToSave);
    }

    return {
      'characters': charactersWithFavorites,
      'info': body['info'],
      'currentPage': page,
      'isOffline': false,
    };
  }

  Future<Map<String, dynamic>> _getFromCache(int page, dynamic error) async {
    final localData = await dbHelper.getAllCharacters();

    if (localData.isNotEmpty) {
      final characters = localData
          .map((map) => HeroModel.fromMap(map))
          .toList();

      final itemsPerPage = 20;
      final startIndex = (page - 1) * itemsPerPage;
      final endIndex = startIndex + itemsPerPage;

      final paginatedCharacters = characters.length > startIndex
          ? characters.sublist(
              startIndex,
              endIndex < characters.length ? endIndex : characters.length,
            )
          : [];

      final hasNext = characters.length > endIndex;

      return {
        'characters': paginatedCharacters,
        'info': {
          'pages': (characters.length / itemsPerPage).ceil(),
          'next': hasNext ? page + 1 : null,
          'prev': page > 1 ? page - 1 : null,
        },
        'currentPage': page,
        'isOffline': true,
      };
    }

    throw Exception('Нет сети и данных в кэше: $error');
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
