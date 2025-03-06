import 'package:flutter/foundation.dart';
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
      } else if (event.toString().contains('updateSelectedKnife')) {
        // Extract knife path from the event
        final knifePath = event.toString().split('(')[1].split(')')[0];
        _handleUpdateSelectedKnife(knifePath, emit);
      }
    });
  }

  void _handleLogin(String userId, Emitter<UserSessionState> emit) {
    // Update state while preserving the selected knife path
    emit(state.copyWith(userId: userId, isLoggedIn: true));
  }

  void _handleLogout(Emitter<UserSessionState> emit) {
    // Update state
    emit(UserSessionState.initial());
  }

  void _handleUpdateSelectedKnife(
    String knifePath,
    Emitter<UserSessionState> emit,
  ) {
    // Clean up the path if needed
    var cleanPath = knifePath;

    if (cleanPath.contains('knifePath:')) {
      cleanPath = cleanPath.split('knifePath:').last.trim();
    }

    // Debug the path
    if (kDebugMode) {
      print('Storing knife path: $cleanPath');
    }

    // Update state with the new selected knife path
    emit(state.copyWith(selectedKnifePath: cleanPath));
  }

  // Helper method to get the selected knife path
  String getSelectedKnifePath() {
    final path = state.selectedKnifePath;
    // Debug the path
    if (kDebugMode) {
      print('Original knife path from state: $path');
    }

    // Clean up the path if needed
    if (path.contains('knifePath:')) {
      // Handle malformed path
      final cleanPath = path.split('knifePath:').last.trim();
      if (kDebugMode) {
        print('Cleaned knife path: $cleanPath');
      }
      return cleanPath;
    }

    return path;
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
