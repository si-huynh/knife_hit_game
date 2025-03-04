part of 'game_settings_bloc.dart';

@freezed
class GameSettingsEvent with _$GameSettingsEvent {
  const factory GameSettingsEvent.updateBestScore(int score) = _UpdateBestScore;
  const factory GameSettingsEvent.toggleMusic() = _ToggleMusic;
  const factory GameSettingsEvent.toggleSound() = _ToggleSound;
  const factory GameSettingsEvent.updateHighestLevel(int level) =
      _UpdateHighestLevel;
}
