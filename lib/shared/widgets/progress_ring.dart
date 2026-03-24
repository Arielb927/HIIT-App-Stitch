import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/kinetic_colors.dart';

/// A circular progress ring matching the Stitch design:
/// heavy 12px stroke, trailing glow on the active arc.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 128,
    this.strokeWidth = 12,
    this.activeColor = KineticColors.work,
    this.trackColor = KineticColors.surfaceContainerHighest,
    this.child,
  });

  /// 0.0 → 1.0
  final double progress;
  final double size;
  final double strokeWidth;
  final Color activeColor;
  final Color trackColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: progress.clamp(0, 1),
              strokeWidth: strokeWidth,
              activeColor: activeColor,
              trackColor: trackColor,
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.activeColor,
    required this.trackColor,
  });

  final double progress;
  final double strokeWidth;
  final Color activeColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Active arc
    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      -pi / 2,             // start at top
      2 * pi * progress,   // sweep
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) {
    return old.progress != progress ||
        old.strokeWidth != strokeWidth ||
        old.activeColor != activeColor ||
        old.trackColor != trackColor;
  }
}
