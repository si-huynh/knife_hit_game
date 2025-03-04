part of 'game_stats_bloc.dart';

enum GameStatus { initial, respawn, respawned, gameOver }

@freezed
abstract class GameStatsState with _$GameStatsState {
  const factory GameStatsState({
    required int score,
    required int numOfKnives,
    required bool isMute,
    required GameStatus status,
    required int level,
  }) = _GameStatsState;

  factory GameStatsState.empty() => const GameStatsState(
    score: 0,
    numOfKnives: 9,
    isMute: false,
    status: GameStatus.initial,
    level: 1,
  );
}
