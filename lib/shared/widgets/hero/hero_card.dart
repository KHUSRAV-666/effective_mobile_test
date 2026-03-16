import 'package:cached_network_image/cached_network_image.dart';
import 'package:effective_mobile_test/core/store/hero_cache_manager.dart';
import 'package:effective_mobile_test/core/theme/app_spacing.dart';
import 'package:effective_mobile_test/features/home/data/models/hero_model.dart';
import 'package:effective_mobile_test/features/favorite/presentation/providers/favorites_provider.dart';
import 'package:effective_mobile_test/features/home/presentation/providers/hero_provider.dart';
import 'package:effective_mobile_test/shared/widgets/rotating_favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part './hero_image.dart';
part './status_row.dart';

class HeroCard extends ConsumerWidget {
  final HeroModel hero;

  const HeroCard({super.key, required this.hero});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final favoritesAsync = ref.watch(favoritesProvider);

    final bool isFavorite = favoritesAsync.when(
      data: (favorites) => favorites.any((h) => h.id == hero.id),
      loading: () => false,
      error: (_, __) => false,
    );

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.s),
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroImage(imageUrl: hero.imageUrl),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Text(
                            hero.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _StatusRow(status: hero.status, species: hero.species),
                        const SizedBox(height: AppSpacing.s),
                        Text(
                          'Последнее местоположение:',
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          hero.location,
                          style: theme.textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: RotatingFavoriteButton(
                      isFavorite: isFavorite,
                      onPressed: () async {
                        final notifier = ref.read(favoritesProvider.notifier);

                        final isAdded = await notifier.toggleFavorite(hero);

                        if (!context.mounted) return;

                        ref
                            .read(heroNotifierProvider.notifier)
                            .updateFavoriteLocal(hero.id, isAdded);

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isAdded
                                  ? '${hero.name} добавлен(а) в избранное'
                                  : '${hero.name} удален(а) из избранных',
                            ),
                            backgroundColor: isAdded
                                ? Colors.green
                                : Colors.redAccent,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
