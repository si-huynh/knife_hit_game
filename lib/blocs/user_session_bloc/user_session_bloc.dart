import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'user_session_bloc.freezed.dart';
part 'user_session_bloc.g.dart';
part 'user_session_event.dart';
part 'user_session_state.dart';

class UserSessionBloc extends HydratedBloc<UserSessionEvent, UserSessionState> {
  UserSessionBloc() : super(UserSessionState.initial()) {
    on<UserSessionEvent>((event, emit) async {
      // Handle events manually until freezed code is generated
      if (event.toString().contains('login')) {
        // Extract userId from the event
        final userId = event.toString().split('(')[1].split(')')[0];
        _handleLogin(userId, emit);
      } else if (event.toString().contains('logout')) {
        _handleLogout(emit);
      }
    });
  }

  void _handleLogin(String userId, Emitter<UserSessionState> emit) {
    // Update state
    emit(UserSessionState(userId: userId, isLoggedIn: true));
  }

  void _handleLogout(Emitter<UserSessionState> emit) {
    // Update state
    emit(UserSessionState.initial());
  }

  @override
  UserSessionState? fromJson(Map<String, dynamic> json) {
    try {
      return UserSessionState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(UserSessionState state) {
    return state.toJson();
  }
}
