import 'package:flutter/material.dart';
import 'kinetic_colors.dart';
import 'kinetic_typography.dart';

/// Assembles the full ThemeData for the KINETIC app.
/// Uses Material 3 with a fully custom dark color scheme.
ThemeData kineticTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: KineticColors.surface,
    colorScheme: const ColorScheme.dark(
      primary: KineticColors.work,
      onPrimary: KineticColors.onWork,
      secondary: KineticColors.rest,
      onSecondary: KineticColors.onRest,
      tertiary: KineticColors.music,
      surface: KineticColors.surface,
      onSurface: KineticColors.onSurface,
      error: KineticColors.error,
      errorContainer: KineticColors.errorContainer,
      outline: KineticColors.outline,
      outlineVariant: KineticColors.outlineVariant,
      surfaceContainerHighest: KineticColors.surfaceContainerHighest,
    ),
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      displayLarge: KineticTypography.displayLarge,
      headlineLarge: KineticTypography.headlineLarge,
      headlineMedium: KineticTypography.headlineMedium,
      headlineSmall: KineticTypography.headlineSmall,
      titleLarge: KineticTypography.titleLarge,
      bodyMedium: KineticTypography.bodyMedium,
      bodySmall: KineticTypography.bodySmall,
      labelMedium: KineticTypography.labelMedium,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: KineticColors.surface,
      foregroundColor: KineticColors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: KineticColors.surface.withAlpha(230), // 90% opacity
      indicatorColor: KineticColors.work.withAlpha(26),      // 10% opacity
      labelTextStyle: WidgetStateProperty.all(
        KineticTypography.labelMedium.copyWith(fontSize: 10),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: KineticColors.work,
        foregroundColor: KineticColors.onWork,
        minimumSize: const Size.fromHeight(64), // 4rem min height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: KineticTypography.headlineSmall.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: KineticColors.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
