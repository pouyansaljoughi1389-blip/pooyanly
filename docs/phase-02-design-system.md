# POUYANLY — Phase 02 Design System and Visual Identity Foundation

**Date:** 2026-11-12  
**Branch:** `feature/pouyanly-full-development`  
**App root:** `pouyanly 2/`  
**Scope:** Shared design tokens and Material 3 theme foundation. This phase does not claim a full screen-by-screen visual redesign.

## 1. Baseline findings

The Phase 01 audit found that the app already had a Material 3 theme, a Vazirmatn font family, centralized brand colors and a small spacing/radius/motion token file. The main design-system weaknesses were duplicated neutral colors between `AppColors` and `AppTheme`, incomplete typography role overrides, and an underspecified token scale that left screens free to invent local dimensions.

## 2. Changes delivered

### Canonical theme surface roles
- Added explicit light/dark roles for scaffold background, surface, card, primary foreground, secondary foreground and outline in `AppColors`.
- Updated `AppTheme` to consume those roles instead of repeating independent color literals.
- Kept the existing brand, semantic, CEFR and gamification palettes intact to avoid changing product meaning during foundation work.

### Expanded design tokens
- Extended the 4 px spacing scale through 64 px.
- Added extra-small and extra-large corner radii.
- Added shared minimum touch target (48 px), icon size scale and content max width.
- Added named elevation levels.
- Kept blur and motion tokens bounded; static UI remains the default and glass stays reserved for navigation/transient controls.

### Typography and component defaults
- Completed explicit Vazirmatn styling for headline, title, body and label roles, including previously under-specified small/medium roles.
- Standardized Material button minimum sizes on the shared 48 px touch-target token.
- Added consistent tooltip and scrollbar theme defaults.
- Preserved solid content surfaces; no additional blur was introduced behind lesson text, definitions or assessment content.

### Regression coverage
- Added `test/core/theme/design_system_contract_test.dart` to verify light/dark theme setup, typography font-family coverage, minimum interactive target size and distinct theme surfaces.
- Retained the existing light-theme contrast tests; they remain part of the test suite.

## 3. Files changed

- `lib/core/theme/app_colors.dart`
- `lib/core/theme/app_design_tokens.dart`
- `lib/core/theme/app_theme.dart`
- `test/core/theme/design_system_contract_test.dart`

## 4. Validation status

- Static source review completed for all modified theme files.
- Automated Flutter analysis and tests have **not** been executed in a local Flutter runtime during this GitHub-only editing pass.
- A successful CI run, Android build, emulator screenshots and visual review are therefore **not claimed**.
- CI must validate the new test and all existing tests before Phase 02 can be marked complete.

## 5. Acceptance checklist

- [x] One canonical set of light/dark surface roles feeds the app theme.
- [x] Shared spacing, radius, touch-target, icon, elevation and motion tokens are defined.
- [x] Material 3 typography roles consistently use Vazirmatn.
- [x] Shared Material controls have a minimum 48 px target.
- [x] No new glass blur was added to reading or assessment content.
- [x] Theme contract regression tests added.
- [ ] Flutter analyze passes on the updated branch.
- [ ] Full Flutter test suite passes on the updated branch.
- [ ] Release build and emulator/device visual review pass.
- [ ] Representative screens are checked in both themes and on narrow/large layouts.

**Phase 02 status: implementation foundation committed; CI and visual acceptance pending.**

## 6. Safety

All changes are confined to `feature/pouyanly-full-development`. PR #2 remains draft/unmerged. No changes to `main`, merge, or release were performed.
