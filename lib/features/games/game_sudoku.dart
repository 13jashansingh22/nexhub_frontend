import 'package:flutter/material.dart';

class SudokuGameScreen extends StatefulWidget {
  const SudokuGameScreen({super.key});

  @override
  State<SudokuGameScreen> createState() => _SudokuGameScreenState();
}

class _SudokuGameScreenState extends State<SudokuGameScreen> {
  int? selectedRow;
  int? selectedCol;
  bool showMistakes = false;
  static const int gridSize = 9;
  late List<List<int>> puzzle;
  late List<List<int>> solution;
  late List<List<bool>> fixed;

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
  }

  void _generatePuzzle() {
    // For demo: a simple static puzzle and solution
    puzzle = [
      [5, 3, 0, 0, 7, 0, 0, 0, 0],
      [6, 0, 0, 1, 9, 5, 0, 0, 0],
      [0, 9, 8, 0, 0, 0, 0, 6, 0],
      [8, 0, 0, 0, 6, 0, 0, 0, 3],
      [4, 0, 0, 8, 0, 3, 0, 0, 1],
      [7, 0, 0, 0, 2, 0, 0, 0, 6],
      [0, 6, 0, 0, 0, 0, 2, 8, 0],
      [0, 0, 0, 4, 1, 9, 0, 0, 5],
      [0, 0, 0, 0, 8, 0, 0, 7, 9],
    ];
    solution = [
      [5, 3, 4, 6, 7, 8, 9, 1, 2],
      [6, 7, 2, 1, 9, 5, 3, 4, 8],
      [1, 9, 8, 3, 4, 2, 5, 6, 7],
      [8, 5, 9, 7, 6, 1, 4, 2, 3],
      [4, 2, 6, 8, 5, 3, 7, 9, 1],
      [7, 1, 3, 9, 2, 4, 8, 5, 6],
      [9, 6, 1, 5, 3, 7, 2, 8, 4],
      [2, 8, 7, 4, 1, 9, 6, 3, 5],
      [3, 4, 5, 2, 8, 6, 1, 7, 9],
    ];
    fixed = List.generate(
      gridSize,
      (i) => List.generate(gridSize, (j) => puzzle[i][j] != 0),
    );
    setState(() {});
  }

  void _setCell(int r, int c, int val) {
    if (!fixed[r][c]) {
      setState(() {
        puzzle[r][c] = val;
        selectedRow = r;
        selectedCol = c;
      });
    }
  }

  void _selectCell(int r, int c) {
    if (!fixed[r][c]) {
      setState(() {
        selectedRow = r;
        selectedCol = c;
      });
    }
  }

  void _clearCell() {
    if (selectedRow != null &&
        selectedCol != null &&
        !fixed[selectedRow!][selectedCol!]) {
      setState(() {
        puzzle[selectedRow!][selectedCol!] = 0;
      });
    }
  }

  void _checkMistakes() {
    setState(() {
      showMistakes = true;
    });
  }

  void _solvePuzzle() {
    setState(() {
      for (int r = 0; r < gridSize; r++) {
        for (int c = 0; c < gridSize; c++) {
          puzzle[r][c] = solution[r][c];
        }
      }
      showMistakes = false;
    });
  }

  bool _isSolved() {
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (puzzle[r][c] != solution[r][c]) return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generatePuzzle,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
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
                  final val = puzzle[r][c];
                  final isSelected = selectedRow == r && selectedCol == c;
                  final isMistake =
                      showMistakes && val != 0 && val != solution[r][c];
                  return GestureDetector(
                    onTap: () => _selectCell(r, c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Colors.blue[400]
                                : (fixed[r][c]
                                    ? Colors.grey[700]
                                    : Colors.grey[800]),
                        border: Border.all(
                          color:
                              isMistake
                                  ? Colors.red
                                  : ((r % 3 == 2 && r != 8) ||
                                          (c % 3 == 2 && c != 8)
                                      ? Colors.white
                                      : Colors.grey[600]!),
                          width:
                              isMistake
                                  ? 3
                                  : ((r % 3 == 2 && r != 8) ||
                                          (c % 3 == 2 && c != 8)
                                      ? 2
                                      : 1),
                        ),
                        borderRadius: BorderRadius.circular(
                          isSelected ? 10 : 4,
                        ),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.25),
                                    blurRadius: 8,
                                  ),
                                ]
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          val == 0 ? '' : '$val',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                fixed[r][c]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color:
                                isMistake
                                    ? Colors.redAccent
                                    : (fixed[r][c]
                                        ? Colors.white
                                        : Colors.orange),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Number pad
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int n = 1; n <= 9; n++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(36, 36),
                        backgroundColor: Colors.grey[850],
                        foregroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed:
                          selectedRow != null &&
                                  selectedCol != null &&
                                  !fixed[selectedRow!][selectedCol!]
                              ? () => _setCell(selectedRow!, selectedCol!, n)
                              : null,
                      child: Text('$n', style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(36, 36),
                      backgroundColor: Colors.grey[850],
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed:
                        selectedRow != null &&
                                selectedCol != null &&
                                !fixed[selectedRow!][selectedCol!]
                            ? _clearCell
                            : null,
                    child: const Icon(Icons.backspace_outlined, size: 18),
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Check'),
                  onPressed: _checkMistakes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.lightbulb),
                  label: const Text('Solve'),
                  onPressed: _solvePuzzle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
          if (_isSolved())
            const Text(
              'Solved!',
              style: TextStyle(fontSize: 28, color: Colors.green),
            ),
        ],
      ),
    );
  }
}

class NumberPickerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a number'),
      content: Wrap(
        spacing: 8,
        children: [
          for (int i = 1; i <= 9; i++)
            ElevatedButton(
              onPressed: () => Navigator.pop(context, i),
              child: Text('$i'),
            ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 0),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
