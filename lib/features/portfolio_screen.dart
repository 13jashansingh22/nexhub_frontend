import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../app/theme/app_palette.dart';

class _GameEntry {
  final String title;
  final String description;
  final String badge;
  final IconData icon;
  final LinearGradient gradient;

  const _GameEntry({
    required this.title,
    required this.description,
    required this.badge,
    required this.icon,
    required this.gradient,
  });
}

class ShortGamePortfolio extends StatelessWidget {
  final List<_GameEntry> games;
  final void Function(String title)? onGameTap;
  const ShortGamePortfolio({super.key, required this.games, this.onGameTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 420;
        final tileWidth = isCompact ? 134.0 : 170.0;
        return SizedBox(
          height: isCompact ? 170 : 188,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
            itemCount: games.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final game = games[index];
              return _GameTile(
                game: game,
                compact: true,
                width: tileWidth,
                onTap: () => onGameTap?.call(game.title),
              );
            },
          ),
        );
      },
    );
  }
}

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _Particle {
  double x, y, dx, dy, radius, opacity;
  Color color;
  _Particle(
    this.x,
    this.y,
    this.dx,
    this.dy,
    this.radius,
    this.opacity,
    this.color,
  );
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  static const List<_GameEntry> _fallbackGames = [
    _GameEntry(
      title: 'Snake',
      description: 'Classic arcade with a sharp neon board.',
      badge: 'Arcade',
      icon: Icons.sports_esports_rounded,
      gradient: AppGradients.arcade,
    ),
    _GameEntry(
      title: 'Asteroids',
      description: 'Dodge debris and survive the field.',
      badge: 'Action',
      icon: Icons.rocket_launch_rounded,
      gradient: AppGradients.action,
    ),
    _GameEntry(
      title: 'Flappy Bird',
      description: 'Tap into a brighter take on the classic flyer.',
      badge: 'Arcade',
      icon: Icons.flutter_dash_rounded,
      gradient: AppGradients.casual,
    ),
    _GameEntry(
      title: 'Tic Tac Toe',
      description: 'Fast matches with a clean neon board.',
      badge: 'Quick Play',
      icon: Icons.grid_view_rounded,
      gradient: AppGradients.casual,
    ),
    _GameEntry(
      title: '2048',
      description: 'Merge tiles and push the score higher.',
      badge: 'Puzzle',
      icon: Icons.paste_rounded,
      gradient: AppGradients.puzzle,
    ),
    _GameEntry(
      title: 'Sudoku',
      description: 'Focus, logic, and a polished puzzle grid.',
      badge: 'Logic',
      icon: Icons.center_focus_strong_rounded,
      gradient: AppGradients.unique,
    ),
    _GameEntry(
      title: 'Memory Match',
      description: 'Train your recall with crisp feedback.',
      badge: 'Brain',
      icon: Icons.psychology_alt_rounded,
      gradient: AppGradients.multiplayer,
    ),
    _GameEntry(
      title: 'Chess',
      description: 'A classic strategy board with a dark polish.',
      badge: 'Strategy',
      icon: Icons.extension_rounded,
      gradient: AppGradients.multiplayer,
    ),
    _GameEntry(
      title: 'Minesweeper',
      description: 'Careful reveals and a crisp victory path.',
      badge: 'Tactical',
      icon: Icons.radar_rounded,
      gradient: AppGradients.puzzle,
    ),
    _GameEntry(
      title: 'Pong',
      description: 'Retro paddle action with a modern skin.',
      badge: 'Retro',
      icon: Icons.sports_tennis_rounded,
      gradient: AppGradients.casual,
    ),
    _GameEntry(
      title: 'Breakout',
      description: 'Smash through bricks with reactive play.',
      badge: 'Arcade',
      icon: Icons.auto_awesome_rounded,
      gradient: AppGradients.action,
    ),
    _GameEntry(
      title: 'Coming Soon',
      description: 'New experiences are already in the queue.',
      badge: 'Next up',
      icon: Icons.upcoming_rounded,
      gradient: AppGradients.hero,
    ),
  ];

  final Dio _dio = Dio();
  late List<_GameEntry> _games = List.of(_fallbackGames);
  List<String> _supportedInputModes = const ['touch', 'keyboard'];
  String? _catalogStatus;

  late AnimationController _bgController;
  List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _bgController =
        AnimationController(vsync: this, duration: const Duration(seconds: 60))
          ..addListener(_updateParticles)
          ..repeat();
    _initParticles();
    _loadGameCatalog();
  }

  String get _catalogBaseUrl {
    const configured = String.fromEnvironment(
      'NEXHUB_API_BASE_URL',
      defaultValue: '',
    );

    if (configured.isNotEmpty) {
      return configured;
    }

    if (kIsWeb) {
      return 'http://localhost:5000/api/v1';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:5000/api/v1';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        return 'http://localhost:5000/api/v1';
    }
  }

  Future<void> _loadGameCatalog() async {
    try {
      final response = await _dio.get('$_catalogBaseUrl/games/catalog');
      final payload = response.data;

      if (payload is Map<String, dynamic>) {
        final data = payload['data'];
        if (data is Map<String, dynamic>) {
          final rawGames = data['games'];
          final rawModes = data['inputModes'];

          if (rawGames is List) {
            final fetchedGames = rawGames
                .whereType<Map>()
                .map(
                  (game) => _GameEntry(
                    title: '${game['title'] ?? ''}',
                    description:
                        '${game['description'] ?? 'Tap to launch a game.'}',
                    badge: '${game['badge'] ?? 'Play'}',
                    icon: _iconForGame(
                      '${game['slug'] ?? ''}',
                      '${game['title'] ?? ''}',
                    ),
                    gradient: _gradientForGame(
                      '${game['category'] ?? ''}',
                      '${game['title'] ?? ''}',
                    ),
                  ),
                )
                .toList(growable: false);

            if (mounted) {
              setState(() {
                if (fetchedGames.isNotEmpty) {
                  _games = fetchedGames;
                }
                _supportedInputModes =
                    rawModes is List
                        ? rawModes.map((mode) => '$mode').toList()
                        : const ['touch', 'keyboard'];
                _catalogStatus = 'Live catalog connected';
              });
            }
            return;
          }
        }
      }

      if (mounted) {
        setState(() {
          _catalogStatus = 'Using local fallback catalog';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _catalogStatus = 'Offline fallback catalog';
        });
      }
    }
  }

  IconData _iconForGame(String slug, String title) {
    switch (slug.toLowerCase()) {
      case 'snake':
        return Icons.sports_esports_rounded;
      case 'asteroids':
        return Icons.rocket_launch_rounded;
      case 'flappy-bird':
      case 'flappy bird':
        return Icons.flutter_dash_rounded;
      case 'tic-tac-toe':
      case 'tic tac toe':
        return Icons.grid_view_rounded;
      case '2048':
        return Icons.paste_rounded;
      case 'sudoku':
        return Icons.center_focus_strong_rounded;
      case 'memory-match':
      case 'memory match':
        return Icons.psychology_alt_rounded;
      case 'chess':
        return Icons.extension_rounded;
      case 'minesweeper':
        return Icons.radar_rounded;
      case 'pong':
        return Icons.sports_tennis_rounded;
      case 'breakout':
        return Icons.auto_awesome_rounded;
      default:
        switch (title.toLowerCase()) {
          case 'snake':
            return Icons.sports_esports_rounded;
          case 'asteroids':
            return Icons.rocket_launch_rounded;
          case 'flappy bird':
            return Icons.flutter_dash_rounded;
          case 'tic tac toe':
            return Icons.grid_view_rounded;
          case '2048':
            return Icons.paste_rounded;
          case 'sudoku':
            return Icons.center_focus_strong_rounded;
          case 'memory match':
            return Icons.psychology_alt_rounded;
          case 'chess':
            return Icons.extension_rounded;
          case 'minesweeper':
            return Icons.radar_rounded;
          case 'pong':
            return Icons.sports_tennis_rounded;
          case 'breakout':
            return Icons.auto_awesome_rounded;
          default:
            return Icons.videogame_asset_rounded;
        }
    }
  }

  LinearGradient _gradientForGame(String category, String title) {
    switch (category.toLowerCase()) {
      case 'arcade':
        return AppGradients.arcade;
      case 'puzzle':
        return AppGradients.puzzle;
      case 'action':
        return AppGradients.action;
      case 'multiplayer':
        return AppGradients.multiplayer;
      case 'unique':
        return AppGradients.unique;
      default:
        switch (title.toLowerCase()) {
          case 'snake':
          case 'flappy bird':
          case 'breakout':
            return AppGradients.arcade;
          case 'asteroids':
          case 'pong':
            return AppGradients.action;
          case '2048':
          case 'sudoku':
          case 'memory match':
            return AppGradients.puzzle;
          case 'chess':
            return AppGradients.multiplayer;
          case 'coming soon':
            return AppGradients.hero;
          default:
            return AppGradients.casual;
        }
    }
  }

  void _initParticles() {
    final random = Random();
    _particles = List.generate(36, (i) {
      final radius = random.nextDouble() * 2.5 + 1.5;
      final x = random.nextDouble() * 600;
      final y = random.nextDouble() * 1200;
      final dx = (random.nextDouble() - 0.5) * 0.7;
      final dy = (random.nextDouble() - 0.5) * 0.7;
      final opacity = random.nextDouble() * 0.5 + 0.2;
      final color =
          Color.lerp(
            Colors.cyanAccent,
            Colors.deepPurpleAccent,
            random.nextDouble(),
          )!;
      return _Particle(x, y, dx, dy, radius, opacity, color);
    });
  }

  void _updateParticles() {
    final random = Random();
    for (final p in _particles) {
      p.x += p.dx;
      p.y += p.dy;
      if (p.x < 0 || p.x > 600) {
        p.dx = -p.dx + (random.nextDouble() - 0.5) * 0.1;
      }
      if (p.y < 0 || p.y > 1200) {
        p.dy = -p.dy + (random.nextDouble() - 0.5) * 0.1;
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          titleSpacing: 12,
          title: ShaderMask(
            shaderCallback:
                (bounds) => const LinearGradient(
                  colors: [AppPalette.cyan, AppPalette.purple, AppPalette.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
            child: const Text(
              'NexHub Games',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 26,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: false,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Animated gradient background
            AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.lerp(
                          AppPalette.bgDeep,
                          AppPalette.purple,
                          0.5 + 0.5 * sin(_bgController.value * 2 * pi),
                        )!,
                        Color.lerp(
                          AppPalette.bgMid,
                          AppPalette.cyan,
                          0.5 + 0.5 * cos(_bgController.value * 2 * pi),
                        )!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                );
              },
            ),
            // Particle effect overlay
            IgnorePointer(
              child: CustomPaint(
                painter: _ParticlePainter(_particles),
                size: Size.infinite,
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  screenWidth < 420 ? 12 : 16,
                  12,
                  screenWidth < 420 ? 12 : 16,
                  28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroPanel(context),
                    const SizedBox(height: 22),
                    _buildSectionHeader(
                      title: 'Featured Arcade',
                      subtitle:
                          'Quick-launch picks with strong first impressions.',
                    ),
                    ShortGamePortfolio(
                      games: _games.take(7).toList(),
                      onGameTap: (title) {
                        GoRouter.of(context).push('/game', extra: title);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSectionHeader(
                      title: 'All Games',
                      subtitle:
                          'A responsive catalog built for quick browsing.',
                    ),
                    const SizedBox(height: 14),
                    _buildGameGrid(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroPanel(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compactHero = screenWidth < 520;
    final primaryGameTitle = _games.isNotEmpty ? _games.first.title : 'Snake';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compactHero ? 18 : 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.14),
            Colors.white.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (compactHero)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppGradients.hero,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.gamepad_rounded, color: Colors.white),
                ),
                const SizedBox(height: 14),
                Text(
                  'Your gaming shelf, cleaned up',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppPalette.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Launch from a polished arcade hub with no missing assets or dead states.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppPalette.textMuted,
                    height: 1.45,
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppGradients.hero,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.gamepad_rounded, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your gaming shelf, cleaned up',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: AppPalette.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Launch from a polished arcade hub with no missing assets or dead states.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppPalette.textMuted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _StatChip(
                label: '${_games.length} games',
                icon: Icons.videogame_asset_rounded,
              ),
              _StatChip(
                label: _supportedInputModes.join(' • '),
                icon: Icons.touch_app_rounded,
              ),
              _StatChip(
                label: _catalogStatus ?? 'Live catalog',
                icon: Icons.cloud_done_rounded,
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                if (_games.isEmpty) {
                  return;
                }
                GoRouter.of(context).push('/game', extra: _games.first.title);
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text('Start with $primaryGameTitle'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppPalette.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppPalette.textMuted,
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount =
            constraints.maxWidth < 420
                ? 1
                : (constraints.maxWidth > 720 ? 3 : 2);
        final childAspectRatio =
            constraints.maxWidth < 420
                ? 1.55
                : (constraints.maxWidth > 720 ? 1.18 : 0.95);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _games.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final game = _games[index];
            return _GameTile(
              game: game,
              compact: false,
              onTap:
                  () => GoRouter.of(context).push('/game', extra: game.title),
            );
          },
        );
      },
    );
  }
}

class _GameTile extends StatefulWidget {
  final _GameEntry game;
  final VoidCallback onTap;
  final bool compact;
  final double? width;

  const _GameTile({
    required this.game,
    required this.onTap,
    required this.compact,
    this.width,
  });

  @override
  State<_GameTile> createState() => _GameTileState();
}

class _GameTileState extends State<_GameTile> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(24);

    return SizedBox(
      width: widget.width,
      height: widget.compact ? 156 : 228,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              widget.onTap();
              return null;
            },
          ),
        },
        onShowFocusHighlight: (value) {
          if (!mounted) {
            return;
          }
          setState(() {
            _isFocused = value;
          });
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: borderRadius,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              decoration: BoxDecoration(
                gradient: widget.game.gradient,
                borderRadius: borderRadius,
                border: Border.all(
                  color:
                      _isFocused
                          ? AppPalette.cyan.withOpacity(0.95)
                          : Colors.white.withOpacity(0.14),
                  width: _isFocused ? 1.8 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.game.gradient.colors.last.withOpacity(0.24),
                    blurRadius: 22,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(widget.compact ? 12 : 16),
                child: widget.compact ? _buildCompact() : _buildFull(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  widget.game.badge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_outward_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
        Center(
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.14)),
            ),
            child: Icon(widget.game.icon, color: Colors.white, size: 28),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.game.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.game.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(0.88),
                height: 1.2,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFull() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                widget.game.badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_outward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: Icon(widget.game.icon, color: Colors.white, size: 34),
        ),
        const Spacer(),
        Text(
          widget.game.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.game.description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withOpacity(0.88),
            height: 1.3,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppPalette.cyan),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppPalette.textPrimary,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter(this.particles);
  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint =
          Paint()
            ..color = p.color.withOpacity(p.opacity)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset(p.x, p.y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
