import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:knife_hit_game/blocs/game_stats_bloc/game_stats_bloc.dart';
import 'package:knife_hit_game/blocs/user_session_bloc/user_session_bloc.dart';
import 'package:knife_hit_game/design/neon_text.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/knife_hit_game.dart';
import 'package:knife_hit_game/router/game_router.dart';
import 'package:url_launcher/url_launcher.dart';

class GameControls extends StatelessWidget {
  const GameControls({super.key, required this.game});
  static const String overlayName = 'GameControls';

  final KnifeHitGame game;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildTopBar(context),
          const Spacer(),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        const Gap(16),
        IconButton(
          onPressed: () {
            game.dispose();
            context.router.navigate(const MainMenuRoute());
          },
          icon: Image.asset(
            'assets/images/layers/back_button.png',
            width: 48,
            height: 48,
          ),
        ),
        const Spacer(),
        // Game stats display
        BlocBuilder<GameStatsBloc, GameStatsState>(
          builder: (context, state) {
            return Row(
              children: [
                // Level indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.yellow),
                  ),
                  child: NeonText(
                    text: 'LEVEL ${state.level}',
                    color: Colors.yellow,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: GameConstants.primaryFontFamily,
                    ),
                  ),
                ),
                const Gap(10),
                // Score indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white),
                  ),
                  child: NeonText(
                    text: 'SCORE: ${state.score}',
                    color: Colors.white,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: GameConstants.primaryFontFamily,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const Gap(16),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Transform.flip(
            flipY: true,
            child: Image.asset(
              'assets/images/layers/panel.jpg',
              width: MediaQuery.of(context).size.width,
              height: 125,
              fit: BoxFit.fill,
              // height: context.size!.height,
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Row(
              children: [
                // Equipment button
                _buildEquipmentButton(context),
                // Knives remaining indicator
                Expanded(child: _buildKnivesIndicator(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKnivesIndicator(BuildContext context) {
    return BlocBuilder<GameStatsBloc, GameStatsState>(
      builder: (context, state) {
        // Calculate used knives based on level and current knives
        // In GameStatsState, numOfKnives represents remaining knives
        final totalKnivesPerLevel =
            GameConstants.baseKnivesCount +
            (state.level == 1
                ? 0
                : state.level); // Use the constant from GameConstants
        final usedKnives =
            totalKnivesPerLevel -
            state.numOfKnives; // Total knives is always the same per level

        return BlocBuilder<UserSessionBloc, UserSessionState>(
          builder: (context, userState) {
            // Get the user's selected knife path
            final knifePath = userState.selectedKnifePath;

            // Calculate knife size based on total knives
            // The more knives, the smaller they should be
            final knifeWidth = totalKnivesPerLevel <= 6 ? 10.0 : 8.0;
            final knifeHeight = totalKnivesPerLevel <= 6 ? 40.0 : 32.0;

            return Container(
              // height: 82,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orangeAccent, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.7),
                    blurRadius: 14,
                  ),
                  BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.3),
                    blurRadius: 21,
                  ),
                ],
              ),
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                spacing: 2,
                children: [
                  // Used knives (dimmed) - Show these first (on the left)
                  for (int i = 0; i < usedKnives; i++)
                    Transform.rotate(
                      angle: 0.3, // Tilt to the right (in radians)
                      child: Image.asset(
                        knifePath,
                        width: knifeWidth,
                        height: knifeHeight,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  // Active knives (remaining) - Show these after used knives (on the right)
                  for (int i = 0; i < state.numOfKnives; i++)
                    Transform.rotate(
                      angle: 0.3, // Tilt to the right (in radians)
                      child: Image.asset(
                        knifePath,
                        width: knifeWidth,
                        height: knifeHeight,
                        color: Colors.amber,
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEquipmentButton(BuildContext context) {
    return BlocBuilder<UserSessionBloc, UserSessionState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (state.isLoggedIn) {
              context.router.navigate(const EquipmentsRoute());
            } else {
              showAdaptiveDialog(
                context: context,
                barrierDismissible: true,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Login required'),
                      content: const Text(
                        'Please login to access your equipment.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await context.router.maybePop();
                            await launchUrl(
                              Uri.parse(AuthConstants.AUTH_URL),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: const Text('Continue with Moneta'),
                        ),
                      ],
                    ),
              );
            }
          },
          child: Image.asset(
            'assets/images/layers/equipments_button.png',
            width: 84,
            height: 84,
          ),
        );
      },
    );
  }
}
