import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/kinetic_colors.dart';

/// Floating glassmorphic music player tray matching the Stitch design.
/// Shows album art, track info, and playback controls.
/// Uses `surface-bright` at 60% opacity + 20px blur per the Glass & Glow rule.
class MusicPlayerTray extends StatelessWidget {
  const MusicPlayerTray({
    super.key,
    required this.trackName,
    required this.artistName,
    this.isPlaying = false,
    this.onPlayPause,
    this.onSkipNext,
    this.onSkipPrevious,
  });

  final String trackName;
  final String artistName;
  final bool isPlaying;
  final VoidCallback? onPlayPause;
  final VoidCallback? onSkipNext;
  final VoidCallback? onSkipPrevious;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: KineticColors.surfaceBright.withAlpha(153), // 60%
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: KineticColors.outlineVariant.withAlpha(51),
            ),
          ),
          child: Row(
            children: [
              // Album art placeholder
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: KineticColors.surfaceContainerHighest,
                ),
                child: const Icon(
                  Icons.music_note,
                  color: KineticColors.music,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Track info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trackName.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: KineticColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      artistName.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: KineticColors.music,
                        letterSpacing: 1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Playback controls
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: KineticColors.music),
                    iconSize: 24,
                    onPressed: onSkipPrevious,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: KineticColors.music,
                    ),
                    iconSize: 36,
                    onPressed: onPlayPause,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: KineticColors.music),
                    iconSize: 24,
                    onPressed: onSkipNext,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
