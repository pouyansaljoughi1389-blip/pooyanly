# Phase 05 — Learner Dashboard

## Scope
Redesign the learner-facing Home tab as a useful daily learning hub while retaining the learning path as the app's primary navigation destination.

## Implemented
- Replaced the previous dense dashboard content with a clearer hierarchy: personalized greeting, daily XP goal, learner statistics, next lesson, quick practice actions, and current CEFR/XP progress.
- Daily XP progress reads the existing persisted daily mission state exposed by `UserProvider`; the displayed target is the same 50 XP target used by the provider's daily progress calculation.
- Streak, coins, total XP, completed lesson count, longest streak, and CEFR level are sourced from the current `UserModel`.
- Vocabulary review count is derived from saved due-date entries and the device's local calendar date. Invalid due-date entries are treated as due so they are not silently hidden.
- Added compact quick-entry cards for vocabulary review, listening practice, and the tutor route.
- Removed the community preview from the dashboard because it was promotional rather than a measurable learning action.
- Removed the hard-coded fallback from the learner's completed CEFR level to A2. The dashboard no longer suggests an unrelated A2 lesson when the selected level has no remaining lesson.
- Updated lesson and review surfaces to use semantic theme colors, and corrected Liquid Glass brightness selection to follow the active ColorScheme.

## Data integrity notes
- No dashboard statistic is generated from a fixed demo value.
- The 50 XP daily target is an existing product rule in `UserProvider`, not a claim that study time has been measured.
- The app does not yet persist actual study minutes, so the dashboard deliberately reports XP progress rather than inventing minutes studied.
- Review count only reflects words with persisted review due-date records; it is not presented as the total size of the vocabulary library.

## Validation
- GitHub Actions validation is required before this phase can be accepted.
- The previous Phase 04 workflow run (run 488) failed in tests: the Liquid Glass brightness assertion failed and the profile empty-state widget test timed out. The brightness source has been corrected to use `ColorScheme.brightness`; the profile test timeout remains an open validation issue until a subsequent run confirms it is resolved.
- Release APK generation and Android emulator smoke evidence must pass on the current phase head.
- Visual acceptance in both light and dark themes and on narrow Android layouts remains required.

## Status
Implementation is in place. **Phase 05 is not complete until the current branch passes analysis, all tests, release APK build, emulator smoke, and visual acceptance.**
