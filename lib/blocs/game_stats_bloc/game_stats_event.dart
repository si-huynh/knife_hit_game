part of 'game_stats_bloc.dart';

@freezed
abstract class GameStatsEvent with _$GameStatsEvent {
  const factory GameStatsEvent.scoreEventAdded(int score) = ScoreEventAdded;
  const factory GameStatsEvent.knifeNumEvent(int numOfKnives) = KnifeNumEvent;
  const factory GameStatsEvent.levelEventAdded(int level) = LevelEventAdded;
  const factory GameStatsEvent.scoreEventCleared() = ScoreEventCleared;
  const factory GameStatsEvent.playerDied() = PlayerDied;
  const factory GameStatsEvent.playerRespawned() = PlayerRespawned;
  const factory GameStatsEvent.gameReset() = GameReset;
  const factory GameStatsEvent.statusChanged(GameStatus status) = StatusChanged;
}
