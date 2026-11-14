// ─── Enums ─────────────────────────────────────────────────────────────────

enum LearningGoal {
  travel, work, study, immigration, entertainment, exam, general;

  String get farsiLabel {
    switch (this) {
      case LearningGoal.travel:        return 'سفر به خارج از کشور';
      case LearningGoal.work:          return 'پیشرفت شغلی';
      case LearningGoal.study:         return 'تحصیل در خارج';
      case LearningGoal.immigration:   return 'مهاجرت';
      case LearningGoal.entertainment: return 'تماشای فیلم و سریال';
      case LearningGoal.exam:          return 'آمادگی برای آزمون';
      case LearningGoal.general:       return 'یادگیری عمومی';
    }
  }
}

enum EngLevel {
  beginner, elementary, preIntermediate, intermediate, upperIntermediate;

  String get farsiLabel {
    switch (this) {
      case EngLevel.beginner:          return 'مبتدی — هیچ چیز نمی‌دانم';
      case EngLevel.elementary:        return 'ابتدایی — چند کلمه بلدم';
      case EngLevel.preIntermediate:   return 'پایه — جملات ساده';
      case EngLevel.intermediate:      return 'متوسط — مکالمه پایه';
      case EngLevel.upperIntermediate: return 'بالاتر از متوسط';
    }
  }
}

enum StudyTime {
  five, ten, fifteen, twenty, thirty, sixty;

  String get farsiLabel {
    switch (this) {
      case StudyTime.five:    return '۵ دقیقه در روز';
      case StudyTime.ten:     return '۱۰ دقیقه در روز';
      case StudyTime.fifteen: return '۱۵ دقیقه در روز';
      case StudyTime.twenty:  return '۲۰ دقیقه در روز';
      case StudyTime.thirty:  return '۳۰ دقیقه در روز';
      case StudyTime.sixty:   return '۶۰ دقیقه در روز';
    }
  }

  int get minutes {
    switch (this) {
      case StudyTime.five:    return 5;
      case StudyTime.ten:     return 10;
      case StudyTime.fifteen: return 15;
      case StudyTime.twenty:  return 20;
      case StudyTime.thirty:  return 30;
      case StudyTime.sixty:   return 60;
    }
  }
}

enum StudyPeriod {
  earlyMorning, morning, afternoon, evening, night;

  String get farsiLabel {
    switch (this) {
      case StudyPeriod.earlyMorning: return 'صبح زود (۶–۸)';
      case StudyPeriod.morning:      return 'صبح (۸–۱۲)';
      case StudyPeriod.afternoon:    return 'بعدازظهر (۱۲–۱۷)';
      case StudyPeriod.evening:      return 'عصر (۱۷–۲۱)';
      case StudyPeriod.night:        return 'شب (۲۱–۲۴)';
    }
  }
}

enum CefrLevel {
  unknown, a1, a2, b1, b2, c1, c2;

  String get label {
    if (this == CefrLevel.unknown) return 'نامشخص';
    return name.toUpperCase();
  }

  String get farsiDescription {
    switch (this) {
      case CefrLevel.unknown: return 'سطح مشخص نشده';
      case CefrLevel.a1:      return 'مبتدی کامل';
      case CefrLevel.a2:      return 'مبتدی پایه';
      case CefrLevel.b1:      return 'متوسط پایه';
      case CefrLevel.b2:      return 'متوسط بالا';
      case CefrLevel.c1:      return 'پیشرفته';
      case CefrLevel.c2:      return 'تسلط کامل';
    }
  }

  static CefrLevel fromString(String s) {
    switch (s.toLowerCase()) {
      case 'a1': return CefrLevel.a1;
      case 'a2': return CefrLevel.a2;
      case 'b1': return CefrLevel.b1;
      case 'b2': return CefrLevel.b2;
      case 'c1': return CefrLevel.c1;
      case 'c2': return CefrLevel.c2;
      default:   return CefrLevel.unknown;
    }
  }
}

// ─── UserModel ─────────────────────────────────────────────────────────────

class UserModel {
  final String id;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? contact;
  final String? contactType;
  final LearningGoal? goal;
  final EngLevel? selfAssessedLevel;
  final StudyTime? dailyStudyTime;
  final StudyPeriod? preferredStudyTime;
  final CefrLevel cefrLevel;
  final int xp;
  final int coins;
  final int streak;
  final int longestStreak;
  final DateTime? lastStudyDate;
  final bool onboardingComplete;
  final bool placementTestComplete;
  final Map<String, int> skillScores;
  final List<String> completedLessonIds;
  /// Local calendar dates (yyyy-MM-dd) on which the learner completed a lesson.
  final List<String> studyDateKeys;
  final Map<String, String> vocabularyReviewDueDates;
  final Map<String, int> vocabularyReviewIntervals;
  final Map<String, int> vocabularyReviewRepetitions;
  final Map<String, int> vocabularyReviewMistakes;
  /// Serialized FSRS-6 card state, keyed by normalized vocabulary term.
  final Map<String, Map<String, dynamic>> vocabularyFsrsCards;
  /// Append-only review evidence, capped by the provider to protect local storage.
  final List<Map<String, dynamic>> vocabularyReviewHistory;
  final String avatarEmoji;
  final List<String> unlockedAvatarEmojis;
  final bool avatarShopPromptShown;
  final int curriculumVersion;
  final bool notificationsEnabled;
  final bool isDarkMode;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.contact,
    this.contactType,
    this.goal,
    this.selfAssessedLevel,
    this.dailyStudyTime,
    this.preferredStudyTime,
    this.cefrLevel = CefrLevel.unknown,
    this.xp = 0,
    this.coins = 0,
    this.streak = 0,
    this.longestStreak = 0,
    this.lastStudyDate,
    this.onboardingComplete = false,
    this.placementTestComplete = false,
    this.skillScores = const {},
    this.completedLessonIds = const [],
    this.studyDateKeys = const [],
    this.vocabularyReviewDueDates = const {},
    this.vocabularyReviewIntervals = const {},
    this.vocabularyReviewRepetitions = const {},
    this.vocabularyReviewMistakes = const {},
    this.vocabularyFsrsCards = const {},
    this.vocabularyReviewHistory = const [],
    this.avatarEmoji = '🦊',
    this.unlockedAvatarEmojis = const ['🦊'],
    this.avatarShopPromptShown = false,
    this.curriculumVersion = 2,
    this.notificationsEnabled = true,
    this.isDarkMode = false,
    required this.createdAt,
  });

  // ── Computed ──────────────────────────────────────────────────────
  int get level => (xp / 500).floor() + 1;
  int get xpInCurrentLevel => xp % 500;
  double get levelProgress => xpInCurrentLevel / 500.0;

  // ── CopyWith ──────────────────────────────────────────────────────
  UserModel copyWith({
    String? id,
    String? name,
    String? firstName,
    String? lastName,
    String? contact,
    String? contactType,
    LearningGoal? goal,
    EngLevel? selfAssessedLevel,
    StudyTime? dailyStudyTime,
    StudyPeriod? preferredStudyTime,
    CefrLevel? cefrLevel,
    int? xp,
    int? coins,
    int? streak,
    int? longestStreak,
    DateTime? lastStudyDate,
    bool clearLastStudyDate = false,
    bool? onboardingComplete,
    bool? placementTestComplete,
    Map<String, int>? skillScores,
    List<String>? completedLessonIds,
    List<String>? studyDateKeys,
    Map<String, String>? vocabularyReviewDueDates,
    Map<String, int>? vocabularyReviewIntervals,
    Map<String, int>? vocabularyReviewRepetitions,
    Map<String, int>? vocabularyReviewMistakes,
    Map<String, Map<String, dynamic>>? vocabularyFsrsCards,
    List<Map<String, dynamic>>? vocabularyReviewHistory,
    String? avatarEmoji,
    List<String>? unlockedAvatarEmojis,
    bool? avatarShopPromptShown,
    int? curriculumVersion,
    bool? notificationsEnabled,
    bool? isDarkMode,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      contact: contact ?? this.contact,
      contactType: contactType ?? this.contactType,
      goal: goal ?? this.goal,
      selfAssessedLevel: selfAssessedLevel ?? this.selfAssessedLevel,
      dailyStudyTime: dailyStudyTime ?? this.dailyStudyTime,
      preferredStudyTime: preferredStudyTime ?? this.preferredStudyTime,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      streak: streak ?? this.streak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastStudyDate: clearLastStudyDate ? null : (lastStudyDate ?? this.lastStudyDate),
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      placementTestComplete: placementTestComplete ?? this.placementTestComplete,
      skillScores: skillScores ?? this.skillScores,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      studyDateKeys: studyDateKeys ?? this.studyDateKeys,
      vocabularyReviewDueDates: vocabularyReviewDueDates ?? this.vocabularyReviewDueDates,
      vocabularyReviewIntervals: vocabularyReviewIntervals ?? this.vocabularyReviewIntervals,
      vocabularyReviewRepetitions: vocabularyReviewRepetitions ?? this.vocabularyReviewRepetitions,
      vocabularyReviewMistakes: vocabularyReviewMistakes ?? this.vocabularyReviewMistakes,
      vocabularyFsrsCards: vocabularyFsrsCards ?? this.vocabularyFsrsCards,
      vocabularyReviewHistory: vocabularyReviewHistory ?? this.vocabularyReviewHistory,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      unlockedAvatarEmojis: unlockedAvatarEmojis ?? this.unlockedAvatarEmojis,
      avatarShopPromptShown: avatarShopPromptShown ?? this.avatarShopPromptShown,
      curriculumVersion: curriculumVersion ?? this.curriculumVersion,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ── JSON ─────────────────────────────────────────────────────────
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'firstName': firstName,
    'lastName': lastName,
    'contact': contact,
    'contactType': contactType,
    'goal': goal?.name,
    'selfAssessedLevel': selfAssessedLevel?.name,
    'dailyStudyTime': dailyStudyTime?.name,
    'preferredStudyTime': preferredStudyTime?.name,
    'cefrLevel': cefrLevel.name,
    'xp': xp,
    'coins': coins,
    'streak': streak,
    'longestStreak': longestStreak,
    'lastStudyDate': lastStudyDate?.toIso8601String(),
    'onboardingComplete': onboardingComplete,
    'placementTestComplete': placementTestComplete,
    'skillScores': skillScores,
    'completedLessonIds': completedLessonIds,
    'studyDateKeys': studyDateKeys,
    'vocabularyReviewDueDates': vocabularyReviewDueDates,
    'vocabularyReviewIntervals': vocabularyReviewIntervals,
    'vocabularyReviewRepetitions': vocabularyReviewRepetitions,
    'vocabularyReviewMistakes': vocabularyReviewMistakes,
    'vocabularyFsrsCards': vocabularyFsrsCards,
    'vocabularyReviewHistory': vocabularyReviewHistory,
    'avatarEmoji': avatarEmoji,
    'unlockedAvatarEmojis': unlockedAvatarEmojis,
    'avatarShopPromptShown': avatarShopPromptShown,
    'curriculumVersion': curriculumVersion,
    'notificationsEnabled': notificationsEnabled,
    'isDarkMode': isDarkMode,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: j['id'] ?? '',
    name: j['name'],
    firstName: j['firstName'],
    lastName: j['lastName'],
    contact: j['contact'],
    contactType: j['contactType'],
    goal: j['goal'] != null
        ? LearningGoal.values.firstWhere((e) => e.name == j['goal'],
            orElse: () => LearningGoal.general)
        : null,
    selfAssessedLevel: j['selfAssessedLevel'] != null
        ? EngLevel.values.firstWhere((e) => e.name == j['selfAssessedLevel'],
            orElse: () => EngLevel.beginner)
        : null,
    dailyStudyTime: j['dailyStudyTime'] != null
        ? StudyTime.values.firstWhere((e) => e.name == j['dailyStudyTime'],
            orElse: () => StudyTime.ten)
        : null,
    preferredStudyTime: j['preferredStudyTime'] != null
        ? StudyPeriod.values.firstWhere((e) => e.name == j['preferredStudyTime'],
            orElse: () => StudyPeriod.evening)
        : null,
    cefrLevel: CefrLevel.fromString(j['cefrLevel'] ?? 'unknown'),
    xp: j['xp'] ?? 0,
    coins: j['coins'] ?? 0,
    streak: j['streak'] ?? 0,
    longestStreak: j['longestStreak'] ?? 0,
    lastStudyDate: j['lastStudyDate'] != null
        ? DateTime.tryParse(j['lastStudyDate'])
        : null,
    onboardingComplete: j['onboardingComplete'] ?? false,
    placementTestComplete: j['placementTestComplete'] ?? false,
    skillScores: Map<String, int>.from(j['skillScores'] ?? {}),
    completedLessonIds: List<String>.from(j['completedLessonIds'] ?? []),
    studyDateKeys: List<String>.from(j['studyDateKeys'] ?? []),
    vocabularyReviewDueDates: Map<String, String>.from(j['vocabularyReviewDueDates'] ?? {}),
    vocabularyReviewIntervals: Map<String, int>.from(j['vocabularyReviewIntervals'] ?? {}),
    vocabularyReviewRepetitions: Map<String, int>.from(j['vocabularyReviewRepetitions'] ?? {}),
    vocabularyReviewMistakes: Map<String, int>.from(j['vocabularyReviewMistakes'] ?? {}),
    vocabularyFsrsCards: Map<String, Map<String, dynamic>>.from(
      (j['vocabularyFsrsCards'] as Map? ?? {}).map((key, value) => MapEntry(
        key.toString(), Map<String, dynamic>.from(value as Map),
      )),
    ),
    vocabularyReviewHistory: (j['vocabularyReviewHistory'] as List? ?? const [])
        .whereType<Map>()
        .map((entry) => Map<String, dynamic>.from(entry))
        .toList(),
    avatarEmoji: j['avatarEmoji'] ?? '🦊',
    unlockedAvatarEmojis: List<String>.from(j['unlockedAvatarEmojis'] ?? ['🦊']),
    avatarShopPromptShown: j['avatarShopPromptShown'] ?? false,
    curriculumVersion: j['curriculumVersion'] is int ? j['curriculumVersion'] as int : 0,
    notificationsEnabled: j['notificationsEnabled'] ?? true,
    isDarkMode: j['isDarkMode'] ?? false,
    createdAt: DateTime.tryParse(j['createdAt'] ?? '') ?? DateTime.now(),
  );
}
