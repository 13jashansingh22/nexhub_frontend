import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../app/theme/app_palette.dart';
import '../domain/game_catalog.dart';
import '../../games/game_router.dart';

class GameHubScreen extends StatelessWidget {
  const GameHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundEffects(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: _TopHeader()),
                const SliverToBoxAdapter(child: _HeroBanner()),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: AppSpace.xl),
                  sliver: SliverList.separated(
                    itemCount: allGameCategories.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: AppSpace.lg),
                    itemBuilder:
                        (context, index) => _CategorySection(
                          category: allGameCategories[index],
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundEffects extends StatelessWidget {
  const _BackgroundEffects();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: AppGradients.appBackground),
          ),
        ),
        Positioned(
          top: -120,
          left: -80,
          child: _GlowOrb(
            color: AppPalette.purple.withValues(alpha: 0.22),
            size: 280,
          ),
        ),
        Positioned(
          right: -70,
          top: 160,
          child: _GlowOrb(
            color: AppPalette.cyan.withValues(alpha: 0.18),
            size: 240,
          ),
        ),
        Positioned(
          bottom: -100,
          left: 70,
          child: _GlowOrb(
            color: AppPalette.pink.withValues(alpha: 0.14),
            size: 260,
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.md,
        AppSpace.md,
        AppSpace.md,
        AppSpace.sm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.sm,
              vertical: AppSpace.xs,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadius.sm,
              gradient: AppGradients.glass,
              border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
              boxShadow: AppGlow.softPurple(16),
            ),
            child: const Row(
              children: [
                Text('🎮', style: TextStyle(fontSize: 18)),
                SizedBox(width: AppSpace.xs),
                Text(
                  'NexMeet Games',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.notifications_none_rounded,
            color: AppPalette.textPrimary,
          ),
          const SizedBox(width: AppSpace.sm),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white.withValues(alpha: 0.14),
            child: const Text(
              'N',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpace.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpace.md),
        decoration: BoxDecoration(
          gradient: AppGradients.hero,
          borderRadius: AppRadius.lg,
          boxShadow: AppGlow.neonCyan(34),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpace.sm,
                vertical: AppSpace.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: AppRadius.sm,
              ),
              child: const Text(
                'High-Graphics Portfolio Theme',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: AppSpace.md),
            const Text(
              'Play. Compete. Level Up.',
              style: TextStyle(
                fontSize: 28,
                height: 1.1,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpace.sm),
            const Text(
              'Neon gradients, glass panels, smooth cards, and premium visuals for all game categories.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpace.md),
            Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.sm,
              children: const [
                _MetricChip(label: 'Games', value: '30+'),
                _MetricChip(label: 'Modes', value: 'Casual • PvP • AI'),
                _MetricChip(label: 'Design', value: 'Neon + Glass'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.sm,
        vertical: AppSpace.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.16),
        borderRadius: AppRadius.sm,
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.category});

  final GameCategoryData category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: const TextStyle(
                  color: AppPalette.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpace.xs),
              Text(
                category.description,
                style: const TextStyle(
                  color: AppPalette.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.md),
        SizedBox(
          height: 160,
          child: ListView.separated(
            itemCount: category.games.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
            separatorBuilder:
                (context, index) => const SizedBox(width: AppSpace.sm),
            itemBuilder: (context, index) {
              final game = category.games[index];
              return _GameCard(game: game, gradient: category.gradient);
            },
          ),
        ),
      ],
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game, required this.gradient});

  final GameTileData game;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 148,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final screen = getGameScreenByTitle(game.title);
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => screen));
          },
          borderRadius: AppRadius.md,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.md,
              gradient: gradient,
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -14,
                  top: -14,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpace.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(game.emoji, style: const TextStyle(fontSize: 30)),
                      const Spacer(),
                      Text(
                        game.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: AppSpace.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpace.xs,
                          vertical: AppSpace.xxs,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.sm,
                          color: Colors.black.withValues(alpha: 0.22),
                        ),
                        child: Text(
                          game.tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
