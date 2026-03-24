# KINETIC HIIT App - Flutter Architecture Map

## Stitch-to-Flutter Component Mapping

This document maps every component from the Stitch design export to its Flutter equivalent,
organized by screen and shared components.

---

## Design System Tokens (`lib/core/theme/`)

| Stitch Token | Flutter Mapping | Value |
|---|---|---|
| `primary-fixed` (Work) | `KineticColors.work` | `#C3F400` |
| `secondary-container` (Rest) | `KineticColors.rest` | `#C5020B` |
| `tertiary-fixed-dim` (Music) | `KineticColors.music` | `#ADC6FF` |
| `surface` (Background) | `KineticColors.surface` | `#131313` |
| `surface-container-low` | `KineticColors.surfaceContainerLow` | `#1C1B1B` |
| `surface-container` | `KineticColors.surfaceContainer` | `#201F1F` |
| `surface-container-high` | `KineticColors.surfaceContainerHigh` | `#2A2A2A` |
| `surface-bright` | `KineticColors.surfaceBright` | `#393939` |
| `on-surface` | `KineticColors.onSurface` | `#E5E2E1` |
| `on-surface-variant` | `KineticColors.onSurfaceVariant` | `#C4C9AC` |
| `outline-variant` | `KineticColors.outlineVariant` | `#444933` |
| Font: Lexend (headlines) | `KineticTypography.headline` | Black/900 weight |
| Font: Inter (body/labels) | `KineticTypography.body` | 400-600 weight |

### Design Rules (from DESIGN.md)
- **No-Line Rule**: No 1px borders. Use tonal shifts + negative space.
- **Glass & Glow Rule**: `surfaceBright` at 60% opacity + 20px blur for floating elements.
- **LED Glow**: `BoxShadow(color: work.withAlpha(102), blurRadius: 20)` on active timer text.
- **No pure white**: Use `onSurface (#E5E2E1)` instead.
- **Border radius**: `xl = 12px` for buttons/cards. No full-round pills.

---

## Shared Widgets (`lib/shared/widgets/`)

| Stitch Component | Flutter Widget | Source Screens |
|---|---|---|
| TopAppBar (KINETIC logo + avatar) | `KineticAppBar` | All screens |
| BottomNavBar (Home/Build/Stats/Settings) | `KineticBottomNav` | Home, Builder, Stats |
| Floating Music Tray (glassmorphic) | `MusicPlayerTray` | Home, Active Workout |
| Progress Ring (SVG circles) | `ProgressRing` | Home (weekly), Active Workout |
| Stat Chip (icon + value + label) | `StatChip` | Home, Active Workout, Stats |
| Neon Primary Button (large) | `KineticPrimaryButton` | All screens |
| Ghost Border Card | `KineticCard` | All screens |

---

## Screen Mapping

### 1. Home Dashboard (`lib/features/home/`)
**Stitch source**: `stitch/home_dashboard/`

| Stitch Section | Flutter Widget | File |
|---|---|---|
| Quick Start Hero (CTA + glow BG) | `QuickStartCard` | `widgets/quick_start_card.dart` |
| Weekly Pulse (3x progress rings) | `WeeklyPulseSection` | `widgets/weekly_pulse_section.dart` |
| Heart Rate Monitor (red card + sparkline) | `HeartRateCard` | `widgets/heart_rate_card.dart` |
| Recent Routines (3-col grid) | `RecentRoutinesGrid` | `widgets/recent_routines_grid.dart` |
| Routine Card (icon + title + stats) | `RoutineCard` | `widgets/routine_card.dart` |
| **Screen** | `HomeScreen` | `home_screen.dart` |

### 2. Workout Builder (`lib/features/workout_builder/`)
**Stitch source**: `stitch/workout_builder/`

| Stitch Section | Flutter Widget | File |
|---|---|---|
| Session Header (title + status dot) | `SessionHeader` | `widgets/session_header.dart` |
| Segment Card (work/rest times + drag + playlist) | `SegmentCard` | `widgets/segment_card.dart` |
| Add Segment Button (dashed border) | `AddSegmentButton` | `widgets/add_segment_button.dart` |
| Summary Bento (duration + calories) | `WorkoutSummaryBar` | `widgets/workout_summary_bar.dart` |
| Save Routine FAB (glass tray) | inline in screen | |
| **Screen** | `WorkoutBuilderScreen` | `workout_builder_screen.dart` |

### 3. Active Workout / Timer (`lib/features/active_workout/`)
**Stitch source**: `stitch/active_workout/`

| Stitch Section | Flutter Widget | File |
|---|---|---|
| Phase Label (WORK/REST + exercise name) | `PhaseHeader` | `widgets/phase_header.dart` |
| Immersion Glow (radial gradient BG) | `ImmersionBackground` | `widgets/immersion_background.dart` |
| Giant Timer + Progress Ring | `WorkoutTimerDisplay` | `widgets/workout_timer_display.dart` |
| Live Stats (BPM + KCAL) | `LiveStatsRow` | `widgets/live_stats_row.dart` |
| Next Up Pill | `NextUpIndicator` | `widgets/next_up_indicator.dart` |
| Pause / Stop Buttons | `WorkoutActionButtons` | `widgets/workout_action_buttons.dart` |
| **Screen** | `ActiveWorkoutScreen` | `active_workout_screen.dart` |

### 4. Playlist Selection (`lib/features/music/`)
**Stitch source**: `stitch/playlist_selection/`

| Stitch Section | Flutter Widget | File |
|---|---|---|
| Phase Assignment Cards (Work/Rest) | `PhaseAssignmentCard` | `widgets/phase_assignment_card.dart` |
| Recommended Mixes (horizontal scroll) | `RecommendedMixesRow` | `widgets/recommended_mixes_row.dart` |
| Mix Card (art + BPM badge + SET buttons) | `MixCard` | `widgets/mix_card.dart` |
| My Playlists List | `PlaylistList` | `widgets/playlist_list.dart` |
| Playlist Item (art + title + BPM + assign btns) | `PlaylistTile` | `widgets/playlist_tile.dart` |
| **Screen** | `PlaylistSelectionScreen` | `playlist_selection_screen.dart` |

### 5. Spotify Connection (`lib/features/music/`)
**Stitch source**: `stitch/spotify_connection/`

| Stitch Section | Flutter Widget | File |
|---|---|---|
| Hero Brand Lockup (KINETIC + Spotify icons) | `SpotifyHero` | `widgets/spotify_hero.dart` |
| Benefits Bento (BPM Matching, Phase Playlists) | `BenefitsGrid` | `widgets/benefits_grid.dart` |
| Permissions List (glass panel) | `PermissionsList` | `widgets/permissions_list.dart` |
| Connect / Maybe Later CTAs | inline in screen | |
| **Screen** | `SpotifyConnectionScreen` | `spotify_connection_screen.dart` |

### 6. Performance Tracking (`lib/features/stats/`)
**Stitch source**: `stitch/performance_tracking/`

| Stitch Section | Flutter Widget | File |
|---|---|---|
| Motivational Header (title + Health sync badge) | `StatsHeader` | `widgets/stats_header.dart` |
| Bento Stats (Time/Calories/HR cards) | `StatsBentoGrid` | `widgets/stats_bento_grid.dart` |
| Activity Velocity Chart (bar chart) | `ActivityChart` | `widgets/activity_chart.dart` |
| Elite Tier CTA Card (primary bg) | `TierProgressCard` | `widgets/tier_progress_card.dart` |
| Recent Execution List | `RecentWorkoutsList` | `widgets/recent_workouts_list.dart` |
| Workout History Card (border-left accent) | `WorkoutHistoryTile` | `widgets/workout_history_tile.dart` |
| **Screen** | `PerformanceScreen` | `performance_screen.dart` |

---

## Navigation Architecture

```
MaterialApp
  └─ ShellRoute (KineticScaffold: AppBar + BottomNav)
      ├─ /home             → HomeScreen
      ├─ /build            → WorkoutBuilderScreen
      ├─ /stats            → PerformanceScreen
      └─ /settings         → SettingsScreen (placeholder)

Standalone Routes (no BottomNav):
  ├─ /workout/active       → ActiveWorkoutScreen (immersive, no nav)
  ├─ /music/playlists      → PlaylistSelectionScreen
  └─ /music/connect        → SpotifyConnectionScreen
```

---

## Directory Structure

```
lib/
├── main.dart
├── app.dart                          # MaterialApp + GoRouter
├── core/
│   ├── theme/
│   │   ├── kinetic_colors.dart       # All color tokens
│   │   ├── kinetic_typography.dart   # Lexend + Inter text styles
│   │   └── kinetic_theme.dart        # ThemeData assembly
│   └── router/
│       └── app_router.dart           # GoRouter config
├── shared/
│   └── widgets/
│       ├── kinetic_app_bar.dart
│       ├── kinetic_bottom_nav.dart
│       ├── kinetic_primary_button.dart
│       ├── kinetic_card.dart
│       ├── music_player_tray.dart
│       ├── progress_ring.dart
│       └── stat_chip.dart
├── features/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   ├── workout_builder/
│   │   ├── workout_builder_screen.dart
│   │   └── widgets/
│   ├── active_workout/
│   │   ├── active_workout_screen.dart
│   │   └── widgets/
│   ├── music/
│   │   ├── playlist_selection_screen.dart
│   │   ├── spotify_connection_screen.dart
│   │   └── widgets/
│   └── stats/
│       ├── performance_screen.dart
│       └── widgets/
└── state/                            # Riverpod providers
    ├── workout_session/
    │   ├── workout_session_provider.dart
    │   ├── workout_session_state.dart
    │   └── timer_provider.dart
    ├── music/
    │   ├── music_player_provider.dart
    │   └── spotify_auth_provider.dart
    └── stats/
        └── performance_provider.dart
```
