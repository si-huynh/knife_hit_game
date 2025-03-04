import 'package:flutter/material.dart';
import 'package:knife_hit_game/knife_hit_game.dart';

class GameOver extends StatelessWidget {
  const GameOver({super.key, required this.game});
  static const String overlayName = 'GameOver';

  // Reference to parent game.
  final KnifeHitGame game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 250,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.15),
            border: Border.all(color: Colors.white, width: 4),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Score: ${game.manager.points} pts',
                style: const TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    game.overlays.remove(overlayName);
                    game.reset();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(width: 3, color: Colors.white),
                  ),
                  child: const Text(
                    'Play again',
                    style: TextStyle(fontSize: 16, fontFamily: 'PressStart2P'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
