import 'dart:math' as math;
import 'package:flutter/material.dart';

/// The semantic icon vocabulary used throughout POUYANLY.
/// Icons are drawn as lightweight vectors so they stay crisp at every scale.
enum PouyanlyIconType {
  home,
  learningPath,
  vocabulary,
  review,
  listening,
  speaking,
  brain,
  target,
  xp,
  coin,
  streak,
  trophy,
  medal,
  locked,
  completed,
  statistics,
  profile,
  settings,
  calendar,
  timer,
  growth,
  sync,
  book,
  school,
}

class PouyanlyIcon extends StatelessWidget {
  final PouyanlyIconType type;
  final double size;
  final Color? color;
  final Color? accentColor;
  final String? semanticLabel;

  const PouyanlyIcon({
    super.key,
    required this.type,
    this.size = 24,
    this.color,
    this.accentColor,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = color ?? scheme.primary;
    return Semantics(
      label: semanticLabel,
      image: true,
      child: ExcludeSemantics(
        child: CustomPaint(
          size: Size.square(size),
          painter: _PouyanlyIconPainter(
            type: type,
            color: foreground,
            accent: accentColor ?? scheme.tertiary,
          ),
        ),
      ),
    );
  }
}

class PouyanlyIconBadge extends StatelessWidget {
  final PouyanlyIconType type;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final String? semanticLabel;

  const PouyanlyIconBadge({
    super.key,
    required this.type,
    this.color,
    this.backgroundColor,
    this.size = 24,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = color ?? scheme.primary;
    return Semantics(
      label: semanticLabel,
      image: true,
      child: Container(
        width: size + 20,
        height: size + 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ?? foreground.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: foreground.withValues(alpha: .14)),
        ),
        child: PouyanlyIcon(
          type: type,
          size: size,
          color: foreground,
        ),
      ),
    );
  }
}

class _PouyanlyIconPainter extends CustomPainter {
  final PouyanlyIconType type;
  final Color color;
  final Color accent;

  const _PouyanlyIconPainter({
    required this.type,
    required this.color,
    required this.accent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width, size.height) / 24;
    canvas.save();
    canvas.translate((size.width - 24 * scale) / 2, (size.height - 24 * scale) / 2);
    canvas.scale(scale);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final accentFill = Paint()
      ..color = accent
      ..style = PaintingStyle.fill;

    void line(double x1, double y1, double x2, double y2, [Paint? p]) {
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), p ?? stroke);
    }
    void circle(double x, double y, double r, [Paint? p]) {
      canvas.drawCircle(Offset(x, y), r, p ?? stroke);
    }
    void rounded(double l, double t, double r, double b, double radius, [Paint? p]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTRB(l, t, r, b), Radius.circular(radius)),
        p ?? stroke,
      );
    }

    switch (type) {
      case PouyanlyIconType.home:
        final path = Path()..moveTo(3, 11)..lineTo(12, 3.5)..lineTo(21, 11)
          ..moveTo(5.5, 9.5)..lineTo(5.5, 20)..lineTo(18.5, 20)..lineTo(18.5, 9.5)
          ..moveTo(10, 20)..lineTo(10, 14)..lineTo(14, 14)..lineTo(14, 20);
        canvas.drawPath(path, stroke);
      case PouyanlyIconType.learningPath:
        circle(6, 18, 2.1, accentFill);
        circle(17.5, 6, 2.1, accentFill);
        final path = Path()..moveTo(8, 17)..cubicTo(18, 16, 5, 9, 15.5, 7);
        canvas.drawPath(path, stroke);
        line(15, 7, 12.8, 5.6);
        line(15, 7, 13.2, 9.2);
      case PouyanlyIconType.vocabulary:
      case PouyanlyIconType.book:
        rounded(4, 4, 20, 20, 2.5);
        line(12, 5, 12, 19);
        line(7, 8, 10, 8);
        line(14, 8, 17, 8);
        line(7, 12, 10, 12);
        line(14, 12, 17, 12);
      case PouyanlyIconType.review:
      case PouyanlyIconType.sync:
        final path = Path()..moveTo(19, 8)..cubicTo(17, 4, 11, 3, 7, 6)
          ..cubicTo(3, 9, 4, 15, 7, 18)..moveTo(7, 18)..lineTo(7, 13)
          ..moveTo(7, 18)..lineTo(12, 18)..moveTo(5, 16)
          ..cubicTo(7, 21, 14, 22, 18, 17);
        canvas.drawPath(path, stroke);
      case PouyanlyIconType.listening:
        final path = Path()..moveTo(5, 13)..lineTo(5, 11)
          ..cubicTo(5, 2, 19, 2, 19, 11)..lineTo(19, 15)
          ..cubicTo(19, 18, 17, 19, 14, 19);
        canvas.drawPath(path, stroke);
        rounded(3, 11, 7, 17, 2, stroke);
        rounded(17, 11, 21, 17, 2, stroke);
        circle(13, 19, 1.1, accentFill);
      case PouyanlyIconType.speaking:
        final path = Path()..moveTo(4, 5)..quadraticBezierTo(4, 3.5, 6, 3.5)
          ..lineTo(18, 3.5)..quadraticBezierTo(20, 3.5, 20, 5)
          ..lineTo(20, 14)..quadraticBezierTo(20, 16, 18, 16)
          ..lineTo(10, 16)..lineTo(6, 20)..lineTo(6, 16)
          ..quadraticBezierTo(4, 16, 4, 14)..close();
        canvas.drawPath(path, stroke);
        circle(9, 10, 1, accentFill);
        circle(12, 10, 1, accentFill);
        circle(15, 10, 1, accentFill);
      case PouyanlyIconType.brain:
        final path = Path()..moveTo(12, 5)..cubicTo(8, 1, 4, 5, 6, 9)
          ..cubicTo(2, 12, 5, 18, 9, 18)..cubicTo(10, 22, 13, 21, 13, 18)
          ..lineTo(13, 6)..moveTo(12, 5)..cubicTo(16, 1, 20, 5, 18, 9)
          ..cubicTo(22, 12, 19, 18, 15, 18)..cubicTo(14, 22, 11, 21, 11, 18);
        canvas.drawPath(path, stroke);
        line(8, 10, 11, 12);
        line(16, 10, 13, 12);
      case PouyanlyIconType.target:
        circle(12, 12, 9);
        circle(12, 12, 5.5, Paint()..color = accent..style = PaintingStyle.stroke..strokeWidth = 1.7);
        circle(12, 12, 1.8, accentFill);
        line(14, 10, 21, 3);
      case PouyanlyIconType.xp:
        final star = Path()..moveTo(12, 2.5)..lineTo(14.8, 8.5)..lineTo(21.3, 9.2)
          ..lineTo(16.5, 13.7)..lineTo(17.8, 20.5)..lineTo(12, 17.2)
          ..lineTo(6.2, 20.5)..lineTo(7.5, 13.7)..lineTo(2.7, 9.2)
          ..lineTo(9.2, 8.5)..close();
        canvas.drawPath(star, fill);
        circle(12, 11, 2.1, accentFill);
      case PouyanlyIconType.coin:
        circle(12, 12, 9);
        circle(12, 12, 6.5, Paint()..color = accent..style = PaintingStyle.stroke..strokeWidth = 1.2);
        final coinMark = Path()..moveTo(15, 8)..quadraticBezierTo(12, 6, 10, 8)
          ..quadraticBezierTo(8, 10, 12, 11)..quadraticBezierTo(16, 12, 14, 15)
          ..quadraticBezierTo(12, 17, 9, 15);
        canvas.drawPath(coinMark, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5..strokeCap = StrokeCap.round);
      case PouyanlyIconType.streak:
        final flame = Path()..moveTo(12, 2)..cubicTo(14, 7, 20, 9, 18, 16)
          ..cubicTo(17, 21, 7, 23, 5, 16)..cubicTo(3, 11, 9, 8, 10, 5)
          ..cubicTo(10, 9, 14, 10, 12, 2)..close();
        canvas.drawPath(flame, accentFill);
        final inner = Path()..moveTo(12, 12)..cubicTo(15, 15, 14, 19, 11, 19)
          ..cubicTo(8, 18, 9, 15, 12, 12)..close();
        canvas.drawPath(inner, Paint()..color = color.withValues(alpha: .9));
      case PouyanlyIconType.trophy:
        rounded(5, 3, 19, 15, 2);
        final cup = Path()..moveTo(5, 6)..lineTo(2.5, 6)..lineTo(2.5, 9)
          ..quadraticBezierTo(2.5, 13, 7, 13)..moveTo(19, 6)..lineTo(21.5, 6)
          ..lineTo(21.5, 9)..quadraticBezierTo(21.5, 13, 17, 13)
          ..moveTo(12, 15)..lineTo(12, 19)..moveTo(8, 21)..lineTo(16, 21);
        canvas.drawPath(cup, stroke);
        circle(12, 8, 1.6, accentFill);
      case PouyanlyIconType.medal:
        final ribbon = Path()..moveTo(7, 3)..lineTo(10, 11)..lineTo(14, 11)..lineTo(17, 3);
        canvas.drawPath(ribbon, stroke);
        circle(12, 15, 6, accentFill);
        circle(12, 15, 3.2, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5);
      case PouyanlyIconType.locked:
        rounded(4, 10, 20, 21, 2);
        final shackle = Path()..moveTo(7, 10)..lineTo(7, 7)
          ..cubicTo(7, 1, 17, 1, 17, 7)..lineTo(17, 10);
        canvas.drawPath(shackle, stroke);
        circle(12, 15, 1.2, accentFill);
        line(12, 16, 12, 18);
      case PouyanlyIconType.completed:
        circle(12, 12, 9, Paint()..color = accent..style = PaintingStyle.stroke..strokeWidth = 1.8);
        final check = Path()..moveTo(7, 12)..lineTo(10.5, 15.5)..lineTo(17.5, 8);
        canvas.drawPath(check, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.2..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round);
      case PouyanlyIconType.statistics:
        rounded(3, 3, 21, 21, 2);
        rounded(6, 13, 9, 18, 1, accentFill);
        rounded(11, 9, 14, 18, 1, fill);
        rounded(16, 6, 19, 18, 1, accentFill);
      case PouyanlyIconType.profile:
        circle(12, 8, 4);
        final shoulders = Path()..moveTo(4, 21)..cubicTo(4, 14, 20, 14, 20, 21);
        canvas.drawPath(shoulders, stroke);
      case PouyanlyIconType.settings:
        circle(12, 12, 3.2);
        for (var i = 0; i < 8; i++) {
          final angle = i * math.pi / 4;
          final inner = Offset(12 + math.cos(angle) * 6, 12 + math.sin(angle) * 6);
          final outer = Offset(12 + math.cos(angle) * 9, 12 + math.sin(angle) * 9);
          canvas.drawLine(inner, outer, stroke);
        }
      case PouyanlyIconType.calendar:
        rounded(3, 5, 21, 21, 2);
        line(3, 9, 21, 9);
        line(8, 3, 8, 7);
        line(16, 3, 16, 7);
        circle(8, 13, 1, accentFill);
        circle(13, 13, 1, accentFill);
        circle(8, 17, 1, accentFill);
      case PouyanlyIconType.timer:
        circle(12, 13, 8);
        line(12, 13, 12, 8);
        line(12, 13, 16, 15);
        line(9, 2, 15, 2);
        line(12, 2, 12, 5);
      case PouyanlyIconType.growth:
        final path = Path()..moveTo(4, 20)..lineTo(4, 15)..lineTo(9, 15)
          ..lineTo(9, 10)..lineTo(14, 10)..lineTo(14, 5)..lineTo(20, 5);
        canvas.drawPath(path, stroke);
        line(15, 5, 20, 5);
        line(20, 5, 20, 10);
        circle(4, 20, 1.3, accentFill);
      case PouyanlyIconType.school:
        final roof = Path()..moveTo(2, 9)..lineTo(12, 3)..lineTo(22, 9)..lineTo(12, 15)..close();
        canvas.drawPath(roof, stroke);
        line(6, 12, 6, 18);
        line(18, 12, 18, 18);
        line(6, 18, 12, 21);
        line(12, 21, 18, 18);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PouyanlyIconPainter oldDelegate) =>
      oldDelegate.type != type ||
      oldDelegate.color != color ||
      oldDelegate.accent != accent;
}
