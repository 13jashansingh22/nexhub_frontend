import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'theme/app_theme.dart';

import '../features/portfolio_screen.dart';
import '../features/games/game_router.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const PortfolioScreen()),
    GoRoute(
      path: '/game',
      builder: (context, state) {
        final title =
            state.extra as String? ??
            state.uri.queryParameters['title'] ??
            'Unknown';
        return getGameScreenByTitle(title);
      },
    ),
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
