# POUYANLY — Liquid Glass UI/UX Audit

## Scope and baseline

Audited the Flutter project under `pouyanly 2/` on
`feature/pouyanly-full-development`. The app uses Flutter Material 3,
Provider, GoRouter, SharedPreferences, a Persian Vazirmatn font and a
central `AppTheme`. Navigation is declared in `lib/main.dart`.

The application has 18 screen entry points:

- Onboarding: splash, welcome, account, onboarding.
- Assessment: placement test and placement result.
- Learning: home/dashboard, learning path, checkpoint, lesson, vocabulary,
  listening and tutor.
- Retention and account: rewards, profile, settings.
- Supporting pages: community and about.

## Findings

1. A centralized light/dark theme already existed, but several widgets
   overrode it with hard-coded colors, gradients and shadows.
2. The old `LiquidGlass` widget applied a 22px blur to every instance and
   added drag gestures to a tappable surface. That behavior was unnecessary
   for controls and could interfere with scrolling and touch feedback.
3. The learning-path screen contained separate blur implementations with
   sigma values of 14, 18 and 42. These were redundant and expensive on
   mid-range Android devices.
4. Buttons and the XP bar duplicated styling and used fixed light-theme colors.
5. Navigation icons used a basic icon-only treatment while game icons had a
   separate custom visual language.
6. Long-form educational copy and question/answer content should not receive
   glass backgrounds. Their contrast and scanability are more important than
   decorative depth.
7. Android uses Flutter's SDK-provided minimum/target SDK values. No iOS-only
   framework or platform API is required for this redesign.

## Surface decisions

| Area | Treatment |
|---|---|
| Bottom navigation | One bounded translucent glass surface; restrained blur |
| Settings action groups | Translucent surface without blur |
| Learning-path header chips/panels | Shared translucent surface without blur |
| Lesson passages and explanations | Plain content surface |
| Vocabulary definitions and examples | Plain content surface |
| Quiz questions and answer choices | Solid, high-contrast interactive surfaces |
| Tutor conversation | Plain message hierarchy; solid composer |
| Dashboard metrics and rewards | Solid cards; selective glass only for controls |
| Profile and account forms | Solid surfaces and standard Material inputs |
| App bars, menus and dialogs | Material 3 themed surfaces |
| Onboarding hero areas | Brand gradients may remain; no blur over text |

## Implementation sequence

1. **Foundation:** centralize spacing, radii, blur limits and motion; rebuild
   light/dark Material 3 themes; make glass optional and bounded; unify buttons,
   XP progress and vector icon treatment.
2. **Navigation and learning map:** migrate the bottom navigation and remove
   custom blur stacks from the learning path.
3. **Core learning:** refine lesson, checkpoint, vocabulary and listening
   layouts while keeping reading and answer surfaces solid.
4. **Dashboard and retention:** refine home, rewards and profile metrics.
5. **Tutor and account flows:** refine tutor message hierarchy, onboarding,
   placement, settings, about and community pages.
6. **Validation:** run formatter, analyzer, all tests, debug/release APK builds,
   then launch on an Android emulator and inspect screenshots and interaction
   states. Fix every discovered issue before considering merge to `main`.

## Implemented in the first foundation pass

- Added `AppDesignTokens` for spacing, radius, blur and motion constants.
- Rebuilt `AppTheme` around Material 3 color schemes for light and dark mode.
- Rebuilt `LiquidGlass`: blur is opt-in, drag gestures are removed, tap
  feedback is Material-native, and the default surface does not blur.
- Limited the navigation bar to one 12px blur layer.
- Replaced the learning-path blur stack with shared non-blurred glass surfaces
  and a gradient orb treatment.
- Added `PremiumIcon` and applied it to primary navigation and shared buttons.
- Migrated `PButton` to themed Material 3 button primitives.
- Made `XPBar` theme-aware, clamped and accessible, with Persian numerals.
- Added widget tests for glass blur bounds, tap behavior and navigation.

## Validation status

Not yet validated by a Flutter SDK or Android emulator in this execution
environment. No analyzer, test, APK, device-launch or screenshot result is
claimed here. The repository's GitHub Actions workflow is configured to run
Flutter 3.41.9 analysis, tests and a release APK build on feature-branch pushes.
