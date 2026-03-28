
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ProjectNameSplashScreen extends StatefulWidget {
  final VoidCallback? onFinish;
  const ProjectNameSplashScreen({super.key, this.onFinish});

  @override
  State<ProjectNameSplashScreen> createState() => _ProjectNameSplashScreenState();
}

class _ProjectNameSplashScreenState extends State<ProjectNameSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _opacityAnim = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    Future.delayed(const Duration(seconds: 2), () {
      widget.onFinish?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232526),
      body: Center(
        child: FadeTransition(
          opacity: _opacityAnim,
          child: Text(
            'NexHub Games',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Color(0xFFE040FB),
              letterSpacing: 2.5,
              shadows: [
                Shadow(
                  blurRadius: 24,
                  color: Color(0xFF1976D2),
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoMorphController;
  late Animation<double> _logoMorphAnim;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnim;
  late AnimationController _taglineController;
  late Animation<double> _taglineAnim;
  bool _showParticles = false;
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late AnimationController _glowController;
  late Animation<double> _glowAnim;
  final List<Offset> _particles = [];
  final int _particleCount = 48;

  @override
  void initState() {
    super.initState();
    debugPrint('SplashScreen: initState called');
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Logo morph animation
    _logoMorphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _logoMorphAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoMorphController, curve: Curves.easeInOut),
    );

    // Shimmer sweep animation
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    // Tagline reveal animation
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _taglineAnim = CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeIn,
    );

    // Generate random particles in a circle
    final double radius = 110;
    for (int i = 0; i < _particleCount; i++) {
      final double angle = (i / _particleCount) * 3.14159 * 2;
      _particles.add(
        Offset(
          radius *
              (1.15 * (i % 3 == 0 ? 1 : (i % 2 == 0 ? 0.92 : 0.78))) *
              cos(angle),
          radius *
              (1.15 * (i % 3 == 0 ? 1 : (i % 2 == 0 ? 0.92 : 0.78))) *
              sin(angle),
        ),
      );
    }

    // Sequence: fade in, morph, shimmer, tagline, then burst particles
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 900), () {
      _taglineController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      setState(() {
        _showParticles = true;
      });
    });
    // Fallback: If animation or timer fails, allow manual skip after 3 seconds
    Timer(const Duration(seconds: 2), () {
      debugPrint('SplashScreen: Timer finished, calling onFinish');
      widget.onFinish();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _glowController.dispose();
    _logoMorphController.dispose();
    _shimmerController.dispose();
    _taglineController.dispose();
    super.dispose();
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
              colors: [
                Color(0xFF1B1734),
                Color(0xFF4B2067),
                Color(0xFF8A63FF),
                Color(0xFF090814),
              ],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeIn,
            child: Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _glowAnim,
                  _logoMorphAnim,
                  _shimmerAnim,
                  _taglineAnim,
                ]),
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glowing animated logo circle with extra border
                      Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purpleAccent.withOpacity(
                                0.22 * _glowAnim.value + 0.18,
                              ),
                              blurRadius: 64 * _glowAnim.value + 18,
                              spreadRadius: 12 * _glowAnim.value + 4,
                            ),
                            BoxShadow(
                              color: Colors.deepPurpleAccent.withOpacity(0.22),
                              blurRadius: 32,
                              spreadRadius: 4,
                            ),
                          ],
                          gradient: RadialGradient(
                            colors: [
                              Color(
                                0xFF8A63FF,
                              ).withOpacity(0.22 + 0.18 * _glowAnim.value),
                              Color(0xFF4B2067).withOpacity(0.18),
                              Color(0xFF1B1734).withOpacity(0.10),
                            ],
                            radius: 0.98,
                          ),
                          border: Border.all(
                            color: Color(
                              0xFF8A63FF,
                            ).withOpacity(0.5 + 0.3 * _glowAnim.value),
                            width: 3.5 + 2 * _glowAnim.value,
                          ),
                        ),
                      ),
                      // Particle burst (appears after morph)
                      if (_showParticles)
                        ..._particles.map((offset) {
                          return Positioned(
                            left: 0.0,
                            top: 0.0,
                            child: Transform.translate(
                              offset:
                                  Offset(0, 0) +
                                  offset *
                                      _glowAnim.value *
                                      (1.0 + 0.5 * _logoMorphAnim.value),
                              child: Container(
                                width: 10 + 6 * _glowAnim.value,
                                height: 10 + 6 * _glowAnim.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.lerp(
                                    Colors.cyanAccent,
                                    Colors.deepPurpleAccent,
                                    (_glowAnim.value + offset.dx) % 1.0,
                                  )?.withOpacity(0.18 + 0.18 * _glowAnim.value),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyanAccent.withOpacity(
                                        0.18,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      // Enhanced NexHub branding with morph and shimmer
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated stylized N logo morphing
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [Color(0xFF00E5FF), Color(0xFF8A63FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Morph between N and a circle for a 3D effect
                                Opacity(
                                  opacity: 1.0 - _logoMorphAnim.value,
                                  child: Text(
                                    'N',
                                    style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.cyanAccent.withOpacity(
                                            0.5 * _glowAnim.value,
                                          ),
                                          blurRadius: 32 * _glowAnim.value,
                                        ),
                                        Shadow(
                                          color: Colors.deepPurpleAccent
                                              .withOpacity(0.18),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: _logoMorphAnim.value,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF00E5FF),
                                          Color(0xFF8A63FF),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.cyanAccent.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Shimmer sweep
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: AnimatedBuilder(
                                      animation: _shimmerAnim,
                                      builder: (context, child) {
                                        return CustomPaint(
                                          painter: _ShimmerPainter(
                                            _shimmerAnim.value,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Animated underline
                          AnimatedBuilder(
                            animation: _glowAnim,
                            builder: (context, child) {
                              return Container(
                                width: 60 + 24 * _glowAnim.value,
                                height: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF00E5FF).withOpacity(0.7),
                                      Color(0xFF8A63FF).withOpacity(0.7),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyanAccent.withOpacity(
                                        0.18 + 0.18 * _glowAnim.value,
                                      ),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          // App name - larger, more prominent, with extra glow
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [
                                  Color(0xFF8A63FF),
                                  Color(0xFF4B2067),
                                  Color(0xFF00E5FF),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: Text(
                              'NexHub Games',
                              style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3.2,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.purpleAccent.withOpacity(
                                      0.38 * _glowAnim.value,
                                    ),
                                    blurRadius: 32 * _glowAnim.value,
                                  ),
                                  Shadow(
                                    color: Colors.deepPurpleAccent.withOpacity(
                                      0.18,
                                    ),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Animated tagline reveal
                          ClipRect(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              widthFactor: _taglineAnim.value,
                              child: const Text(
                                'Play. Compete. Enjoy.',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Optional loading indicator
                          SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF00E5FF),
                              ),
                              strokeWidth: 3.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        // Fallback skip button (appears after 3 seconds)
        Positioned(
          bottom: 32,
          right: 32,
          child: Builder(
            builder: (context) {
              return FutureBuilder(
                future: Future.delayed(const Duration(seconds: 3)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 6,
                      ),
                      icon: const Icon(Icons.skip_next),
                      label: const Text('Skip'),
                      onPressed: () {
                        debugPrint('SplashScreen: Skip button pressed');
                        widget.onFinish();
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Custom painter for shimmer sweep
class _ShimmerPainter extends CustomPainter {
  final double shimmerValue;
  _ShimmerPainter(this.shimmerValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.white.withOpacity(0.0),
              Colors.white.withOpacity(0.45),
              Colors.white.withOpacity(0.0),
            ],
            stops: [0.0, 0.5, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            transform: GradientRotation(0.8 * pi),
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final shimmerWidth = size.width * 0.25;
    final shimmerRect = Rect.fromLTWH(
      size.width * shimmerValue - shimmerWidth / 2,
      0,
      shimmerWidth,
      size.height,
    );
    canvas.saveLayer(null, Paint());
    canvas.drawRect(shimmerRect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter oldDelegate) {
    return shimmerValue != oldDelegate.shimmerValue;
  }
}
