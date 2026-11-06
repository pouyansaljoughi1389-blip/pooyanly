import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pouyanly/data/local/storage_service.dart';
import 'package:pouyanly/shared/providers/user_provider.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.instance.init();
  });

  group('Daily missions', () {
    test('lesson reward is claimable only once and persists', () async {
      final provider = UserProvider();
      await provider.init();
      await provider.createUser();

      expect(await provider.claimDailyMission('lesson'), isFalse);
      await provider.completeLesson('lesson-1');
      expect(provider.dailyMissionProgress['lesson'], 1);

      expect(await provider.claimDailyMission('lesson'), isTrue);
      expect(provider.user!.xp, 40);
      expect(provider.user!.coins, 10);
      expect(await provider.claimDailyMission('lesson'), isFalse);

      final restored = UserProvider();
      await restored.init();
      expect(restored.claimedDailyMissions, contains('lesson'));
    });

    test('five vocabulary reviews unlock the vocabulary reward', () async {
      final provider = UserProvider();
      await provider.init();
      await provider.createUser();

      for (var i = 0; i < 5; i++) {
        await provider.reviewVocabulary('word-$i', remembered: true);
      }

      expect(provider.dailyMissionProgress['vocabulary'], 5);
      expect(await provider.claimDailyMission('vocabulary'), isTrue);
      expect(provider.user!.xp, 15);
      expect(provider.user!.coins, 3);
    });
  });
}
