import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pouyanly/core/theme/app_theme.dart';
import 'package:pouyanly/data/local/storage_service.dart';
import 'package:pouyanly/features/gamification/screens/rewards_screen.dart';
import 'package:pouyanly/shared/providers/user_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.instance.init();
  });

  testWidgets('rewards screen shows level progress without avatar selection',
      (tester) async {
    final provider = UserProvider();
    await provider.init();
    await provider.createUser();

    await tester.pumpWidget(
      ChangeNotifierProvider<UserProvider>.value(
        value: provider,
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: RewardsScreen()),
        ),
      ),
    );

    // Animated game icons intentionally repeat; pump a bounded frame instead
    // of pumpAndSettle, which waits forever for repeating tickers to stop.
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('پیشرفت سطح'), findsOneWidget);
    expect(find.text('انتخاب آواتار'), findsNothing);
    expect(find.byType(ChoiceChip), findsNothing);
    expect(find.byIcon(Icons.workspace_premium_rounded), findsOneWidget);
    expect(find.textContaining('XP تا سطح بعدی'), findsOneWidget);
  });
}
