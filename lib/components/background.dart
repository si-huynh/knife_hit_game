import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:knife_hit_game/game_constants.dart';

class Background extends SpriteComponent {
  Background()
    : super(
        sprite: Sprite(Flame.images.fromCache(GameConstants.background)),
        size: Vector2(GameConstants.cameraWidth, GameConstants.cameraHeight),
      );
}
