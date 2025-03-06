part of 'user_session_bloc.dart';

@freezed
class UserSessionEvent with _$UserSessionEvent {
  const factory UserSessionEvent.login(String userId) = _Login;
  const factory UserSessionEvent.logout() = _Logout;
  const factory UserSessionEvent.updateSelectedKnife(String knifePath) =
      _UpdateSelectedKnife;
}
