import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pouyanly/data/local/storage_service.dart';
import 'package:pouyanly/shared/providers/user_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.instance.init();
  });

  group('Phase 8 gamification', () {
    test('XP levels progress at 500 XP intervals', () async {
      final provider = UserProvider();
      await provider.createUser();
      expect(provider.user!.level, 1);
      await provider.addXP(500);
      expect(provider.user!.level, 2);
      expect(provider.user!.xpInCurrentLevel, 0);
      expect(provider.user!.levelProgress, 0);
    });

    test('weekly lesson mission grants its reward only once', () async {
      final provider = UserProvider();
      await provider.init();
      await provider.createUser();

      expect(await provider.claimWeeklyMission('lessons'), isFalse);
      await provider.completeLesson('weekly-1');
      await provider.completeLesson('weekly-2');
      await provider.completeLesson('weekly-3');

      expect(provider.weeklyMissionProgress['lessons'], 3);
      expect(await provider.claimWeeklyMission('lessons'), isTrue);
      final xpAfterClaim = provider.user!.xp;
      final coinsAfterClaim = provider.user!.coins;
      expect(await provider.claimWeeklyMission('lessons'), isFalse);
      expect(provider.user!.xp, xpAfterClaim);
      expect(provider.user!.coins, coinsAfterClaim);
    });

    test('weekly vocabulary mission counts reviews and persists claims', () async {
      final provider = UserProvider();
      await provider.init();
      await provider.createUser();

      for (var i = 0; i < 20; i++) {
        await provider.reviewVocabulary('weekly-word-$i', remembered: true);
      }
      expect(provider.weeklyMissionProgress['vocabulary'], 20);
      expect(await provider.claimWeeklyMission('vocabulary'), isTrue);

      final restored = UserProvider();
      await restored.init();
      expect(restored.claimedWeeklyMissions, contains('vocabulary'));
      expect(restored.weeklyMissionProgress['vocabulary'], 20);
    });

    test('avatar selection is restricted and persists', () async {
      final provider = UserProvider();
      await provider.createUser();
      await provider.setAvatarEmoji('🐼');
      expect(provider.user!.avatarEmoji, '🦊');
      expect(await provider.unlockAvatarEmoji('🐼'), isFalse);
      await provider.addCoins(30);
      expect(await provider.unlockAvatarEmoji('🐼'), isTrue);
      await provider.setAvatarEmoji('🐼');
      expect(provider.user!.avatarEmoji, '🐼');

      await provider.setAvatarEmoji('🚀');
      expect(provider.user!.avatarEmoji, '🐼');

      final restored = StorageService.instance.loadUser();
      expect(restored!.avatarEmoji, '🐼');
      expect(restored.unlockedAvatarEmojis, contains('🐼'));
    });
  });
}
