import 'package:flutter/material.dart';
import '../../core/theme/kinetic_colors.dart';
import '../../shared/widgets/music_player_tray.dart';
import 'widgets/quick_start_card.dart';
import 'widgets/weekly_pulse_section.dart';
import 'widgets/heart_rate_card.dart';
import 'widgets/recent_routines_grid.dart';

/// Home Dashboard screen matching `stitch/home_dashboard/`.
///
/// Layout (top to bottom):
///   - Quick Start hero card with glow background
///   - Weekly Pulse (3 progress rings) + Heart Rate bento row
///   - Recent Routines grid
///   - Floating music tray (positioned above bottom nav)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KineticColors.surface,
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                sliver: SliverToBoxAdapter(child: QuickStartCard()),
              ),
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(24, 40, 24, 0),
                sliver: SliverToBoxAdapter(child: _StatsBentoRow()),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'RECENT ROUTINE',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: navigate to history
                        },
                        child: const Text(
                          'VIEW ALL HISTORY',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: KineticColors.work,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 160),
                sliver: SliverToBoxAdapter(child: RecentRoutinesGrid()),
              ),
            ],
          ),

          // Floating music tray
          Positioned(
            left: 24,
            right: 24,
            bottom: 96,
            child: MusicPlayerTray(
              trackName: 'Vibrance (Remix)',
              artistName: 'HIIT Power Mix - Spotify',
              isPlaying: false,
              onPlayPause: () {
                // TODO: wire to MusicPlayer provider
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Bento row: 2/3 Weekly Pulse + 1/3 Heart Rate card.
class _StatsBentoRow extends StatelessWidget {
  const _StatsBentoRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Tablet / wide: side-by-side
          return const IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 2, child: WeeklyPulseSection()),
                SizedBox(width: 24),
                Expanded(child: HeartRateCard()),
              ],
            ),
          );
        }
        // Phone: stacked
        return const Column(
          children: [
            WeeklyPulseSection(),
            SizedBox(height: 24),
            HeartRateCard(),
          ],
        );
      },
    );
  }
}
