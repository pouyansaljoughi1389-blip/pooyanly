import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pouyanly/data/local/storage_service.dart';
import 'package:pouyanly/features/lessons/models/lesson_data.dart';
import 'package:pouyanly/shared/providers/user_provider.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.instance.init();
  });

  group('Daily missions', () {
    test('study calendar records unique local dates and survives restart', () async {
      final provider = UserProvider();
      await provider.init();
      await provider.createUser();
      final firstUnit = CourseData.getAllUnits().first;
      await provider.completeLesson(firstUnit.lessons[0].id);
      await provider.completeLesson(firstUnit.lessons[1].id);
      expect(provider.user!.studyDateKeys, hasLength(1));
      final restored = UserProvider();
      await restored.init();
      expect(restored.user!.studyDateKeys, provider.user!.studyDateKeys);
    });

    test('negative XP and coin grants cannot reduce balances', () async {
      final provider = UserProvider();
      await provider.init();
      await provider.createUser();
      await provider.addXP(-500);
      await provider.addCoins(-100);
      expect(provider.user!.xp, 0);
      expect(provider.user!.coins, 0);
    });

    test('lesson reward is claimable only once and persists', () async {
      final provider = UserProvider();
      await provider.init();
      await provider.createUser();

      expect(await provider.claimDailyMission('lesson'), isFalse);
      await provider.completeLesson(CourseData.getAllUnits().first.lessons.first.id);
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
