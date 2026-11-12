import 'package:flutter/material.dart';

/// A single, consistent icon treatment for primary product actions.
/// It uses Flutter's built-in vector icons; no raster pack or emoji assets.
class PremiumIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final bool elevated;
  final String? semanticLabel;

  const PremiumIcon({
    super.key,
    required this.icon,
    this.size = 22,
    this.color,
    this.elevated = false,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = color ?? scheme.primary;

    final glyph = SizedBox(
      width: size + (elevated ? 12 : 0),
      height: size + (elevated ? 12 : 0),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, 1.2),
              child: Icon(
                icon,
                size: size,
                color: foreground.withOpacity(.20),
              ),
            ),
            Icon(icon, size: size, color: foreground),
          ],
        ),
      ),
    );

    if (!elevated) {
      return Semantics(
        label: semanticLabel,
        image: true,
        child: glyph,
      );
    }

    return Semantics(
      label: semanticLabel,
      image: true,
      child: Container(
        width: size + 12,
        height: size + 12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              foreground.withOpacity(.20),
              foreground.withOpacity(.08),
            ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? .16 : .70,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: foreground.withOpacity(.13),
              blurRadius: 9,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: glyph,
      ),
    );
  }
}
