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

  test('vocabulary review schedules increasing intervals when remembered', () async {
    final provider = UserProvider();
    await provider.createUser();

    await provider.reviewVocabulary('Hello', remembered: true);
    expect(provider.user!.vocabularyReviewRepetitions['hello'], 1);
    expect(provider.user!.vocabularyReviewIntervals['hello'], 1);

    await provider.reviewVocabulary('Hello', remembered: true);
    expect(provider.user!.vocabularyReviewRepetitions['hello'], 2);
    expect(provider.user!.vocabularyReviewIntervals['hello'], 3);

    await provider.reviewVocabulary('Hello', remembered: true);
    expect(provider.user!.vocabularyReviewRepetitions['hello'], 3);
    expect(provider.user!.vocabularyReviewIntervals['hello'], 6);
  });

  test('a forgotten word returns to a short review interval', () async {
    final provider = UserProvider();
    await provider.createUser();

    await provider.reviewVocabulary('Goodbye', remembered: true);
    await provider.reviewVocabulary('Goodbye', remembered: true);
    await provider.reviewVocabulary('Goodbye', remembered: false);

    expect(provider.user!.vocabularyReviewRepetitions['goodbye'], 0);
    expect(provider.user!.vocabularyReviewIntervals['goodbye'], 1);
  });

  test('forgotten words are counted and mastery is measurable', () async {
    final provider = UserProvider();
    await provider.createUser();

    await provider.reviewVocabulary('Remember', remembered: true);
    await provider.reviewVocabulary('Remember', remembered: false);

    expect(provider.vocabularyMistakeCount, 1);
    expect(provider.vocabularyMasteryPercent, 0);
    expect(provider.user!.vocabularyReviewMistakes['remember'], 1);
  });

  test('review scheduling survives user JSON persistence', () async {
    final provider = UserProvider();
    await provider.createUser();
    await provider.reviewVocabulary('Thank you', remembered: true);

    final restored = StorageService.instance.loadUser();
    expect(restored!.vocabularyReviewRepetitions['thank you'], 1);
    expect(restored.vocabularyReviewIntervals['thank you'], 1);
    expect(restored.vocabularyReviewDueDates.containsKey('thank you'), isTrue);
  });
}
