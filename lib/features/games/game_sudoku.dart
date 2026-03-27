import 'package:flutter/material.dart';

class SudokuGameScreen extends StatefulWidget {
  const SudokuGameScreen({super.key});

  @override
  State<SudokuGameScreen> createState() => _SudokuGameScreenState();
}

class _SudokuGameScreenState extends State<SudokuGameScreen> {
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
      });
    }
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
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
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
                  return GestureDetector(
                    onTap:
                        fixed[r][c]
                            ? null
                            : () async {
                              final n = await showDialog<int>(
                                context: context,
                                builder: (context) => NumberPickerDialog(),
                              );
                              if (n != null) _setCell(r, c, n);
                            },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color:
                            fixed[r][c] ? Colors.grey[700] : Colors.grey[800],
                        border: Border.all(
                          color:
                              (r % 3 == 2 && r != 8) || (c % 3 == 2 && c != 8)
                                  ? Colors.white
                                  : Colors.grey[600]!,
                          width:
                              (r % 3 == 2 && r != 8) || (c % 3 == 2 && c != 8)
                                  ? 2
                                  : 1,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          val == 0 ? '' : '$val',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                fixed[r][c]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color: fixed[r][c] ? Colors.white : Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
