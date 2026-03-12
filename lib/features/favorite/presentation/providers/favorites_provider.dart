import 'package:effective_mobile_test/core/store/shared_prefs_helper.dart';
import 'package:effective_mobile_test/features/home/data/models/hero_model.dart';
import 'package:effective_mobile_test/features/home/data/repositories/hero_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
      final storage = ref.watch(sharedPrefsHelperProvider);
      return FavoritesNotifier(storage);
    });

class FavoritesNotifier extends StateNotifier<List<String>> {
  final SharedPrefsHelper _storage;
  static const _key = 'favorite_heroes_ids';

  FavoritesNotifier(this._storage) : super([]) {
    _init();
  }

  void _init() {
    state = _storage.getStringList(_key);
  }

  Future<bool> toggleFavorite(String id) async {
    final currentIds = List<String>.from(state);
    bool isAdded = false;

    if (currentIds.contains(id)) {
      currentIds.remove(id);
      isAdded = false;
    } else {
      currentIds.add(id);
      isAdded = true;
    }

    state = currentIds;
    await _storage.setStringList(_key, currentIds);

    return isAdded;
  }

  bool isFavorite(String id) => state.contains(id);
}

final favoriteHeroesProvider = FutureProvider<List<HeroModel>>((ref) async {
  final ids = ref.watch(favoritesProvider);

  if (ids.isEmpty) return [];

  final repository = ref.read(heroRepositoryProvider);

  return repository.getMultipleCharacters(ids);
});
