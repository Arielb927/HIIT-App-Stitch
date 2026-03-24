import 'package:flutter/material.dart';
import '../../../core/theme/kinetic_colors.dart';

/// 3-column grid of recent workout routine cards.
class RecentRoutinesGrid extends StatelessWidget {
  const RecentRoutinesGrid({super.key});

  static const _routines = [
    _RoutineData('Leg Day Burn', '45 MIN', '520 KCAL', Icons.fitness_center, KineticColors.work, '01'),
    _RoutineData('Core Blast', '20 MIN', '210 KCAL', Icons.timer, KineticColors.rest, '02'),
    _RoutineData('Full Body AMP', '35 MIN', '430 KCAL', Icons.electric_bolt, KineticColors.music, '03'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: crossAxisCount == 1 ? 2.5 : 1.1,
          ),
          itemCount: _routines.length,
          itemBuilder: (context, index) => _RoutineCard(data: _routines[index]),
        );
      },
    );
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({required this.data});
  final _RoutineData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: KineticColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: KineticColors.outlineVariant.withAlpha(38),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: KineticColors.surfaceContainerHigh,
                ),
                child: Icon(data.icon, color: data.accentColor, size: 24),
              ),
              Text(
                data.number,
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: KineticColors.onSurfaceVariant.withAlpha(51),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            data.title.toUpperCase(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: KineticColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(data.duration, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(width: 16),
              const Icon(Icons.local_fire_department, size: 14, color: KineticColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(data.calories, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoutineData {
  const _RoutineData(this.title, this.duration, this.calories, this.icon, this.accentColor, this.number);
  final String title;
  final String duration;
  final String calories;
  final IconData icon;
  final Color accentColor;
  final String number;
}
