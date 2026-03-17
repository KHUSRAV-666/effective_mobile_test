import 'package:effective_mobile_test/features/home/data/models/hero_model.dart';
import 'package:effective_mobile_test/features/home/data/repositories/hero_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final heroNotifierProvider =
    AsyncNotifierProvider<HeroNotifier, List<HeroModel>>(() {
      return HeroNotifier();
    });

class HeroNotifier extends AsyncNotifier<List<HeroModel>> {
  final _repository = HeroRepository();

  int _currentPage = 1;
  bool _hasNext = true;
  bool _isLoadingMore = false;

  @override
  Future<List<HeroModel>> build() async {
    _currentPage = 1;
    _hasNext = true;
    final result = await _repository.getCharacters(page: 1);
    return result['characters'] as List<HeroModel>;
  }

  Future<void> refresh() async {
    final result = await AsyncValue.guard<List<HeroModel>>(() async {
      final res = await _repository.getCharacters(page: 1, forceRefresh: true);
      return res['characters'] as List<HeroModel>;
    });

    if (result.hasError) {
      state = AsyncValue.data(state.value ?? []).copyWithPrevious(result);
    } else {
      _currentPage = 1;
      state = result;
    }
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasNext || state.isLoading) return;

    _isLoadingMore = true;
    final nextPage = _currentPage + 1;

    final result = await AsyncValue.guard<List<HeroModel>>(() async {
      final res = await _repository.getCharacters(page: nextPage);
      final newCharacters = res['characters'] as List<HeroModel>;

      _hasNext = res['info']['next'] != null;
      _currentPage = nextPage;

      return [...(state.value ?? []), ...newCharacters];
    });

    if (result.hasError) {
      state = AsyncValue.data(state.value ?? []);
    } else {
      state = result;
    }

    _isLoadingMore = false;
  }

  void updateFavoriteLocal(int id, bool isFavorite) {
    state.whenData((characters) {
      final updatedList = characters.map((char) {
        return char.id == id ? char.copyWith(isFavorite: isFavorite) : char;
      }).toList();

      state = AsyncValue.data(updatedList);
    });
  }
}
