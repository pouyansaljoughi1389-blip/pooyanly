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


## Four-phase completion plan (expanded acceptance checklist)

### Phase 1 — Dashboard, rewards and profile
- [ ] Dashboard: hierarchy, daily goal, XP/level progress, streak, coins, next lesson, review entry points and quick navigation.
- [ ] Rewards: daily/weekly mission progress, claim states, achievements, offline league, streak calendar, avatar unlock costs and selected state.
- [ ] Profile: persisted identity, CEFR band, study goal/time, assessment scores, XP, streak, completed lessons, avatar shop and settings shortcuts.
- [ ] All counters must be sourced from persisted provider state; no placeholder or fabricated statistics.
- [ ] Empty, loading, error and signed-out states must be visible and recoverable; no blank `SizedBox.shrink()` for a required route.
- [ ] Verify tab retention, state refresh after returning from lesson/settings, and no duplicate reward claims.

### Phase 2 — Lesson, assessment, dictionary and listening
- [ ] Lesson: readable vocabulary/passage layout, audio controls, answer selection, feedback, progress, retry and completion states.
- [ ] Preserve strict lesson gating: minimum pass score required, zero score never advances, and skip remains an explicit XP-cost action.
- [ ] Assessment: question clarity, progress indicator, answer randomization, score calculation, skill breakdown and result navigation.
- [ ] Dictionary: search, filters, Persian meaning, English definition, IPA, examples, collocations, synonyms/antonyms, CEFR and topic metadata.
- [ ] Review: due-date handling, repetition/interval persistence, mistake tracking and no mutation of source lesson vocabulary.
- [ ] Listening: playable audio state, replay/seek behavior where supported, transcript/task hierarchy, answer feedback and completion state.
- [ ] Keep educational passages, definitions, transcripts and answer explanations on calm solid surfaces; do not place blur behind learning text.

### Phase 3 — Tutor, registration, settings and supporting pages
- [ ] Tutor: clear conversation hierarchy, empty/loading/error/offline states, accessible composer, send/retry behavior and truthful capability labels.
- [ ] AI boundary: no provider API key in Flutter assets or source; network AI must go through a secure backend. Clearly distinguish local rules from real AI responses.
- [ ] Registration: first/last name, email or phone validation, keyboard/input types, field errors, focus order, persistence and returning-user flow.
- [ ] Onboarding: goal, self-assessed level, daily study time and preferred time persist and influence the learning route.
- [ ] Settings: light/dark mode, reminder enable/time/days, widget guidance, placement retake, learning goal edit and destructive reset confirmation.
- [ ] Supporting pages: about/creator details, community preview, checkpoint and placement-result screens must have working navigation and no dead-end controls.
- [ ] Verify every visible button, menu item, switch, sheet and dialog has a real action or is explicitly disabled with an explanation.

### Phase 4 — RTL, responsive layout, accessibility, performance and release validation
- [ ] RTL: directionality, start/end alignment, icon direction, back navigation, mixed Persian/English strings, punctuation and Persian digit formatting.
- [ ] Responsive: narrow Android phones, standard phones, large phones/tablets, landscape, safe areas, keyboard insets and scroll overflow.
- [ ] Typography: font fallback, line height, dynamic text scaling, truncation/wrapping and minimum touch target sizes.
- [ ] Contrast: check normal text against its actual surface (WCAG AA target 4.5:1), large text (3:1), icons/focus states and both light/dark themes.
- [ ] Motion: respect reduced-motion preference where available; avoid unnecessary infinite animation, layout shifts and repeated blur.
- [ ] Performance: inspect raster/blur cost, rebuild scope, list virtualization, image sizing, memory and frame pacing on a low-end Android profile.
- [ ] Quality gates: format, `flutter analyze`, complete `flutter test`, Android debug APK and release APK.
- [ ] Device validation: install and launch the exact release/debug artifact on an Android emulator, exercise primary flows, capture dated screenshots and record emulator/API/device details.
- [ ] No emulator launch, screenshot, or physical-device result is claimed until it has actually been performed and recorded.

## Newly confirmed defects and fixes in the current pass

1. **Persisted user was never hydrated at application startup.** `main.dart` initialized SharedPreferences but created `UserProvider()` without awaiting `UserProvider.init()`. The profile/dashboard/rewards widgets could therefore receive `user == null` after a cold launch. Startup now awaits provider hydration before `runApp`.
2. **Blank account-dependent tabs.** Profile, dashboard and rewards previously returned an empty `SizedBox.shrink()` when no user was present. They now show a visible recovery state with a route back to the welcome flow.
3. **Insufficient white-text contrast on brand gradients.** Several old gradient stops (including pale lavender and mint) were used behind white labels. Primary, success, hero and warm gradient stops have been darkened; semantic foreground colors and CEFR colors have also been adjusted toward WCAG AA contrast.

## Latest CI evidence

- Workflow run: [Build Android APK #43271697468](https://github.com/pouyansaljoughi1389-blip/pooyanly/actions/runs/43271697468)
- Flutter analysis: passed.
- Flutter tests: passed.
- Android release APK build: passed.
- APK artifact upload: passed.
- This run predates the latest startup, recovery-state and contrast commits. Those changes require a fresh CI run.
- No Android emulator launch or screenshot capture has yet been verified in this work session.
