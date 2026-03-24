import 'package:flutter/material.dart';
import '../../../core/theme/kinetic_colors.dart';

/// Red heart rate monitor card with animated pulse icon and large BPM display.
class HeartRateCard extends StatelessWidget {
  const HeartRateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: KineticColors.rest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: KineticColors.onRest.withAlpha(26),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: KineticColors.onRest, size: 20),
              const SizedBox(width: 8),
              Text(
                'AVG HR',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: KineticColors.onRest,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '142',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 56,
                      color: KineticColors.onRest,
                    ),
              ),
              const SizedBox(width: 8),
              Text(
                'BPM',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: KineticColors.onRest.withAlpha(153),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
