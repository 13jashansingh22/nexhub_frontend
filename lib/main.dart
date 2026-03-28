import 'package:flutter/material.dart';
import 'app/app.dart';

import 'features/splash_screen.dart';

import 'features/splash_screen.dart' show ProjectNameSplashScreen;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppWithSplash());
}

class AppWithSplash extends StatefulWidget {
  const AppWithSplash({super.key});

  @override
  State<AppWithSplash> createState() => _AppWithSplashState();
}

class _AppWithSplashState extends State<AppWithSplash> {
  bool _showSplash = true;

  void _finishSplash() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash
        ? ProjectNameSplashScreen(onFinish: _finishSplash)
        : const NexMeetGamesApp();
  }
}
