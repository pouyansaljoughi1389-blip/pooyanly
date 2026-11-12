import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Lightweight, offline animated game icons built with Flutter primitives.
class AnimatedCoinIcon extends StatefulWidget {
  final double size;
  const AnimatedCoinIcon({super.key, this.size = 24});

  @override
  State<AnimatedCoinIcon> createState() => _AnimatedCoinIconState();
}

class _AnimatedCoinIconState extends State<AnimatedCoinIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * math.pi * 2;
        final depth = .22 + .78 * math.cos(angle).abs();
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(depth, 1, 1),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF2A6), Color(0xFFFFC533), Color(0xFFB96A08)],
              ),
              border: Border.all(color: const Color(0xFFFFE8A0), width: 1.4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB52E).withOpacity(.38),
                  blurRadius: widget.size * .42,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(widget.size * .12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFB8750B), width: 1),
                ),
                child: Icon(
                  Icons.star_rounded,
                  size: widget.size * .48,
                  color: const Color(0xFF9B5A05),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedFlameIcon extends StatefulWidget {
  final double size;
  const AnimatedFlameIcon({super.key, this.size = 24});

  @override
  State<AnimatedFlameIcon> createState() => _AnimatedFlameIconState();
}

class _AnimatedFlameIconState extends State<AnimatedFlameIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -1.8 * _controller.value),
        child: CustomPaint(
          size: Size.square(widget.size),
          painter: _FlamePainter(_controller.value),
        ),
      ),
    );
  }
}

class _FlamePainter extends CustomPainter {
  final double phase;
  const _FlamePainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final sway = math.sin(phase * math.pi) * w * .055;

    final outer = Path()
      ..moveTo(w * .5, h * .03)
      ..cubicTo(w * .56 + sway, h * .25, w * .98, h * .42, w * .82, h * .72)
      ..cubicTo(w * .72, h * .98, w * .28, h * 1.02, w * .16, h * .72)
      ..cubicTo(w * .02, h * .43, w * .38 - sway, h * .28, w * .5, h * .03)
      ..close();

    final outerPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFE36B), Color(0xFFFF8A24), Color(0xFFE83D26)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(outer, outerPaint);

    final inner = Path()
      ..moveTo(w * .51, h * .39)
      ..cubicTo(w * .55, h * .55, w * .77, h * .64, w * .64, h * .83)
      ..cubicTo(w * .56, h * .96, w * .34, h * .92, w * .31, h * .77)
      ..cubicTo(w * .28, h * .63, w * .45, h * .55, w * .51, h * .39)
      ..close();
    final innerPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFC0), Color(0xFFFFD34D), Color(0xFFFF8B32)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(inner, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _FlamePainter oldDelegate) =>
      oldDelegate.phase != phase;
}

class AnimatedSymbolIcon extends StatefulWidget {
  final String symbol;
  final double size;
  final Color? color;

  const AnimatedSymbolIcon({
    super.key,
    required this.symbol,
    this.size = 24,
    this.color,
  });

  @override
  State<AnimatedSymbolIcon> createState() => _AnimatedSymbolIconState();
}

class _AnimatedSymbolIconState extends State<AnimatedSymbolIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData get _icon {
    switch (widget.symbol) {
      case '🔥': return Icons.local_fire_department_rounded;
      case '🪙': return Icons.monetization_on_rounded;
      case '⭐': return Icons.star_rounded;
      case '🏆': return Icons.emoji_events_rounded;
      case '🏅': return Icons.military_tech_rounded;
      case '📚':
      case '📖': return Icons.menu_book_rounded;
      case '🌱': return Icons.eco_rounded;
      case '💪': return Icons.fitness_center_rounded;
      case '🔁': return Icons.sync_rounded;
      case '🧠': return Icons.psychology_rounded;
      case '📅': return Icons.calendar_month_rounded;
      case '🎯': return Icons.track_changes_rounded;
      case '⏱️': return Icons.timer_rounded;
      case '📊': return Icons.bar_chart_rounded;
      case '✅': return Icons.check_circle_rounded;
      case '🔒': return Icons.lock_rounded;
      default: return Icons.auto_awesome_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.symbol == '🔥') {
      return AnimatedFlameIcon(size: widget.size);
    }
    if (widget.symbol == '🪙') {
      return AnimatedCoinIcon(size: widget.size);
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -1.2 * _controller.value),
        child: Icon(_icon, size: widget.size, color: widget.color),
      ),
    );
  }
}

IconData learningSymbolIcon(String symbol) {
  switch (symbol) {
    case '📚':
    case '📖': return Icons.menu_book_rounded;
    case '🔁': return Icons.sync_rounded;
    case '🧠': return Icons.psychology_rounded;
    case '🎯': return Icons.track_changes_rounded;
    case '🌱': return Icons.eco_rounded;
    case '⭐': return Icons.star_rounded;
    case '🏆': return Icons.emoji_events_rounded;
    case '🏅': return Icons.military_tech_rounded;
    case '🔥': return Icons.local_fire_department_rounded;
    default: return Icons.school_rounded;
  }
}
