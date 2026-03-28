import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';

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
                colors: [
                  Color(0xFF8A63FF),
                  Color(0xFF4B2067),
                  Color(0xFF1B1734),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
          child: const Text(
            'NexHub Games',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 34,
              letterSpacing: 2.5,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 24,
                  color: Color(0xFF8A63FF),
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
                        const Color(0xFF090814),
                        const Color(0xFF8A63FF),
                        0.5 + 0.5 * sin(_bgController.value * 2 * pi),
                      )!,
                      Color.lerp(
                        const Color(0xFF1B1734),
                        const Color(0xFF00E5FF),
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
          // Glassmorphic grid and content
          Column(
            children: [
              const SizedBox(height: 80),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(32),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 32,
                    mainAxisSpacing: 32,
                  ),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    final isHovered = _hoveredIndex == index;
                    return MouseRegion(
                      onEnter: (_) => setState(() => _hoveredIndex = index),
                      onExit:
                          (_) => setState(() {
                            _hoveredIndex = -1;
                            _tiltX = 0;
                            _tiltY = 0;
                          }),
                      child: Listener(
                        onPointerHover: (event) {
                          if (_hoveredIndex == index) {
                            final box =
                                context.findRenderObject() as RenderBox?;
                            if (box != null) {
                              final local = box.globalToLocal(event.position);
                              final size = box.size;
                              final dx = (local.dx / size.width - 0.5) * 2;
                              final dy = (local.dy / size.height - 0.5) * 2;
                              setState(() {
                                _tiltX = dy * 0.18;
                                _tiltY = -dx * 0.18;
                              });
                            }
                          }
                        },
                        child: GestureDetector(
                          onTap: () {
                            GoRouter.of(
                              context,
                            ).push('/game', extra: game['title']);
                          },
                          child: AnimatedScale(
                            scale: isHovered ? 1.10 : 1.0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        isHovered
                                            ? Colors.cyanAccent.withOpacity(
                                              0.55,
                                            )
                                            : Colors.deepPurpleAccent
                                                .withOpacity(0.18),
                                    blurRadius: isHovered ? 60 : 18,
                                    spreadRadius: isHovered ? 16 : 2,
                                  ),
                                  BoxShadow(
                                    color:
                                        isHovered
                                            ? Colors.blueAccent.withOpacity(
                                              0.22,
                                            )
                                            : Colors.black.withOpacity(0.08),
                                    blurRadius: isHovered ? 80 : 12,
                                    spreadRadius: isHovered ? 18 : 2,
                                  ),
                                ],
                                gradient:
                                    isHovered
                                        ? LinearGradient(
                                          colors: [
                                            Color(0xFF00E5FF),
                                            Color(0xFF8A63FF),
                                            Color(0xFF1B1734),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                        : LinearGradient(
                                          colors: [
                                            Color(0xFF090814),
                                            Color(0xFF8A63FF),
                                            Color(0xFF1B1734),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                border: Border.all(
                                  color:
                                      isHovered
                                          ? Colors.cyanAccent.withOpacity(0.8)
                                          : Colors.white.withOpacity(0.14),
                                  width: isHovered ? 5.0 : 1.5,
                                ),
                                backgroundBlendMode: BlendMode.overlay,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 18,
                                    sigmaY: 18,
                                  ),
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform:
                                        isHovered
                                            ? (Matrix4.identity()
                                              ..setEntry(3, 2, 0.001)
                                              ..rotateX(_tiltX)
                                              ..rotateY(_tiltY))
                                            : Matrix4.identity(),
                                    child: Card(
                                      elevation: isHovered ? 60 : 16,
                                      color: Colors.white.withOpacity(
                                        isHovered ? 0.18 : 0.10,
                                      ),
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 18.0,
                                              bottom: 8.0,
                                            ),
                                            child: SizedBox(
                                              height: 72,
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 400,
                                                ),
                                                curve: Curves.easeInOut,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    if (isHovered)
                                                      BoxShadow(
                                                        color: Colors.cyanAccent
                                                            .withOpacity(0.38),
                                                        blurRadius: 48,
                                                        spreadRadius: 12,
                                                      ),
                                                  ],
                                                ),
                                                child: Image.asset(
                                                  game['image']!,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return Icon(
                                                      Icons.videogame_asset,
                                                      size: 56,
                                                      color: const Color(
                                                        0xFF8A63FF,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            game['title']!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: isHovered ? 28 : 22,
                                              color:
                                                  isHovered
                                                      ? Color(0xFF00E5FF)
                                                      : Color(0xFF8A63FF),
                                              letterSpacing: 1.7,
                                              shadows:
                                                  isHovered
                                                      ? [
                                                        Shadow(
                                                          color: Colors
                                                              .cyanAccent
                                                              .withOpacity(
                                                                0.38,
                                                              ),
                                                          blurRadius: 24,
                                                        ),
                                                      ]
                                                      : [],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6.0,
                                              horizontal: 12.0,
                                            ),
                                            child: Text(
                                              game['description']!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color:
                                                    isHovered
                                                        ? Colors.white
                                                        : Colors.white70,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
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
