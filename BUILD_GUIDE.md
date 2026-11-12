# POUYANLY — دستورالعمل ساخت پروژه

## ساختار پروژه

```
pouyanly/
├── lib/
│   ├── main.dart                          ← نقطه ورود اپ
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart            ← تمام رنگ‌ها و گرادیان‌ها
│   │   │   └── app_theme.dart             ← Light/Dark Theme
│   │   └── widgets/
│   │       ├── p_button.dart              ← دکمه اختصاصی
│   │       └── xp_bar.dart               ← نوار XP
│   ├── data/
│   │   ├── local/
│   │   │   └── storage_service.dart       ← SharedPreferences
│   │   └── models/
│   │       └── user_model.dart            ← مدل کاربر + enum‌ها
│   ├── shared/
│   │   └── providers/
│   │       └── user_provider.dart         ← State Management
│   └── features/
│       ├── onboarding/
│       │   └── screens/
│       │       ├── splash_screen.dart
│       │       ├── welcome_screen.dart
│       │       └── onboarding_screen.dart  ← ۴ مرحله Onboarding
│       ├── placement_test/
│       │   ├── models/
│       │   │   └── placement_question.dart ← سؤالات + الگوریتم محاسبه
│       │   └── screens/
│       │       ├── placement_test_screen.dart
│       │       └── placement_result_screen.dart
│       ├── home/
│       │   └── screens/
│       │       └── home_screen.dart        ← صفحه اصلی با BottomNav
│       ├── learning_path/
│       │   └── screens/
│       │       └── learning_path_screen.dart ← نقشه یادگیری
│       ├── lessons/
│       │   ├── models/
│       │   │   └── lesson_data.dart        ← محتوای آموزشی A1/A2
│       │   └── screens/
│       │       └── lesson_screen.dart      ← Flashcard + تمرین
│       ├── vocabulary/
│       │   └── screens/
│       │       └── vocabulary_screen.dart  ← لغت‌نامه + مرور SRS
│       ├── gamification/
│       │   └── screens/
│       │       └── rewards_screen.dart     ← جوایز + دستاوردها
│       └── profile/
│           └── screens/
│               └── profile_screen.dart    ← پروفایل + تنظیمات
└── pubspec.yaml
```

---

## مرحله ۱ — نصب پیش‌نیازها

### Flutter SDK

```bash
# دانلود Flutter (ویندوز)
# از https://docs.flutter.dev/get-started/install/windows دانلود کنید

# macOS
brew install flutter

# لینوکس
sudo snap install flutter --classic
```

### تأیید نصب:
```bash
flutter doctor
```

---

## مرحله ۲ — دانلود فونت Vazirmatn

فونت فارسی Vazirmatn را از این آدرس دانلود کنید:

```
https://github.com/rastikerdar/vazirmatn/releases/latest
```

فایل‌های موردنیاز را در مسیر زیر قرار دهید:

```
assets/fonts/
├── Vazirmatn-Regular.ttf
├── Vazirmatn-Medium.ttf
├── Vazirmatn-SemiBold.ttf
├── Vazirmatn-Bold.ttf
└── Vazirmatn-ExtraBold.ttf
```

---

## مرحله ۳ — نصب Dependencies

```bash
cd pouyanly
flutter pub get
```

---

## مرحله ۴ — اجرا در شبیه‌ساز

```bash
# لیست دستگاه‌های موجود
flutter devices

# اجرا در اندروید
flutter run -d android

# اجرا در iOS
flutter run -d ios
```

---

## مرحله ۵ — ساخت APK اندروید

```bash
# APK معمولی (برای نصب مستقیم)
flutter build apk --release

# APK به تفکیک معماری (حجم کمتر)
flutter build apk --split-per-abi --release
```

فایل APK در این مسیر قرار می‌گیرد:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## مرحله ۶ — ساخت AAB (Google Play)

```bash
flutter build appbundle --release
```

---

## نکات مهم

### Android SDK
برای ساخت APK باید Android SDK نصب باشد:
```bash
# نصب Android Studio از https://developer.android.com/studio
# سپس:
flutter doctor --android-licenses
```

### Keystore (امضای APK)
برای انتشار در Google Play، باید Keystore بسازید:
```bash
keytool -genkey -v -keystore ~/my-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias my-key-alias
```

سپس فایل `android/app/build.gradle` را برای امضا تنظیم کنید.

---

## قابلیت‌های پیاده‌سازی‌شده

| قابلیت | وضعیت |
|--------|--------|
| رابط فارسی RTL | ✅ کامل |
| Splash Screen انیمیشن | ✅ کامل |
| صفحه خوش‌آمدگویی | ✅ کامل |
| Onboarding ۴ مرحله‌ای | ✅ کامل |
| آزمون تعیین سطح | ✅ کامل |
| محاسبه CEFR تطبیقی | ✅ کامل |
| نتیجه آزمون + مهارت‌ها | ✅ کامل |
| صفحه اصلی با BottomNav | ✅ کامل |
| نقشه مسیر یادگیری | ✅ کامل |
| سیستم قفل درس‌ها | ✅ کامل |
| موتور درس (Flashcard+تمرین) | ✅ کامل |
| لغت‌نامه + جستجو | ✅ کامل |
| مرور SRS | ✅ ساختار اولیه |
| سیستم XP + Coins + Streak | ✅ کامل |
| ماموریت‌های روزانه | ✅ کامل |
| دستاوردها | ✅ کامل |
| پروفایل کاربر | ✅ کامل |
| Light/Dark Mode | ✅ کامل |
| ذخیره پیشرفت محلی | ✅ کامل |
| Design System کامل | ✅ کامل |
| محتوای A1 کامل | ✅ ۳ واحد، ۵ درس |
| محتوای A2 | ✅ ۲ واحد، ۲ درس |

## توسعه آینده

- اتصال Backend (Firebase یا REST API)
- هوش مصنوعی برای تصحیح تلفظ (ELSA-style)
- محتوای B1, B2, C1, C2
- Leaderboard آنلاین
- اشتراک Premium
- Push Notification واقعی
- محتوای صوتی (Text-to-Speech)
