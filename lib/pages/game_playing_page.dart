import 'package:auto_route/auto_route.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:knife_hit_game/knife_hit_game.dart';
import 'package:knife_hit_game/overlays/game_controls.dart';
import 'package:knife_hit_game/overlays/game_over.dart';
import 'package:flame_audio/flame_audio.dart';

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
  bool _wasMusicPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Handle app lifecycle changes
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // App is in background or being closed
        // Save music state and pause it
        _wasMusicPlaying = FlameAudio.bgm.isPlaying;
        if (_wasMusicPlaying) {
          FlameAudio.bgm.pause();
        }
        // Pause the game
        _game.pauseEngine();
        break;
      case AppLifecycleState.resumed:
        // App is in foreground and visible
        // Resume music if it was playing before
        if (_wasMusicPlaying && _game.isSettingsMusicOn()) {
          FlameAudio.bgm.resume();
        }
        // Resume the game
        _game.resumeEngine();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _game.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.transparent, child: _gameWidget);
  }
}
