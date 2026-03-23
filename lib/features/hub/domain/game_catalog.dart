import 'package:flutter/material.dart';

import '../../../app/theme/app_palette.dart';

class GameCategoryData {
  const GameCategoryData({
    required this.name,
    required this.description,
    required this.gradient,
    required this.games,
  });

  final String name;
  final String description;
  final LinearGradient gradient;
  final List<GameTileData> games;
}

class GameTileData {
  const GameTileData({
    required this.title,
    required this.emoji,
    required this.tag,
  });

  final String title;
  final String emoji;
  final String tag;
}

const List<GameCategoryData> allGameCategories = [
  GameCategoryData(
    name: 'Casual Games',
    description: 'Fast, fun, and MVP-ready crowd favorites.',
    gradient: AppGradients.casual,
    games: [
      GameTileData(title: 'Snake', emoji: '🐍', tag: 'MVP'),
      GameTileData(title: 'Flappy Bird', emoji: '🐦', tag: 'MVP'),
      GameTileData(title: 'Tic Tac Toe', emoji: '❌⭕', tag: 'MVP'),
      GameTileData(title: '2048', emoji: '🔢', tag: 'Casual'),
      GameTileData(title: 'Stack Game', emoji: '🧱', tag: 'Arcade'),
      GameTileData(title: 'Color Switch', emoji: '🎨', tag: 'Skill'),
      GameTileData(title: 'Endless Runner', emoji: '🏃', tag: 'Action-lite'),
    ],
  ),
  GameCategoryData(
    name: 'Arcade Games',
    description: 'Classic intensity with smooth action loops.',
    gradient: AppGradients.arcade,
    games: [
      GameTileData(title: 'Brick Breaker', emoji: '🧱', tag: 'Classic'),
      GameTileData(title: 'Space Shooter', emoji: '🚀', tag: 'Neon'),
      GameTileData(title: 'Pacman', emoji: '👾', tag: 'Retro'),
      GameTileData(title: 'Pinball', emoji: '🎯', tag: 'Physics'),
      GameTileData(title: 'Fruit Ninja', emoji: '🍉', tag: 'Swipe'),
    ],
  ),
  GameCategoryData(
    name: 'Puzzle Games',
    description: 'Brain-focused play with calm premium visuals.',
    gradient: AppGradients.puzzle,
    games: [
      GameTileData(title: 'Sudoku', emoji: '🔢', tag: 'Logic'),
      GameTileData(title: 'Match-3', emoji: '🍬', tag: 'Popular'),
      GameTileData(title: 'Word Puzzle', emoji: '🧩', tag: 'Word'),
      GameTileData(title: 'Memory Cards', emoji: '🧠', tag: 'Memory'),
      GameTileData(title: 'Maze Game', emoji: '🌀', tag: 'Pathfinding'),
    ],
  ),
  GameCategoryData(
    name: 'Action Games',
    description: 'Impact-heavy gameplay and speed-driven excitement.',
    gradient: AppGradients.action,
    games: [
      GameTileData(title: 'Shooting Game', emoji: '🔫', tag: 'Shooter'),
      GameTileData(title: 'Zombie Survival', emoji: '🧟', tag: 'Survival'),
      GameTileData(title: 'Car Racing', emoji: '🏎️', tag: 'Speed'),
      GameTileData(title: 'Platformer', emoji: '🕹️', tag: 'Adventure'),
    ],
  ),
  GameCategoryData(
    name: 'Multiplayer Games',
    description: 'Competitive and social modes built for retention.',
    gradient: AppGradients.multiplayer,
    games: [
      GameTileData(title: 'Ludo', emoji: '🎲', tag: 'Social'),
      GameTileData(title: 'Chess', emoji: '♟️', tag: 'Strategy'),
      GameTileData(title: '1v1 Shooting', emoji: '🎯', tag: 'PvP'),
      GameTileData(title: 'Quiz Battle', emoji: '🧠', tag: 'Realtime'),
      GameTileData(title: 'Realtime Racing', emoji: '🏁', tag: 'Live'),
    ],
  ),
  GameCategoryData(
    name: 'Unique / Modern',
    description: 'Innovative formats for standout brand identity.',
    gradient: AppGradients.unique,
    games: [
      GameTileData(title: 'AI Opponent Games', emoji: '🤖', tag: 'Smart'),
      GameTileData(title: 'Voice-Controlled Game', emoji: '🎤', tag: 'Voice'),
      GameTileData(title: 'AR Games', emoji: '📱', tag: 'AR'),
      GameTileData(title: 'Reaction Speed Test', emoji: '⚡', tag: 'Reflex'),
      GameTileData(title: 'Brain Training', emoji: '🧠', tag: 'Cognitive'),
    ],
  ),
];
