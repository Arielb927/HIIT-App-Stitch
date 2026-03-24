import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/active_workout/active_workout_screen.dart';
import '../../features/home/home_screen.dart';
import '../../shared/widgets/kinetic_app_bar.dart';
import '../../shared/widgets/kinetic_bottom_nav.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      // ── Shell: screens with bottom nav ──
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _KineticScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/build',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _Placeholder('Workout Builder'),
            ),
          ),
          GoRoute(
            path: '/stats',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _Placeholder('Performance Stats'),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _Placeholder('Settings'),
            ),
          ),
        ],
      ),

      // ── Standalone: immersive screens without bottom nav ──
      GoRoute(
        path: '/workout/active',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ActiveWorkoutScreen(),
      ),
      GoRoute(
        path: '/music/playlists',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const _Placeholder('Playlist Selection'),
      ),
      GoRoute(
        path: '/music/connect',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const _Placeholder('Spotify Connect'),
      ),
    ],
  );
}

/// Shell scaffold that wraps tab screens with the KINETIC app bar and bottom nav.
class _KineticScaffold extends StatelessWidget {
  const _KineticScaffold({required this.child});
  final Widget child;

  static const _paths = ['/home', '/build', '/stats', '/settings'];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final idx = _paths.indexWhere((p) => location.startsWith(p));
    return idx >= 0 ? idx : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KineticAppBar(),
      body: child,
      bottomNavigationBar: KineticBottomNav(
        currentIndex: _currentIndex(context),
        onTap: (i) => context.go(_paths[i]),
      ),
    );
  }
}

/// Temporary placeholder for screens not yet implemented.
class _Placeholder extends StatelessWidget {
  const _Placeholder(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
