import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/hub/presentation/game_hub_screen.dart';
import 'theme/app_theme.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const GameHubScreen()),
  ],
);

class NexMeetGamesApp extends StatelessWidget {
  const NexMeetGamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'NexMeet Games',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: _router,
    );
  }
}
