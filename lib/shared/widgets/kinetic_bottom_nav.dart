import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/kinetic_colors.dart';

/// Bottom navigation bar matching the Stitch design:
/// Home (bolt), Build (add_box), Stats (leaderboard), Settings.
/// Glassmorphic background with a subtle top border glow.
class KineticBottomNav extends StatelessWidget {
  const KineticBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(icon: Icons.bolt, activeIcon: Icons.bolt, label: 'HOME'),
    _NavItem(icon: Icons.add_box_outlined, activeIcon: Icons.add_box, label: 'BUILD'),
    _NavItem(icon: Icons.leaderboard_outlined, activeIcon: Icons.leaderboard, label: 'STATS'),
    _NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'SETTINGS'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: KineticColors.surface.withAlpha(230),
            border: Border(
              top: BorderSide(
                color: KineticColors.onSurface.withAlpha(38),
              ),
            ),
          ),
          padding: const EdgeInsets.only(top: 8, bottom: 32, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final selected = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: selected
                        ? KineticColors.work.withAlpha(26)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected ? item.activeIcon : item.icon,
                        color: selected
                            ? KineticColors.work
                            : KineticColors.onSurface.withAlpha(153),
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? KineticColors.work
                              : KineticColors.onSurface.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
