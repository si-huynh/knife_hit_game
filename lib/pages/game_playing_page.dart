import 'package:auto_route/auto_route.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:knife_hit_game/knife_hit_game.dart';
import 'package:knife_hit_game/overlays/game_controls.dart';

@RoutePage()
class GamePlayingPage extends StatefulWidget {
  const GamePlayingPage({super.key});

  @override
  State<GamePlayingPage> createState() => _GamePlayingPageState();
}

class _GamePlayingPageState extends State<GamePlayingPage>
    with WidgetsBindingObserver, AutoRouteAware {
  late final KnifeHitGame _game;
  late final GameWidget<KnifeHitGame> _gameWidget;
  late final AutoRouteObserver? _observer;

  @override
  void initState() {
    super.initState();
    _game = KnifeHitGame(context: context);
    _gameWidget = GameWidget<KnifeHitGame>.controlled(
      gameFactory: () => _game,
      overlayBuilderMap: {
        GameControls.overlayName: (context, game) => GameControls(game: game),
      },
      initialActiveOverlays: const [GameControls.overlayName],
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _observer =
        RouterScope.of(context).firstObserverOfType<AutoRouteObserver>();
    if (_observer != null) {
      _observer.subscribe(this, context.routeData);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // print('resumed');
        break;
      case AppLifecycleState.paused:
        // print('paused');
        break;
      case AppLifecycleState.detached:
        // print('detached');
        break;
      case AppLifecycleState.inactive:
        // print('inactive');
        break;
      case AppLifecycleState.hidden:
        // print('hidden');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.transparent, child: _gameWidget);
  }

  @override
  void didInitTabRoute(TabPageRoute? previousRoute) {
    print('GamePlayingPage didInitTabRoute ${previousRoute?.name}');
    super.didInitTabRoute(previousRoute);
  }

  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    print('GamePlayingPage didChangeTabRoute ${previousRoute.name}');
    super.didChangeTabRoute(previousRoute);
    if (previousRoute.name == 'MainMenuRoute') {
      _game.initialize();
    }
  }
}
