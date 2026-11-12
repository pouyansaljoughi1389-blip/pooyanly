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
        final customPaint = tester.widget<CustomPaint>(find.byType(CustomPaint));
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
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(PouyanlyIconBadge),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.constraints?.maxWidth, isNull);
      expect(find.byType(PouyanlyIcon), findsOneWidget);
    });
  });
}
