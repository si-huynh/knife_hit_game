import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:knife_hit_game/blocs/game_settings_bloc/game_settings_bloc.dart';
import 'package:knife_hit_game/design/neon_text.dart';
import 'package:knife_hit_game/game_constants.dart';

@RoutePage()
class SettingsMenuPage extends StatelessWidget {
  const SettingsMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameSettingsBloc, GameSettingsState>(
      builder: (context, state) {
        return Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(180),
              border: Border.all(color: Colors.orange, width: 4),
              borderRadius: const BorderRadius.all(Radius.circular(64)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.router.pop(),
                      icon: Image.asset(
                        'assets/images/layers/back_button.png',
                        width: 48,
                        height: 48,
                      ),
                    ),
                    const NeonText(
                      text: 'Settings',
                      color: Colors.amberAccent,
                      style: TextStyle(
                        fontSize: 48,
                        fontFamily: GameConstants.primaryFontFamily,
                      ),
                    ),
                    const Gap(48),
                  ],
                ),
                const Gap(48),
                _buildSettingItem(
                  context,
                  'Music',
                  state.isMusicOn,
                  const GameSettingsEvent.toggleMusic(),
                ),
                const Gap(32),
                _buildSettingItem(
                  context,
                  'SFX',
                  state.isSoundOn,
                  const GameSettingsEvent.toggleSound(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String text,
    bool value,
    GameSettingsEvent event,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          NeonText(
            text: text,
            color: Colors.amberAccent,
            style: const TextStyle(fontSize: 32),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: (value) => context.read<GameSettingsBloc>().add(event),
          ),
        ],
      ),
    );
  }
}
