import 'package:effective_mobile_test/core/themes/app_spacing.dart';
import 'package:effective_mobile_test/data/models/hero_model.dart';
import 'package:effective_mobile_test/presentation/providers/favorites_provider.dart';
import 'package:effective_mobile_test/presentation/widgets/rotating_favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeroCard extends ConsumerWidget {
  final HeroModel hero;

  const HeroCard({super.key, required this.hero});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final favoriteIds = ref.watch(favoritesProvider);
    final isFavorite = favoriteIds.contains(hero.id);

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
                      onPressed: () {
                        ref
                            .read(favoritesProvider.notifier)
                            .toggleFavorite(hero.id);
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

class _HeroImage extends StatelessWidget {
  final String imageUrl;

  const _HeroImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(
        left: Radius.circular(AppSpacing.s),
      ),
      child: Image.network(
        imageUrl,
        width: 120,
        height: 140,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 120,
            height: 140,
            color: Theme.of(context).colorScheme.surface.withAlpha(78),
            child: const Center(child: CircularProgressIndicator.adaptive()),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          width: 120,
          height: 140,
          color: Theme.of(context).colorScheme.errorContainer,
          child: Icon(
            Icons.person_off,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String status;
  final String species;

  const _StatusRow({required this.status, required this.species});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = switch (status.toLowerCase()) {
      'alive' => Colors.green,
      'dead' => Colors.red,
      _ => Colors.grey,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: statusColor.withAlpha(104),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        // Текст статуса и вида
        Expanded(
          child: Text(
            '$status — $species',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
