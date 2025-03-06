import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knife_hit_game/game_constants.dart';

part 'game_stats_event.dart';
part 'game_stats_state.dart';

part 'game_stats_bloc.freezed.dart';

class GameStatsBloc extends Bloc<GameStatsEvent, GameStatsState> {
  GameStatsBloc()
    : super(
        GameStatsState.empty().copyWith(
          numOfKnives: GameConstants.baseKnivesCount,
        ),
      ) {
    on<ScoreEventAdded>(
      (event, emit) => emit(state.copyWith(score: state.score + event.score)),
    );

    on<ScoreEventCleared>((event, emit) => emit(state.copyWith(score: 0)));

    on<KnifeNumEvent>(
      (event, emit) => emit(state.copyWith(numOfKnives: event.numOfKnives)),
    );

    on<LevelEventAdded>(
      (event, emit) => emit(state.copyWith(level: event.level)),
    );

    on<PlayerRespawned>(
      (event, emit) => emit(state.copyWith(status: GameStatus.respawned)),
    );

    on<PlayerDied>((event, emit) {
      emit(state.copyWith(status: GameStatus.gameOver));
    });

    on<StatusChanged>((event, emit) {
      emit(state.copyWith(status: event.status));
    });

    on<GameReset>(
      (event, emit) => emit(
        GameStatsState.empty().copyWith(
          numOfKnives: GameConstants.baseKnivesCount,
        ),
      ),
    );
  }
}
