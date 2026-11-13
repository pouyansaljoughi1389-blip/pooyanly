# POUYANLY Light Mode Typography Audit — Initial Inventory and Repair

Branch: `feature/pouyanly-full-development`
Scope: Flutter sources under `pouyanly 2/`.

## Repository inventory

The current tree contains 18 routed/feature screen files:

1. Splash
2. Welcome
3. Onboarding
4. Account / local registration
5. Placement Test
6. Placement Result
7. Home
8. Learning Path
9. Checkpoint Exam
10. Lesson / Exercise
11. Listening
12. Vocabulary / Dictionary
13. AI Tutor
14. Community
15. Rewards / Missions / Achievements / Streak Calendar
16. Profile / Avatar Shop / Profile Editor
17. Settings
18. About

There is no separate Login, Speaking, Statistics, or standalone Quiz screen in the current Flutter source tree. The existing app has account creation/local profile continuation, placement/checkpoint assessments, home statistics, lesson exercises, and rewards-based mission/streak views. These absent screens cannot be visually audited as existing screens.

Shared surfaces/components inspected include AppTheme, AppColors, AppDesignTokens, AppSurface, LiquidGlass, PButton, XP bar, and user-required state. AppTheme is Material 3 and already sets Vazirmatn globally, but feature screens contain many local TextStyle overrides.

## Static findings (before repairs)

- The 18 screen files contain approximately 251 explicit TextStyle constructions. These are not all defects, but they fragment the typography system and require contextual review.
- Most local overrides repeat `fontFamily: 'Vazirmatn'` and hardcode sizes (roughly 9–42 logical pixels); several screens therefore bypass semantic TextTheme roles.
- Font assets include Thin, ExtraLight, Light, Regular, Medium, SemiBold, Bold, ExtraBold and Black. pubspec previously registered only Regular through ExtraBold, despite UI code using `FontWeight.w900`; Black was not mapped and the light weights were unavailable to Flutter's font resolver.
- Several gradient-backed screens used white70/white54 foreground labels. These alpha levels can fall below 4.5:1 for normal text on the actual brand gradients. The issue was present in Splash, Account, Lesson, Listening and Rewards.
- Existing contrast tests covered selected palette/gradient colors, but did not assert the complete semantic text pairs from the active Light ColorScheme, all TextTheme roles, disabled text, or large-text/narrow-width RTL rendering.
- The shared theme has global font family and semantic color roles. Dark Mode is generated separately from dark semantic tokens and must remain unchanged in appearance.

## Repairs in this pass

- Registered all bundled Vazirmatn weights (100, 200, 300, 400, 500, 600, 700, 800 and 900), including Black for the existing w900 headings.
- Replaced low-opacity white text on brand-gradient surfaces in Splash, Account, Lesson, Listening and Rewards with 92% white. This keeps the visual hierarchy while targeting at least 4.5:1 contrast on the lightest stop of the primary brand gradient.
- Set the theme's disabledColor to the semantic secondary text role instead of relying on the default low-contrast disabled color.
- Added a focused typography audit test for all 15 Material text roles, semantic foreground/background contrast pairs, interactive component font configuration, Dark Mode typography preservation, RTL, 320px width and 1.8x text scaling.

## Screen-by-screen static review status

All 18 listed screen source files were inspected for Text/TextStyle usage, font-family and font-size overrides, hardcoded colors, and alpha-based white labels. The highest override counts are Settings (33), Vocabulary (28), Lesson (27), Profile (23), and Learning Path (22). The Splash, Account, Lesson, Listening and Rewards gradient text cases listed above were changed.

A static source review is not a substitute for inspecting rendered pixels. No screen is marked as visually verified by this document.

## Contrast reference values

For the current Light semantic palette on white:
- foregroundLightRole `#211D32`: 16.32:1
- secondaryTextLightRole `#6D687C`: 5.36:1
- primary `#5B5FEF`: 4.85:1
- secondary `#08745D`: 5.73:1
- accent `#C43F4A`: 5.05:1
- success `#16834A`: 4.80:1
- warning `#9A5B00`: 5.43:1
- error `#B42318`: 6.57:1
- info `#1D5FA7`: 6.47:1

These values are mathematical palette checks against pure white, not proof of every widget's actual rendered background. The new widget-level semantic test checks the active ColorScheme roles.

## Visual QA still required

The repository workflow currently provides analyzer, tests and APK build/upload. It does not run Android emulators, capture screenshots, or perform pixel-based review. Therefore screenshots at small/standard/large device sizes and normal/increased text scale remain an explicit release gate. Do not describe the typography audit as fully complete until that visual QA is performed.
