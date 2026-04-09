import 'package:chess/chess.dart' as chess_engine;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChessGameScreen extends StatefulWidget {
  const ChessGameScreen({super.key});

  @override
  State<ChessGameScreen> createState() => _ChessGameScreenState();
}

class _ChessGameScreenState extends State<ChessGameScreen> {
  final chess_engine.Chess _chess = chess_engine.Chess();
  final FocusNode _focusNode = FocusNode(debugLabel: 'chess_board');

  String? _selectedSquare;
  int _cursorRow = 7;
  int _cursorCol = 4;
  final List<String> _sanHistory = [];

  @override
  void initState() {
    super.initState();
    _syncCursorToSelection();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _resetGame() {
    setState(() {
      _selectedSquare = null;
      _cursorRow = 7;
      _cursorCol = 4;
      _sanHistory.clear();
      _chess.reset();
      _syncCursorToSelection();
    });
  }

  void _syncCursorToSelection() {
    if (_selectedSquare == null) {
      return;
    }
    final coords = _coordsFromSquare(_selectedSquare!);
    _cursorRow = coords.$1;
    _cursorCol = coords.$2;
  }

  String _squareAt(int row, int col) {
    const files = 'abcdefgh';
    final file = files[col];
    final rank = 8 - row;
    return '$file$rank';
  }

  (int, int) _coordsFromSquare(String square) {
    const files = 'abcdefgh';
    final file = files.indexOf(square[0]);
    final rank = 8 - int.parse(square[1]);
    return (rank, file);
  }

  int _indexForSquare(String square) {
    final coords = _coordsFromSquare(square);
    return coords.$1 * 16 + coords.$2;
  }

  List<chess_engine.Move> _legalMovesFrom(String square) {
    final moves = _chess.moves({'square': square, 'asObjects': true});
    return moves.cast<chess_engine.Move>();
  }

  List<String> _legalDestinationsFor(String square) {
    return _legalMovesFrom(square).map((move) => move.toAlgebraic).toList();
  }

  bool _isPromotionMove(String from, String to) {
    final piece = _chess.board[_indexForSquare(from)];
    return piece != null &&
        piece.type == chess_engine.Chess.PAWN &&
        (to.endsWith('8') || to.endsWith('1'));
  }

  void _applyMove(String from, String to) {
    final verboseMoves = _chess.moves({'square': from, 'verbose': true});
    final moveMap = verboseMoves
        .cast<Map>()
        .cast<Map<String, dynamic>?>()
        .firstWhere((candidate) => candidate?['to'] == to, orElse: () => null);

    if (moveMap == null) {
      return;
    }

    final played = _chess.move({
      'from': from,
      'to': to,
      if (_isPromotionMove(from, to)) 'promotion': 'q',
    });

    if (played == true) {
      setState(() {
        _sanHistory.add('${moveMap['san'] ?? '$from$to'}');
        _selectedSquare = null;
        final coords = _coordsFromSquare(to);
        _cursorRow = coords.$1;
        _cursorCol = coords.$2;
      });
    }
  }

  void _handleSquareTap(String square) {
    final piece = _chess.board[_indexForSquare(square)];
    final currentTurn = _chess.turn;
    final isCurrentPlayersPiece = piece != null && piece.color == currentTurn;

    if (_selectedSquare == null) {
      if (isCurrentPlayersPiece) {
        setState(() {
          _selectedSquare = square;
          final coords = _coordsFromSquare(square);
          _cursorRow = coords.$1;
          _cursorCol = coords.$2;
        });
      }
      return;
    }

    if (_selectedSquare == square) {
      setState(() {
        _selectedSquare = null;
      });
      return;
    }

    final destinations = _legalDestinationsFor(_selectedSquare!);
    if (destinations.contains(square)) {
      _applyMove(_selectedSquare!, square);
      return;
    }

    if (isCurrentPlayersPiece) {
      setState(() {
        _selectedSquare = square;
        final coords = _coordsFromSquare(square);
        _cursorRow = coords.$1;
        _cursorCol = coords.$2;
      });
    } else {
      setState(() {
        _selectedSquare = null;
      });
    }
  }

  void _moveCursor(int rowDelta, int colDelta) {
    setState(() {
      _cursorRow = (_cursorRow + rowDelta).clamp(0, 7);
      _cursorCol = (_cursorCol + colDelta).clamp(0, 7);
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    final logicalKey = event.logicalKey;
    if (logicalKey == LogicalKeyboardKey.arrowUp) {
      _moveCursor(-1, 0);
      return KeyEventResult.handled;
    }
    if (logicalKey == LogicalKeyboardKey.arrowDown) {
      _moveCursor(1, 0);
      return KeyEventResult.handled;
    }
    if (logicalKey == LogicalKeyboardKey.arrowLeft) {
      _moveCursor(0, -1);
      return KeyEventResult.handled;
    }
    if (logicalKey == LogicalKeyboardKey.arrowRight) {
      _moveCursor(0, 1);
      return KeyEventResult.handled;
    }
    if (logicalKey == LogicalKeyboardKey.space ||
        logicalKey == LogicalKeyboardKey.enter) {
      final square = _squareAt(_cursorRow, _cursorCol);
      _handleSquareTap(square);
      return KeyEventResult.handled;
    }
    if (logicalKey == LogicalKeyboardKey.escape) {
      setState(() {
        _selectedSquare = null;
      });
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  String _pieceGlyph(chess_engine.Piece? piece) {
    if (piece == null) {
      return '';
    }

    switch (piece.type) {
      case chess_engine.Chess.PAWN:
        return piece.color == chess_engine.Chess.WHITE ? '♙' : '♟';
      case chess_engine.Chess.KNIGHT:
        return piece.color == chess_engine.Chess.WHITE ? '♘' : '♞';
      case chess_engine.Chess.BISHOP:
        return piece.color == chess_engine.Chess.WHITE ? '♗' : '♝';
      case chess_engine.Chess.ROOK:
        return piece.color == chess_engine.Chess.WHITE ? '♖' : '♜';
      case chess_engine.Chess.QUEEN:
        return piece.color == chess_engine.Chess.WHITE ? '♕' : '♛';
      case chess_engine.Chess.KING:
        return piece.color == chess_engine.Chess.WHITE ? '♔' : '♚';
    }

    return '';
  }

  Color _squareColor(int row, int col) {
    final isLight = (row + col) % 2 == 0;
    return isLight ? const Color(0xFFE6DCC7) : const Color(0xFF5B4B3B);
  }

  @override
  Widget build(BuildContext context) {
    final isGameOver = _chess.game_over;
    final isCheckmate = _chess.in_checkmate;
    final isStalemate = _chess.in_stalemate;
    final isDraw = _chess.in_draw;
    final isCheck = _chess.in_check;

    final boardStatus =
        isCheckmate
            ? 'Checkmate'
            : isStalemate
            ? 'Stalemate'
            : isDraw
            ? 'Draw'
            : isCheck
            ? 'Check'
            : '${_chess.turn == chess_engine.Chess.WHITE ? 'White' : 'Black'} to move';

    final legalDestinations =
        _selectedSquare == null
            ? <String>{}
            : _legalDestinationsFor(_selectedSquare!).toSet();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Focus(
        autofocus: true,
        focusNode: _focusNode,
        onKeyEvent: _handleKeyEvent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final boardSize =
                constraints.maxWidth < 420 ? constraints.maxWidth - 24 : 420.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatusCard(
                        boardStatus: boardStatus,
                        moveCount: _sanHistory.length,
                        isGameOver: isGameOver,
                        isCheckmate: isCheckmate,
                      ),
                      const SizedBox(height: 12),
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF17131E),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.34),
                                blurRadius: 28,
                                offset: const Offset(0, 18),
                              ),
                            ],
                          ),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 8,
                                ),
                            itemCount: 64,
                            itemBuilder: (context, index) {
                              final row = index ~/ 8;
                              final col = index % 8;
                              final square = _squareAt(row, col);
                              final boardIndex = row * 16 + col;
                              final piece = _chess.board[boardIndex];
                              final selected = _selectedSquare == square;
                              final cursor =
                                  _cursorRow == row && _cursorCol == col;
                              final legalTarget = legalDestinations.contains(
                                square,
                              );

                              return GestureDetector(
                                onTap: () => _handleSquareTap(square),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 140),
                                  decoration: BoxDecoration(
                                    color: _squareColor(row, col),
                                    border: Border.all(
                                      color:
                                          selected
                                              ? Colors.amberAccent
                                              : cursor
                                              ? Colors.lightBlueAccent
                                              : Colors.transparent,
                                      width: selected || cursor ? 2.4 : 0,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      if (legalTarget && piece == null)
                                        Center(
                                          child: Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.22,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      Center(
                                        child: Text(
                                          _pieceGlyph(piece),
                                          style: TextStyle(
                                            fontSize: boardSize / 9.6,
                                            height: 1,
                                            color:
                                                piece?.color ==
                                                        chess_engine.Chess.WHITE
                                                    ? Colors.white
                                                    : Colors.black,
                                            shadows: const [
                                              Shadow(
                                                blurRadius: 2,
                                                color: Colors.black54,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (row == 7)
                                        Positioned(
                                          right: 6,
                                          bottom: 4,
                                          child: Text(
                                            square[0],
                                            style: TextStyle(
                                              fontSize: 10,
                                              color:
                                                  _squareColor(row, col) ==
                                                          const Color(
                                                            0xFFE6DCC7,
                                                          )
                                                      ? Colors.black87
                                                      : Colors.white70,
                                            ),
                                          ),
                                        ),
                                      if (col == 0)
                                        Positioned(
                                          left: 6,
                                          top: 4,
                                          child: Text(
                                            square[1],
                                            style: TextStyle(
                                              fontSize: 10,
                                              color:
                                                  _squareColor(row, col) ==
                                                          const Color(
                                                            0xFFE6DCC7,
                                                          )
                                                      ? Colors.black87
                                                      : Colors.white70,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _resetGame,
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Restart'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedSquare = null;
                                });
                              },
                              icon: const Icon(Icons.clear_rounded),
                              label: const Text('Clear'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Move History',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (_sanHistory.isEmpty)
                              const Text('Make your first move to begin.')
                            else
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    _sanHistory
                                        .map(
                                          (move) => Chip(
                                            label: Text(move),
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                        )
                                        .toList(),
                              ),
                            if (isGameOver) ...[
                              const SizedBox(height: 12),
                              Text(
                                isCheckmate
                                    ? 'Checkmate. Restart for a fresh game.'
                                    : isStalemate
                                    ? 'Stalemate. Restart to play again.'
                                    : 'Game finished.',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String boardStatus;
  final int moveCount;
  final bool isGameOver;
  final bool isCheckmate;

  const _StatusCard({
    required this.boardStatus,
    required this.moveCount,
    required this.isGameOver,
    required this.isCheckmate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF20152F), Color(0xFF110E1D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE6DCC7), Color(0xFF5B4B3B)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.extension_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  boardStatus,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$moveCount moves played',
                  style: TextStyle(color: Colors.white.withOpacity(0.72)),
                ),
              ],
            ),
          ),
          if (isGameOver)
            Chip(
              label: Text(isCheckmate ? 'Checkmate' : 'Finished'),
              backgroundColor: Colors.red.withOpacity(0.2),
              labelStyle: const TextStyle(color: Colors.white),
            )
          else
            Chip(
              label: const Text('Live'),
              backgroundColor: Colors.green.withOpacity(0.18),
              labelStyle: const TextStyle(color: Colors.white),
            ),
        ],
      ),
    );
  }
}
