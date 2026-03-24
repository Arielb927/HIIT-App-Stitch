import 'dart:ui';

/// All color tokens extracted from the Stitch design system.
/// Naming follows the Material 3 tonal palette from DESIGN.md.
abstract final class KineticColors {
  // ── Functional Palette ────────────────────────────────────
  static const work         = Color(0xFFC3F400); // primary-fixed (neon green)
  static const workDim      = Color(0xFFABD600); // primary-fixed-dim
  static const onWork       = Color(0xFF161E00); // on-primary-fixed
  static const rest         = Color(0xFFC5020B); // secondary-container (red)
  static const onRest       = Color(0xFFFFD2CC); // on-secondary-container
  static const music        = Color(0xFFADC6FF); // tertiary-fixed-dim (blue)
  static const musicBright  = Color(0xFFD8E2FF); // tertiary-fixed

  // ── Surface Stack (Tonal Layering) ────────────────────────
  static const surface              = Color(0xFF131313);
  static const surfaceDim           = Color(0xFF131313);
  static const surfaceContainerLowest = Color(0xFF0E0E0E);
  static const surfaceContainerLow  = Color(0xFF1C1B1B);
  static const surfaceContainer     = Color(0xFF201F1F);
  static const surfaceContainerHigh = Color(0xFF2A2A2A);
  static const surfaceContainerHighest = Color(0xFF353534);
  static const surfaceBright        = Color(0xFF393939);

  // ── On-Surface / Text ─────────────────────────────────────
  static const onSurface        = Color(0xFFE5E2E1);
  static const onSurfaceVariant = Color(0xFFC4C9AC);

  // ── Outline ───────────────────────────────────────────────
  static const outline        = Color(0xFF8E9379);
  static const outlineVariant = Color(0xFF444933);

  // ── Error ─────────────────────────────────────────────────
  static const error          = Color(0xFFFFB4AB);
  static const errorContainer = Color(0xFF93000A);
}
