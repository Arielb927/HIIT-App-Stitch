import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../workout_session/hiit_engine.dart';
import '../workout_session/workout_session_state.dart';
import 'local_metronome_controller.dart';
import 'spotify_web_playback_sdk.dart';

part 'music_player_provider.g.dart';

/// Manages music playback state and exact phase-boundary transitions.
@riverpod
class MusicPlayer extends _$MusicPlayer {
  @override
  MusicSyncState build() {
    return const MusicSyncState();
  }

  void setWorkPlaylist(String playlistId, {String? playlistName}) {
    state = state.copyWith(
      workPlaylistId: playlistId,
      workPlaylistName: playlistName,
    );
  }

  void setRestPlaylist(String playlistId, {String? playlistName}) {
    state = state.copyWith(
      restPlaylistId: playlistId,
      restPlaylistName: playlistName,
    );
  }

  Future<void> togglePlayPause() async {
    final spotify = ref.read(spotifyWebPlaybackSdkProvider);
    if (state.isPlaying) {
      await spotify.pause();
      ref.read(localMetronomeControllerProvider).stop();
    } else {
      await spotify.resume();
    }

    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  Future<void> skipNext() {
    return ref.read(spotifyWebPlaybackSdkProvider).skipNext();
  }

  Future<void> skipPrevious() {
    return ref.read(spotifyWebPlaybackSdkProvider).skipPrevious();
  }

  void setConnected(bool connected) {
    state = state.copyWith(isConnected: connected);
  }

  /// Called by the workout timer the moment a countdown hits 0.
  Future<void> handleTimerHitZero(PhasePlaybackCue cue) async {
    final playlistId = _playlistForCue(cue);
    state = state.copyWith(
      pendingPlaylistId: playlistId,
      isFallbackActive: false,
      useVisualBeep: false,
      useLocalMetronome: false,
      fallbackReason: '',
      fallbackLabel: 'BEEP',
    );

    if (!state.isConnected || playlistId == null || playlistId.isEmpty) {
      await _activateFailSafe(
        reason: !state.isConnected
            ? 'Spotify is disconnected during the phase change.'
            : 'No playlist is assigned for ${cue.phase.name.toUpperCase()}.',
      );
      return;
    }

    final result =
        await ref.read(spotifyWebPlaybackSdkProvider).playPlaylist(playlistId);

    if (!result.didLoadTrack || result.track == null) {
      await _activateFailSafe(
        reason: result.failureReason ??
            'Spotify failed to load a track for ${cue.phase.name.toUpperCase()}.',
      );
      return;
    }

    ref.read(localMetronomeControllerProvider).stop();
    state = state.copyWith(
      isPlaying: true,
      currentTrackName: result.track!.trackName,
      currentArtist: result.track!.artistName,
      albumArtUrl: result.track!.albumArtUrl,
      pendingPlaylistId: null,
      activePlaylistId: playlistId,
      isFallbackActive: false,
      useVisualBeep: false,
      useLocalMetronome: false,
      fallbackReason: '',
    );
  }

  Future<void> pauseForWorkout() async {
    await ref.read(spotifyWebPlaybackSdkProvider).pause();
    ref.read(localMetronomeControllerProvider).stop();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> resumeForWorkout(PhasePlaybackCue cue) {
    return handleTimerHitZero(cue);
  }

  Future<void> completeWorkout() async {
    await ref.read(spotifyWebPlaybackSdkProvider).pause();
    ref.read(localMetronomeControllerProvider).stop();
    state = state.copyWith(
      isPlaying: false,
      pendingPlaylistId: null,
      isFallbackActive: false,
      useVisualBeep: false,
      useLocalMetronome: false,
      fallbackReason: '',
    );
  }

  String? _playlistForCue(PhasePlaybackCue cue) {
    return switch (cue.phase) {
      WorkoutPhase.work => cue.playlistId ?? state.workPlaylistId,
      WorkoutPhase.rest => cue.playlistId ?? state.restPlaylistId,
      _ => cue.playlistId,
    };
  }

  Future<void> _activateFailSafe({required String reason}) async {
    await ref.read(localMetronomeControllerProvider).start();
    state = state.copyWith(
      isPlaying: true,
      currentTrackName: 'BEEP',
      currentArtist: 'LOCAL METRONOME',
      albumArtUrl: null,
      pendingPlaylistId: null,
      isFallbackActive: true,
      useVisualBeep: true,
      useLocalMetronome: true,
      fallbackReason: reason,
      fallbackLabel: 'BEEP',
    );
  }
}
