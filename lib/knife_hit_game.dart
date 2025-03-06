import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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
import 'package:knife_hit_game/blocs/user_session_bloc/user_session_bloc.dart';
import 'package:knife_hit_game/components/knife.dart';
import 'package:knife_hit_game/components/timber.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/manager/game_manager.dart';
import 'package:knife_hit_game/overlays/game_controls.dart';
import 'package:knife_hit_game/overlays/game_over.dart';

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
  late final FlameBlocListener<GameStatsBloc, GameStatsState> _statsListener;
  late final FlameBlocListener<UserSessionBloc, UserSessionState>
  _userSessionListener;

  bool isThrowing = false;
  bool isInitialized = false;
  bool isTransitioning = false; // Flag to track level transition state

  @override
  bool get debugMode => false;

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

    // Preload all knife images
    await Flame.images.load('knives/basic.png');

    // Elite knives
    for (var i = 1; i <= 4; i++) {
      await Flame.images.load('knives/elite$i.png');
    }

    // Luxury knives
    for (var i = 1; i <= 4; i++) {
      await Flame.images.load('knives/lux$i.png');
    }

    // Premium knives
    for (var i = 1; i <= 4; i++) {
      await Flame.images.load('knives/pre$i.png');
    }

    // Ultimate knives
    for (var i = 1; i <= 4; i++) {
      await Flame.images.load('knives/ulti$i.png');
    }

    await FlameAudio.audioCache.loadAll([
      GameConstants.hitKnife,
      GameConstants.hitTimber,
    ]);

    // Get the selected knife path from the UserSessionBloc
    final userSessionBloc = context.read<UserSessionBloc>();
    final selectedKnifePath = userSessionBloc.getSelectedKnifePath();

    // Load the knife image
    await _loadKnifeImage(selectedKnifePath);

    // First create the components
    timber = Timber(
      GameConstants.cameraWidth / 2,
      GameConstants.cameraHeight / 4 + 50,
      angle: 0,
    );

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

    // Create empty bloc provider (we'll add components later)
    _blocProvider = FlameMultiBlocProvider(
      providers: [_statsBlocProvider, _settingsBlocProvider],
      children: [timber],
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

    _statsListener = FlameBlocListener<GameStatsBloc, GameStatsState>(
      bloc: _statsBloc,
      onNewState: (state) {
        switch (state.status) {
          case GameStatus.gameOver:
            // Save best score if current score is higher
            final currentScore = _statsBloc.state.score;
            final bestScore = _settingsBloc.state.bestScore;

            if (currentScore > bestScore) {
              _settingsBloc.add(
                GameSettingsEvent.updateBestScore(currentScore),
              );
            }

            // Save highest level if current level is higher
            final currentLevel = _statsBloc.state.level;
            final highestLevel = _settingsBloc.state.highestLevel;
            if (currentLevel > highestLevel) {
              _settingsBloc.add(
                GameSettingsEvent.updateHighestLevel(currentLevel),
              );
            }

            // Show game over overlay
            overlays.add(GameOver.overlayName);

            // Don't reset the game state here - we'll do it when the user clicks "Play Again"
            break;
          case GameStatus.respawn:
            resetKnife();
            break;
          case GameStatus.respawned:
            break;
          case GameStatus.initial:
            break;
        }
      },
    );

    _userSessionListener = FlameBlocListener<UserSessionBloc, UserSessionState>(
      bloc: context.read<UserSessionBloc>(),
      onNewState: (state) {
        // Update the knife when the selected knife path changes
        if (isInitialized && state.selectedKnifePath.isNotEmpty) {
          _updateKnifeFromPath(state.selectedKnifePath);
        }
      },
    );

    _world =
        World()..addAll([
          _blocProvider,
          _settingsListener,
          _statsListener,
          _userSessionListener,
        ]);
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

    if (ctx == 'GamePlayingPage') {
      timber = Timber(
        GameConstants.cameraWidth / 2,
        GameConstants.cameraHeight / 4 + 50,
        angle: 0,
      );
      _blocProvider.add(timber);
    }

    isInitialized = true;
    overlays.add(GameControls.overlayName);

    // Get the selected knife path from the UserSessionBloc
    final userSessionBloc = context.read<UserSessionBloc>();
    final selectedKnifePath = userSessionBloc.getSelectedKnifePath();

    // Load and create the knife
    final knifePath = await _loadKnifeImage(selectedKnifePath);
    final (knifeType, variant) = _getKnifeTypeAndVariant(knifePath);
    knife = _createKnife(knifeType, variant, imagePath: knifePath);

    // Add components to the existing bloc provider
    _world.add(knife);
  }

  void throwKnife() {
    // Don't allow throwing if in transition or no knives left
    if (isTransitioning || _statsBloc.state.numOfKnives <= 0) {
      return;
    }

    knife.canUpdate = true;
    isThrowing = true;

    // Decrease the number of knives left
    _statsBloc.add(
      GameStatsEvent.knifeNumEvent(_statsBloc.state.numOfKnives - 1),
    );
  }

  void playHitKnife() {
    if (_settingsBloc.state.isSoundOn) {
      FlameAudio.play(GameConstants.hitKnife);
    }
  }

  void playHitTimber() {
    if (_settingsBloc.state.isSoundOn) {
      FlameAudio.play(GameConstants.hitTimber, volume: 0.1);
    }

    // Increment score when knife hits timber
    _statsBloc.add(const GameStatsEvent.scoreEventAdded(1));

    // Check if level is completed (no knives left)
    if (_statsBloc.state.numOfKnives <= 0) {
      // Level completed
      completeLevel();
    }
  }

  void completeLevel() {
    // Set transitioning flag
    isTransitioning = true;

    // Calculate next level
    final nextLevel = _statsBloc.state.level + 1;

    // Check if we've reached max level (30)
    if (nextLevel > GameConstants.maxLevel) {
      // Game completed - you could add special handling here
      _statsBloc.add(const GameStatsEvent.playerDied());
      return;
    }

    // Update to next level
    _statsBloc.add(GameStatsEvent.levelEventAdded(nextLevel));

    // Set number of knives for next level (base + level)
    _statsBloc.add(
      GameStatsEvent.knifeNumEvent(GameConstants.baseKnivesCount + nextLevel),
    );

    // Add a level transition effect
    showLevelTransition(nextLevel);

    // Reset the game for next level after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      reset();
      // Clear transitioning flag after reset
      isTransitioning = false;
    });
  }

  void showLevelTransition(int level) {
    // Create a full-screen overlay effect
    final levelText = TextComponent(
      text: 'LEVEL $level',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 60,
          fontFamily: GameConstants.primaryFontFamily,
          color: Colors.yellow,
          shadows: [Shadow(color: Colors.orange, blurRadius: 20)],
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(
        GameConstants.cameraWidth / 2,
        GameConstants.cameraHeight / 2,
      ),
    );

    // Add a scaling effect
    levelText.add(
      SequenceEffect(
        [
          ScaleEffect.by(
            Vector2.all(1.5),
            EffectController(duration: 0.5, curve: Curves.easeOut),
          ),
          ScaleEffect.by(
            Vector2.all(0.6),
            EffectController(duration: 0.5, curve: Curves.easeIn),
          ),
          RemoveEffect(),
        ],
        onComplete: () {
          // Effect completed
        },
      ),
    );

    // Add the text to the world
    _world.add(levelText);

    // Play a level up sound if available
    if (_settingsBloc.state.isSoundOn) {
      // FlameAudio.play('level_up.mp3');
    }
  }

  void resetKnife() {
    knife.removeFromParent();

    // Get the selected knife path from the UserSessionBloc
    final userSessionBloc = context.read<UserSessionBloc>();
    final selectedKnifePath = userSessionBloc.getSelectedKnifePath();

    // Clean the knife path
    final knifePath = _cleanKnifePath(selectedKnifePath);

    // Determine knife type and variant
    final (knifeType, variant) = _getKnifeTypeAndVariant(knifePath);

    // Create knife with the selected type and variant
    knife = _createKnife(knifeType, variant, imagePath: knifePath);

    // Add new knife to bloc provider
    _blocProvider.add(knife);
    isThrowing = false;
  }

  void dispose() {
    _blocProvider.remove(timber);
    knife.removeFromParent();
    _statsBloc.add(const GameStatsEvent.gameReset());
    overlays.remove(GameControls.overlayName);
    isInitialized = false;
  }

  Future<void> gameOver() async {
    // Stop the game
    isThrowing = false;
    isTransitioning = false; // Reset transitioning flag

    // Save best score if current score is higher
    final currentScore = _statsBloc.state.score;
    final bestScore = _settingsBloc.state.bestScore;
    if (currentScore > bestScore) {
      _settingsBloc.add(GameSettingsEvent.updateBestScore(currentScore));
    }

    // Save highest level if current level is higher
    final currentLevel = _statsBloc.state.level;
    final highestLevel = _settingsBloc.state.highestLevel;
    if (currentLevel > highestLevel) {
      _settingsBloc.add(GameSettingsEvent.updateHighestLevel(currentLevel));
    }

    // Update game status to game over (now this won't reset the level)
    _statsBloc.add(const GameStatsEvent.playerDied());
  }

  void reset() {
    // Remove old timber
    timber.removeFromParent();

    // Create new timber
    timber = Timber(
      GameConstants.cameraWidth / 2,
      GameConstants.cameraHeight / 4 + 50,
      angle: 0,
    );

    // Add new timber to bloc provider
    _blocProvider.add(timber);

    // Reset knife
    resetKnife();
  }

  // Helper method to clean knife path
  String _cleanKnifePath(String path) {
    var cleanPath = path;

    // Clean up the path if needed
    if (cleanPath.contains('knifePath:')) {
      cleanPath = cleanPath.split('knifePath:').last.trim();
    }

    // Remove assets/images/ prefix if present
    if (cleanPath.startsWith('assets/images/')) {
      cleanPath = cleanPath.substring('assets/images/'.length);
    }

    // Debug the path
    if (kDebugMode) {
      print('Cleaned knife path: $cleanPath');
    }

    return cleanPath;
  }

  // Helper method to load knife image
  Future<String> _loadKnifeImage(String path) async {
    final cleanPath = _cleanKnifePath(path);

    try {
      await Flame.images.load(cleanPath);
      return cleanPath;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading knife image: $e');
        print('Falling back to default knife');
      }
      const defaultPath = 'knives/basic.png';
      await Flame.images.load(defaultPath);
      return defaultPath;
    }
  }

  // Helper method to determine knife type and variant from path
  (KnifeType, int) _getKnifeTypeAndVariant(String path) {
    var knifeType = KnifeType.basic;
    var variant = 0;

    if (path.contains('elite')) {
      knifeType = KnifeType.elite;
      // Extract variant number from the path (e.g., elite1.png -> variant 0)
      final variantStr = path.split('elite')[1].split('.')[0];
      variant = int.tryParse(variantStr) ?? 1;
      variant -= 1; // Convert to 0-based index
    } else if (path.contains('lux')) {
      knifeType = KnifeType.luxury;
      final variantStr = path.split('lux')[1].split('.')[0];
      variant = int.tryParse(variantStr) ?? 1;
      variant -= 1;
    } else if (path.contains('pre')) {
      knifeType = KnifeType.premium;
      final variantStr = path.split('pre')[1].split('.')[0];
      variant = int.tryParse(variantStr) ?? 1;
      variant -= 1;
    } else if (path.contains('ulti')) {
      knifeType = KnifeType.ultimate;
      final variantStr = path.split('ulti')[1].split('.')[0];
      variant = int.tryParse(variantStr) ?? 1;
      variant -= 1;
    }

    return (knifeType, variant);
  }

  // Helper method to create a knife with the selected type and variant
  Knife _createKnife(KnifeType type, int variant, {String? imagePath}) {
    return Knife(
      GameConstants.cameraWidth / 2,
      GameConstants.cameraHeight - 180,
      0,
      type: type,
      variant: variant,
      imagePath: imagePath,
    );
  }

  // Helper method to update the knife based on the selected knife path
  Future<void> _updateKnifeFromPath(String knifePath) async {
    if (kDebugMode) {
      print('Updating knife from path: $knifePath');
    }

    // Don't update if we're in the middle of throwing
    if (isThrowing) {
      if (kDebugMode) {
        print('Skipping knife update because knife is being thrown');
      }
      return;
    }

    // Load the knife image
    final cleanPath = await _loadKnifeImage(knifePath);

    // Determine knife type and variant
    final (knifeType, variant) = _getKnifeTypeAndVariant(cleanPath);

    // Remove the old knife if it exists
    if (isInitialized) {
      knife.removeFromParent();
    }

    // Create knife with the selected type and variant
    knife = _createKnife(knifeType, variant, imagePath: cleanPath);

    // Add the new knife to the world or bloc provider
    if (isInitialized) {
      _blocProvider.add(knife);
    }
  }
}
