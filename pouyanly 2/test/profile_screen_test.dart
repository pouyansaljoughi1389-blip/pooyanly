import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lib/core/theme/app_theme.dart';
import '../lib/data/local/storage_service.dart';
import '../lib/features/profile/screens/profile_screen.dart';
import '../lib/shared/providers/user_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.instance.init();
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
    await tester.pump();

    expect(find.text('هنوز حسابی برای نمایش وجود ندارد'), findsOneWidget);
    expect(find.text('رفتن به صفحهٔ شروع'), findsOneWidget);
  });

  test('user provider initialization is idempotent', () async {
    final provider = UserProvider();

    await Future.wait([provider.init(), provider.init()]);

    expect(provider.isInitialized, isTrue);
    expect(provider.user, isNull);
  });
}
