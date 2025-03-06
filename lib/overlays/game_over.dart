import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:knife_hit_game/blocs/game_settings_bloc/game_settings_bloc.dart';
import 'package:knife_hit_game/blocs/game_stats_bloc/game_stats_bloc.dart';
import 'package:knife_hit_game/design/neon_text.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/knife_hit_game.dart';

class GameOver extends StatelessWidget {
  const GameOver({super.key, required this.game});
  static const String overlayName = 'GameOver';

  // Reference to parent game.
  final KnifeHitGame game;

  @override
  Widget build(BuildContext context) {
    final statsBloc = context.watch<GameStatsBloc>();
    final settingsBloc = context.watch<GameSettingsBloc>();

    return Material(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 300,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const NeonText(
                text: 'GAME OVER',
                color: Colors.red,
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: GameConstants.primaryFontFamily,
                ),
              ),
              const Gap(20),
              NeonText(
                text: 'Score: ${statsBloc.state.score}',
                color: Colors.white,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: GameConstants.primaryFontFamily,
                ),
              ),
              const Gap(10),
              NeonText(
                text: 'Best Score: ${settingsBloc.state.bestScore}',
                color: Colors.yellow,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: GameConstants.primaryFontFamily,
                ),
              ),
              const Gap(10),
              NeonText(
                text: 'Level: ${statsBloc.state.level}',
                color: Colors.blue,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: GameConstants.primaryFontFamily,
                ),
              ),
              const Gap(10),
              NeonText(
                text: 'Best Level: ${settingsBloc.state.highestLevel}',
                color: Colors.green,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: GameConstants.primaryFontFamily,
                ),
              ),
              const Gap(30),
              ElevatedButton(
                onPressed: () {
                  // Reset the game state first
                  context.read<GameStatsBloc>().add(
                    const GameStatsEvent.gameReset(),
                  );

                  // Then reset the game components
                  game.reset();
                  game.overlays.remove(overlayName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'PLAY AGAIN',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: GameConstants.primaryFontFamily,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
