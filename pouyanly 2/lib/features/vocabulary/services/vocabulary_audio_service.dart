import 'package:flutter_tts/flutter_tts.dart';

/// Uses the device's installed English speech engine; no audio files or
/// network connection are required when an offline English voice is installed.
class VocabularyAudioService {
  VocabularyAudioService._();

  static final VocabularyAudioService instance = VocabularyAudioService._();
  final FlutterTts _tts = FlutterTts();

  Future<bool> speak(String text, {double rate = 0.42}) async {
    final value = text.trim();
    if (value.isEmpty) return false;
    try {
      await _tts.stop();
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(rate);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      await _tts.speak(value);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {
      // A missing or unavailable system TTS engine should not crash the app.
    }
  }
}
