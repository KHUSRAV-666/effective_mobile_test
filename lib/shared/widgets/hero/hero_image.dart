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
