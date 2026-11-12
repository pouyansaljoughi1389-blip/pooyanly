## Phase 08 — CEFR Learning Path

### Scope
Make the learning path follow the canonical A1→A2→B1→B2→C1→C2 curriculum order, expose progress by CEFR level, and enforce lesson/unit/checkpoint prerequisites in both UI and persistence logic.

### Implemented
- Preserve canonical CEFR order. Learning goals now mark relevant units but never reorder prerequisite units.
- Add per-level progress sections with completed/total lesson counts and progress indicators.
- Centralize sequential lesson and unit unlock rules in `LearningPathPolicy`.
- Enforce the next-lesson rule in `completeLesson` and `skipLesson`, including calls made through deep links.
- Require all lessons and the previous unit checkpoint before completing a checkpoint or unlocking the next unit.
- Add regression tests for six-level coverage, canonical order, lesson sequencing, and checkpoint gates.
- Update existing gamification tests to complete real curriculum lesson IDs.
- Fix the escaped Dart interpolation in the Phase 7 study calendar discovered by CI.

### Curriculum coverage note
The current local curriculum is approximately 133 lessons across A1–C2. The longer-term target of 233 lessons is not reached by this phase; this phase improves path structure and progression integrity, not the size or academic validation of the content library.

### Validation status
Do not consider this phase complete until Flutter analysis, the full test suite, release APK build, and emulator smoke tests pass in GitHub Actions. Progress and curriculum remain device-local; no remote curriculum versioning or cross-device sync is introduced here.
