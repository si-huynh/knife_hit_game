import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:knife_hit_game/blocs/game_stats_bloc/game_stats_bloc.dart';
import 'package:knife_hit_game/design/neon_text.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/knife_hit_game.dart';
import 'package:knife_hit_game/router/game_router.dart';

class GameControls extends StatelessWidget {
  const GameControls({super.key, required this.game});
  static const String overlayName = 'GameControls';

  final KnifeHitGame game;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              const Gap(16),
              IconButton(
                onPressed: () {
                  game.dispose();
                  context.router.navigate(const MainMenuRoute());
                },
                icon: Image.asset(
                  'assets/images/layers/back_button.png',
                  width: 48,
                  height: 48,
                ),
              ),
              const Spacer(),
              // Game stats display
              BlocBuilder<GameStatsBloc, GameStatsState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      // Level indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.yellow),
                        ),
                        child: NeonText(
                          text: 'LEVEL ${state.level}',
                          color: Colors.yellow,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: GameConstants.primaryFontFamily,
                          ),
                        ),
                      ),
                      const Gap(10),
                      // Score indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white),
                        ),
                        child: NeonText(
                          text: 'SCORE: ${state.score}',
                          color: Colors.white,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: GameConstants.primaryFontFamily,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Gap(16),
            ],
          ),
          const Spacer(),
          // Knives remaining indicator
          BlocBuilder<GameStatsBloc, GameStatsState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < state.numOfKnives; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Image.asset(
                          'assets/images/layers/knives.png',
                          width: 12,
                          height: 50,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
