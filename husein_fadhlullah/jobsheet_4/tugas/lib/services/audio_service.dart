import 'package:audioplayers/audioplayers.dart' as ap;
import 'dart:async';

enum PlayerState {
  stopped,
  playing,
  paused,
  loading,
}

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final ap.AudioPlayer _audioPlayer = ap.AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  
  // Stream controllers
  final StreamController<PlayerState> _playerStateController = StreamController<PlayerState>.broadcast();
  final StreamController<Duration> _positionController = StreamController<Duration>.broadcast();
  final StreamController<Duration> _durationController = StreamController<Duration>.broadcast();

  // Getters
  PlayerState get playerState => _playerState;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get isPlaying => _playerState == PlayerState.playing;
  bool get isPaused => _playerState == PlayerState.paused;
  bool get isLoading => _playerState == PlayerState.loading;

  // Streams
  Stream<PlayerState> get playerStateStream => _playerStateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;

  // Initialize the audio service
  Future<void> initialize() async {
    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      switch (state) {
        case ap.PlayerState.playing:
          _updatePlayerState(PlayerState.playing);
          break;
        case ap.PlayerState.paused:
          _updatePlayerState(PlayerState.paused);
          break;
        case ap.PlayerState.stopped:
          _updatePlayerState(PlayerState.stopped);
          break;
        case ap.PlayerState.completed:
          _updatePlayerState(PlayerState.stopped);
          _currentPosition = Duration.zero;
          _positionController.add(_currentPosition);
          break;
        case ap.PlayerState.disposed:
          _updatePlayerState(PlayerState.stopped);
          break;
      }
    });

    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      _positionController.add(position);
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      _durationController.add(duration);
    });
  }

  // Load and play audio from assets
  Future<void> loadAndPlay(String assetPath) async {
    try {
      _updatePlayerState(PlayerState.loading);
      
      await _audioPlayer.setSource(ap.AssetSource(assetPath));
      await _audioPlayer.resume();
      
    } catch (e) {
      print('Error loading audio: $e');
      _updatePlayerState(PlayerState.stopped);
      rethrow;
    }
  }

  // Play/Resume
  Future<void> play() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  // Pause
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  // Stop
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _currentPosition = Duration.zero;
      _positionController.add(_currentPosition);
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  // Toggle play/pause
  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await pause();
    } else if (isPaused) {
      await play();
    } else {
      // If stopped, try to load and play the default song
      await loadAndPlay('audio/im_still_standing.mp3');
    }
  }

  // Seek to position
  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  // Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  // Get current position as percentage (0.0 to 1.0)
  double get progressPercentage {
    if (_totalDuration.inMilliseconds == 0) return 0.0;
    return _currentPosition.inMilliseconds / _totalDuration.inMilliseconds;
  }

  // Get current position in seconds
  int get currentPositionInSeconds => _currentPosition.inSeconds;

  // Format duration to MM:SS
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  // Get formatted current position
  String get formattedCurrentPosition => formatDuration(_currentPosition);

  // Get formatted total duration
  String get formattedTotalDuration => formatDuration(_totalDuration);

  // Get formatted time remaining
  String get formattedTimeRemaining {
    Duration remaining = _totalDuration - _currentPosition;
    return "-${formatDuration(remaining)}";
  }

  // Update player state and notify listeners
  void _updatePlayerState(PlayerState state) {
    _playerState = state;
    _playerStateController.add(state);
  }

  // Dispose
  void dispose() {
    _audioPlayer.dispose();
    _playerStateController.close();
    _positionController.close();
    _durationController.close();
  }
}