import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knife_hit_game/blocs/game_settings_bloc/game_settings_bloc.dart';
import 'package:knife_hit_game/blocs/game_stats_bloc/game_stats_bloc.dart';
import 'package:knife_hit_game/components/knife.dart';
import 'package:knife_hit_game/components/timber.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/manager/game_manager.dart';
import 'package:knife_hit_game/overlays/game_controls.dart';

class KnifeHitGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  KnifeHitGame({required this.context}) : super();
  final BuildContext context;
  final manager = GameManager();

  late double windowHeight;
  late double windowWidth;
  late World _world;
  late Timber timber;
  late Knife knife;

  late final FlameMultiBlocProvider _blocProvider;
  late final FlameBlocProvider<GameStatsBloc, GameStatsState>
  _statsBlocProvider;
  late final FlameBlocProvider<GameSettingsBloc, GameSettingsState>
  _settingsBlocProvider;
  late final GameStatsBloc _statsBloc;
  late final GameSettingsBloc _settingsBloc;

  late final FlameBlocListener<GameSettingsBloc, GameSettingsState>
  _settingsListener;
  // late final FlameBlocListener<GameStatsBloc, GameStatsState> _statsListener;

  bool isThrowing = false;
  bool isInitialized = false;

  @override
  bool get debugMode => kDebugMode;

  @override
  void onGameResize(Vector2 size) {
    windowHeight = size.y;
    windowWidth = size.x;
    super.onGameResize(size);
  }

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    // Load and cache images
    await Flame.images.load(GameConstants.timber);
    await Flame.images.load(GameConstants.knives);

    await FlameAudio.audioCache.loadAll([
      GameConstants.hitKnife,
      GameConstants.hitTimber,
    ]);

    // Initialize blocs
    _statsBloc = context.read<GameStatsBloc>();
    _settingsBloc = context.read<GameSettingsBloc>();
    _statsBlocProvider = FlameBlocProvider<GameStatsBloc, GameStatsState>(
      create: () => _statsBloc,
    );
    _settingsBlocProvider =
        FlameBlocProvider<GameSettingsBloc, GameSettingsState>(
          create: () => _settingsBloc,
        );
    _blocProvider = FlameMultiBlocProvider(
      providers: [_statsBlocProvider, _settingsBlocProvider],
    );

    // Initialize settings listener
    _settingsListener = FlameBlocListener<GameSettingsBloc, GameSettingsState>(
      bloc: _settingsBloc,
      onInitialState: (state) {
        if (state.isMusicOn && !FlameAudio.bgm.isPlaying) {
          FlameAudio.bgm.play(GameConstants.backgroundMusic, volume: 0.2);
        }
      },
      onNewState: (state) {
        if (state.isMusicOn) {
          FlameAudio.bgm.play(GameConstants.backgroundMusic, volume: 0.2);
        } else if (!state.isMusicOn && FlameAudio.bgm.isPlaying) {
          FlameAudio.bgm.stop();
        }
      },
    );

    _world = World()..addAll([_blocProvider, _settingsListener]);
    add(_world);

    // Initialize camera
    camera
      ..world = _world
      ..viewfinder.zoom = 1.0
      ..viewfinder.visibleGameSize = Vector2(
        GameConstants.cameraWidth,
        GameConstants.cameraHeight,
      )
      ..viewfinder.position = Vector2(
        GameConstants.cameraWidth / 2,
        GameConstants.cameraHeight / 2,
      )
      ..viewfinder.anchor = Anchor.center;

    // Initialize components
    await initialize();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    throwKnife();
  }

  Future<void> initialize({String ctx = 'Game'}) async {
    if (kDebugMode) {
      print('initialize $ctx');
    }
    if (isInitialized) {
      return;
    }
    isInitialized = true;
    overlays.add(GameControls.overlayName);

    // First create the components
    timber = Timber(
      GameConstants.cameraWidth / 2,
      GameConstants.cameraHeight / 4 + 50,
      angle: 0,
    );

    knife = Knife(
      GameConstants.cameraWidth / 2,
      GameConstants.cameraHeight - 150,
      0,
    );

    // Initialize world
    _world.addAll([timber, knife]);
  }

  void throwKnife() {
    knife.canUpdate = true;
    isThrowing = true;
  }

  void playHitKnife() {
    if (_settingsBloc.state.isSoundOn) {
      FlameAudio.play(GameConstants.hitKnife);
    }
  }

  void playHitTimber() {
    if (_settingsBloc.state.isSoundOn) {
      FlameAudio.play(GameConstants.hitTimber);
    }
  }

  void resetKnife() {
    knife.removeFromParent();
    knife = Knife(
      GameConstants.cameraWidth / 2,
      GameConstants.cameraHeight - 150,
      0,
    );
    _world.add(knife);
    isThrowing = false;
  }

  void dispose() {
    _world.removeAll([timber, knife]);
    overlays.remove(GameControls.overlayName);
    isInitialized = false;
  }

  Future<void> gameOver() async {
    // statsBloc.add(PlayerDied());
    // int score = await LocalStorageSettingsPersistence().getBestScore();

    // context
    //     .read<SettingsController>()
    //     .setBesetScore(max(statsBloc.state.score, score));
    // Future.delayed(Duration(milliseconds: 500), () {
    //   showGeneralDialog(
    //       context: context,
    //       pageBuilder: (context, animation, secondaryAnimation) =>
    //           GameOverDialog(
    //               animation: animation, score: statsBloc.state.score));
    // });
  }

  void reset() {
    manager.reset();
  }
}
