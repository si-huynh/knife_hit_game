import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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

class Knife extends SpriteAnimationComponent
    with HasGameRef<KnifeHitGame>, CollisionCallbacks {
  Knife(
    double x,
    double y,
    double angle, {
    this.type = KnifeType.basic,
    this.variant = 0,
    this.state = KnifeState.idle,
  }) : super(
         size: Vector2(21, 100),
         position: Vector2(x, y),
         angle: angle,
         anchor: Anchor.center,
       ) {
    hitbox = RectangleHitbox(size: size)..collisionType = collisionType;
    add(hitbox);
  }
  static const double knifeWidth = 55;
  static const double knifeHeight = 255;

  final KnifeType type;
  final int variant;

  KnifeState state;

  CollisionType collisionType = CollisionType.active;
  bool canUpdate = false;

  late RectangleHitbox hitbox;

  @override
  Future<void> onLoad() async {
    // Calculate x position based on knife type and variant
    double x = 0;
    switch (type) {
      case KnifeType.basic:
        x = 0;
        break;
      case KnifeType.elite:
        x = knifeWidth + (variant % 4) * knifeWidth;
        break;
      case KnifeType.premium:
        x = knifeWidth * 5 + (variant % 4) * knifeWidth;
        break;
      case KnifeType.luxury:
        x = knifeWidth * 9 + (variant % 4) * knifeWidth;
        break;
      case KnifeType.ultimate:
        x = knifeWidth * 13 + (variant % 4) * knifeWidth;
        break;
    }

    animation = await gameRef.loadSpriteAnimation(
      GameConstants.knives,
      SpriteAnimationData.sequenced(
        stepTime: 1,
        amount: 1,
        loop: false,
        textureSize: Vector2(50, 255),
        texturePosition: Vector2(x, 0),
      ),
    );
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
        onComplete: () {
          removeOnFinish = true;
        },
      ),
    );
    add(
      RotateEffect.by(pi * 2, EffectController(duration: 0.6, repeatCount: 10)),
    );

    //if (!gameRef.isMute) FlameAudio.play('bounce.mp3');
  }

  void dropAnimation() {
    final x =
        -1 * gameRef.windowWidth / 2 +
        Random().nextDouble() * gameRef.windowWidth / 2;
    add(
      MoveByEffect(
        Vector2(x, gameRef.windowHeight),
        EffectController(duration: 1),
        onComplete: () {
          removeOnFinish = true;
        },
      ),
    );
  }

  void reset() {
    gameRef.isThrowing = false;
    position.y = GameConstants.cameraHeight - 150;
    canUpdate = false;
  }
}
