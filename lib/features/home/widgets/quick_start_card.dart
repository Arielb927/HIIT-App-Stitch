import 'package:flutter/material.dart';
import '../../../core/theme/kinetic_colors.dart';

/// Hero card with neon glow background, "Quick Start: Auto-HIIT" title,
/// and "Launch Session" primary button.
class QuickStartCard extends StatelessWidget {
  const QuickStartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 256),
      decoration: BoxDecoration(
        color: KineticColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: KineticColors.outlineVariant.withAlpha(26),
        ),
        boxShadow: [
          BoxShadow(
            color: KineticColors.work.withAlpha(13),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background icon
          Positioned(
            top: 32,
            right: 32,
            child: Icon(
              Icons.bolt,
              size: 64,
              color: KineticColors.work.withAlpha(51),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'READY FOR CHAOS?',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: KineticColors.work,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'QUICK START:\nAUTO-HIIT',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 40,
                        fontStyle: FontStyle.italic,
                        height: 0.9,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'AI-generated randomization based on your fatigue levels and goals.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: KineticColors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: launch quick session
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('LAUNCH SESSION'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
