import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/kinetic_colors.dart';
import '../../shared/widgets/music_player_tray.dart';
import '../../shared/widgets/progress_ring.dart';
import '../../state/music/music_player_provider.dart';
import '../../state/workout_session/workout_session_provider.dart';
import '../../state/workout_session/workout_session_state.dart';

/// Active Workout / Timer screen matching `stitch/active_workout/`.
class ActiveWorkoutScreen extends ConsumerWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(workoutSessionProvider);
    final music = ref.watch(musicPlayerProvider);
    final timeRemaining = ref.watch(formattedTimeRemainingProvider);
    final progress = ref.watch(phaseProgressProvider);
    final nextUp = ref.watch(nextUpLabelProvider) ?? 'FINISH';

    final activePhase =
        session.phase == WorkoutPhase.paused ? session.lastActivePhase : session.phase;
    final phaseColor =
        activePhase == WorkoutPhase.rest ? KineticColors.rest : KineticColors.work;
    final phaseLabel = switch (activePhase) {
      WorkoutPhase.rest => 'REST',
      WorkoutPhase.completed => 'DONE',
      WorkoutPhase.paused => 'PAUSED',
      _ => 'WORK',
    };
    final segmentName = session.routine.segments.isEmpty
        ? 'SEGMENT'
        : session.routine.segments[session.currentSegmentIndex].name.toUpperCase();

    final screenSize = MediaQuery.sizeOf(context);
    final ringSize = screenSize.width * 0.75;

    return Scaffold(
      backgroundColor: KineticColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 24,
        title: Row(
          children: [
            Icon(Icons.menu, color: phaseColor),
            const SizedBox(width: 12),
            Text(
              'KINETIC',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: phaseColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    phaseColor.withAlpha(51),
                    KineticColors.surface,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  phaseLabel,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 56,
                        color: phaseColor,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  segmentName,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: KineticColors.onSurface.withAlpha(153),
                        letterSpacing: 3,
                      ),
                ),
                Expanded(
                  child: Center(
                    child: ProgressRing(
                      progress: progress,
                      size: ringSize,
                      strokeWidth: 8,
                      activeColor: phaseColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            timeRemaining,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: ringSize * 0.28,
                                  shadows: [
                                    Shadow(
                                      color: phaseColor.withAlpha(102),
                                      blurRadius: 25,
                                    ),
                                  ],
                                ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildStat(context, '${session.currentHeartRate}', 'BPM'),
                              const SizedBox(width: 48),
                              _buildStat(
                                context,
                                '${session.caloriesBurned}',
                                'KCAL',
                              ),
                            ],
                          ),
                          if (music.isFallbackActive) ...[
                            const SizedBox(height: 24),
                            _FallbackBanner(music: music),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  decoration: BoxDecoration(
                    color: KineticColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'UP NEXT:  ',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: KineticColors.onSurface.withAlpha(102),
                                letterSpacing: 2,
                              ),
                        ),
                        TextSpan(
                          text: nextUp,
                          style: const TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: KineticColors.onRest,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: session.phase == WorkoutPhase.paused ? 'RESUME' : 'PAUSE',
                          color: KineticColors.surfaceContainerHigh,
                          textColor: KineticColors.onSurface,
                          onPressed: () {
                            final notifier =
                                ref.read(workoutSessionProvider.notifier);
                            if (session.phase == WorkoutPhase.paused) {
                              notifier.resume();
                            } else {
                              notifier.pause();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ActionButton(
                          label: 'STOP',
                          color: KineticColors.rest,
                          textColor: KineticColors.onRest,
                          onPressed: () {
                            ref.read(workoutSessionProvider.notifier).stop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: MusicPlayerTray(
                    trackName: music.currentTrackName.isEmpty
                        ? 'NO TRACK'
                        : music.currentTrackName,
                    artistName: music.currentArtist.isEmpty
                        ? 'SPOTIFY'
                        : music.currentArtist,
                    isPlaying: music.isPlaying,
                    onPlayPause: () {
                      ref.read(musicPlayerProvider.notifier).togglePlayPause();
                    },
                    onSkipNext: () {
                      ref.read(musicPlayerProvider.notifier).skipNext();
                    },
                    onSkipPrevious: () {
                      ref.read(musicPlayerProvider.notifier).skipPrevious();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Lexend',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: KineticColors.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: KineticColors.onSurface.withAlpha(102),
          ),
        ),
      ],
    );
  }
}

class _FallbackBanner extends StatelessWidget {
  const _FallbackBanner({required this.music});

  final MusicSyncState music;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: KineticColors.onSurface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: KineticColors.work.withAlpha(120),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            music.fallbackLabel,
            style: const TextStyle(
              fontFamily: 'Lexend',
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: KineticColors.surface,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            music.fallbackReason,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: KineticColors.surface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.textColor,
    this.onPressed,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 64,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
