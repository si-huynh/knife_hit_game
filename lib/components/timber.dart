import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:knife_hit_game/blocs/game_stats_bloc/game_stats_bloc.dart';
import 'package:knife_hit_game/components/knife.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/knife_hit_game.dart';

class Timber extends PositionComponent
    with
        HasGameRef<KnifeHitGame>,
        CollisionCallbacks,
        FlameBlocReader<GameStatsBloc, GameStatsState> {
  Timber(double x, double y, {double angle = pi / 2})
    : super(
        position: Vector2(x, y),
        anchor: Anchor.center,
        angle: angle,
        size: Vector2.all(radius * 2),
      );
  static const double baseSpeed = 1.2;
  static const double radius = 117;

  late final SpriteComponent timberSprite;

  // Rotation properties
  double rotationSpeed = baseSpeed;
  int rotationDirection = 1; // 1 for clockwise, -1 for counter-clockwise
  double timeSinceLastChange = 0;
  double changeDirectionChance = 0.005; // Base chance to change direction
  double changeSpeedChance = 0.01; // Base chance to change speed

  // Performance optimization: Cache values that don't change frequently
  int _lastLevel = 1;
  double _levelFactor = 0.1; // Initial value for level 1
  double _directionChangeThreshold = 0.0005;
  double _speedChangeThreshold = 0.001;

  // Random generator - reuse the same instance
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    // Add hitbox
    add(
      CircleHitbox(
        radius: radius,
        anchor: Anchor(anchor.x - 0.5, anchor.y - 0.5),
      )..collisionType = CollisionType.passive,
    );

    // Create and add knives container (lower priority, rendered first)
    final knivesContainer = Component()..priority = 0;
    add(knivesContainer);

    // Create and add timber sprite (higher priority, rendered on top)
    timberSprite = SpriteComponent(
      sprite: Sprite(Flame.images.fromCache(GameConstants.timber)),
      size: Vector2.all(radius * 2),
      priority: 1,
    );
    add(timberSprite);

    super.onLoad();
  }

  @override
  void update(double dt) {
    // Get current level for difficulty scaling
    final currentLevel = bloc.state.level;

    // Only recalculate level factor when level changes
    if (currentLevel != _lastLevel) {
      _lastLevel = currentLevel;
      _levelFactor = min(currentLevel / 10, 3); // Cap at 3x for level 30
      _directionChangeThreshold = changeDirectionChance * _levelFactor;
      _speedChangeThreshold = changeSpeedChance * _levelFactor;
    }

    // Update timers
    timeSinceLastChange += dt;

    // Random direction change (more frequent at higher levels)
    if (_random.nextDouble() < _directionChangeThreshold * dt * 60) {
      rotationDirection *= -1;
    }

    // Random speed change (more frequent at higher levels)
    if (_random.nextDouble() < _speedChangeThreshold * dt * 60) {
      // Random speed between 0.8x and 1.5x base speed, scaled by level
      final speedMultiplier = 0.8 + _random.nextDouble() * 0.7 * _levelFactor;
      rotationSpeed = baseSpeed * speedMultiplier;
    }

    // Apply rotation
    angle += rotationSpeed * rotationDirection * dt;

    // Occasional sudden acceleration (higher levels only)
    if (currentLevel > 5 &&
        _random.nextDouble() < 0.001 * _levelFactor * dt * 60) {
      // Brief acceleration
      angle += rotationSpeed * rotationDirection * dt * 5;
    }

    super.update(dt);
  }

  void takeHit() {
    gameRef.playHitTimber();

    // Calculate the position in local coordinates
    final localX = radius + radius * cos(pi / 2 - angle);
    final localY = radius + radius * sin(pi / 2 - angle);

    // Create the knife with the same image as the one that hit the timber
    final knife =
        Knife(
            localX,
            localY,
            -1 * angle,
            state: KnifeState.hit,
            type: gameRef.knife.type,
            variant: gameRef.knife.variant,
            imagePath: gameRef.knife.imagePath,
          )
          ..collisionType = CollisionType.passive
          ..canUpdate = false
          ..priority = 0;

    // Add the knife to the knives container (first child)
    final knivesContainer = children.firstWhere(
      (child) => child.priority == 0,
      orElse: Component.new,
    );
    knivesContainer.add(knife);

    // Reset the player's knife
    gameRef.knife.reset();

    // Check if this was the last knife (level completed)
    if (bloc.state.numOfKnives <= 0) {
      // Make sure the knife is properly added before the level completion logic runs
      Future.delayed(const Duration(milliseconds: 10), () {
        gameRef.playHitTimber(); // Call again to trigger level completion
      });
    }
  }

  // Disable collisions for all components to prevent accidental game over during animation
  void disableCollisions() {
    // Disable collisions for the timber
    children.whereType<CircleHitbox>().forEach((hitbox) {
      hitbox.collisionType = CollisionType.inactive;
    });

    // Disable collisions for all knives
    final knivesContainer = children.firstWhere(
      (child) => child.priority == 0,
      orElse: Component.new,
    );

    knivesContainer.children.whereType<Knife>().forEach((knife) {
      knife.collisionType = CollisionType.inactive;
      knife.children.whereType<RectangleHitbox>().forEach((hitbox) {
        hitbox.collisionType = CollisionType.inactive;
      });
    });

    // Also disable collision for the last thrown knife if it's in hit state
    if (gameRef.knife.state == KnifeState.hit) {
      gameRef.knife.collisionType = CollisionType.inactive;
      gameRef.knife.children.whereType<RectangleHitbox>().forEach((hitbox) {
        hitbox.collisionType = CollisionType.inactive;
      });
    }
  }

  // Collect all knives that need to be animated, including the last thrown knife
  List<Knife> collectAllKnives() {
    // Remove any TimberKnifeTracker components first
    gameRef.children.whereType<TimberKnifeTracker>().forEach((tracker) {
      tracker.removeFromParent();
    });

    children.whereType<TimberKnifeTracker>().forEach((tracker) {
      tracker.removeFromParent();
    });

    // Get the knives container
    final knivesContainer = children.firstWhere(
      (child) => child.priority == 0,
      orElse: Component.new,
    );

    // Get all knives in the container
    final stuckKnives = knivesContainer.children.whereType<Knife>().toList();

    // Check if the last thrown knife should be included
    if (gameRef.knife.state == KnifeState.hit) {
      // Force detach the knife from any parent
      gameRef.knife.parent?.remove(gameRef.knife);

      // Make sure it's not already in the list
      if (!stuckKnives.contains(gameRef.knife)) {
        stuckKnives.add(gameRef.knife);
      }
    }

    return stuckKnives;
  }

  // Animate all knives with a realistic falling effect
  void animateKnives(List<Knife> knives) {
    if (knives.isEmpty) {
      return;
    }

    // For each knife, add flying animation
    for (final knife in knives) {
      // Make sure the knife is detached from any parent components
      knife.parent?.remove(knife);

      // Add the knife directly to the game for independent animation
      gameRef.add(knife);

      // Disable collisions to prevent accidental game over
      knife.collisionType = CollisionType.inactive;

      // Simple downward movement
      knife.add(
        MoveEffect.to(
          Vector2(knife.position.x, gameRef.windowHeight + 100),
          EffectController(duration: 0.8),
          onComplete: () {
            if (knife.isMounted) {
              knife.removeFromParent();
            }
          },
        ),
      );

      // Simple rotation
      knife.add(
        RotateEffect.by(
          _random.nextDouble() * 2 - 1,
          EffectController(duration: 0.8),
        ),
      );

      // Fade out
      knife.add(OpacityEffect.fadeOut(EffectController(duration: 0.8)));
    }
  }

  // Ensure all knives are properly removed from the game
  void cleanupAllKnives() {
    // Remove any knives directly in the game
    gameRef.children.whereType<Knife>().forEach((knife) {
      if (knife != gameRef.knife || knife.state == KnifeState.hit) {
        knife.removeFromParent();
      }
    });

    // Remove any knives in the timber
    final knivesContainer = children.firstWhere(
      (child) => child.priority == 0,
      orElse: Component.new,
    );

    knivesContainer.children.whereType<Knife>().forEach((knife) {
      knife.removeFromParent();
    });
  }
}

// A component that keeps the knife positioned relative to the timber
class TimberKnifeTracker extends Component with HasGameRef<KnifeHitGame> {
  TimberKnifeTracker(this.timber, this.knife);

  final Timber timber;
  final Knife knife;
  final Vector2 initialRelativePos = Vector2.zero();
  final Vector2 _rotatedPos =
      Vector2.zero(); // Reusable vector to avoid allocations

  @override
  void onMount() {
    super.onMount();
    // Store the initial relative position
    initialRelativePos.setFrom(knife.position - timber.position);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update knife position and rotation to match timber
    // Use the reusable vector to avoid allocations
    _rotatedPos.setFrom(initialRelativePos);
    _rotatedPos.rotate(timber.angle - pi / 2);
    knife.position.setFrom(timber.position + _rotatedPos);
    knife.angle = timber.angle - pi / 2;
  }
}
