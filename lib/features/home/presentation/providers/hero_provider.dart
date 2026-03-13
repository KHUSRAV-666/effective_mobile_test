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
    final result = await _repository.getCharacters(page: 1);
    return result['characters'] as List<HeroModel>;
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasNext) return;

    _isLoadingMore = true;
    _currentPage++;

    final result = await _repository.getCharacters(page: _currentPage);
    final newCharacters = result['characters'] as List<HeroModel>;

    _hasNext = result['info']['next'] != null;

    state = AsyncData([...state.value ?? [], ...newCharacters]);
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
