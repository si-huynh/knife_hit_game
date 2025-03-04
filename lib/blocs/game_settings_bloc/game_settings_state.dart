part of 'game_settings_bloc.dart';

@freezed
abstract class GameSettingsState with _$GameSettingsState {
  const factory GameSettingsState({
    required int bestScore,
    required bool isMusicOn,
    required bool isSoundOn,
    required int highestLevel,
  }) = _GameSettingsState;

  factory GameSettingsState.initial() => const GameSettingsState(
    bestScore: 0,
    isMusicOn: true,
    isSoundOn: true,
    highestLevel: 1,
  );

  factory GameSettingsState.fromJson(Map<String, dynamic> json) =>
      _$GameSettingsStateFromJson(json);
}
