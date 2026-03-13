import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final AudioPlayer _workToBreakPlayer = AudioPlayer();
  final AudioPlayer _breakToWorkPlayer = AudioPlayer();
  final AudioPlayer _completionPlayer = AudioPlayer();

  AudioService._internal();

  Future<void> init() async {
    // Clear old audio cache on startup to reclaim leaked storage (Android bug)
    final cache = AudioCache(prefix: 'Assets/');
    await cache.clearAll();

    _workToBreakPlayer.audioCache = cache;
    _breakToWorkPlayer.audioCache = cache;
    _completionPlayer.audioCache = cache;

    _workToBreakPlayer.setReleaseMode(ReleaseMode.stop);
    _breakToWorkPlayer.setReleaseMode(ReleaseMode.stop);
    _completionPlayer.setReleaseMode(ReleaseMode.stop);

    // Pre-load sources so they are extracted to cache only once.
    await _workToBreakPlayer.setSource(AssetSource('worktobreak.mp3'));
    await _breakToWorkPlayer.setSource(AssetSource('breaktowork.mp3'));
    await _completionPlayer.setSource(AssetSource('completion.mp3'));
  }


  Future<void> playWorkToBreak() async {
    await _workToBreakPlayer.stop();
    await _workToBreakPlayer.resume();
  }

  Future<void> playBreakToWork() async {
    await _breakToWorkPlayer.stop();
    await _breakToWorkPlayer.resume();
  }

  Future<void> playCompletion() async {
    await _completionPlayer.stop();
    await _completionPlayer.resume();
  }
}
