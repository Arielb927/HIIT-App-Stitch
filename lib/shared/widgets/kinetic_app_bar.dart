import 'package:flutter/material.dart';
import '../../core/theme/kinetic_colors.dart';

/// The KINETIC top app bar: logo on the left, user avatar on the right.
/// Matches the Stitch TopAppBar fragment across all screens.
class KineticAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KineticAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 24,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: KineticColors.onSurface),
            onPressed: () {
              // TODO: open drawer
            },
          ),
          const SizedBox(width: 8),
          Text(
            'KINETIC',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: KineticColors.work,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  fontStyle: FontStyle.normal,
                ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: GestureDetector(
            onTap: () {
              // TODO: navigate to profile
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: KineticColors.surfaceContainerHigh,
                border: Border.all(
                  color: KineticColors.outlineVariant.withAlpha(51),
                ),
              ),
              child: const Icon(
                Icons.person,
                color: KineticColors.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
