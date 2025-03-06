part of 'user_session_bloc.dart';

@freezed
abstract class UserSessionState with _$UserSessionState {
  const factory UserSessionState({
    String? userId,
    @Default(false) bool isLoggedIn,
    @Default('assets/images/knives/basic.png') String selectedKnifePath,
  }) = _UserSessionState;

  factory UserSessionState.initial() => const UserSessionState();

  factory UserSessionState.fromJson(Map<String, dynamic> json) =>
      _$UserSessionStateFromJson(json);
}
