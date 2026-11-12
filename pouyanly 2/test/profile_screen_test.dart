import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lib/core/theme/app_theme.dart';
import '../lib/data/local/storage_service.dart';
import '../lib/data/models/user_model.dart';
import '../lib/features/profile/screens/profile_screen.dart';
import '../lib/shared/providers/user_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // The Android launcher-widget plugin has no host implementation in unit
    // tests. Use a non-Android test platform so provider hydration stays local.
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    SharedPreferences.setMockInitialValues({});
    await StorageService.instance.init();
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('profile never renders a blank screen without a user',
      (tester) async {
    final provider = UserProvider();
    await provider.init();
    expect(provider.isInitialized, isTrue);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ProfileScreen(),
        ),
      ),
    );

    expect(find.text('هنوز حسابی برای نمایش وجود ندارد'), findsOneWidget);
    expect(find.text('رفتن به صفحهٔ شروع'), findsOneWidget);
  });

  test('user provider initialization is idempotent', () async {
    final provider = UserProvider();

    await Future.wait([provider.init(), provider.init()]);

    expect(provider.isInitialized, isTrue);
    expect(provider.user, isNull);
  });

  test('progress reset preserves the local account and clears learning data', () async {
    final provider = UserProvider();
    await provider.init();
    await provider.createUser(
      firstName: 'Pouyan',
      lastName: 'Test',
      contact: 'pouyan@example.com',
      contactType: 'email',
    );
    final originalId = provider.user!.id;
    await provider.updateUser(provider.user!.copyWith(
      xp: 1250,
      coins: 80,
      streak: 6,
      longestStreak: 9,
      completedLessonIds: const ['lesson_a1_01'],
      cefrLevel: CefrLevel.b1,
      placementTestComplete: true,
      skillScores: const {'grammar': 80},
      vocabularyReviewDueDates: const {'hello': '2026-01-01'},
    ));

    await provider.resetProgress();

    final user = provider.user!;
    expect(user.id, originalId);
    expect(user.name, 'Pouyan Test');
    expect(user.contact, 'pouyan@example.com');
    expect(user.xp, 0);
    expect(user.coins, 0);
    expect(user.streak, 0);
    expect(user.longestStreak, 0);
    expect(user.lastStudyDate, isNull);
    expect(user.completedLessonIds, isEmpty);
    expect(user.vocabularyReviewDueDates, isEmpty);
    expect(user.skillScores, isEmpty);
    expect(user.cefrLevel, CefrLevel.unknown);
    expect(user.placementTestComplete, isFalse);
    expect(user.onboardingComplete, isTrue);
    expect(StorageService.instance.loadUser()!.id, originalId);
  });


  testWidgets('profile editor updates persisted local account details',
      (tester) async {
    final provider = UserProvider();
    await provider.init();
    await provider.createUser(
      firstName: 'Old',
      lastName: 'Name',
      contact: 'old@example.com',
      contactType: 'email',
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ProfileScreen(),
        ),
      ),
    );
    await tester.tap(find.byTooltip('ویرایش اطلاعات حساب'));
    // Profile contains repeating decorative animations; settle only the
    // dialog transition instead of waiting for every ticker on the page.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(find.byType(TextFormField).at(0), 'New');
    await tester.enterText(find.byType(TextFormField).at(1), 'Learner');
    await tester.enterText(find.byType(TextFormField).at(2), 'new@example.com');
    await tester.tap(find.text('ذخیره'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(provider.user!.name, 'New Learner');
    expect(provider.user!.contact, 'new@example.com');
    expect(StorageService.instance.loadUser()!.name, 'New Learner');
  });

}
