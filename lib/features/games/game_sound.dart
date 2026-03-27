import 'package:flutter/services.dart';

class GameSound {
  static Future<void> play(String asset) async {
    // Placeholder: Use a package like audioplayers for real sound
    // await AudioPlayer().play(AssetSource(asset));
    // For now, just vibrate as a placeholder
    HapticFeedback.mediumImpact();
  }
}
