import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'game_score.dart';
import 'game_leaderboard.dart';
import 'game_sound.dart';

class FlappyBirdGameScreen extends StatefulWidget {
  const FlappyBirdGameScreen({super.key});

  @override
  State<FlappyBirdGameScreen> createState() => _FlappyBirdGameScreenState();
}

class _FlappyBirdGameScreenState extends State<FlappyBirdGameScreen> {
  static const double gravity = 1.2;
  static const double jumpVelocity = -0.38;
  static const double moveDelta = 0.04;
  static double birdX = 0.2; // Now mutable for left/right
  static const double pipeWidth = 0.15;
  static const double gap = 0.25;
  static const Duration tickRate = Duration(milliseconds: 18);

  final GameScore _score = GameScore();
  final List<Map<String, dynamic>> _leaderboard = [
    {'name': 'Alice', 'score': 15},
    {'name': 'Bob', 'score': 10},
    {'name': 'You', 'score': 0},
  ];

  double _birdY = 0.5;
  double _velocity = 0;
  double _birdX = birdX;
  List<_Pipe> _pipes = [];
  Timer? _timer;
  bool _isGameOver = false;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    _birdY = 0.5;
    _velocity = 0;
    _birdX = birdX;
    _pipes = [_Pipe(x: 1.0, gapY: 0.4), _Pipe(x: 1.5, gapY: 0.6)];
    _score.reset();
    _isGameOver = false;
    _started = false;
    _timer?.cancel();
    setState(() {});
  }

  void _startGame() {
    if (_started) return;
    _started = true;
    _timer = Timer.periodic(tickRate, (_) => _tick());
  }

  void _tick() {
    if (_isGameOver) return;
    setState(() {
      // Fixed timestep for stability
      const double dt = 0.018;
      // Apply gravity
      _velocity += gravity * dt;
      // Clamp velocity for stability
      _velocity = _velocity.clamp(-1.0, 1.0);
      // Update position
      _birdY += _velocity;
      // Clamp bird position to screen
      _birdY = _birdY.clamp(0.0, 1.0);
      for (final pipe in _pipes) {
        pipe.x -= 0.012;
      }
      // Recycle pipes
      if (_pipes.first.x < -pipeWidth) {
        _pipes.removeAt(0);
        _pipes.add(
          _Pipe(x: 1.0, gapY: 0.2 + 0.6 * (UniqueKey().hashCode % 1000) / 1000),
        );
        _score.increment();
        GameSound.play('point.wav');
        _leaderboard[2]['score'] = _score.score;
      }
      // Collision with ground/ceiling
      if (_birdY <= 0 || _birdY >= 1) {
        _gameOver();
        return;
      }
      // Collision with pipes
      for (final pipe in _pipes) {
        if (pipe.x < _birdX + pipeWidth / 2 &&
            pipe.x + pipeWidth > _birdX - pipeWidth / 2) {
          if (_birdY < pipe.gapY - gap / 2 || _birdY > pipe.gapY + gap / 2) {
            _gameOver();
            return;
          }
        }
      }
    });
  }

  void _jump() {
    if (_isGameOver) return;
    _startGame();
    setState(() {
      _velocity = jumpVelocity;
    });
    GameSound.play('jump.wav');
  }

  void _moveUp() {
    if (_isGameOver) return;
    _startGame();
    setState(() {
      _velocity = jumpVelocity;
    });
    GameSound.play('jump.wav');
  }

  void _moveDown() {
    if (_isGameOver) return;
    _startGame();
    setState(() {
      _birdY += moveDelta;
    });
    GameSound.play('jump.wav');
  }

  void _moveLeft() {
    if (_isGameOver) return;
    _startGame();
    setState(() {
      _birdX = (_birdX - moveDelta).clamp(0.0, 1.0);
    });
    GameSound.play('jump.wav');
  }

  void _moveRight() {
    if (_isGameOver) return;
    _startGame();
    setState(() {
      _birdX = (_birdX + moveDelta).clamp(0.0, 1.0);
    });
    GameSound.play('jump.wav');
  }

  void _gameOver() {
    _timer?.cancel();
    setState(() {
      _isGameOver = true;
    });
    GameSound.play('gameover.wav');
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Game Over'),
            content: Text('Your score: ${_score.score}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetGame();
                },
                child: const Text('Restart'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flappy Bird')),
      backgroundColor: Colors.blue.shade50,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Focus(
                  autofocus: true,
                  onKey: (node, event) {
                    if (event is RawKeyDownEvent) {
                      final key = event.logicalKey.keyLabel.toLowerCase();
                      if (key == ' ' ||
                          key == 'w' ||
                          event.logicalKey.keyId == 0x100070052) {
                        _moveUp();
                        return KeyEventResult.handled;
                      } else if (key == 's' ||
                          event.logicalKey.keyId == 0x100070051) {
                        _moveDown();
                        return KeyEventResult.handled;
                      } else if (key == 'a' ||
                          event.logicalKey.keyId == 0x100070050) {
                        _moveLeft();
                        return KeyEventResult.handled;
                      } else if (key == 'd' ||
                          event.logicalKey.keyId == 0x10007004f) {
                        _moveRight();
                        return KeyEventResult.handled;
                      }
                    }
                    return KeyEventResult.ignored;
                  },
                  child: GestureDetector(
                    onTap: _jump,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFB3E5FC), Color(0xFF0288D1)],
                        ),
                      ),
                      child: CustomPaint(
                        painter: _FlappyPainter(
                          _birdY,
                          _pipes,
                          _isGameOver,
                          birdX: _birdX,
                        ),
                        child: Container(),
                      ),
                    ),
                  ),
                ),
                // Floating score overlay
                Positioned(
                  top: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _score,
                      builder:
                          (_, __) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'Score: ${_score.score}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
                // Sun
                const Positioned(
                  top: 30,
                  left: 30,
                  child: Icon(Icons.wb_sunny, size: 48, color: Colors.yellow),
                ),
                // Clouds
                Positioned(
                  top: 60,
                  left: 100,
                  child: Icon(Icons.cloud, size: 40, color: Colors.white70),
                ),
                Positioned(
                  top: 100,
                  right: 60,
                  child: Icon(Icons.cloud, size: 32, color: Colors.white60),
                ),
                // Ground
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 24,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8BC34A), Color(0xFF558B2F)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // On-screen controls
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_drop_up, size: 36),
                      onPressed: _moveUp,
                      tooltip: 'Up',
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_left, size: 36),
                          onPressed: _moveLeft,
                          tooltip: 'Left',
                        ),
                        const SizedBox(width: 24),
                        IconButton(
                          icon: const Icon(Icons.arrow_right, size: 36),
                          onPressed: _moveRight,
                          tooltip: 'Right',
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_drop_down, size: 36),
                      onPressed: _moveDown,
                      tooltip: 'Down',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Leaderboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 1, child: GameLeaderboard(scores: _leaderboard)),
        ],
      ),
    );
  }
}

class _Pipe {
  double x;
  double gapY;
  _Pipe({required this.x, required this.gapY});
}

class _FlappyPainter extends CustomPainter {
  final double birdY;
  final List<_Pipe> pipes;
  final bool isGameOver;
  final double birdX;
  _FlappyPainter(this.birdY, this.pipes, this.isGameOver, {this.birdX = 0.2});

  @override
  void paint(Canvas canvas, Size size) {
    final birdPaint = Paint()..color = isGameOver ? Colors.grey : Colors.orange;
    final beakPaint = Paint()..color = Colors.deepOrange;
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;
    final pipePaint = Paint()..color = Colors.green.shade700;
    final pipeBorder =
        Paint()
          ..color = Colors.green.shade900
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;
    final birdSize = size.height * 0.05;
    final groundHeight = 24.0;
    // Draw pipes (rounded)
    for (final pipe in pipes) {
      final pipeX = pipe.x * size.width;
      final gapTop =
          (pipe.gapY - _FlappyBirdGameScreenState.gap / 2) * size.height;
      final gapBottom =
          (pipe.gapY + _FlappyBirdGameScreenState.gap / 2) * size.height;
      // Top pipe
      final topRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          pipeX,
          0,
          size.width * _FlappyBirdGameScreenState.pipeWidth,
          gapTop,
        ),
        const Radius.circular(12),
      );
      canvas.drawRRect(topRect, pipePaint);
      canvas.drawRRect(topRect, pipeBorder);
      // Bottom pipe
      final bottomRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          pipeX,
          gapBottom,
          size.width * _FlappyBirdGameScreenState.pipeWidth,
          size.height - gapBottom - groundHeight,
        ),
        const Radius.circular(12),
      );
      canvas.drawRRect(bottomRect, pipePaint);
      canvas.drawRRect(bottomRect, pipeBorder);
    }
    // Draw bird (body, beak, eye)
    final bx = birdX * size.width;
    final by = birdY * size.height;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(bx, by),
        width: birdSize,
        height: birdSize,
      ),
      birdPaint,
    );
    // Beak
    final beakPath =
        Path()
          ..moveTo(bx + birdSize / 2, by)
          ..lineTo(bx + birdSize * 0.8, by - birdSize * 0.1)
          ..lineTo(bx + birdSize * 0.8, by + birdSize * 0.1)
          ..close();
    canvas.drawPath(beakPath, beakPaint);
    // Eye
    canvas.drawCircle(
      Offset(bx + birdSize * 0.18, by - birdSize * 0.18),
      birdSize * 0.13,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(bx + birdSize * 0.18, by - birdSize * 0.18),
      birdSize * 0.06,
      pupilPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _FlappyPainter oldDelegate) {
    return oldDelegate.birdY != birdY ||
        oldDelegate.pipes != pipes ||
        oldDelegate.isGameOver != isGameOver;
  }
}
