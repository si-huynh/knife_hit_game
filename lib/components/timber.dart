import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:knife_hit_game/components/knife.dart';
import 'package:knife_hit_game/components/timber_mask.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/knife_hit_game.dart';

class Timber extends SpriteComponent
    with HasGameRef<KnifeHitGame>, CollisionCallbacks {
  Timber(double x, double y, {double angle = pi / 2})
    : super(
        position: Vector2(x, y),
        anchor: Anchor.center,
        angle: angle,
        priority: 1,
        size: Vector2(radius, radius),
      );
  static const double speed = 1.2;
  static const double radius = 256;

  late TimberMask _timberMask;

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: radius)..collisionType = CollisionType.passive);

    sprite = Sprite(Flame.images.fromCache(GameConstants.timber));
    _timberMask =
        TimberMask()
          ..anchor = Anchor.center
          ..position = Vector2(128, 128)
          ..priority = 3;
    add(_timberMask);
    super.onLoad();
  }

  @override
  void update(double dt) {
    angle = (angle + speed * dt) % 360;
    super.update(dt);
  }

  void takeHit() {
    final x = radius / 2 + radius / 2 * cos(pi / 2 - angle);
    final y = radius / 2 + radius / 2 * sin(pi / 2 - angle);

    final knife =
        Knife(x, y, -1 * angle, state: KnifeState.hit)
          ..collisionType = CollisionType.passive
          ..canUpdate = false
          ..priority = 1;

    gameRef.knife.reset();
    add(knife);
  }
}
