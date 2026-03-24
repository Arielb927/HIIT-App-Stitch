import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_session_state.freezed.dart';

/// Represents one interval segment in a workout routine.
@freezed
class WorkoutSegment with _$WorkoutSegment {
  const factory WorkoutSegment({
    required String id,
    required String name,
    required Duration workDuration,
    required Duration restDuration,
    String? workPlaylistId,
    String? workPlaylistName,
    String? restPlaylistId,
    String? restPlaylistName,
  }) = _WorkoutSegment;
}

/// A complete workout routine template.
@freezed
class WorkoutRoutine with _$WorkoutRoutine {
  const factory WorkoutRoutine({
    required String id,
    required String title,
    required List<WorkoutSegment> segments,
    @Default(1) int rounds,
  }) = _WorkoutRoutine;
}

/// Which phase the timer is currently in.
enum WorkoutPhase { idle, work, rest, paused, completed }

/// The live state of an in-progress workout session.
@freezed
class WorkoutSessionState with _$WorkoutSessionState {
  const factory WorkoutSessionState({
    /// The routine being executed.
    required WorkoutRoutine routine,

    /// Index of the current segment in [routine.segments].
    @Default(0) int currentSegmentIndex,

    /// Current round (1-based).
    @Default(1) int currentRound,

    /// Whether we are in the work or rest portion of the segment.
    @Default(WorkoutPhase.idle) WorkoutPhase phase,

    /// The active work/rest phase to restore after a pause.
    @Default(WorkoutPhase.idle) WorkoutPhase lastActivePhase,

    /// Time remaining in the current phase interval.
    @Default(Duration.zero) Duration timeRemaining,

    /// Total duration of the current phase interval (for progress ring %).
    @Default(Duration.zero) Duration phaseTotalDuration,

    /// Accumulated calories burned.
    @Default(0) int caloriesBurned,

    /// Latest heart rate reading (BPM).
    @Default(0) int currentHeartRate,

    /// Total elapsed workout time (excludes paused time).
    @Default(Duration.zero) Duration elapsed,
  }) = _WorkoutSessionState;
}

/// Snapshot of the music player synced to the workout.
@freezed
class MusicSyncState with _$MusicSyncState {
  const factory MusicSyncState({
    @Default(false) bool isConnected,
    @Default(false) bool isPlaying,
    @Default('') String currentTrackName,
    @Default('') String currentArtist,
    String? albumArtUrl,

    /// Default playlist assigned to work phases when a segment does not override it.
    String? workPlaylistId,
    String? workPlaylistName,

    /// Default playlist assigned to rest phases when a segment does not override it.
    String? restPlaylistId,
    String? restPlaylistName,

    /// Playlist that should be active once the current transition settles.
    String? pendingPlaylistId,

    /// Playlist currently active in the player.
    String? activePlaylistId,

    /// High-contrast visual + local metronome fail-safe flags.
    @Default(false) bool isFallbackActive,
    @Default(false) bool useVisualBeep,
    @Default(false) bool useLocalMetronome,
    @Default('') String fallbackReason,
    @Default('BEEP') String fallbackLabel,
  }) = _MusicSyncState;
}
