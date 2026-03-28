import 'package:flutter/material.dart';

import 'snake.dart';
import 'asteroids.dart';
import 'tic_tac_toe.dart';
import 'coming_soon.dart';
import 'game_2048.dart';
import 'game_sudoku.dart';
import 'game_memory_match.dart';
import 'game_chess.dart';
import 'game_minesweeper.dart';
import 'game_pong.dart';
import 'game_breakout.dart';

Widget getGameScreenByTitle(String title) {
  switch (title) {
    case 'Snake':
      return const SnakeGameScreen();
    case 'Flappy Bird':
    case 'Asteroids':
      return const AsteroidsGameScreen();
    case 'Tic Tac Toe':
      return const TicTacToeGameScreen();
    case '2048':
      return const Game2048Screen();
    case 'Sudoku':
      return const SudokuGameScreen();
    case 'Memory Match':
      return const MemoryMatchGameScreen();
    case 'Chess':
      return const ChessGameScreen();
    case 'Minesweeper':
      return const MinesweeperGameScreen();
    case 'Pong':
      return const PongGameScreen();
    case 'Breakout':
      return const BreakoutGameScreen();
    case 'Coming Soon':
      return ComingSoonGameScreen(title: title);
    default:
      return ComingSoonGameScreen(title: title);
  }
}
