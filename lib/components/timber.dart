import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:knife_hit_game/components/knife.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/knife_hit_game.dart';

class Timber extends PositionComponent
    with HasGameRef<KnifeHitGame>, CollisionCallbacks {
  Timber(double x, double y, {double angle = pi / 2})
    : super(
        position: Vector2(x, y),
        anchor: Anchor.center,
        angle: angle,
        size: Vector2.all(radius * 2),
      );
  static const double speed = 1.2;
  static const double radius = 117;

  late final SpriteComponent timberSprite;

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
    angle += speed * dt;
    super.update(dt);
  }

  void takeHit() {
    gameRef.playHitTimber();

    // Calculate the position in local coordinates
    final localX = radius + radius * cos(pi / 2 - angle);
    final localY = radius + radius * sin(pi / 2 - angle);

    // Create the knife
    final knife =
        Knife(localX, localY, -1 * angle, state: KnifeState.hit)
          ..collisionType = CollisionType.passive
          ..canUpdate = false
          ..priority =
              0; // Priority doesn't matter as it's added to the knives container

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
