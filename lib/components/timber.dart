import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
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

  // Random generator
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

    // Scale difficulty based on level
    final levelFactor = min(currentLevel / 10, 3); // Cap at 3x for level 30

    // Update timers
    timeSinceLastChange += dt;

    // Increase chances based on level
    final directionChangeThreshold = changeDirectionChance * levelFactor;
    final speedChangeThreshold = changeSpeedChance * levelFactor;

    // Random direction change (more frequent at higher levels)
    if (_random.nextDouble() < directionChangeThreshold * dt * 60) {
      rotationDirection *= -1;
    }

    // Random speed change (more frequent at higher levels)
    if (_random.nextDouble() < speedChangeThreshold * dt * 60) {
      // Random speed between 0.8x and 1.5x base speed, scaled by level
      final speedMultiplier = 0.8 + _random.nextDouble() * 0.7 * levelFactor;
      rotationSpeed = baseSpeed * speedMultiplier;
    }

    // Apply rotation
    angle += rotationSpeed * rotationDirection * dt;

    // Occasional sudden acceleration (higher levels only)
    if (currentLevel > 5 &&
        _random.nextDouble() < 0.001 * levelFactor * dt * 60) {
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
    children.first.add(knife);

    // Reset the player's knife
    gameRef.knife.reset();
  }
}

// A component that keeps the knife positioned relative to the timber
class TimberKnifeTracker extends Component with HasGameRef<KnifeHitGame> {
  TimberKnifeTracker(this.timber, this.knife);

  final Timber timber;
  final Knife knife;
  final Vector2 initialRelativePos = Vector2.zero();

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
    final rotatedPos =
        initialRelativePos.clone()..rotate(timber.angle - pi / 2);
    knife.position.setFrom(timber.position + rotatedPos);
    knife.angle = timber.angle - pi / 2;
  }
}
