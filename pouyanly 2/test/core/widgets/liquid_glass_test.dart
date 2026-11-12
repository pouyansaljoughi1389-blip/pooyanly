import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/core/widgets/liquid_glass.dart';

void main() {
  testWidgets('plain glass surfaces avoid an expensive blur layer', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LiquidGlass(child: Text('Readable content')),
        ),
      ),
    );

    expect(find.text('Readable content'), findsOneWidget);
    expect(find.byType(BackdropFilter), findsNothing);
  });

  testWidgets('interactive glass surface invokes its action', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LiquidGlass(
            onTap: () => tapped = true,
            child: const Text('Open settings'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open settings'));
    expect(tapped, isTrue);
  });

  testWidgets('navigation uses one bounded blur layer and reports selection',
      (tester) async {
    var selected = -1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: LiquidGlassNavigationBar(
            selectedIndex: 2,
            onTap: (index) => selected = index,
          ),
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(find.text('لغت'), findsOneWidget);
    await tester.tap(find.text('خانه'));
    expect(selected, 1);
  });
}
