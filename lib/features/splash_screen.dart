import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';

import '../app/theme/app_palette.dart';

class ProjectNameSplashScreen extends StatefulWidget {
  final VoidCallback? onFinish;
  const ProjectNameSplashScreen({super.key, this.onFinish});

  @override
  State<ProjectNameSplashScreen> createState() =>
      _ProjectNameSplashScreenState();
}

class _ProjectNameSplashScreenState extends State<ProjectNameSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;
  Timer? _finishTimer;
  Timer? _skipTimer;
  bool _canSkip = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
    _skipTimer = Timer(const Duration(milliseconds: 1300), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _canSkip = true;
      });
    });
    _finishTimer = Timer(const Duration(milliseconds: 2400), _completeSplash);
  }

  @override
  void dispose() {
    _finishTimer?.cancel();
    _skipTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _completeSplash() {
    if (!mounted) {
      return;
    }
    _finishTimer?.cancel();
    _skipTimer?.cancel();
    widget.onFinish?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.bgDeep,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(gradient: AppGradients.appBackground),
          ),
          Positioned(
            left: -120,
            top: -80,
            child: _GlowOrb(
              color: AppPalette.purple.withOpacity(0.34),
              size: 260,
            ),
          ),
          Positioned(
            right: -100,
            bottom: -110,
            child: _GlowOrb(
              color: AppPalette.cyan.withOpacity(0.22),
              size: 240,
            ),
          ),
          Positioned(
            right: 28,
            top: 72,
            child: _GlowOrb(
              color: AppPalette.pink.withOpacity(0.20),
              size: 120,
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 32,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppGradients.glass,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.14),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.28),
                              blurRadius: 40,
                              offset: const Offset(0, 22),
                            ),
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _pulseAnim,
                          builder: (context, child) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Transform.scale(
                                  scale: 0.96 + _pulseAnim.value * 0.06,
                                  child: Container(
                                    width: 134,
                                    height: 134,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppGradients.hero,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppPalette.cyan.withOpacity(
                                            0.28 + 0.12 * _pulseAnim.value,
                                          ),
                                          blurRadius: 42,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppPalette.bgDeep.withOpacity(
                                          0.32,
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.18),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'N',
                                          style: TextStyle(
                                            fontSize: 68,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            letterSpacing: -3,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 20,
                                                color: Colors.black54,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                const Text(
                                  'NexHub Games',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    color: AppPalette.textPrimary,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Play. Compete. Discover.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.4,
                                    color: AppPalette.textMuted.withOpacity(
                                      0.95,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    minHeight: 7,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.08,
                                    ),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppPalette.cyan,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Loading your arcade hub',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppPalette.textMuted.withOpacity(
                                      0.85,
                                    ),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                AnimatedOpacity(
                                  opacity: _canSkip ? 1 : 0,
                                  duration: const Duration(milliseconds: 250),
                                  child: TextButton.icon(
                                    onPressed:
                                        _canSkip ? _completeSplash : null,
                                    icon: const Icon(Icons.skip_next_rounded),
                                    label: const Text('Skip intro'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.white.withOpacity(
                                        0.08,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withOpacity(0.02)]),
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
