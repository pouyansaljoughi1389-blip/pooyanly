POUYANLY — FREE MODEL EXECUTION PROTOCOL

You are operating under limited model context, reasoning and execution capacity.

You must optimize your workflow for reliability, accuracy and minimal context consumption.

The objective is NOT to complete as many tasks as possible in one response.

The objective is to complete each task correctly, verify it and preserve enough documentation for the next session.

RULE 1 — NEVER IMPLEMENT THE ENTIRE ROADMAP AT ONCE

Never attempt to implement all 24 phases in one execution.

Work on exactly ONE phase at a time.

A phase may contain multiple small sub-tasks.

Complete and verify those sub-tasks before proceeding.

RULE 2 — INSPECT BEFORE EDITING

Before modifying code:

1. Inspect the relevant files.
2. Understand their dependencies.
3. Identify existing implementations.
4. Identify potential regressions.
5. Determine the smallest safe modification.
6. Record the intended changes.

Never rewrite an entire file when a targeted modification is sufficient.

Never replace existing working functionality without understanding it.

RULE 3 — USE SMALL, CONTROLLED TASKS

Break each phase into small implementation units.

For example:

Phase 10:

- Task 10.1: Audit dictionary models.
- Task 10.2: Audit vocabulary storage.
- Task 10.3: Fix duplicate detection.
- Task 10.4: Improve search.
- Task 10.5: Improve vocabulary details.
- Task 10.6: Add validation.
- Task 10.7: Test all dictionary workflows.

Do not combine unrelated tasks into one massive implementation.

RULE 4 — PRESERVE PROJECT CONTEXT

Maintain these project documents:

1. PROJECT_OVERVIEW.md
2. MASTER_ROADMAP.md
3. CURRENT_STATUS.md
4. ARCHITECTURE.md
5. DECISIONS.md
6. BUGS_AND_ISSUES.md
7. TEST_REPORT.md
8. CHANGELOG.md

Update the relevant documents after completing work.

CURRENT_STATUS.md must always contain:

- Current phase.
- Current sub-task.
- Completed work.
- Remaining work.
- Modified files.
- Known bugs.
- Test results.
- Build status.
- Next exact task.

These documents are essential for continuing work in future Free model sessions.

RULE 5 — NEVER ASSUME A TASK IS COMPLETE

A task is complete only when:

- Its implementation exists.
- The implementation is connected to the actual application.
- Its expected behavior is verified.
- Relevant tests pass.
- Existing functionality remains intact.
- Documentation is updated.

A successful code edit is not equivalent to a successful feature.

A successful build is not equivalent to a fully tested application.

RULE 6 — CONTROL CONTEXT CONSUMPTION

Prefer:

- Focused file inspection.
- Small diffs.
- Targeted tests.
- Short technical reports.
- Incremental implementation.
- Persistent project documentation.

Avoid:

- Repeatedly printing entire source files.
- Repeating the entire roadmap.
- Rewriting already completed documentation.
- Re-analyzing unrelated modules.
- Generating enormous explanations.
- Implementing multiple unrelated phases together.

Read only the files necessary for the current task, unless dependencies require broader inspection.

RULE 7 — ERROR HANDLING

If an error occurs:

1. Stop the current implementation.
2. Read the complete error message.
3. Identify the actual root cause.
4. Inspect the relevant source.
5. Fix the smallest responsible component.
6. Run the relevant test again.
7. Verify that the fix did not introduce regressions.

Never hide errors.

Never claim success when tests have failed.

RULE 8 — TESTING

After each meaningful change:

- Run dart format on modified Dart files.
- Run flutter analyze.
- Run relevant unit tests.
- Run relevant widget tests.
- Run integration tests when appropriate.
- Build Android APK at meaningful milestones.

Do not claim that an emulator test was performed unless an emulator was actually available and used.

RULE 9 — FILE AND GIT SAFETY

Repository:
POUYANLY

Project directory:
pouyanly 2/

Inspect the actual repository structure before assuming paths.

Do not delete important files.

Do not overwrite user work.

Do not modify unrelated modules.

Do not commit, merge or push changes without explicit authorization.

Always explain potentially destructive operations before performing them.

RULE 10 — PHASE COMPLETION REPORT

At the end of each phase, provide:

1. Phase number and name.
2. Original problems.
3. Changes implemented.
4. Files modified.
5. Tests executed.
6. Test results.
7. Remaining issues.
8. Build status.
9. Documentation updated.
10. Exact next phase and task.

Use three statuses:

- COMPLETE: all acceptance criteria passed.
- PARTIAL: some tasks completed, others remain.
- BLOCKED: progress requires resolving a dependency or external issue.

Never label PARTIAL or BLOCKED work as COMPLETE.

RULE 11 — NO FABRICATED RESULTS

Never invent:

- Test results.
- Build results.
- Repository changes.
- File contents.
- API responses.
- Dictionary data.
- Educational sources.
- Performance measurements.

If something cannot be verified, explicitly state that it remains unverified.

RULE 12 — OPTIMIZE FOR FREE MODEL RELIABILITY

Use a checkpoint-driven workflow.

At the beginning of a new session:

1. Read CURRENT_STATUS.md.
2. Read the relevant roadmap section.
3. Inspect the current Git state.
4. Verify the actual project state.
5. Continue from the last verified task.

Do not trust old conversation summaries over the actual source code.

If context is insufficient, inspect the necessary files instead of guessing.

FINAL EXECUTION PRINCIPLE

Precision over speed.

Verified implementation over large code output.

Small reliable changes over uncontrolled rewrites.

Educational quality over superficial gamification.

Real functionality over visual placeholders.

A stable product over premature feature expansion.
