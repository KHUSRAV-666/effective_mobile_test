import 'package:effective_mobile_test/core/theme/app_spacing.dart';
import 'package:effective_mobile_test/features/favorite/presentation/providers/favorites_provider.dart';
import 'package:effective_mobile_test/shared/widgets/hero/hero_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortOption { nameAsc, nameDesc }

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  SortOption _sortOption = SortOption.nameAsc;

  List<dynamic> _sortHeroes(List<dynamic> heroes) {
    final sorted = List.from(heroes);

    switch (_sortOption) {
      case SortOption.nameAsc:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDesc:
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
    }

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные'),
        actions: [
          if (favoritesAsync.hasValue && favoritesAsync.value!.isNotEmpty)
            _sortPopup(),
        ],
      ),
      body: favoritesAsync.when(
        data: (heroes) {
          if (heroes.isEmpty) {
            return const _EmptyFavorites();
          }

          final sortedHeroes = _sortHeroes(heroes);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.s),
                  itemCount: sortedHeroes.length,
                  itemBuilder: (context, index) =>
                      HeroCard(hero: sortedHeroes[index]),
                ),
              ),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  PopupMenuButton<SortOption> _sortPopup() {
    return PopupMenuButton<SortOption>(
      icon: const Icon(Icons.sort),
      onSelected: (SortOption option) {
        setState(() {
          _sortOption = option;
        });
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: SortOption.nameAsc,
          child: Row(
            children: [
              Icon(Icons.arrow_upward, size: 18),
              SizedBox(width: 8),
              Text('A-Z'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: SortOption.nameDesc,
          child: Row(
            children: [
              Icon(Icons.arrow_downward, size: 18),
              SizedBox(width: 8),
              Text('Z-A'),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border, size: 80, color: Colors.grey[400]),
          const SizedBox(height: AppSpacing.m),
          const Text(
            'Список избранных пуст',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'Добавляйте персонажей в избранное\nна главном экране',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
