import 'package:flutter/material.dart';
import 'dart:math';

class PongGameScreen extends StatefulWidget {
  const PongGameScreen({super.key});

  @override
  State<PongGameScreen> createState() => _PongGameScreenState();
}

class _PongGameScreenState extends State<PongGameScreen>
    with SingleTickerProviderStateMixin {
  static const double paddleWidth = 80;
  static const double paddleHeight = 16;
  static const double ballSize = 16;
  double _paddleSpeed = 8;
  double _ballSpeed = 6;

  double playerX = 110;
  double aiX = 110;
  double ballX = 120;
  double ballY = 200;
  double ballVX = 6;
  double ballVY = 6;
  int playerScore = 0;
  int aiScore = 0;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
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

  void _tick() {
    setState(() {
      // Ball movement
      ballX += ballVX;
      ballY += ballVY;
      // Wall collision
      if (ballX <= 0 || ballX + ballSize >= 320) ballVX = -ballVX;
      // Paddle collision
      if (ballY + ballSize >= 400 - paddleHeight &&
          ballX + ballSize > playerX &&
          ballX < playerX + paddleWidth) {
        ballVY = -ballVY;
        ballY = 400 - paddleHeight - ballSize;
      }
      if (ballY <= paddleHeight &&
          ballX + ballSize > aiX &&
          ballX < aiX + paddleWidth) {
        ballVY = -ballVY;
        ballY = paddleHeight;
      }
      // AI movement
      if (aiX + paddleWidth / 2 < ballX) aiX += _paddleSpeed;
      if (aiX + paddleWidth / 2 > ballX) aiX -= _paddleSpeed;
      aiX = aiX.clamp(0, 320 - paddleWidth);
      // Score
      if (ballY < 0) {
        playerScore++;
        _resetBall();
      } else if (ballY > 400) {
        aiScore++;
        _resetBall();
      }
    });
  }

  void _resetBall() {
    ballX = 120;
    ballY = 200;
    ballVX = _ballSpeed * (Random().nextBool() ? 1 : -1);
    ballVY = _ballSpeed * (Random().nextBool() ? 1 : -1);
  }

  void _movePlayer(double dx) {
    setState(() {
      playerX = (playerX + dx).clamp(0, 320 - paddleWidth);
    });
  }

  void _onSpeedChanged(double value) {
    setState(() {
      _ballSpeed = 4 + value * 8; // Range: 4-12
      _paddleSpeed = 4 + value * 8; // Range: 4-12
      // Update ball velocity direction but keep speed
      ballVX = ballVX.sign * _ballSpeed;
      ballVY = ballVY.sign * _ballSpeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pong')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                onHorizontalDragUpdate:
                    (details) => _movePlayer(details.delta.dx),
                child: Container(
                  width: 320,
                  height: 400,
                  color: Colors.black,
                  child: Stack(
                    children: [
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
                      // AI paddle
                      Positioned(
                        left: aiX,
                        top: 0,
                        child: Container(
                          width: paddleWidth,
                          height: paddleHeight,
                          color: Colors.red,
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
                          'AI: $aiScore',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Text(
                          'You: $playerScore',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Speed control slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                const Text('Speed', style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Slider(
                    value: (_ballSpeed - 4) / 8,
                    onChanged: _onSpeedChanged,
                    min: 0,
                    max: 1,
                  ),
                ),
                Text(
                  _ballSpeed.toStringAsFixed(1),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
