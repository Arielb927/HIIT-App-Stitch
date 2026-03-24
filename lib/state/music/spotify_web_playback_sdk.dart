import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spotify_web_playback_sdk.g.dart';

class SpotifyTrackSnapshot {
  const SpotifyTrackSnapshot({
    required this.trackName,
    required this.artistName,
    this.albumArtUrl,
  });

  final String trackName;
  final String artistName;
  final String? albumArtUrl;
}

class SpotifyPlaylistLoadResult {
  const SpotifyPlaylistLoadResult._({
    required this.didLoadTrack,
    this.track,
    this.failureReason,
  });

  const SpotifyPlaylistLoadResult.success(SpotifyTrackSnapshot track)
      : this._(
          didLoadTrack: true,
          track: track,
        );

  const SpotifyPlaylistLoadResult.failed(String failureReason)
      : this._(
          didLoadTrack: false,
          failureReason: failureReason,
        );

  final bool didLoadTrack;
  final SpotifyTrackSnapshot? track;
  final String? failureReason;
}

/// Adapter around the Spotify Web Playback SDK.
///
/// The hook points are intentionally explicit so a real JS bridge can be
/// attached without changing the music/session providers.
abstract class SpotifyWebPlaybackSdk {
  Future<SpotifyPlaylistLoadResult> playPlaylist(String playlistId);
  Future<void> pause();
  Future<void> resume();
  Future<void> skipNext();
  Future<void> skipPrevious();
}

typedef SpotifyPlaylistLoader = Future<SpotifyTrackSnapshot?> Function(
  String playlistId,
);
typedef SpotifyVoidCommand = Future<void> Function();

class SpotifyWebPlaybackSdkBridge implements SpotifyWebPlaybackSdk {
  SpotifyWebPlaybackSdkBridge({
    SpotifyPlaylistLoader? playPlaylist,
    SpotifyVoidCommand? pause,
    SpotifyVoidCommand? resume,
    SpotifyVoidCommand? skipNext,
    SpotifyVoidCommand? skipPrevious,
  })  : _playPlaylist = playPlaylist,
        _pause = pause,
        _resume = resume,
        _skipNext = skipNext,
        _skipPrevious = skipPrevious;

  final SpotifyPlaylistLoader? _playPlaylist;
  final SpotifyVoidCommand? _pause;
  final SpotifyVoidCommand? _resume;
  final SpotifyVoidCommand? _skipNext;
  final SpotifyVoidCommand? _skipPrevious;

  @override
  Future<SpotifyPlaylistLoadResult> playPlaylist(String playlistId) async {
    if (_playPlaylist == null) {
      return const SpotifyPlaylistLoadResult.failed(
        'Spotify Web Playback SDK is not configured.',
      );
    }

    try {
      final track = await _playPlaylist(playlistId).timeout(
        const Duration(seconds: 2),
      );
      if (track == null) {
        return const SpotifyPlaylistLoadResult.failed(
          'Spotify did not load a track before the 2 second deadline.',
        );
      }
      return SpotifyPlaylistLoadResult.success(track);
    } on TimeoutException {
      return const SpotifyPlaylistLoadResult.failed(
        'Spotify track load timed out after 2 seconds.',
      );
    } catch (_) {
      return const SpotifyPlaylistLoadResult.failed(
        'Spotify API request failed during playlist transition.',
      );
    }
  }

  @override
  Future<void> pause() => _pause?.call() ?? Future.value();

  @override
  Future<void> resume() => _resume?.call() ?? Future.value();

  @override
  Future<void> skipNext() => _skipNext?.call() ?? Future.value();

  @override
  Future<void> skipPrevious() => _skipPrevious?.call() ?? Future.value();
}

@riverpod
SpotifyWebPlaybackSdk spotifyWebPlaybackSdk(SpotifyWebPlaybackSdkRef ref) {
  return SpotifyWebPlaybackSdkBridge();
}
