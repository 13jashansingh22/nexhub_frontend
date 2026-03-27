import 'package:flutter/material.dart';
import 'game_score.dart';
import 'game_leaderboard.dart';
import 'game_sound.dart';

class TicTacToeGameScreen extends StatefulWidget {
  const TicTacToeGameScreen({super.key});

  @override
  State<TicTacToeGameScreen> createState() => _TicTacToeGameScreenState();
}

class _TicTacToeGameScreenState extends State<TicTacToeGameScreen> {
  final GameScore _score = GameScore();
  final List<Map<String, dynamic>> _leaderboard = [
    {'name': 'Alice', 'score': 5},
    {'name': 'Bob', 'score': 3},
    {'name': 'You', 'score': 0},
  ];

  void _incrementScore() {
    _score.increment();
    GameSound.play('point.wav');
    setState(() {
      _leaderboard[2]['score'] = _score.score;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic Tac Toe')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Score:', style: TextStyle(fontSize: 18)),
                AnimatedBuilder(
                  animation: _score,
                  builder:
                      (_, __) => Text(
                        '${_score.score}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
                ElevatedButton(
                  onPressed: _incrementScore,
                  child: const Text('Add Point'),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Leaderboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: GameLeaderboard(scores: _leaderboard)),
        ],
      ),
    );
  }
}
