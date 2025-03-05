import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'game_settings_bloc.freezed.dart';
part 'game_settings_bloc.g.dart';
part 'game_settings_event.dart';
part 'game_settings_state.dart';

class GameSettingsBloc
    extends HydratedBloc<GameSettingsEvent, GameSettingsState> {
  GameSettingsBloc() : super(GameSettingsState.initial()) {
    on<_UpdateBestScore>((event, emit) {
      if (event.score > state.bestScore) {
        emit(state.copyWith(bestScore: event.score));
      }
    });

    on<_ToggleMusic>((event, emit) {
      emit(state.copyWith(isMusicOn: !state.isMusicOn));
    });

    on<_ToggleSound>((event, emit) {
      emit(state.copyWith(isSoundOn: !state.isSoundOn));
    });

    on<_UpdateHighestLevel>((event, emit) {
      if (event.level > state.highestLevel) {
        emit(state.copyWith(highestLevel: event.level));
      }
    });
  }

  @override
  GameSettingsState? fromJson(Map<String, dynamic> json) {
    return GameSettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(GameSettingsState state) {
    return state.toJson();
  }
}
