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
  static const double paddleSpeed = 8;
  static const double ballSpeed = 6;

  double playerX = 110;
  double aiX = 110;
  double ballX = 120;
  double ballY = 200;
  double ballVX = ballSpeed;
  double ballVY = ballSpeed;
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
      if (aiX + paddleWidth / 2 < ballX) aiX += paddleSpeed;
      if (aiX + paddleWidth / 2 > ballX) aiX -= paddleSpeed;
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
    ballVX = ballSpeed * (Random().nextBool() ? 1 : -1);
    ballVY = ballSpeed * (Random().nextBool() ? 1 : -1);
  }

  void _movePlayer(double dx) {
    setState(() {
      playerX = (playerX + dx).clamp(0, 320 - paddleWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pong')),
      body: Center(
        child: GestureDetector(
          onHorizontalDragUpdate: (details) => _movePlayer(details.delta.dx),
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
    );
  }
}
