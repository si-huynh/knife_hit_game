import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:knife_hit_game/design/neon_text.dart';
import 'package:knife_hit_game/design/responsive_screen.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/router/game_router.dart';

@RoutePage()
class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  static const mainMenuTextStyle = TextStyle(
    fontSize: 55,
    height: 1,
    color: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ResponsiveScreen(
        squarishMainArea: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/layers/timber.png',
                width: 320,
                height: 320,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: SizedBox(
                width: 320,
                height: 320,
                child: Column(
                  children: [
                    const Gap(25),
                    Transform.rotate(
                      angle: -0.1,
                      child: const NeonText(
                        text: 'Knife Hit',
                        color: Colors.yellow,
                        style: TextStyle(
                          fontFamily: GameConstants.primaryFontFamily,
                          fontSize: 60,
                        ),
                      ),
                    ),
                    const Gap(100),
                    const NeonText(
                      text: 'Moneta Studio © 2025',
                      color: Colors.yellow,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: GameConstants.primaryFontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed:
                  () => context.router.navigate(const GamePlayingRoute()),
              child: const NeonText(
                text: 'Play',
                color: Colors.white,
                style: mainMenuTextStyle,
              ),
            ),

            TextButton(
              onPressed: () => context.router.push(const SettingsMenuRoute()),
              child: const NeonText(
                text: 'Settings',
                color: Colors.white,
                style: mainMenuTextStyle,
              ),
            ),
            TextButton(
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Knife Hit',
                  applicationVersion: '1.0.0',
                  applicationIcon: Image.asset(
                    'assets/images/layers/timber.png',
                    width: 64,
                    height: 64,
                  ),
                );
              },
              child: const NeonText(
                text: 'About',
                color: Colors.white,
                style: mainMenuTextStyle,
              ),
            ),

            const Gap(32),
          ],
        ),
      ),
    );
  }
}
