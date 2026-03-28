import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class AsteroidsGameScreen extends StatefulWidget {
  const AsteroidsGameScreen({super.key});

  @override
  State<AsteroidsGameScreen> createState() => _AsteroidsGameScreenState();
}

class _AsteroidsGameScreenState extends State<AsteroidsGameScreen> {
  static const int numAsteroids = 6;
  static const double shipSize = 32;
  static const double asteroidSize = 40;
  static const double bulletSize = 8;
  static const double shipSpeed = 4;
  static const double bulletSpeed = 8;
  static const double asteroidSpeed = 2.2;
  static const Duration tickRate = Duration(milliseconds: 16);

  late Timer _timer;
  double _shipX = 200;
  double _shipY = 400;
  double _shipAngle = 0;
  List<_Asteroid> _asteroids = [];
  final List<_Bullet> _bullets = [];
  int _score = 0;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
    _timer = Timer.periodic(tickRate, _update);
  }

  void _resetGame() {
    _shipX = 200;
    _shipY = 400;
    _shipAngle = 0;
    _score = 0;
    _gameOver = false;
    _bullets.clear();
    _asteroids = List.generate(numAsteroids, (i) => _Asteroid.random());
  }

  void _update(Timer timer) {
    if (_gameOver) return;
    setState(() {
      // Move asteroids
      for (final a in _asteroids) {
        a.x += a.dx;
        a.y += a.dy;
        if (a.x < 0) a.x += 400;
        if (a.x > 400) a.x -= 400;
        if (a.y < 0) a.y += 800;
        if (a.y > 800) a.y -= 800;
      }
      // Move bullets
      _bullets.removeWhere((b) => b.x < 0 || b.x > 400 || b.y < 0 || b.y > 800);
      for (final b in _bullets) {
        b.x += bulletSpeed * cos(b.angle);
        b.y += bulletSpeed * sin(b.angle);
      }
      // Check collisions
      for (final b in _bullets) {
        for (final a in _asteroids) {
          if ((b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y) <
              (asteroidSize / 2) * (asteroidSize / 2)) {
            a.hit = true;
            b.hit = true;
            _score += 10;
          }
        }
      }
      _bullets.removeWhere((b) => b.hit);
      _asteroids.removeWhere((a) => a.hit);
      // Respawn asteroids
      while (_asteroids.length < numAsteroids) {
        _asteroids.add(_Asteroid.random());
      }
      // Check ship collision
      for (final a in _asteroids) {
        if ((_shipX - a.x) * (_shipX - a.x) + (_shipY - a.y) * (_shipY - a.y) <
            (asteroidSize / 2 + shipSize / 2) *
                (asteroidSize / 2 + shipSize / 2)) {
          _gameOver = true;
        }
      }
    });
  }

  void _onLeft() {
    setState(() {
      _shipAngle -= pi / 12;
    });
  }

  void _onRight() {
    setState(() {
      _shipAngle += pi / 12;
    });
  }

  void _onThrust() {
    setState(() {
      _shipX += shipSpeed * cos(_shipAngle);
      _shipY += shipSpeed * sin(_shipAngle);
      if (_shipX < 0) _shipX += 400;
      if (_shipX > 400) _shipX -= 400;
      if (_shipY < 0) _shipY += 800;
      if (_shipY > 800) _shipY -= 800;
    });
  }

  void _onFire() {
    setState(() {
      _bullets.add(
        _Bullet(
          x: _shipX + shipSize / 2 * cos(_shipAngle),
          y: _shipY + shipSize / 2 * sin(_shipAngle),
          angle: _shipAngle,
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _AsteroidsPainter(
                shipX: _shipX,
                shipY: _shipY,
                shipAngle: _shipAngle,
                asteroids: _asteroids,
                bullets: _bullets,
                score: _score,
                gameOver: _gameOver,
              ),
            ),
          ),
          if (_gameOver)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Game Over',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Score: $_score',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _resetGame,
                    child: const Text('Restart'),
                  ),
                ],
              ),
            ),
          Positioned(
            left: 10,
            bottom: 20,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.rotate_left, color: Colors.white),
                  onPressed: _onLeft,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_upward, color: Colors.white),
                  onPressed: _onThrust,
                ),
                IconButton(
                  icon: const Icon(Icons.rotate_right, color: Colors.white),
                  onPressed: _onRight,
                ),
                IconButton(
                  icon: const Icon(Icons.circle, color: Colors.white),
                  onPressed: _onFire,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Asteroid {
  double x, y, dx, dy;
  bool hit = false;
  _Asteroid({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
  });
  static final _rand = Random();
  factory _Asteroid.random() {
    return _Asteroid(
      x: _rand.nextDouble() * 400,
      y: _rand.nextDouble() * 800,
      dx: (_rand.nextDouble() - 0.5) * 4,
      dy: (_rand.nextDouble() - 0.5) * 4,
    );
  }
}

class _Bullet {
  double x, y, angle;
  bool hit = false;
  _Bullet({required this.x, required this.y, required this.angle});
}

class _AsteroidsPainter extends CustomPainter {
  final double shipX, shipY, shipAngle;
  final List<_Asteroid> asteroids;
  final List<_Bullet> bullets;
  final int score;
  final bool gameOver;
  _AsteroidsPainter({
    required this.shipX,
    required this.shipY,
    required this.shipAngle,
    required this.asteroids,
    required this.bullets,
    required this.score,
    required this.gameOver,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // Draw ship
    paint.color = Colors.cyanAccent;
    final shipPath =
        Path()
          ..moveTo(shipX + 20 * cos(shipAngle), shipY + 20 * sin(shipAngle))
          ..lineTo(
            shipX + 12 * cos(shipAngle + 2.5),
            shipY + 12 * sin(shipAngle + 2.5),
          )
          ..lineTo(
            shipX + 12 * cos(shipAngle - 2.5),
            shipY + 12 * sin(shipAngle - 2.5),
          )
          ..close();
    canvas.drawPath(shipPath, paint);
    // Draw asteroids
    paint.color = Colors.grey;
    for (final a in asteroids) {
      canvas.drawCircle(Offset(a.x, a.y), 20, paint);
    }
    // Draw bullets
    paint.color = Colors.yellowAccent;
    for (final b in bullets) {
      canvas.drawCircle(Offset(b.x, b.y), 4, paint);
    }
    // Draw score
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Score: $score',
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, const Offset(10, 10));
    // Draw game over
    if (gameOver) {
      final goPainter = TextPainter(
        text: const TextSpan(
          text: 'Game Over',
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      goPainter.paint(
        canvas,
        Offset(
          size.width / 2 - goPainter.width / 2,
          size.height / 2 - goPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
