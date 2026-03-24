import 'package:flutter/material.dart';
import 'kinetic_colors.dart';

/// Typography scale derived from the Stitch design system.
/// Headlines: Lexend (Black weight, tight tracking, uppercase)
/// Body/Labels: Inter (Regular-SemiBold)
abstract final class KineticTypography {
  static const _lexend = 'Lexend';
  static const _inter = 'Inter';

  // ── Display (giant timer digits) ──────────────────────────
  static const displayLarge = TextStyle(
    fontFamily: _lexend,
    fontWeight: FontWeight.w900,
    fontSize: 128, // 8rem – active countdown
    height: 1.0,
    letterSpacing: -2,
    color: KineticColors.work,
  );

  // ── Headlines ─────────────────────────────────────────────
  static const headlineLarge = TextStyle(
    fontFamily: _lexend,
    fontWeight: FontWeight.w900,
    fontSize: 32, // 2rem
    height: 0.9,
    letterSpacing: -0.5,
    color: KineticColors.onSurface,
  );

  static const headlineMedium = TextStyle(
    fontFamily: _lexend,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.1,
    letterSpacing: -0.3,
    color: KineticColors.onSurface,
  );

  static const headlineSmall = TextStyle(
    fontFamily: _lexend,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 1.2,
    color: KineticColors.onSurface,
  );

  // ── Titles ────────────────────────────────────────────────
  static const titleLarge = TextStyle(
    fontFamily: _lexend,
    fontWeight: FontWeight.w900,
    fontSize: 14,
    height: 1.4,
    letterSpacing: 2.0, // wide tracking for segment labels
    color: KineticColors.onSurface,
  );

  // ── Body ──────────────────────────────────────────────────
  static const bodyMedium = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.5,
    color: KineticColors.onSurface,
  );

  static const bodySmall = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.5,
    color: KineticColors.onSurfaceVariant,
  );

  // ── Labels ────────────────────────────────────────────────
  static const labelMedium = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w700,
    fontSize: 10,
    height: 1.3,
    letterSpacing: 1.5,
    color: KineticColors.onSurfaceVariant,
  );
}
