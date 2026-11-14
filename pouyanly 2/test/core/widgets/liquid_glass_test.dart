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

  testWidgets('glass Material clips to its exact rounded shape in both themes',
      (tester) async {
    const radius = BorderRadius.all(Radius.circular(28));

    for (final theme in [ThemeData.light(), ThemeData.dark()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: LiquidGlass(
              borderRadius: radius,
              child: Text('Shape-aware glass'),
            ),
          ),
        ),
      );

      final shapedMaterials = find.byWidgetPredicate(
        (widget) =>
            widget is Material &&
            widget.shape is RoundedRectangleBorder &&
            widget.clipBehavior == Clip.antiAlias,
      );
      expect(shapedMaterials, findsOneWidget);
      final material = tester.widget<Material>(shapedMaterials);
      expect(
        (material.shape! as RoundedRectangleBorder).borderRadius,
        radius,
      );
    }
  });

  testWidgets('glass tint and border follow both theme brightnesses',
      (tester) async {
    for (final theme in [ThemeData.light(), ThemeData.dark()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: LiquidGlass(child: Text('Theme-aware surface')),
          ),
        ),
      );
      final glassFinder = find.byType(LiquidGlass);
      final inkFinder = find.descendant(
        of: glassFinder,
        matching: find.byType(Ink),
      ).first;
      final ink = tester.widget<Ink>(inkFinder);
      final decoration = ink.decoration! as BoxDecoration;
      final colors = (decoration.gradient! as LinearGradient).colors;
      final scheme = Theme.of(tester.element(glassFinder)).colorScheme;
      expect(
        colors.first,
        scheme.surfaceContainerHighest.withValues(
          alpha: scheme.brightness == Brightness.dark ? .84 : .78,
        ),
      );
      expect(decoration.border, isA<Border>());
    }
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

  testWidgets('navigation uses bounded rounded blur layers and reports selection',
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
    final shapedMaterials = find.byWidgetPredicate(
      (widget) =>
          widget is Material &&
          widget.shape is RoundedRectangleBorder &&
          widget.clipBehavior == Clip.antiAlias,
    );
    expect(shapedMaterials, findsAtLeastNWidgets(2));
    expect(find.text('لغت'), findsOneWidget);
    await tester.tap(find.text('خانه'));
    expect(selected, 1);
  });
}
