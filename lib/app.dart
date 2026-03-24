import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/kinetic_theme.dart';

class KineticApp extends ConsumerWidget {
  const KineticApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'KINETIC',
      debugShowCheckedModeBanner: false,
      theme: kineticTheme(),
      routerConfig: router,
    );
  }
}
