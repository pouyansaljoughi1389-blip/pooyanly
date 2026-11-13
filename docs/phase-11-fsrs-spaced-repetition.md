# Phase 11 — FSRS-6 Intelligent Spaced Repetition

## Scope
Replace the legacy fixed-interval vocabulary review scheduler with the FSRS-6 algorithm while preserving existing learners' local data.

## Implementation in this checkpoint
- Added the MIT-licensed Dart `fsrs` 2.0.1 dependency (FSRS-6).
- Added an app adapter with four explicit recall grades: Again, Hard, Good and Easy.
- Persisted serialized FSRS card state per normalized vocabulary key.
- Persisted review-event evidence with a bounded 2,000-event local history.
- Used UTC timestamps at the scheduler boundary and retained exact due instants, including short learning/relearning steps.
- Preserved legacy due dates for un-migrated words. On first review, the existing due date is carried into a new Learning card; unknown historical stability/difficulty values are not fabricated.
- Kept legacy interval/repetition fields synchronized for backward compatibility.
- Changed the review UI to expose all four recall grades.
- Changed the retention statistic to mean FSRS-predicted retrievability across cards with learned stability; unreviewed cards are excluded.
- Added regression coverage for four ratings, mistake accounting, due-date migration, serialization, bounded history and legacy JSON compatibility.

## Data and migration policy
The old scheduler stored only a due date, interval and repetition count. Those values cannot reliably reconstruct FSRS stability and difficulty. Existing due dates are therefore retained until the first FSRS review; then the card enters FSRS Learning state. No fabricated memory parameters are assigned.

The FSRS review history is capped at the latest 2,000 events to bound SharedPreferences JSON growth. This remains device-local and is not synchronized between devices.

## Validation
Source-level patch checks were performed before commit. Flutter formatting, analyzer, full tests and Android release build must run in CI. This source-writing environment does not provide a local Flutter SDK/checkout, so no local test or APK success is claimed.

## Remaining acceptance work
- Confirm current-head CI passes, including the full Flutter test suite and release APK.
- Review the rendered four-grade review UI on narrow Android screens and both themes.
- Verify real-device behavior across timezone changes and app restarts.
- Decide whether review history should later move to SQLite as event volume grows.
- Complete remaining phase-11 integration and QA before marking the phase complete.
