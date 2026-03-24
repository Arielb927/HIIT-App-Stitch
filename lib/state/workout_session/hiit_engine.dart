import 'workout_session_state.dart';

/// Playback instructions for a single workout phase.
class PhasePlaybackCue {
  const PhasePlaybackCue({
    required this.phase,
    required this.segmentId,
    required this.segmentName,
    this.playlistId,
    this.playlistName,
  });

  final WorkoutPhase phase;
  final String segmentId;
  final String segmentName;
  final String? playlistId;
  final String? playlistName;
}

/// Result of advancing the timer through a phase boundary.
class HiitTransition {
  const HiitTransition({
    required this.nextState,
    required this.shouldContinueTicking,
    this.playbackCue,
  });

  final WorkoutSessionState nextState;
  final bool shouldContinueTicking;
  final PhasePlaybackCue? playbackCue;
}

/// Core HIIT interval engine for segmented work/rest routines.
abstract final class HiitEngine {
  static WorkoutSessionState initialState(WorkoutRoutine routine) {
    final firstSegment = routine.segments.first;
    return WorkoutSessionState(
      routine: routine,
      currentSegmentIndex: 0,
      currentRound: 1,
      phase: WorkoutPhase.work,
      lastActivePhase: WorkoutPhase.work,
      timeRemaining: firstSegment.workDuration,
      phaseTotalDuration: firstSegment.workDuration,
    );
  }

  static PhasePlaybackCue cueForState(WorkoutSessionState state) {
    final segment = state.routine.segments[state.currentSegmentIndex];
    return cueForSegment(
      segment: segment,
      phase: state.phase == WorkoutPhase.paused ? state.lastActivePhase : state.phase,
    );
  }

  static PhasePlaybackCue cueForSegment({
    required WorkoutSegment segment,
    required WorkoutPhase phase,
  }) {
    return switch (phase) {
      WorkoutPhase.work => PhasePlaybackCue(
          phase: phase,
          segmentId: segment.id,
          segmentName: segment.name,
          playlistId: segment.workPlaylistId,
          playlistName: segment.workPlaylistName,
        ),
      WorkoutPhase.rest => PhasePlaybackCue(
          phase: phase,
          segmentId: segment.id,
          segmentName: segment.name,
          playlistId: segment.restPlaylistId,
          playlistName: segment.restPlaylistName,
        ),
      _ => PhasePlaybackCue(
          phase: phase,
          segmentId: segment.id,
          segmentName: segment.name,
        ),
    };
  }

  static HiitTransition advance(
    WorkoutSessionState state, {
    Duration? elapsed,
  }) {
    final resolvedElapsed = elapsed ?? state.elapsed;

    if (state.phase == WorkoutPhase.work) {
      return _normalizeZeroDurationPhases(
        state.copyWith(
          phase: WorkoutPhase.rest,
          lastActivePhase: WorkoutPhase.rest,
          timeRemaining: state.routine.segments[state.currentSegmentIndex].restDuration,
          phaseTotalDuration:
              state.routine.segments[state.currentSegmentIndex].restDuration,
          elapsed: resolvedElapsed,
        ),
      );
    }

    final nextIndex = state.currentSegmentIndex + 1;
    if (nextIndex < state.routine.segments.length) {
      final nextSegment = state.routine.segments[nextIndex];
      return _normalizeZeroDurationPhases(
        state.copyWith(
          currentSegmentIndex: nextIndex,
          phase: WorkoutPhase.work,
          lastActivePhase: WorkoutPhase.work,
          timeRemaining: nextSegment.workDuration,
          phaseTotalDuration: nextSegment.workDuration,
          elapsed: resolvedElapsed,
        ),
      );
    }

    if (state.currentRound < state.routine.rounds) {
      final firstSegment = state.routine.segments.first;
      return _normalizeZeroDurationPhases(
        state.copyWith(
          currentSegmentIndex: 0,
          currentRound: state.currentRound + 1,
          phase: WorkoutPhase.work,
          lastActivePhase: WorkoutPhase.work,
          timeRemaining: firstSegment.workDuration,
          phaseTotalDuration: firstSegment.workDuration,
          elapsed: resolvedElapsed,
        ),
      );
    }

    return HiitTransition(
      nextState: state.copyWith(
        phase: WorkoutPhase.completed,
        timeRemaining: Duration.zero,
        phaseTotalDuration: Duration.zero,
        elapsed: resolvedElapsed,
      ),
      shouldContinueTicking: false,
    );
  }

  static HiitTransition _normalizeZeroDurationPhases(WorkoutSessionState state) {
    if (state.phase == WorkoutPhase.completed) {
      return HiitTransition(
        nextState: state,
        shouldContinueTicking: false,
      );
    }

    if (state.phaseTotalDuration > Duration.zero) {
      return HiitTransition(
        nextState: state,
        shouldContinueTicking: true,
        playbackCue: cueForState(state),
      );
    }

    return advance(state, elapsed: state.elapsed);
  }
}
