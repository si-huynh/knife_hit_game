import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knife_hit_game/blocs/game_settings_bloc/game_settings_bloc.dart';
import 'package:knife_hit_game/blocs/game_stats_bloc/game_stats_bloc.dart';
import 'package:knife_hit_game/components/background.dart';
import 'package:knife_hit_game/components/knife.dart';
import 'package:knife_hit_game/components/timber.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/manager/game_manager.dart';

class KnifeHitGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  KnifeHitGame({required this.context}) : super();

  final manager = GameManager();

  late double windowHeight;
  late double windowWidth;
  late World _world;
  late Timber timber;
  late Knife knife;

  final BuildContext context;

  bool isThrowing = false;

  @override
  void onGameResize(Vector2 size) {
    windowHeight = size.y;
    windowWidth = size.x;
    super.onGameResize(size);
  }

  @override
  Color backgroundColor() {
    return Colors.white;
  }

  @override
  Future<void> onLoad() async {
    // Load and cache images
    await Flame.images.load(GameConstants.background);
    await Flame.images.load(GameConstants.timber);
    await Flame.images.load(GameConstants.knives);

    // await FlameAudio.bgm.play(GameConstants.backgroundMusic, volume: 0.2);

    final background = Background();
    _world = World()..add(background);
    add(_world);

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

    _world.add(
      FlameBlocListener<GameSettingsBloc, GameSettingsState>(
        bloc: context.read<GameSettingsBloc>(),
        onInitialState: (state) {
          if (state.isMusicOn && !FlameAudio.bgm.isPlaying) {
            FlameAudio.bgm.play(GameConstants.backgroundMusic, volume: 0.2);
          } else if (!state.isMusicOn && FlameAudio.bgm.isPlaying) {
            FlameAudio.bgm.stop();
          }
        },
        onNewState: (state) {
          if (state.isMusicOn) {
            FlameAudio.bgm.play(GameConstants.backgroundMusic, volume: 0.2);
          } else {
            FlameAudio.bgm.stop();
          }
        },
      ),
    );
  }

  @override
  void onDispose() {
    FlameAudio.bgm.stop();
    super.onDispose();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    throwKnife();
  }

  Future<void> initialize() async {
    // First create the components
    timber = Timber(
      GameConstants.cameraWidth / 2,
      GameConstants.cameraHeight / 4,
    );

    knife = Knife(
      GameConstants.cameraWidth / 2,
      GameConstants.cameraHeight - 150,
      0,
    );

    // Create and add the bloc provider
    final blocProvider = FlameMultiBlocProvider(
      providers: [
        FlameBlocProvider<GameStatsBloc, GameStatsState>(
          create: buildContext!.read<GameStatsBloc>,
        ),
        FlameBlocProvider<GameSettingsBloc, GameSettingsState>(
          create: buildContext!.read<GameSettingsBloc>,
        ),
      ],
      children: [timber, knife],
    );

    // Add the bloc provider to world
    _world.add(blocProvider);

    await _world.add(
      FlameBlocListener<GameSettingsBloc, GameSettingsState>(
        bloc: buildContext!.read<GameSettingsBloc>(),
        onNewState: (state) {
          if (state.isMusicOn) {
            print('play music');
            // FlameAudio.bgm.play(GameConstants.backgroundMusic, volume: 0.2);
          } else {
            print('stop music');
            //FlameAudio.bgm.stop();
          }
        },
      ),
    );
  }

  @override
  void onAttach() {
    super.onAttach();

    _world.add(
      FlameBlocListener<GameSettingsBloc, GameSettingsState>(
        bloc: buildContext!.read<GameSettingsBloc>(),
        onNewState: (state) {
          print('settings state changed in game: $state');
        },
      ),
    );
  }

  void throwKnife() {
    knife.canUpdate = true;
    isThrowing = true;
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
