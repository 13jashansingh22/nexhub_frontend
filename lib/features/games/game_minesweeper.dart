import 'package:flutter/material.dart';
import 'dart:math';

class MinesweeperGameScreen extends StatefulWidget {
  const MinesweeperGameScreen({super.key});

  @override
  State<MinesweeperGameScreen> createState() => _MinesweeperGameScreenState();
}

class _MinesweeperGameScreenState extends State<MinesweeperGameScreen> {
  static const int gridSize = 8;
  static const int mineCount = 10;
  late List<List<_Cell>> grid;
  bool gameOver = false;
  bool won = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    grid = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => _Cell()),
    );
    gameOver = false;
    won = false;
    _placeMines();
    _calculateNumbers();
    setState(() {});
  }

  void _placeMines() {
    int placed = 0;
    final rand = Random();
    while (placed < mineCount) {
      int r = rand.nextInt(gridSize);
      int c = rand.nextInt(gridSize);
      if (!grid[r][c].mine) {
        grid[r][c].mine = true;
        placed++;
      }
    }
  }

  void _calculateNumbers() {
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (grid[r][c].mine) continue;
        int count = 0;
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            int nr = r + dr, nc = c + dc;
            if (nr >= 0 &&
                nr < gridSize &&
                nc >= 0 &&
                nc < gridSize &&
                grid[nr][nc].mine) {
              count++;
            }
          }
        }
        grid[r][c].number = count;
      }
    }
  }

  void _reveal(int r, int c) {
    if (grid[r][c].revealed || grid[r][c].flagged || gameOver) return;
    setState(() {
      grid[r][c].revealed = true;
      if (grid[r][c].mine) {
        gameOver = true;
      } else if (grid[r][c].number == 0) {
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            int nr = r + dr, nc = c + dc;
            if (nr >= 0 && nr < gridSize && nc >= 0 && nc < gridSize) {
              _reveal(nr, nc);
            }
          }
        }
      }
      _checkWin();
    });
  }

  void _toggleFlag(int r, int c) {
    if (grid[r][c].revealed || gameOver) return;
    setState(() {
      grid[r][c].flagged = !grid[r][c].flagged;
      _checkWin();
    });
  }

  void _checkWin() {
    int unrevealed = 0;
    for (var row in grid) {
      for (var cell in row) {
        if (!cell.revealed) unrevealed++;
      }
    }
    if (unrevealed == mineCount && !gameOver) {
      won = true;
      gameOver = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minesweeper'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _initGame),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (gameOver && won)
            const Text(
              'You Win!',
              style: TextStyle(fontSize: 28, color: Colors.green),
            ),
          if (gameOver && !won)
            const Text(
              'Game Over!',
              style: TextStyle(fontSize: 28, color: Colors.red),
            ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (context, i) {
                final r = i ~/ gridSize;
                final c = i % gridSize;
                final cell = grid[r][c];
                return GestureDetector(
                  onTap: () => _reveal(r, c),
                  onLongPress: () => _toggleFlag(r, c),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color:
                          cell.revealed
                              ? (cell.mine ? Colors.red : Colors.grey[300])
                              : Colors.grey[800],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Center(
                      child:
                          cell.revealed
                              ? (cell.mine
                                  ? const Icon(
                                    Icons.warning,
                                    color: Colors.black,
                                  )
                                  : (cell.number > 0
                                      ? Text(
                                        '${cell.number}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                      : const SizedBox.shrink()))
                              : (cell.flagged
                                  ? const Icon(Icons.flag, color: Colors.orange)
                                  : const SizedBox.shrink()),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell {
  bool mine = false;
  int number = 0;
  bool revealed = false;
  bool flagged = false;
}
