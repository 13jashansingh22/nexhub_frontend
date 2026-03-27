import 'package:flutter/material.dart';
import 'games/game_router.dart';

class PortfolioScreen extends StatelessWidget {
  static const List<Map<String, String>> games = [
    {
      'title': 'Snake',
      'image': 'assets/snake.png',
      'description': 'Classic snake game.',
    },
    {
      'title': 'Flappy Bird',
      'image': 'assets/flappy_bird.png',
      'description': 'Tap to fly and avoid pipes.',
    },
    {
      'title': 'Tic Tac Toe',
      'image': 'assets/tic_tac_toe.png',
      'description': 'Play Xs and Os.',
    },
    {
      'title': '2048',
      'image': 'assets/2048.png',
      'description': 'Join the numbers and get to 2048!',
    },
    {
      'title': 'Sudoku',
      'image': 'assets/sudoku.png',
      'description': 'Fill the grid with numbers 1-9.',
    },
    {
      'title': 'Memory Match',
      'image': 'assets/memory.png',
      'description': 'Test your memory skills.',
    },
    {
      'title': 'Chess',
      'image': 'assets/chess.png',
      'description': 'Classic chess game.',
    },
    {
      'title': 'Minesweeper',
      'image': 'assets/minesweeper.png',
      'description': 'Find all the mines!',
    },
    {
      'title': 'Pong',
      'image': 'assets/pong.png',
      'description': 'Retro paddle game.',
    },
    {
      'title': 'Breakout',
      'image': 'assets/breakout.png',
      'description': 'Break all the bricks!',
    },
    {
      'title': 'Coming Soon',
      'image': 'assets/coming_soon.png',
      'description': 'More games on the way!',
    },
  ];

  const PortfolioScreen({super.key});

  IconData _getGameIcon(String title) {
    switch (title) {
      case 'Snake':
        return Icons.settings_ethernet;
      case 'Flappy Bird':
        return Icons.flight;
      case 'Tic Tac Toe':
        return Icons.close;
      case '2048':
        return Icons.grid_4x4;
      case 'Sudoku':
        return Icons.grid_on;
      case 'Memory Match':
        return Icons.memory;
      case 'Chess':
        return Icons.extension; // No chess icon in default set
      case 'Minesweeper':
        return Icons.bug_report;
      case 'Pong':
        return Icons.sports_tennis;
      case 'Breakout':
        return Icons.sports_baseball;
      default:
        return Icons.videogame_asset;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF090814), Color(0xFF8A63FF), Color(0xFF1B1734)],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              padding: const EdgeInsets.only(top: 32, left: 24, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NexHub Games',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          foreground:
                              Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color(0xFF8A63FF),
                                    Color(0xFF00E5FF),
                                  ],
                                ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Play. Compete. Enjoy.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('About Games'),
                                  content: const Text(
                                    'Explore and play all games!',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                          );
                        },
                        child: const Text('About'),
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF8A63FF),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Sign In/Sign Up'),
                                  content: const Text(
                                    'Sign in/up is optional!',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                          );
                        },
                        child: const Text('Sign In/Up'),
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF00E5FF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return GestureDetector(
                      onTap: () {
                        // Directly push the game screen for reliability
                        final screen = getGameScreenByTitle(
                          game['title'] ?? '',
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => screen),
                        );
                      },
                      child: Card(
                        elevation: 8,
                        color: Colors.white.withOpacity(0.06),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 18.0,
                                bottom: 8.0,
                              ),
                              child: SizedBox(
                                height: 48,
                                child: Image.asset(
                                  game['image']!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      _getGameIcon(game['title'] ?? ''),
                                      size: 40,
                                      color: const Color(0xFF8A63FF),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Text(
                              game['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xFF8A63FF),
                                letterSpacing: 1.5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 8.0,
                              ),
                              child: Text(
                                game['description']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
