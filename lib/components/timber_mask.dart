import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/knife_hit_game.dart';

double generateRandom(double start, double end) {
  return math.Random().nextDouble() * (end - start) + start;
}

class TimberMaskSprite extends SpriteComponent with HasGameRef<KnifeHitGame> {
  TimberMaskSprite(this.r, this.startAngle, this.endAngle)
    : super(position: Vector2(0, 0), anchor: Anchor.center, priority: 999);
  double r;
  double startAngle;
  double endAngle;

  @override
  Future<void> onLoad() async {
    sprite = Sprite(Flame.images.fromCache(GameConstants.timber));
    size = Vector2(256, 256);
  }

  @override
  void render(Canvas canvas) {
    final point1 = Offset(
      r + r * math.cos(startAngle),
      r + r * math.sin(startAngle),
    );
    final point2 = Offset(
      r + r * math.cos(endAngle),
      r + r * math.sin(endAngle),
    );
    final path = Path();
    path.moveTo(r, r);
    path.lineTo(point1.dx, point1.dy);
    path.arcToPoint(point2, radius: Radius.circular(r), largeArc: true);
    path.close();
    canvas.clipPath(path);
    super.render(canvas);
  }
}

class TimberMask extends PositionComponent with HasGameRef<KnifeHitGame> {
  TimberMask() {
    final randomAry = <double>[0 * math.pi, 2 * math.pi];
    randomAry.add(generateRandom(math.pi / 3, math.pi * 35 / 18));
    randomAry.add(generateRandom(math.pi / 3, math.pi * 35 / 18));
    randomAry.add(generateRandom(math.pi / 3, math.pi * 35 / 18));
    randomAry.sort((a, b) => a.compareTo(b));
    for (var i = 0; i < randomAry.length - 1; i++) {
      const double r = 100;
      final next = i + 1;
      final startAngle = randomAry[i];
      final endAngle = next > randomAry.length ? 360.0 : randomAry[next];
      final m = TimberMaskSprite(r, startAngle, endAngle);
      // m.x += generateRandom(30, 90);
      // m.y += generateRandom(30, 90);
      // m.angle += generateRandom(30, 90);
      ary.add(m);
    }
    addAll(ary);
  }
  List<TimberMaskSprite> ary = [];

  void startAnimation() {
    for (final item in ary) {
      // item.add()
      final x = generateRandom(
        -1 * gameRef.windowWidth / 2,
        gameRef.windowWidth / 2,
      );
      final y = gameRef.windowHeight;
      item.add(
        MoveEffect.to(
          Vector2(x, y),
          EffectController(duration: 1),
          onComplete: () {
            remove(item);
          },
        ),
      );
      item.x += generateRandom(30, 90);
      item.y += generateRandom(30, 90);
      item.angle += generateRandom(30, 90);
    }
  }
}
