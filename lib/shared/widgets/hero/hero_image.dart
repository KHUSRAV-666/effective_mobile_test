part of './hero_card.dart';

class _HeroImage extends StatelessWidget {
  final String imageUrl;

  const _HeroImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(
        left: Radius.circular(AppSpacing.s),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 120,
        height: 140,
        fit: BoxFit.cover,
        cacheManager: HeroCacheManager.instance,

        fadeInDuration: const Duration(milliseconds: 300),
        fadeInCurve: Curves.easeOut,

        placeholder: (context, url) => Container(
          width: 120,
          height: 140,
          color: Theme.of(context).colorScheme.surface.withAlpha(78),
          child: const Center(child: CircularProgressIndicator.adaptive()),
        ),

        errorWidget: (context, url, error) => Container(
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
