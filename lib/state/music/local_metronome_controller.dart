import 'dart:async';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_metronome_controller.g.dart';

/// Minimal local fail-safe audio using platform click/alert sounds.
class LocalMetronomeController {
  Timer? _timer;

  Future<void> start({
    Duration interval = const Duration(milliseconds: 500),
  }) async {
    stop();
    await SystemSound.play(SystemSoundType.alert);
    _timer = Timer.periodic(interval, (_) {
      SystemSound.play(SystemSoundType.click);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}

@riverpod
LocalMetronomeController localMetronomeController(
  LocalMetronomeControllerRef ref,
) {
  final controller = LocalMetronomeController();
  ref.onDispose(controller.stop);
  return controller;
}
