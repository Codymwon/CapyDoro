import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final AudioPlayer _player = AudioPlayer();

  AudioService._internal() {
    // Override the default 'assets/' prefix because our folder is 'Assets/'
    _player.audioCache = AudioCache(prefix: 'Assets/');
    _player.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> playWorkToBreak() async {
    await _player.play(AssetSource('worktobreak.mp3'));
  }

  Future<void> playBreakToWork() async {
    await _player.play(AssetSource('breaktowork.mp3'));
  }

  Future<void> playCompletion() async {
    await _player.play(AssetSource('completion.mp3'));
  }
}
