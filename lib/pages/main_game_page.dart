import 'package:auto_route/annotations.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:knife_hit_game/knife_hit_game.dart';
import 'package:knife_hit_game/overlays/main_menu.dart';

@RoutePage()
class MainGamePage extends StatelessWidget {
  const MainGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GameWidget<KnifeHitGame>.controlled(
        gameFactory: () => KnifeHitGame(context: context),
        overlayBuilderMap: {
          MainMenu.overlayName: (context, game) => MainMenu(game: game),
        },
        initialActiveOverlays: const [MainMenu.overlayName],
      ),
    );
  }
}
