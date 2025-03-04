import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_stats_event.dart';
part 'game_stats_state.dart';

part 'game_stats_bloc.freezed.dart';

class GameStatsBloc extends Bloc<GameStatsEvent, GameStatsState> {
  GameStatsBloc() : super(GameStatsState.empty()) {
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
      emit(state.copyWith(status: GameStatus.gameOver, level: 1));
    });

    on<GameReset>((event, emit) => emit(GameStatsState.empty()));
  }
}
