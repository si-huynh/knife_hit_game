import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/foundation.dart';
import 'package:knife_hit_game/components/timber.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/knife_hit_game.dart';

enum KnifeType {
  basic, // 1 knife
  elite, // 4 knives
  premium, // 4 knives
  luxury, // 4 knives
  ultimate, // 4 knives
}

enum KnifeState { idle, flying, hit }

class Knife extends SpriteComponent
    with HasGameRef<KnifeHitGame>, CollisionCallbacks {
  Knife(
    double x,
    double y,
    double angle, {
    this.type = KnifeType.basic,
    this.variant = 0,
    this.state = KnifeState.idle,
    this.imagePath,
  }) : super(
         size: Vector2(21, 100),
         position: Vector2(x, y),
         angle: angle,
         anchor: Anchor.center,
       ) {
    hitbox = RectangleHitbox(size: size)..collisionType = collisionType;
    add(hitbox);
  }

  final KnifeType type;
  final int variant;
  final String? imagePath; // Path to the knife image

  KnifeState state;

  CollisionType collisionType = CollisionType.active;
  bool canUpdate = false;

  late RectangleHitbox hitbox;

  @override
  Future<void> onLoad() async {
    try {
      if (imagePath != null && imagePath!.isNotEmpty) {
        // Load the specific knife image if provided
        if (kDebugMode) {
          print('Loading knife from path: $imagePath');
        }
        sprite = await Sprite.load(imagePath!);
      } else {
        // Fallback to default knife if no path provided
        if (kDebugMode) {
          print('Loading default knife for type: $type, variant: $variant');
        }
        sprite = await Sprite.load('knives/basic.png');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading knife image: $e');
        print('Falling back to basic knife');
      }
      // Fallback to basic knife if there's an error
      sprite = await Sprite.load('knives/basic.png');
    }

    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!canUpdate) {
      return;
    }

    y += GameConstants.knifeSpeed * dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Timber && state == KnifeState.idle) {
      other.takeHit();
      gameRef.resetKnife();
    }
    if (state != KnifeState.hit && other is Knife) {
      if (other.state == KnifeState.hit) {
        gameRef.playHitKnife();
        bounceAnimation();

        // Call gameOver when knife hits another knife
        gameRef.gameOver();
        return;
      }
    }
  }

  void bounceAnimation() {
    canUpdate = false;
    state = KnifeState.flying;
    collisionType = CollisionType.inactive;
    add(
      MoveToEffect(
        Vector2(gameRef.windowWidth, gameRef.windowHeight),
        EffectController(duration: 1),
        onComplete: removeFromParent,
      ),
    );
    add(
      RotateEffect.by(pi * 2, EffectController(duration: 0.6, repeatCount: 10)),
    );
  }

  void dropAnimation() {
    final x =
        -1 * gameRef.windowWidth / 2 +
        Random().nextDouble() * gameRef.windowWidth / 2;
    add(
      MoveByEffect(
        Vector2(x, gameRef.windowHeight),
        EffectController(duration: 1),
        onComplete: removeFromParent,
      ),
    );
  }

  void reset() {
    gameRef.isThrowing = false;
    position.y = GameConstants.cameraHeight - 150;
    canUpdate = false;
  }
}
