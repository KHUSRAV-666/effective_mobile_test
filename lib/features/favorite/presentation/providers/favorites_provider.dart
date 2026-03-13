import 'package:effective_mobile_test/features/home/data/models/hero_model.dart';
import 'package:effective_mobile_test/features/home/data/repositories/hero_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<HeroModel>>>((
      ref,
    ) {
      final repository = ref.watch(heroRepositoryProvider);
      return FavoritesNotifier(repository);
    });

class FavoritesNotifier extends StateNotifier<AsyncValue<List<HeroModel>>> {
  final HeroRepository _repository;

  FavoritesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = const AsyncValue.loading();
    try {
      final favorites = await _repository.getFavoriteCharacters();
      state = AsyncValue.data(favorites);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> toggleFavorite(HeroModel hero) async {
    final newStatus = !hero.isFavorite;
    await _repository.toggleFavorite(hero);
    await loadFavorites();
    return newStatus;
  }
}
