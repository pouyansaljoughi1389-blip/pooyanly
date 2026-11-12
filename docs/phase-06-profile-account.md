# Phase 06 — Profile and Local Account

## Scope
Improve the learner profile and account-management experience. This phase covers local account identity, editable personal details, learning preferences, progress visibility, assessment history, avatar selection, and safe progress reset.

## Implemented
- Added profile editing for first name, last name, and email/phone contact with validation.
- Persisted profile edits through the existing `UserProvider.updateUser` and `StorageService` path.
- Clearly labels the current account as local/device-stored. Registration and profile editing do not claim email/SMS verification or cloud authentication.
- Added account information to the profile: display name, contact method, account storage type, and profile creation date.
- Retained the avatar shop and wired its selection/unlock behavior to the existing persisted user state.
- Expanded profile presentation of XP, coins, current and longest streak, completed lessons, level, learning goal, self-assessed level, daily study time, preferred study time, skill scores, and saved assessment history.
- Reworked the destructive progress-reset behavior: it now preserves the local account identity, contact details, avatar, and preferences while clearing learning progress, XP, coins, streaks, vocabulary review state, assessment results, and mission state.
- Added an explicit `clearLastStudyDate` option to `UserModel.copyWith` so progress reset can reliably clear a nullable study date.
- Hardened registration persistence error handling so a failed local save does not leave the registration screen permanently busy.
- Added tests for empty profile state, idempotent provider initialization, account edit persistence, and progress reset preservation.

## Data and security boundaries
- User data remains stored locally with SharedPreferences-backed JSON. This is not a cloud account system.
- Contact values are editable profile metadata only. There is no OTP, email verification, password, remote identity provider, or account recovery in this phase.
- The app does not expose a fake sign-out action while no authenticated session exists.
- Progress reset is distinct from account deletion and is explicitly described before confirmation.

## Validation
- GitHub Actions analysis, test suite, release APK, and Android emulator smoke validation are required on the final phase head.
- Light/dark and narrow-screen visual review remains part of acceptance.
- CI from the previous dashboard head was still running tests before this phase's commits; subsequent commits supersede that run. The new CI run must be used for acceptance.

## Status
Implementation and regression tests are committed to the feature branch. **Phase 06 is not complete until current-head CI, release APK, emulator smoke, and visual acceptance pass.** No merge to `main` is authorized or performed.
