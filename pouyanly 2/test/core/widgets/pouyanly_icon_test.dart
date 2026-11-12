import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/core/widgets/pouyanly_icon.dart';

void main() {
  group('POUYANLY semantic icon family', () {
    testWidgets('every semantic icon paints at its requested size', (tester) async {
      for (final type in PouyanlyIconType.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: PouyanlyIcon(
                  type: type,
                  size: 32,
                  semanticLabel: type.name,
                ),
              ),
            ),
          ),
        );
        final customPaint = tester.widget<CustomPaint>(
          find.descendant(
            of: find.byType(PouyanlyIcon),
            matching: find.byType(CustomPaint),
          ),
        );
        expect(customPaint.size, const Size.square(32), reason: type.name);
        expect(find.bySemanticsLabel(type.name), findsOneWidget, reason: type.name);
      }
    });

    testWidgets('badge uses the supplied icon and dimensions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PouyanlyIconBadge(
              type: PouyanlyIconType.trophy,
              size: 28,
              semanticLabel: 'Achievement',
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Achievement'), findsOneWidget);
      expect(
        tester.getSize(find.byType(PouyanlyIconBadge)),
        const Size(48, 48),
      );
      expect(find.byType(PouyanlyIcon), findsOneWidget);
    });
  });
}
