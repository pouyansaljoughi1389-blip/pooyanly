# POUYANLY — Phase 03 Custom Icon Family

**Date:** 2026-11-12  
**Branch:** `feature/pouyanly-full-development`  
**App root:** `pouyanly 2/`

## Objective

Replace the mixed generic icon treatment used by game and learning symbols with a coherent, scalable semantic icon family that has a consistent stroke language and works in light and dark themes.

## Delivered

### Bespoke vector icon vocabulary

Added `lib/core/widgets/pouyanly_icon.dart` with a semantic enum and custom Flutter painter for:
- Home and learning path
- Vocabulary, book, review and sync
- Listening, speaking and brain/learning
- Target and XP
- Coin, streak, trophy and medal
- Locked and completed states
- Statistics, profile, settings, calendar, timer, growth and school

The icons are drawn at a normalized 24-unit coordinate system and scale to the requested size without raster assets or third-party icon fonts. Their foreground and accent colors are theme-aware by default and can be overridden when a surface requires a specific semantic color.

### Reusable icon treatments

- `PouyanlyIcon`: standalone semantic vector with optional accessibility label.
- `PouyanlyIconBadge`: consistent icon container for achievement, metric and action surfaces.
- Existing `AnimatedSymbolIcon` now acts as a compatibility adapter and maps supported legacy emoji identifiers to the semantic icon family. Existing call sites can migrate without changing their model data in one risky sweep.
- The generic icon adapter no longer runs a perpetual animation for every symbol. Motion remains isolated to the explicitly animated coin and flame components.

### Tests

Added `test/core/widgets/pouyanly_icon_test.dart` to exercise every enum value at a requested size and verify the badge/accessibility surface.

## Files changed

- `lib/core/widgets/pouyanly_icon.dart` (new)
- `lib/core/widgets/animated_game_icons.dart`
- `test/core/widgets/pouyanly_icon_test.dart` (new)

Also corrected the Phase 02 regression-test analyzer issue discovered in CI:
- `test/core/theme/design_system_contract_test.dart`: read the font family from `TextTheme`, not `ThemeData`.
- `lib/features/profile/screens/profile_screen.dart`: removed an unused import reported by analyzer.

## Design rules

1. Functional icons are vector glyphs, not emoji.
2. A semantic icon must not depend on its color alone to communicate state; labels and surrounding text remain authoritative.
3. Use one foreground color and at most one accent color per icon.
4. Use static icons by default; animation is reserved for explicit reward feedback.
5. Do not add blur behind learning text, dictionary definitions or assessments.
6. Preserve user-selected avatar emoji as user content; this phase only standardizes functional product icons.

## Validation

- Source review completed.
- Flutter analyzer, tests, release APK and emulator screenshots must pass in GitHub Actions before acceptance.
- No claim of visual-device validation is made in this source-only implementation pass.

## Acceptance checklist

- [x] Semantic vector family defined for the main product concepts.
- [x] Theme-aware foreground/accent colors.
- [x] Reusable badge treatment.
- [x] Legacy symbol adapter migrated to the new icon family.
- [x] Unrequested continuous motion removed from generic symbols.
- [x] Widget tests added for all icon enum values.
- [ ] CI analyzer passes.
- [ ] Full test suite passes.
- [ ] Release APK builds.
- [ ] Emulator screenshots reviewed at small and large display sizes in light and dark themes.
- [ ] Existing screens audited for remaining direct emoji/Material icon usage and migrated where appropriate.

**Phase 03 status: icon family implemented; CI and screen-by-screen migration/visual acceptance pending.**

All work is confined to `feature/pouyanly-full-development`. No merge or changes to `main` were performed.
