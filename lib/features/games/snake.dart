import 'package:flutter/material.dart';
import 'dart:async';
import 'game_score.dart';
import 'game_leaderboard.dart';
import 'game_sound.dart';
import 'package:flutter/services.dart';

enum Direction { up, down, left, right }

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  static const int rowCount = 20;
  static const int colCount = 20;
  static const Duration tickRate = Duration(milliseconds: 180);

  final GameScore _score = GameScore();
  final List<Map<String, dynamic>> _leaderboard = [
    {'name': 'Alice', 'score': 12},
    {'name': 'Bob', 'score': 8},
    {'name': 'You', 'score': 0},
  ];

  List<Offset> _snake = [const Offset(10, 10)];
  Direction _direction = Direction.right;
  Offset _food = const Offset(5, 5);
  Timer? _timer;
  bool _isGameOver = false;

  // Start or restart the game
  void _startGame() {
    setState(() {
      _snake = [const Offset(10, 10)];
      _direction = Direction.right;
      _food = _randomFood();
      _score.reset();
      _leaderboard[2]['score'] = 0;
      _isGameOver = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(tickRate, (_) {
      if (!_isGameOver) {
        _moveSnake();
      }
    });
  }

  // Generate a new food position not occupied by the snake
  Offset _randomFood() {
    final random =
        (int max) =>
            (max *
                    (new DateTime.now().microsecondsSinceEpoch % 1000000) /
                    1000000)
                .floor();
    Offset pos;
    do {
      pos = Offset(random(colCount).toDouble(), random(rowCount).toDouble());
    } while (_snake.contains(pos));
    return pos;
  }

  void _moveSnake() {
    final head = _snake.first;
    Offset newHead;
    switch (_direction) {
      case Direction.up:
        newHead = Offset(head.dx, head.dy - 1);
        break;
      case Direction.down:
        newHead = Offset(head.dx, head.dy + 1);
        break;
      case Direction.left:
        newHead = Offset(head.dx - 1, head.dy);
        break;
      case Direction.right:
        newHead = Offset(head.dx + 1, head.dy);
        break;
    }
    // Check collision
    if (newHead.dx < 0 ||
        newHead.dx >= colCount ||
        newHead.dy < 0 ||
        newHead.dy >= rowCount ||
        _snake.contains(newHead)) {
      _gameOver();
      return;
    }
    setState(() {
      _snake = [newHead, ..._snake];
      if (newHead == _food) {
        _score.increment();
        GameSound.play('point.wav');
        _leaderboard[2]['score'] = _score.score;
        _food = _randomFood();
      } else {
        _snake.removeLast();
      }
    });
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
            content: Text('Your score: \\${_score.score}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startGame();
                },
                child: const Text('Restart'),
              ),
            ],
          ),
    );
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (details.delta.dy < 0 && _direction != Direction.down) {
      _direction = Direction.up;
    } else if (details.delta.dy > 0 && _direction != Direction.up) {
      _direction = Direction.down;
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (details.delta.dx < 0 && _direction != Direction.right) {
      _direction = Direction.left;
    } else if (details.delta.dx > 0 && _direction != Direction.left) {
      _direction = Direction.right;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Snake')),
      backgroundColor: Colors.green.shade50,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: colCount / rowCount,
                  child: Focus(
                    autofocus: true,
                    onKey: (node, event) {
                      if (event is! RawKeyDownEvent)
                        return KeyEventResult.ignored;
                      final key = event.logicalKey.keyLabel.toLowerCase();
                      if ((event.logicalKey.keyId == 0x100070052 &&
                              _direction != Direction.down) ||
                          key == 'w' && _direction != Direction.down) {
                        setState(() => _direction = Direction.up);
                        return KeyEventResult.handled;
                      } else if ((event.logicalKey.keyId == 0x100070051 &&
                              _direction != Direction.up) ||
                          key == 's' && _direction != Direction.up) {
                        setState(() => _direction = Direction.down);
                        return KeyEventResult.handled;
                      } else if ((event.logicalKey.keyId == 0x100070050 &&
                              _direction != Direction.right) ||
                          key == 'a' && _direction != Direction.right) {
                        setState(() => _direction = Direction.left);
                        return KeyEventResult.handled;
                      } else if ((event.logicalKey.keyId == 0x10007004f &&
                              _direction != Direction.left) ||
                          key == 'd' && _direction != Direction.left) {
                        setState(() => _direction = Direction.right);
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: GestureDetector(
                      onVerticalDragUpdate: _onVerticalDragUpdate,
                      onHorizontalDragUpdate: _onHorizontalDragUpdate,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFA8E063), Color(0xFF56AB2F)],
                          ),
                        ),
                        child: CustomPaint(
                          painter: _SnakePainter(_snake, _food),
                          child: Container(),
                        ),
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
                              color: Colors.white.withOpacity(0.85),
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
                                color: Colors.green,
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
                // Game border
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green.shade900,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                // Restart button (top right)
                Positioned(
                  top: 24,
                  right: 24,
                  child: ElevatedButton(
                    onPressed: _startGame,
                    child: const Text('Restart'),
                  ),
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

class _SnakePainter extends CustomPainter {
  final List<Offset> snake;
  final Offset food;
  _SnakePainter(this.snake, this.food);

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / _SnakeGameScreenState.colCount;
    final cellHeight = size.height / _SnakeGameScreenState.rowCount;
    final snakePaint = Paint()..color = Colors.green.shade700;
    final snakeShadow =
        Paint()
          ..color = Colors.black.withOpacity(0.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final foodPaint = Paint()..color = Colors.redAccent;
    final foodLeafPaint = Paint()..color = Colors.green.shade800;
    // Draw snake with rounded segments and shadow
    for (final pos in snake) {
      final rect = Rect.fromLTWH(
        pos.dx * cellWidth,
        pos.dy * cellHeight,
        cellWidth,
        cellHeight,
      );
      final rrect = RRect.fromRectAndRadius(
        rect,
        Radius.circular(cellWidth * 0.4),
      );
      // Shadow
      canvas.drawRRect(rrect.shift(const Offset(2, 2)), snakeShadow);
      // Body
      canvas.drawRRect(rrect, snakePaint);
    }
    // Draw food as an apple (circle with a leaf)
    final foodCenter = Offset(
      food.dx * cellWidth + cellWidth / 2,
      food.dy * cellHeight + cellHeight / 2,
    );
    final foodRadius = cellWidth * 0.38;
    canvas.drawCircle(foodCenter, foodRadius, foodPaint);
    // Apple leaf
    final leafPath = Path();
    leafPath.moveTo(foodCenter.dx, foodCenter.dy - foodRadius);
    leafPath.quadraticBezierTo(
      foodCenter.dx + foodRadius * 0.5,
      foodCenter.dy - foodRadius * 1.2,
      foodCenter.dx + foodRadius * 0.2,
      foodCenter.dy - foodRadius * 0.2,
    );
    canvas.drawPath(leafPath, foodLeafPaint);
  }

  @override
  bool shouldRepaint(covariant _SnakePainter oldDelegate) {
    return oldDelegate.snake != snake || oldDelegate.food != food;
  }
}
