import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:knife_hit_game/knife_hit_game.dart';
import 'package:knife_hit_game/router/game_router.dart';

class GameControls extends StatelessWidget {
  const GameControls({super.key, required this.game});
  static const overlayName = 'GameControls';

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
            ],
          ),
        ],
      ),
    );
  }
}
