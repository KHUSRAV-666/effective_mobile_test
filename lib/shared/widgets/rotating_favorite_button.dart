import 'dart:math' as math;
import 'package:flutter/material.dart';

class RotatingFavoriteButton extends StatefulWidget {
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
  State<RotatingFavoriteButton> createState() => _RotatingFavoriteButtonState();
}

class _RotatingFavoriteButtonState extends State<RotatingFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> rotation;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    rotation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 1.35,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.35,
          end: 1,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  Future<void> _handleTap() async {
    await _controller.forward(from: 0);
    widget.onPressed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveInactiveColor =
        widget.inactiveColor ?? Theme.of(context).colorScheme.outline;

    return IconButton(
      onPressed: _handleTap,
      icon: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final direction = widget.isFavorite ? -1 : 1;

          return Transform.rotate(
            angle: rotation.value * 2 * math.pi * direction,
            child: Transform.scale(scale: scale.value, child: child),
          );
        },
        child: Icon(
          widget.isFavorite ? Icons.star : Icons.star_border,
          color: widget.isFavorite
              ? widget.activeColor
              : effectiveInactiveColor,
          size: 28,
        ),
      ),
    );
  }
}
