// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameSettingsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameSettingsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameSettingsEvent()';
}


}

/// @nodoc
class $GameSettingsEventCopyWith<$Res>  {
$GameSettingsEventCopyWith(GameSettingsEvent _, $Res Function(GameSettingsEvent) __);
}


/// @nodoc


class _UpdateBestScore implements GameSettingsEvent {
  const _UpdateBestScore(this.score);
  

 final  int score;

/// Create a copy of GameSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateBestScoreCopyWith<_UpdateBestScore> get copyWith => __$UpdateBestScoreCopyWithImpl<_UpdateBestScore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateBestScore&&(identical(other.score, score) || other.score == score));
}


@override
int get hashCode => Object.hash(runtimeType,score);

@override
String toString() {
  return 'GameSettingsEvent.updateBestScore(score: $score)';
}


}

/// @nodoc
abstract mixin class _$UpdateBestScoreCopyWith<$Res> implements $GameSettingsEventCopyWith<$Res> {
  factory _$UpdateBestScoreCopyWith(_UpdateBestScore value, $Res Function(_UpdateBestScore) _then) = __$UpdateBestScoreCopyWithImpl;
@useResult
$Res call({
 int score
});




}
/// @nodoc
class __$UpdateBestScoreCopyWithImpl<$Res>
    implements _$UpdateBestScoreCopyWith<$Res> {
  __$UpdateBestScoreCopyWithImpl(this._self, this._then);

  final _UpdateBestScore _self;
  final $Res Function(_UpdateBestScore) _then;

/// Create a copy of GameSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? score = null,}) {
  return _then(_UpdateBestScore(
null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ToggleMusic implements GameSettingsEvent {
  const _ToggleMusic();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleMusic);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameSettingsEvent.toggleMusic()';
}


}




/// @nodoc


class _ToggleSound implements GameSettingsEvent {
  const _ToggleSound();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleSound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameSettingsEvent.toggleSound()';
}


}




/// @nodoc


class _UpdateHighestLevel implements GameSettingsEvent {
  const _UpdateHighestLevel(this.level);
  

 final  int level;

/// Create a copy of GameSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateHighestLevelCopyWith<_UpdateHighestLevel> get copyWith => __$UpdateHighestLevelCopyWithImpl<_UpdateHighestLevel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateHighestLevel&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,level);

@override
String toString() {
  return 'GameSettingsEvent.updateHighestLevel(level: $level)';
}


}

/// @nodoc
abstract mixin class _$UpdateHighestLevelCopyWith<$Res> implements $GameSettingsEventCopyWith<$Res> {
  factory _$UpdateHighestLevelCopyWith(_UpdateHighestLevel value, $Res Function(_UpdateHighestLevel) _then) = __$UpdateHighestLevelCopyWithImpl;
@useResult
$Res call({
 int level
});




}
/// @nodoc
class __$UpdateHighestLevelCopyWithImpl<$Res>
    implements _$UpdateHighestLevelCopyWith<$Res> {
  __$UpdateHighestLevelCopyWithImpl(this._self, this._then);

  final _UpdateHighestLevel _self;
  final $Res Function(_UpdateHighestLevel) _then;

/// Create a copy of GameSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? level = null,}) {
  return _then(_UpdateHighestLevel(
null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$GameSettingsState {

 int get bestScore; bool get isMusicOn; bool get isSoundOn; int get highestLevel;
/// Create a copy of GameSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameSettingsStateCopyWith<GameSettingsState> get copyWith => _$GameSettingsStateCopyWithImpl<GameSettingsState>(this as GameSettingsState, _$identity);

  /// Serializes this GameSettingsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameSettingsState&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore)&&(identical(other.isMusicOn, isMusicOn) || other.isMusicOn == isMusicOn)&&(identical(other.isSoundOn, isSoundOn) || other.isSoundOn == isSoundOn)&&(identical(other.highestLevel, highestLevel) || other.highestLevel == highestLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bestScore,isMusicOn,isSoundOn,highestLevel);

@override
String toString() {
  return 'GameSettingsState(bestScore: $bestScore, isMusicOn: $isMusicOn, isSoundOn: $isSoundOn, highestLevel: $highestLevel)';
}


}

/// @nodoc
abstract mixin class $GameSettingsStateCopyWith<$Res>  {
  factory $GameSettingsStateCopyWith(GameSettingsState value, $Res Function(GameSettingsState) _then) = _$GameSettingsStateCopyWithImpl;
@useResult
$Res call({
 int bestScore, bool isMusicOn, bool isSoundOn, int highestLevel
});




}
/// @nodoc
class _$GameSettingsStateCopyWithImpl<$Res>
    implements $GameSettingsStateCopyWith<$Res> {
  _$GameSettingsStateCopyWithImpl(this._self, this._then);

  final GameSettingsState _self;
  final $Res Function(GameSettingsState) _then;

/// Create a copy of GameSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bestScore = null,Object? isMusicOn = null,Object? isSoundOn = null,Object? highestLevel = null,}) {
  return _then(_self.copyWith(
bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as int,isMusicOn: null == isMusicOn ? _self.isMusicOn : isMusicOn // ignore: cast_nullable_to_non_nullable
as bool,isSoundOn: null == isSoundOn ? _self.isSoundOn : isSoundOn // ignore: cast_nullable_to_non_nullable
as bool,highestLevel: null == highestLevel ? _self.highestLevel : highestLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _GameSettingsState implements GameSettingsState {
  const _GameSettingsState({required this.bestScore, required this.isMusicOn, required this.isSoundOn, required this.highestLevel});
  factory _GameSettingsState.fromJson(Map<String, dynamic> json) => _$GameSettingsStateFromJson(json);

@override final  int bestScore;
@override final  bool isMusicOn;
@override final  bool isSoundOn;
@override final  int highestLevel;

/// Create a copy of GameSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameSettingsStateCopyWith<_GameSettingsState> get copyWith => __$GameSettingsStateCopyWithImpl<_GameSettingsState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameSettingsStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameSettingsState&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore)&&(identical(other.isMusicOn, isMusicOn) || other.isMusicOn == isMusicOn)&&(identical(other.isSoundOn, isSoundOn) || other.isSoundOn == isSoundOn)&&(identical(other.highestLevel, highestLevel) || other.highestLevel == highestLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bestScore,isMusicOn,isSoundOn,highestLevel);

@override
String toString() {
  return 'GameSettingsState(bestScore: $bestScore, isMusicOn: $isMusicOn, isSoundOn: $isSoundOn, highestLevel: $highestLevel)';
}


}

/// @nodoc
abstract mixin class _$GameSettingsStateCopyWith<$Res> implements $GameSettingsStateCopyWith<$Res> {
  factory _$GameSettingsStateCopyWith(_GameSettingsState value, $Res Function(_GameSettingsState) _then) = __$GameSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 int bestScore, bool isMusicOn, bool isSoundOn, int highestLevel
});




}
/// @nodoc
class __$GameSettingsStateCopyWithImpl<$Res>
    implements _$GameSettingsStateCopyWith<$Res> {
  __$GameSettingsStateCopyWithImpl(this._self, this._then);

  final _GameSettingsState _self;
  final $Res Function(_GameSettingsState) _then;

/// Create a copy of GameSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bestScore = null,Object? isMusicOn = null,Object? isSoundOn = null,Object? highestLevel = null,}) {
  return _then(_GameSettingsState(
bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as int,isMusicOn: null == isMusicOn ? _self.isMusicOn : isMusicOn // ignore: cast_nullable_to_non_nullable
as bool,isSoundOn: null == isSoundOn ? _self.isSoundOn : isSoundOn // ignore: cast_nullable_to_non_nullable
as bool,highestLevel: null == highestLevel ? _self.highestLevel : highestLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
