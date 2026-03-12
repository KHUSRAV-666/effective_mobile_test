import 'package:effective_mobile_test/core/theme/app_spacing.dart';
import 'package:effective_mobile_test/features/favorite/presentation/providers/favorites_provider.dart';
import 'package:effective_mobile_test/shared/widgets/hero_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteHeroesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Избранные')),
      body: favoritesAsync.when(
        data: (heroes) {
          if (heroes.isEmpty) {
            return const _EmptyFavorites();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.s),
            itemCount: heroes.length,
            itemBuilder: (context, index) => HeroCard(hero: heroes[index]),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
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
          const Text('Список избранных пуст', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
