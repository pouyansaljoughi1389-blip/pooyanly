# Phase 09 — Lesson experience

## Scope
- Guard direct lesson routes with the same sequential CEFR prerequisite policy used by the learning path.
- Make lesson completion report whether progress was actually persisted; the result screen must not claim a pass or XP reward when persistence rejects it.
- Randomize answer presentation per lesson/exercise while retaining a stable retry order and the original answer key.
- Handle lessons with missing or malformed exercise content without dividing by zero or recording completion.
- Preserve Persian RTL content and LTR English prompts.

## Implementation
- Added `LessonOptionOrder` as a deterministic, per-exercise option permutation.
- Updated `LessonScreen` to block locked lessons, guard unusable exercise lists, and distinguish score success from persisted completion.
- Changed `UserProvider.completeLesson` to return a boolean: false for invalid/out-of-order completion, true for an already completed lesson or a newly persisted completion.
- Repeated completed lessons do not grant duplicate XP.

## Tests
- `test/features/lessons/lesson_option_order_test.dart` checks answer-key preservation, option integrity, retry stability, and answer-position distribution.
- CI analysis, complete test suite, release APK and emulator validation are pending. This phase is not complete until those checks pass.
