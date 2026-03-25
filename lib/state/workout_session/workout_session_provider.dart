import 'dart:async';

import 'package:live_activities/live_activities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../music/music_player_provider.dart';
import '../health/health_kit_service.dart';
import 'hiit_engine.dart';
import 'workout_session_state.dart';

part 'workout_session_provider.g.dart';

/// Manages the full lifecycle of a segmented HIIT workout session.
@riverpod
class WorkoutSession extends _$WorkoutSession {
  Timer? _timer;
  DateTime? _sessionStartTime;
  String? _liveActivityId;
  final HealthKitService _healthKitService = HealthKitService();
  final LiveActivities _liveActivitiesPlugin = LiveActivities();

  @override
  WorkoutSessionState build() {
    ref.onDispose(() => _timer?.cancel());

    return WorkoutSessionState(
      routine: const WorkoutRoutine(
        id: '',
        title: '',
        segments: [],
      ),
    );
  }

  /// Begin a new session from a routine template.
  void start(WorkoutRoutine routine) {
    if (routine.segments.isEmpty) return;

    final initialState = HiitEngine.initialState(routine);
    _sessionStartTime = DateTime.now();
    state = initialState;
    unawaited(
      ref
          .read(musicPlayerProvider.notifier)
          .handleTimerHitZero(HiitEngine.cueForState(initialState)),
    );
    unawaited(_startLiveActivity(initialState));
    _startTicking();
  }

  void pause() {
    if (state.phase == WorkoutPhase.work || state.phase == WorkoutPhase.rest) {
      _timer?.cancel();
      state = state.copyWith(phase: WorkoutPhase.paused);
      unawaited(ref.read(musicPlayerProvider.notifier).pauseForWorkout());
    }
  }

  void resume() {
    if (state.phase != WorkoutPhase.paused) return;

    state = state.copyWith(phase: state.lastActivePhase);
    unawaited(
      ref
          .read(musicPlayerProvider.notifier)
          .resumeForWorkout(HiitEngine.cueForState(state)),
    );
    _startTicking();
  }

  void stop() {
    final stopTime = DateTime.now();
    final startTime = _sessionStartTime ?? stopTime.subtract(state.elapsed);
    final caloriesBurned = state.caloriesBurned;

    _timer?.cancel();
    state = state.copyWith(
      phase: WorkoutPhase.completed,
      timeRemaining: Duration.zero,
      phaseTotalDuration: Duration.zero,
    );
    unawaited(
      _saveWorkoutToHealthKit(
        startTime: startTime,
        endTime: stopTime,
        caloriesBurned: caloriesBurned,
      ),
    );
    unawaited(ref.read(musicPlayerProvider.notifier).completeWorkout());
    unawaited(_endLiveActivity());
  }

  /// Skip to the next phase boundary immediately.
  void skipPhase() {
    _timer?.cancel();
    _advancePhase(elapsed: state.elapsed);
  }

  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (state.phase == WorkoutPhase.paused ||
        state.phase == WorkoutPhase.completed) {
      return;
    }

    final remaining = state.timeRemaining - const Duration(seconds: 1);
    final elapsed = state.elapsed + const Duration(seconds: 1);

    if (remaining <= Duration.zero) {
      _advancePhase(elapsed: elapsed);
      return;
    }

    state = state.copyWith(
      timeRemaining: remaining,
      elapsed: elapsed,
    );
    unawaited(_updateLiveActivity(state));
  }

  void _advancePhase({required Duration elapsed}) {
    final transition = HiitEngine.advance(state, elapsed: elapsed);
    state = transition.nextState;
    unawaited(_updateLiveActivity(state));

    if (transition.playbackCue != null) {
      unawaited(
        ref
            .read(musicPlayerProvider.notifier)
            .handleTimerHitZero(transition.playbackCue!),
      );
    } else {
      unawaited(ref.read(musicPlayerProvider.notifier).completeWorkout());
    }

    if (transition.shouldContinueTicking) {
      _startTicking();
    } else {
      _timer?.cancel();
    }
  }

  Future<void> _startLiveActivity(WorkoutSessionState session) async {
    try {
      _liveActivityId = await _liveActivitiesPlugin.createActivity(
        _liveActivityData(session),
      );
    } catch (_) {
      _liveActivityId = null;
    }
  }

  Future<void> _updateLiveActivity(WorkoutSessionState session) async {
    if (_liveActivityId == null) return;

    if (session.phase == WorkoutPhase.completed) {
      await _endLiveActivity();
      return;
    }

    try {
      await _liveActivitiesPlugin.updateActivity(
        _liveActivityId!,
        _liveActivityData(session),
      );
    } catch (_) {
      // Ignore unsupported platform/runtime errors.
    }
  }

  Future<void> _endLiveActivity() async {
    if (_liveActivityId == null) return;
    try {
      await _liveActivitiesPlugin.endActivity(_liveActivityId!);
    } catch (_) {
      // Ignore unsupported platform/runtime errors.
    }
    _liveActivityId = null;
  }

  Map<String, dynamic> _liveActivityData(WorkoutSessionState session) {
    final segment = session.routine.segments.isNotEmpty
        ? session.routine.segments[session.currentSegmentIndex]
        : null;
    final progress = session.phaseTotalDuration.inMilliseconds > 0
        ? 1.0 -
            (session.timeRemaining.inMilliseconds /
                session.phaseTotalDuration.inMilliseconds)
        : 0.0;

    return {
      'phase': _phaseLabel(session),
      'segmentName': segment?.name ?? '',
      'remainingSeconds': session.timeRemaining.inSeconds,
      'timeRemaining': _formatTime(session.timeRemaining),
      'heartRate': session.currentHeartRate,
      'progress': progress.clamp(0.0, 1.0),
      'isPaused': session.phase == WorkoutPhase.paused,
    };
  }

  String _phaseLabel(WorkoutSessionState session) {
    return switch (session.phase) {
      WorkoutPhase.work => 'WORK',
      WorkoutPhase.rest => 'REST',
      WorkoutPhase.paused => 'PAUSED',
      WorkoutPhase.completed => 'DONE',
      WorkoutPhase.idle => 'IDLE',
    };
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _saveWorkoutToHealthKit({
    required DateTime startTime,
    required DateTime endTime,
    required int caloriesBurned,
  }) async {
    try {
      await _healthKitService.saveWorkoutSession(
        startTime: startTime,
        endTime: endTime,
        caloriesBurned: caloriesBurned,
      );
    } catch (_) {
      // Ignore authorization/platform errors to avoid blocking session stop.
    }
  }
}

@riverpod
double phaseProgress(PhaseProgressRef ref) {
  final session = ref.watch(workoutSessionProvider);
  if (session.phaseTotalDuration == Duration.zero) return 0;
  final consumed =
      session.phaseTotalDuration.inMilliseconds -
      session.timeRemaining.inMilliseconds;
  return (consumed / session.phaseTotalDuration.inMilliseconds).clamp(0, 1);
}

@riverpod
String formattedTimeRemaining(FormattedTimeRemainingRef ref) {
  final remaining = ref.watch(workoutSessionProvider).timeRemaining;
  final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

@riverpod
String? nextUpLabel(NextUpLabelRef ref) {
  final session = ref.watch(workoutSessionProvider);
  if (session.phase == WorkoutPhase.completed ||
      session.routine.segments.isEmpty) {
    return null;
  }

  if (session.phase == WorkoutPhase.work) {
    final restDuration =
        session.routine.segments[session.currentSegmentIndex].restDuration;
    return 'REST - ${restDuration.inSeconds}S';
  }

  final nextIndex = session.currentSegmentIndex + 1;
  if (nextIndex < session.routine.segments.length) {
    return session.routine.segments[nextIndex].name.toUpperCase();
  }

  if (session.currentRound < session.routine.rounds) {
    return 'ROUND ${session.currentRound + 1}';
  }

  return 'FINISH';
}
