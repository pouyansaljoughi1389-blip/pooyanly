## Phase 07 — Rewards & Game Economy

### Scope
Harden the existing XP/coin economy and replace the streak calendar's inferred activity with persisted study-day evidence.

### Implemented
- Persist unique local study dates in yyyy-MM-dd format in the user model, with backward-compatible JSON loading for existing installs.
- Record a study date only when a lesson is completed for the first time; multiple lessons on one date produce one calendar day.
- Render the last seven calendar days from actual saved study dates. The calendar no longer infers activity from the current streak count.
- Clear study-date history when the learner explicitly resets learning progress.
- Reject non-positive XP and coin grants through the provider's public grant methods.
- Add regression tests for date deduplication, persistence, and negative reward grants.

### Existing economy retained
- Daily and weekly missions remain claim-once and progress-gated.
- Lesson completion remains idempotent and grants its configured XP/coins once.
- Avatar purchases remain restricted to the known catalog and require sufficient coins.
- Offline league labels remain local progression tiers, not a real competitive leaderboard.

### Validation status
This phase is not considered complete until Flutter analysis, the full test suite, release APK build, and emulator smoke test pass in GitHub Actions. The app currently uses local SharedPreferences; balances and rewards are device-local and are not server-verified or synced across devices.
