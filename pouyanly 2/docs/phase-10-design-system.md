# Phase 10 — POUYANLY Design System

## Purpose
Provide a consistent, Persian-first visual language across the Flutter application. The identity is independent and must not copy another language-learning product.

## Foundation
- `core/theme/app_colors.dart` is the source of truth for brand, semantic, CEFR, gamification, light and dark color roles.
- `core/theme/app_design_tokens.dart` owns spacing, shape, typography, sizing, elevation and motion scales.
- `core/theme/app_theme.dart` defines the Material 3 light and dark themes.
- `core/widgets/app_surface.dart` provides shared solid content surfaces, section headers and accessible progress bars.
- Existing premium icon and liquid-glass widgets are shared primitives; glass is reserved for navigation and transient controls.

## Usage rules
1. Prefer `Theme.of(context).textTheme` and `Theme.of(context).colorScheme` over screen-local font and color literals.
2. Use `AppDesignTokens` for spacing, radii, touch targets, typography and motion durations.
3. Use `AppSurface` for content cards. Do not wrap lesson copy, definitions or long-form reading content in glass.
4. Use `AppProgressBar` for consistent, clamped and semantically labelled progress.
5. Keep Persian layouts RTL; mixed English strings must remain readable and must not force the whole screen into LTR.
6. Interactive targets must be at least 48 logical pixels where practical.
7. Animate state changes only; honor platform reduced-motion preferences before adding decorative motion.
8. Verify both light and dark themes, narrow Android widths, text scaling and contrast before declaring a screen complete.

## Phase 10 changes in this pass
- Centralized the Persian typography scale and applied it to the application-wide Material theme.
- Added reusable `AppSurface`, `AppSectionHeader` and `AppProgressBar` primitives.
- Updated Rewards to use the shared surface/progress components and theme typography.
- Removed avatar selection and avatar purchase controls from Rewards. Avatar management remains in Profile; Rewards retains level progress, XP, coins, missions, achievements and streak information.

## Validation
- Widget tests cover light/dark theme setup and shared component rendering.
- Rewards widget test asserts that avatar selection is absent while level progress remains visible.
- CI must pass analyzer, all tests, release APK build and artifact upload before this phase is considered validated.
