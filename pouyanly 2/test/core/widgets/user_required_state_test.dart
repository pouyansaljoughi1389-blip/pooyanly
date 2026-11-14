import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/core/widgets/user_required_state.dart';

void main() {
  testWidgets('shows a visible recovery action when account data is missing',
      (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserRequiredState(
            title: 'پروفایل آماده نیست',
            message: 'اطلاعات حساب در دسترس نیست.',
            actionLabel: 'رفتن به شروع',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('پروفایل آماده نیست'), findsOneWidget);
    expect(find.text('اطلاعات حساب در دسترس نیست.'), findsOneWidget);
    expect(find.text('رفتن به شروع'), findsOneWidget);

    await tester.tap(find.text('رفتن به شروع'));
    expect(tapped, isTrue);
  });
}
