import 'package:auto_route/auto_route.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:knife_hit_game/knife_hit_game.dart';
import 'package:knife_hit_game/overlays/game_controls.dart';
import 'package:knife_hit_game/overlays/game_over.dart';

@RoutePage()
class GamePlayingPage extends StatefulWidget {
  const GamePlayingPage({super.key});

  @override
  State<GamePlayingPage> createState() => _GamePlayingPageState();
}

class _GamePlayingPageState extends State<GamePlayingPage>
    with WidgetsBindingObserver {
  late final KnifeHitGame _game;
  late final GameWidget<KnifeHitGame> _gameWidget;

  @override
  void initState() {
    super.initState();
    _game = KnifeHitGame(context: context);
    _gameWidget = GameWidget<KnifeHitGame>.controlled(
      gameFactory: () => _game,
      overlayBuilderMap: {
        GameControls.overlayName: (context, game) => GameControls(game: game),
        GameOver.overlayName: (context, game) => GameOver(game: game),
      },
      initialActiveOverlays: const [GameControls.overlayName],
    );

    // Initialize the game when the page is active
    AutoTabsRouter.of(context).addListener(() {
      final tabRouter = AutoTabsRouter.of(context);
      if (tabRouter.activeIndex == 1 && _game.isLoaded) {
        _game.initialize(ctx: 'GamePlayingPage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.transparent, child: _gameWidget);
  }
}
