import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:knife_hit_game/design/neon_text.dart';
import 'package:knife_hit_game/design/responsive_screen.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/knife_hit_game.dart';
import 'package:knife_hit_game/router/game_router.dart';
import 'package:url_launcher/url_launcher.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key, required this.game});
  static const String overlayName = 'MainMenu';

  // Reference to parent game.
  final KnifeHitGame game;

  final bool isLoggedIn = true;

  static const mainMenuTextStyle = TextStyle(
    fontSize: 55,
    height: 1,
    fontFamily: GameConstants.primaryFontFamily,
    color: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(75),
      child: ResponsiveScreen(
        squarishMainArea: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/layers/timber.png',
                width: 320,
                height: 320,
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
              onPressed: () {
                if (isLoggedIn) {
                  game.overlays.remove(overlayName);
                  game.initialize();
                } else {
                  launchUrl(
                    Uri.parse(AuthConstants.AUTH_URL),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              child: NeonText(
                text: isLoggedIn ? 'Play' : 'Login',
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
                launchUrl(
                  Uri.parse('https://game-portal.stg.pressingly.net'),
                  mode: LaunchMode.externalApplication,
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
