import 'package:flutter/material.dart';

class BreakoutGameScreen extends StatefulWidget {
  const BreakoutGameScreen({super.key});

  @override
  State<BreakoutGameScreen> createState() => _BreakoutGameScreenState();
}

class _BreakoutGameScreenState extends State<BreakoutGameScreen>
    with SingleTickerProviderStateMixin {
  static const double paddleWidth = 80;
  static const double paddleHeight = 16;
  static const double ballSize = 16;

  static const double ballSpeed = 6;
  static const int rowCount = 5;
  static const int colCount = 8;

  double playerX = 110;
  double ballX = 120;
  double ballY = 200;
  double ballVX = ballSpeed;
  double ballVY = -ballSpeed;
  late List<List<bool>> bricks;
  int score = 0;
  late AnimationController controller;
  bool gameOver = false;
  bool win = false;

  @override
  void initState() {
    super.initState();
    _initGame();
    controller =
        AnimationController(vsync: this, duration: const Duration(days: 1))
          ..addListener(_tick)
          ..forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _initGame() {
    playerX = 110;
    ballX = 120;
    ballY = 200;
    ballVX = ballSpeed;
    ballVY = -ballSpeed;
    bricks = List.generate(rowCount, (_) => List.filled(colCount, true));
    score = 0;
    gameOver = false;
    win = false;
    setState(() {});
  }

  void _tick() {
    if (gameOver || win) return;
    setState(() {
      ballX += ballVX;
      ballY += ballVY;
      // Wall collision
      if (ballX <= 0 || ballX + ballSize >= 320) ballVX = -ballVX;
      if (ballY <= 0) ballVY = -ballVY;
      // Paddle collision
      if (ballY + ballSize >= 400 - paddleHeight &&
          ballX + ballSize > playerX &&
          ballX < playerX + paddleWidth) {
        ballVY = -ballVY;
        ballY = 400 - paddleHeight - ballSize;
      }
      // Brick collision
      for (int r = 0; r < rowCount; r++) {
        for (int c = 0; c < colCount; c++) {
          if (!bricks[r][c]) continue;
          double brickX = c * 40.0;
          double brickY = r * 20.0 + 40;
          if (ballX + ballSize > brickX &&
              ballX < brickX + 40 &&
              ballY + ballSize > brickY &&
              ballY < brickY + 20) {
            bricks[r][c] = false;
            score += 10;
            ballVY = -ballVY;
          }
        }
      }
      // Lose
      if (ballY > 400) {
        gameOver = true;
      }
      // Win
      if (bricks.every((row) => row.every((b) => !b))) {
        win = true;
      }
    });
  }

  void _movePlayer(double dx) {
    setState(() {
      playerX = (playerX + dx).clamp(0, 320 - paddleWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breakout'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _initGame),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onHorizontalDragUpdate: (details) => _movePlayer(details.delta.dx),
          child: Container(
            width: 320,
            height: 400,
            color: Colors.black,
            child: Stack(
              children: [
                // Bricks
                for (int r = 0; r < rowCount; r++)
                  for (int c = 0; c < colCount; c++)
                    if (bricks[r][c])
                      Positioned(
                        left: c * 40.0,
                        top: r * 20.0 + 40,
                        child: Container(
                          width: 40,
                          height: 20,
                          color: Colors.orange,
                        ),
                      ),
                // Player paddle
                Positioned(
                  left: playerX,
                  top: 400 - paddleHeight,
                  child: Container(
                    width: paddleWidth,
                    height: paddleHeight,
                    color: Colors.blue,
                  ),
                ),
                // Ball
                Positioned(
                  left: ballX,
                  top: ballY,
                  child: Container(
                    width: ballSize,
                    height: ballSize,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Score
                Positioned(
                  left: 8,
                  top: 8,
                  child: Text(
                    'Score: $score',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (gameOver)
                  const Center(
                    child: Text(
                      'Game Over!',
                      style: TextStyle(fontSize: 28, color: Colors.red),
                    ),
                  ),
                if (win)
                  const Center(
                    child: Text(
                      'You Win!',
                      style: TextStyle(fontSize: 28, color: Colors.green),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
