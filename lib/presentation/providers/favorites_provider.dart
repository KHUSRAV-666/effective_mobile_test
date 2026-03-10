import 'package:effective_mobile_test/data/models/hero_model.dart';
import 'package:effective_mobile_test/data/repositories/hero_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
      return FavoritesNotifier();
    });

class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  static const _key = 'favorite_heroes_ids';

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList(_key);
    if (savedIds != null) {
      state = savedIds;
    }
  }

  Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();

    if (state.contains(id)) {
      state = state.where((element) => element != id).toList();
    } else {
      state = [...state, id];
    }

    await prefs.setStringList(_key, state);
  }

  bool isFavorite(String id) => state.contains(id);
}

final favoriteHeroesProvider = FutureProvider<List<HeroModel>>((ref) async {
  final ids = ref.watch(favoritesProvider); // Следим за списком ID
  if (ids.isEmpty) return [];

  // Преобразуем List<String> в List<int>, так как API ждет числа
  final intIds = ids.map((id) => int.parse(id)).toList();

  return HeroRepository().getMultipleCharacters(intIds);
});
