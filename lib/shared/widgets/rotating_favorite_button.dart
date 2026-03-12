import 'dart:math' as math;
import 'package:flutter/material.dart';

class RotatingFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onPressed;
  final Color? activeColor;
  final Color? inactiveColor;

  const RotatingFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.activeColor = Colors.amber,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveInactiveColor =
        inactiveColor ?? Theme.of(context).colorScheme.outline;

    return IconButton(
      onPressed: onPressed,
      icon: TweenAnimationBuilder<double>(
        key: ValueKey(isFavorite),
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutBack,
        builder: (context, value, child) {
          return Transform.rotate(
            // Поворот на 360 градусов (2 * pi)
            angle: value * 2 * math.pi,
            child: child,
          );
        },
        child: Icon(
          isFavorite ? Icons.star : Icons.star_border,
          color: isFavorite ? activeColor : effectiveInactiveColor,
        ),
      ),
    );
  }
}
