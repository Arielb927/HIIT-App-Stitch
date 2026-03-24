import 'package:flutter/material.dart';
import '../../../core/theme/kinetic_colors.dart';
import '../../../shared/widgets/progress_ring.dart';

/// "Weekly Pulse" card: 3 progress rings (Daily %, Intensity %, Volume %)
/// and a 7-dot streak indicator.
class WeeklyPulseSection extends StatelessWidget {
  const WeeklyPulseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: KineticColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: KineticColors.outlineVariant.withAlpha(38),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WEEKLY PULSE',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '4 Day Streak / 1,200 CAL',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: KineticColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              // Streak dots
              Row(
                children: List.generate(7, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < 4
                            ? KineticColors.work
                            : KineticColors.surfaceContainerHighest,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Progress rings row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRing(context, 0.75, '75%', 'DAILY', KineticColors.work),
              _buildRing(context, 0.40, '40%', 'INTENSITY', KineticColors.rest),
              _buildRing(context, 0.62, '62%', 'VOLUME', KineticColors.music),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRing(
    BuildContext context,
    double progress,
    String label,
    String subtitle,
    Color color,
  ) {
    return ProgressRing(
      progress: progress,
      size: 100,
      activeColor: color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Lexend',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: KineticColors.onSurface,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: KineticColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
