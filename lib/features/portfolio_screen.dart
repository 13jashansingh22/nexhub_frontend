import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'package:go_router/go_router.dart';

const _portfolioFont = 'Poppins';
const _primaryColor = Color(0xFF1976D2); // Blue
const _accentColor = Color(0xFFE040FB); // Pink
const _bgGradient1 = Color(0xFF232526);
const _bgGradient2 = Color(0xFF1976D2);
const _bgGradient3 = Color(0xFFE040FB);

// Short horizontal game portfolio widget
class ShortGamePortfolio extends StatelessWidget {
  final List<Map<String, String>> games;
  final void Function(String title)? onGameTap;
  const ShortGamePortfolio({super.key, required this.games, this.onGameTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: games.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final game = games[index];
          return GestureDetector(
            onTap: () => onGameTap?.call(game['title'] ?? ''),
            child: Container(
              width: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _primaryColor.withOpacity(0.18)),
                boxShadow: [
                  BoxShadow(
                    color: _accentColor.withOpacity(0.18),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 48,
                    child: Image.asset(
                      game['image'] ?? '',
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) => Icon(
                            Icons.videogame_asset,
                            size: 36,
                            color: _accentColor,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game['title'] ?? '',
                    style: const TextStyle(
                      fontFamily: _portfolioFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: _primaryColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _Particle {
  double x, y, dx, dy, radius, opacity;
  Color color;
  _Particle(
    this.x,
    this.y,
    this.dx,
    this.dy,
    this.radius,
    this.opacity,
    this.color,
  );
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> games = [
    {
      'title': 'Snake',
      'image': 'assets/snake.png',
      'description': 'Classic snake game.',
    },
    {
      'title': 'Asteroids',
      'image': 'assets/asteroids.png',
      'description': 'Dodge and destroy asteroids in space!',
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

  int _hoveredIndex = -1;
  double _tiltX = 0;
  double _tiltY = 0;
  late AnimationController _bgController;
  List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _bgController =
        AnimationController(vsync: this, duration: const Duration(seconds: 60))
          ..addListener(_updateParticles)
          ..repeat();
    _initParticles();
  }

  void _initParticles() {
    final random = Random();
    _particles = List.generate(36, (i) {
      final radius = random.nextDouble() * 2.5 + 1.5;
      final x = random.nextDouble() * 600;
      final y = random.nextDouble() * 1200;
      final dx = (random.nextDouble() - 0.5) * 0.7;
      final dy = (random.nextDouble() - 0.5) * 0.7;
      final opacity = random.nextDouble() * 0.5 + 0.2;
      final color =
          Color.lerp(
            Colors.cyanAccent,
            Colors.deepPurpleAccent,
            random.nextDouble(),
          )!;
      return _Particle(x, y, dx, dy, radius, opacity, color);
    });
  }

  void _updateParticles() {
    final random = Random();
    for (final p in _particles) {
      p.x += p.dx;
      p.y += p.dy;
      if (p.x < 0 || p.x > 600) {
        p.dx = -p.dx + (random.nextDouble() - 0.5) * 0.1;
      }
      if (p.y < 0 || p.y > 1200) {
        p.dy = -p.dy + (random.nextDouble() - 0.5) * 0.1;
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
                colors: [_primaryColor, _accentColor, _bgGradient1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
          child: const Text(
            'NexHub Games',
            style: TextStyle(
              fontFamily: _portfolioFont,
              fontWeight: FontWeight.bold,
              fontSize: 34,
              letterSpacing: 2.5,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 24,
                  color: _primaryColor,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(
                        _bgGradient1,
                        _primaryColor,
                        0.5 + 0.5 * sin(_bgController.value * 2 * pi),
                      )!,
                      Color.lerp(
                        _bgGradient2,
                        _accentColor,
                        0.5 + 0.5 * cos(_bgController.value * 2 * pi),
                      )!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
          // Particle effect overlay
          IgnorePointer(
            child: CustomPaint(
              painter: _ParticlePainter(_particles),
              size: Size.infinite,
            ),
          ),
          // Short horizontal portfolio at the top
          Column(
            children: [
              const SizedBox(height: 80),
              ShortGamePortfolio(
                games: games.take(6).toList(),
                onGameTap: (title) {
                  GoRouter.of(context).push('/game', extra: title);
                },
              ),
              // Expanded grid (optional, can be removed for only short portfolio)
              // Expanded(
              //   child: Container(),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter(this.particles);
  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint =
          Paint()
            ..color = p.color.withOpacity(p.opacity)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset(p.x, p.y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
