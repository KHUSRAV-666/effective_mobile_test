import 'package:effective_mobile_test/data/models/hero_model.dart';
import 'package:effective_mobile_test/data/repositories/hero_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Провайдер для хранения списка персонажей
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
    // Загрузка первой страницы
    final result = await _repository.getAllCharacters(page: 1);
    return result['characters'] as List<HeroModel>;
  }

  Future<void> loadNextPage() async {
    // Если уже грузим или страниц больше нет — выходим
    if (_isLoadingMore || !_hasNext) return;

    _isLoadingMore = true;
    _currentPage++;

    final result = await _repository.getAllCharacters(page: _currentPage);
    final newCharacters = result['characters'] as List<HeroModel>;

    // Проверяем, есть ли следующая страница в ответе API
    _hasNext = result['info']['next'] != null;

    // Обновляем состояние, добавляя новых персонажей к старым
    state = AsyncData([...state.value ?? [], ...newCharacters]);
    _isLoadingMore = false;
  }
}
