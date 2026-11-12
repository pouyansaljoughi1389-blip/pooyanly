# POUYANLY — Phase 01 Product UI Audit

**Audit date:** 2026-11-12  
**Branch:** `feature/pouyanly-full-development`  
**Audited app root:** `pouyanly 2/`  
**Mode:** Inspection only. No product code or visual assets were changed in this phase.

## 1. Executive summary

The current branch already contains a meaningful first-pass design foundation: a centralized Material 3 theme, shared design tokens, a restrained `LiquidGlass` surface, a shared `PremiumIcon`, and a custom animated game-icon layer. The application is not starting from zero.

However, the visual language is not yet consistent enough to be considered a finished product. The largest visible design-system gap is iconography: navigation uses generic Material rounded glyphs, game/reward areas translate emoji strings into Material glyphs, other areas use direct `Icons.*`, and user avatars intentionally use emoji. These patterns have different visual weights and semantics. The current shared icon widgets also apply decorative treatment and continuous animation too broadly.

The audit confirms that the next design work should not simply install a new icon package. POUYANLY needs a deliberate icon taxonomy and a small, coherent, purpose-designed set for its distinctive product concepts.

## 2. Application inventory

The existing UI audit documents 18 screen entry points across onboarding, assessment, learning, retention/account and supporting flows:

- Splash, welcome, account, onboarding
- Placement test and placement result
- Home/dashboard, learning path, checkpoint, lesson, vocabulary, listening, tutor
- Rewards, profile, settings
- Community and about

The primary in-app navigation is a five-destination tab bar: learning path, home, vocabulary, rewards and profile. Other flows are reached through GoRouter routes.

## 3. Confirmed findings

### P1 — Iconography is fragmented

**Evidence**
- `core/widgets/premium_icon.dart` wraps standard Material `IconData` with a duplicated offset glyph, translucent shadow and (when elevated) a gradient container, border and shadow.
- `core/widgets/animated_game_icons.dart` accepts emoji strings and maps a limited list of them to Material icons. Unknown values silently fall back to `auto_awesome`.
- The same file runs repeating animation controllers for coin, flame and generic symbol icons. The generic symbol implementation animates every mapped symbol, even when the symbol is a static status or utility marker.
- `LiquidGlassNavigationBar` uses generic Material rounded icons for all five primary destinations.
- Dashboard and rewards code also use direct `Icons.*`, custom animated icons and emoji identifiers. Avatar emoji are a separate user-personalization choice and should not be conflated with functional UI icons.
- The only image asset under `assets/images/` is the raster `app_icon.jpg` plus a placeholder SVG; there is no dedicated product icon family in the asset tree.

**Impact**
- Different areas look like they belong to different apps.
- The repeated shadow/gradient treatment can make small icons muddy at actual phone sizes.
- Generic emoji-to-icon conversion hides semantic mismatches and makes it difficult to review icon intent.
- Continuous per-icon animation adds visual noise and unnecessary work for static UI.

**Required direction**
- Establish one icon system with explicit categories: navigation, action, learning skill, progress/status, reward/currency, achievement and avatar.
- Use a consistent optical grid, stroke/weight, corner language, baseline and size scale.
- Design bespoke icons only for POUYANLY-defining concepts (for example learning path, XP, streak, review, CEFR progression and tutor); use a consistent established vector set for ordinary actions.
- Replace emoji-string dispatch with typed icon identifiers or direct typed icon definitions. Unknown identifiers must be caught in tests/analyzer paths rather than silently displaying a sparkle.
- Animation must be opt-in and reserved for meaningful feedback, not applied to every icon instance.
- Keep avatar emoji as user-selected content if desired; do not use them as a substitute for functional interface icons.
- Review every icon at 16, 20, 24 and 32 logical pixels in both themes and in selected/unselected states.

### P1 — Dashboard hierarchy and source-of-truth need verification

**Evidence**
- The dashboard includes XP, daily goal, next lesson, listening, tutor, community, review and summary statistics.
- The daily goal card currently formats a fallback of “10 minutes per day” and displays a denominator of 50 XP in its text.
- The dashboard uses multiple card treatments and icon styles in the same scroll flow.
- The dashboard's “next lesson” fallback currently tries A2 after the current level's units are exhausted.

**Impact**
- A displayed goal can diverge from a user's configured goal or the actual progress calculation.
- Fixed copy/denominators can misrepresent progress when the goal changes.
- A fallback course level can lead to a learner seeing content outside the expected progression if the current level has no remaining lessons.
- Several competing card treatments weaken content hierarchy.

**Required direction**
- Derive goal labels and progress denominators from one persisted goal model.
- Make next-lesson selection respect the learner's actual curriculum and gating state; do not hardcode A2 as a universal fallback.
- Establish a dashboard hierarchy: next learning action first, daily progress second, secondary destinations third.
- Keep educational content surfaces plain and calm; reserve translucent/glass treatment for navigation and transient controls.

### P1 — Rewards page requires a data and visual integrity pass

**Evidence**
- Rewards currently presents daily/weekly missions, a locally computed offline league, achievements and a seven-day streak calendar.
- Mission definitions, thresholds and reward amounts are embedded in the screen UI.
- The streak calendar derives the active days from the current streak integer and the current weekday rather than a persisted per-day activity history.
- Achievement and mission visuals mix emoji identifiers, animated icon wrappers and Material glyphs.

**Impact**
- UI definitions and reward logic can drift apart.
- A streak count alone cannot reconstruct which exact calendar dates were active.
- The visual style of rewards is not consistent with the navigation and core learning UI.

**Required direction**
- Separate mission/achievement definitions from presentation.
- Render the streak calendar from persisted activity dates, or label it honestly as a streak summary until date history exists.
- Keep reward claim eligibility and idempotency enforced in the provider/domain layer, not only by button state.
- Give currency, achievement, mission and streak iconography one shared visual language.

### P1 — Profile and account states need end-to-end verification

**Evidence**
- The current branch has a visible `UserRequiredState` recovery path rather than silently rendering an empty widget when the user is null.
- Profile includes identity/progression information and an avatar selector with unlock costs.
- Avatar selection uses emoji as user-facing personalization.
- Profile and dashboard rely on the hydrated `UserProvider` state.

**Impact**
- The null-user blank-screen defect has been addressed in the current feature branch, but persistence, migration, malformed saved data, returning-user routing and refresh behavior still need end-to-end validation.
- A profile can look complete while some displayed fields are still not backed by durable user state.

**Required direction**
- Test fresh install, existing saved account, null account, malformed/legacy data, recovery and return-to-profile flows.
- Audit every displayed statistic against the persisted model/provider source.
- Preserve user-selected avatar emoji as content, but redesign the surrounding avatar selector controls and functional icons.

### P2 — Theme foundation exists, but screen-level contrast is not proven

**Evidence**
- `AppTheme` provides centralized Material 3 light and dark themes with Vazirmatn typography.
- `AppColors` contains brand, semantic, CEFR, gamification and neutral palettes.
- Several screens still contain direct colors, white foregrounds on gradients, and local decoration values.

**Impact**
- A centralized theme does not guarantee all individual widgets use it.
- A few hard-coded colors can cause the light-mode unreadable-text issue to reappear on secondary pages or states.

**Required direction**
- Build a screen-by-screen color exception inventory.
- Check actual foreground/background pairs, including disabled, selected, error, success and gradient states.
- Prefer `ColorScheme` roles and semantic tokens over raw colors except for intentional brand illustrations.

### P2 — Motion and visual effects need a budget

**Evidence**
- The learning-path header uses a continuously repeating ambient animation.
- Coin, flame and generic symbol icons also repeat animations.
- `LiquidGlass` now makes blur opt-in and caps the sigma value, which is a good baseline.
- The design notes correctly keep lesson copy, definitions and answer choices on solid surfaces.

**Impact**
- Many simultaneous repeating animations can increase battery use and reduce smoothness on lower-end Android devices.
- Decorative motion can compete with learning tasks and accessibility needs.

**Required direction**
- Define motion tiers: static by default, short state-transition animation, and rare ambient animation.
- Respect reduced-motion preferences where supported.
- Keep blur limited to navigation/transient controls; do not add blur behind reading or assessment content.

## 4. Icon redesign specification

The icon redesign must be treated as a dedicated product-design task, not a cosmetic package swap.

| Family | Examples | Design requirement |
|---|---|---|
| Primary navigation | Path, home, vocabulary, rewards, profile | Recognizable at 20–24 px; selected state uses color/shape, not extra ornament alone |
| Learning actions | Start lesson, continue, listen, speak, review, retry | Clear action semantics; consistent directional behavior in RTL |
| Progress | XP, level, streak, daily goal, completion | Distinct silhouettes; avoid using the same star/flame for unrelated concepts |
| Rewards | Coins, achievement, unlock, shop | Cohesive dimensionality; no tiny decorative detail |
| CEFR | A1–C2, checkpoint, level-up | A scalable progression family with clear level differentiation |
| System actions | Back, close, edit, search, settings, notification | Use consistent standard vector glyphs; avoid unnecessary bespoke styling |
| Avatar | User-selected character | Separate illustration/identity system; not used as an action icon |

**Visual acceptance criteria**
1. One consistent silhouette/weight language across functional icons.
2. Optical alignment and consistent bounding boxes.
3. Clear meaning without relying on color alone.
4. Correct RTL mirroring only for directional icons; non-directional symbols must not flip.
5. Readable in light and dark themes, including disabled/selected states.
6. No continuous animation unless it communicates a state change or meaningful reward.
7. No silent fallback icon for an unknown identifier.
8. Screen-reader labels must describe the action; decorative icons must be excluded from semantics.
9. No raster icon blur or pixelation at common Android densities.
10. No icon redesign should alter an action's behavior or navigation route.

## 5. Recommended execution order after Phase 01

1. Phase 02: finalize design tokens and component rules before redrawing individual pages.
2. Phase 03: create the POUYANLY icon inventory, taxonomy and visual prototypes; approve the family before broad replacement.
3. Phase 04: complete light/dark contrast and color exception audit.
4. Continue with dashboard, profile and rewards only after these foundations are stable.

## 6. Phase 01 exit criteria

- [x] Confirm active branch and pull request state.
- [x] Inventory primary routes and shared UI foundations.
- [x] Inspect dashboard, profile, rewards, navigation and shared icon implementations.
- [x] Record icon-system inconsistencies and define acceptance criteria.
- [x] Record high-priority data/visual risks for the first screen group.
- [ ] Capture real-device/emulator screenshots for all audited screens and both themes.
- [ ] Run current-branch Flutter analysis/tests and verify the current workflow result.
- [ ] Inspect every screen entry point individually for visual defects; this requires a running build and screenshot pass.

**Phase 01 status: audit baseline documented; visual/device validation remains open.**

## 7. Branch and release safety

This audit is committed only to `feature/pouyanly-full-development`. The draft pull request remains unmerged. No change to `main` or public release is authorized by this work.
