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

  static const int gridSize = 3;
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  String currentPlayer = 'X';
  String? winner;
  List<List<int>>? winLine;
  bool draw = false;

  void _resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      currentPlayer = 'X';
      winner = null;
      winLine = null;
      draw = false;
    });
  }

  void _handleTap(int r, int c) {
    if (board[r][c] != '' || winner != null) return;
    setState(() {
      board[r][c] = currentPlayer;
      _checkGameState();
      if (winner == null && !draw) {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
    });
  }

  void _checkGameState() {
    // Check rows, columns, diagonals
    for (int i = 0; i < gridSize; i++) {
      if (board[i][0] != '' &&
          board[i][0] == board[i][1] &&
          board[i][1] == board[i][2]) {
        winner = board[i][0];
        winLine = [
          [i, 0],
          [i, 1],
          [i, 2],
        ];
        _score.increment();
        GameSound.play('point.wav');
        _leaderboard[2]['score'] = _score.score;
        return;
      }
      if (board[0][i] != '' &&
          board[0][i] == board[1][i] &&
          board[1][i] == board[2][i]) {
        winner = board[0][i];
        winLine = [
          [0, i],
          [1, i],
          [2, i],
        ];
        _score.increment();
        GameSound.play('point.wav');
        _leaderboard[2]['score'] = _score.score;
        return;
      }
    }
    if (board[0][0] != '' &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2]) {
      winner = board[0][0];
      winLine = [
        [0, 0],
        [1, 1],
        [2, 2],
      ];
      _score.increment();
      GameSound.play('point.wav');
      _leaderboard[2]['score'] = _score.score;
      return;
    }
    if (board[0][2] != '' &&
        board[0][2] == board[1][1] &&
        board[1][1] == board[2][0]) {
      winner = board[0][2];
      winLine = [
        [0, 2],
        [1, 1],
        [2, 0],
      ];
      _score.increment();
      GameSound.play('point.wav');
      _leaderboard[2]['score'] = _score.score;
      return;
    }
    // Draw
    if (board.expand((e) => e).every((cell) => cell != '')) {
      draw = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: 'Restart',
          ),
        ],
      ),
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
                      (_, _) => Text(
                        '${_score.score}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, i) {
                  final r = i ~/ gridSize;
                  final c = i % gridSize;
                  final isWinCell =
                      winLine?.any((pos) => pos[0] == r && pos[1] == c) ??
                      false;
                  return GestureDetector(
                    onTap: () => _handleTap(r, c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:
                            isWinCell
                                ? Colors.green[400]
                                : (board[r][c] == ''
                                    ? Colors.grey[800]
                                    : (board[r][c] == 'X'
                                        ? Colors.blue[300]
                                        : Colors.orange[300])),
                        border: Border.all(
                          color: isWinCell ? Colors.greenAccent : Colors.white,
                          width: isWinCell ? 3 : 1.5,
                        ),
                        borderRadius: BorderRadius.circular(isWinCell ? 12 : 6),
                        boxShadow:
                            isWinCell
                                ? [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.18),
                                    blurRadius: 8,
                                  ),
                                ]
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          board[r][c],
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color:
                                isWinCell
                                    ? Colors.white
                                    : (board[r][c] == 'X'
                                        ? Colors.blue[900]
                                        : Colors.deepOrange[900]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              winner != null
                  ? 'Winner: $winner!'
                  : (draw ? 'Draw!' : 'Current: $currentPlayer'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color:
                    winner != null
                        ? Colors.green
                        : (draw ? Colors.orange : Colors.blueGrey),
              ),
            ),
          ),
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
