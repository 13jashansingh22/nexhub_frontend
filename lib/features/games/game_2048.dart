import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class Game2048Screen extends StatefulWidget {
  const Game2048Screen({super.key});

  @override
  State<Game2048Screen> createState() => _Game2048ScreenState();
}

class _Game2048ScreenState extends State<Game2048Screen> {
  static const int gridSize = 4;
  late List<List<int>> grid;
  int score = 0;
  int bestScore = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    grid = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    if (score > bestScore) bestScore = score;
    score = 0;
    gameOver = false;
    _addRandomTile();
    _addRandomTile();
    setState(() {});
  }

  void _addRandomTile() {
    final empty = <Point<int>>[];
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (grid[r][c] == 0) empty.add(Point(r, c));
      }
    }
    if (empty.isNotEmpty) {
      final pos = empty[Random().nextInt(empty.length)];
      grid[pos.x][pos.y] = Random().nextInt(10) == 0 ? 4 : 2;
    }
  }

  bool _moveLeft() {
    bool moved = false;
    for (int r = 0; r < gridSize; r++) {
      List<int> row = grid[r].where((v) => v != 0).toList();
      for (int i = 0; i < row.length - 1; i++) {
        if (row[i] == row[i + 1]) {
          row[i] *= 2;
          score += row[i];
          row[i + 1] = 0;
        }
      }
      row = row.where((v) => v != 0).toList();
      while (row.length < gridSize) {
        row.add(0);
      }
      if (!ListEquality().equals(grid[r], row)) moved = true;
      grid[r] = row;
    }
    return moved;
  }

  bool _moveRight() {
    bool moved = false;
    for (int r = 0; r < gridSize; r++) {
      List<int> row = grid[r].reversed.where((v) => v != 0).toList();
      for (int i = 0; i < row.length - 1; i++) {
        if (row[i] == row[i + 1]) {
          row[i] *= 2;
          score += row[i];
          row[i + 1] = 0;
        }
      }
      row = row.where((v) => v != 0).toList();
      while (row.length < gridSize) {
        row.add(0);
      }
      row = row.reversed.toList();
      if (!ListEquality().equals(grid[r], row)) moved = true;
      grid[r] = row;
    }
    return moved;
  }

  bool _moveUp() {
    bool moved = false;
    for (int c = 0; c < gridSize; c++) {
      List<int> col = [];
      for (int r = 0; r < gridSize; r++) {
        if (grid[r][c] != 0) col.add(grid[r][c]);
      }
      for (int i = 0; i < col.length - 1; i++) {
        if (col[i] == col[i + 1]) {
          col[i] *= 2;
          score += col[i];
          col[i + 1] = 0;
        }
      }
      col = col.where((v) => v != 0).toList();
      while (col.length < gridSize) {
        col.add(0);
      }
      for (int r = 0; r < gridSize; r++) {
        if (grid[r][c] != col[r]) moved = true;
        grid[r][c] = col[r];
      }
    }
    return moved;
  }

  bool _moveDown() {
    bool moved = false;
    for (int c = 0; c < gridSize; c++) {
      List<int> col = [];
      for (int r = gridSize - 1; r >= 0; r--) {
        if (grid[r][c] != 0) col.add(grid[r][c]);
      }
      for (int i = 0; i < col.length - 1; i++) {
        if (col[i] == col[i + 1]) {
          col[i] *= 2;
          score += col[i];
          col[i + 1] = 0;
        }
      }
      col = col.where((v) => v != 0).toList();
      while (col.length < gridSize) {
        col.add(0);
      }
      col = col.reversed.toList();
      for (int r = 0; r < gridSize; r++) {
        if (grid[r][c] != col[r]) moved = true;
        grid[r][c] = col[r];
      }
    }
    return moved;
  }

  bool _canMove() {
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (grid[r][c] == 0) return true;
        if (r < gridSize - 1 && grid[r][c] == grid[r + 1][c]) return true;
        if (c < gridSize - 1 && grid[r][c] == grid[r][c + 1]) return true;
      }
    }
    return false;
  }

  void _handleMove(bool Function() moveFn) {
    if (gameOver) return;
    final moved = moveFn();
    if (moved) {
      _addRandomTile();
      if (!_canMove()) {
        gameOver = true;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2048'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _initGame),
        ],
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey.keyLabel == 'Arrow Up' ||
                event.logicalKey.keyLabel.toLowerCase() == 'w') {
              _handleMove(_moveUp);
            } else if (event.logicalKey.keyLabel == 'Arrow Down' ||
                event.logicalKey.keyLabel.toLowerCase() == 's') {
              _handleMove(_moveDown);
            } else if (event.logicalKey.keyLabel == 'Arrow Left' ||
                event.logicalKey.keyLabel.toLowerCase() == 'a') {
              _handleMove(_moveLeft);
            } else if (event.logicalKey.keyLabel == 'Arrow Right' ||
                event.logicalKey.keyLabel.toLowerCase() == 'd') {
              _handleMove(_moveRight);
            }
          }
        },
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _handleMove(_moveUp);
            } else if (details.primaryVelocity! > 0) {
              _handleMove(_moveDown);
            }
          },
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _handleMove(_moveLeft);
            } else if (details.primaryVelocity! > 0) {
              _handleMove(_moveRight);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Score: $score',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Best: $bestScore',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('New Game'),
                      onPressed: _initGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridSize,
                        ),
                    itemCount: gridSize * gridSize,
                    itemBuilder: (context, i) {
                      final r = i ~/ gridSize;
                      final c = i % gridSize;
                      final val = grid[r][c];
                      Color tileColor;
                      switch (val) {
                        case 2:
                          tileColor = const Color(0xFFEEE4DA);
                          break;
                        case 4:
                          tileColor = const Color(0xFFEDE0C8);
                          break;
                        case 8:
                          tileColor = const Color(0xFFF2B179);
                          break;
                        case 16:
                          tileColor = const Color(0xFFF59563);
                          break;
                        case 32:
                          tileColor = const Color(0xFFF67C5F);
                          break;
                        case 64:
                          tileColor = const Color(0xFFF65E3B);
                          break;
                        case 128:
                          tileColor = const Color(0xFFEDCF72);
                          break;
                        case 256:
                          tileColor = const Color(0xFFEDCC61);
                          break;
                        case 512:
                          tileColor = const Color(0xFFEDC850);
                          break;
                        case 1024:
                          tileColor = const Color(0xFFEDC53F);
                          break;
                        case 2048:
                          tileColor = const Color(0xFFEDC22E);
                          break;
                        default:
                          tileColor =
                              val == 0 ? Colors.grey[800]! : Colors.black87;
                      }
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: tileColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow:
                              val > 0
                                  ? [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.12),
                                      blurRadius: 8,
                                    ),
                                  ]
                                  : null,
                        ),
                        child: Center(
                          child:
                              val == 0
                                  ? const SizedBox.shrink()
                                  : Text(
                                    '$val',
                                    style: TextStyle(
                                      fontSize: val < 128 ? 28 : 24,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          val <= 4
                                              ? Colors.grey[800]
                                              : Colors.white,
                                    ),
                                  ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (gameOver)
                const Text(
                  'Game Over!',
                  style: TextStyle(fontSize: 28, color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListEquality {
  bool equals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
