// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_stats_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameStatsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameStatsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameStatsEvent()';
}


}

/// @nodoc
class $GameStatsEventCopyWith<$Res>  {
$GameStatsEventCopyWith(GameStatsEvent _, $Res Function(GameStatsEvent) __);
}


/// @nodoc


class ScoreEventAdded implements GameStatsEvent {
  const ScoreEventAdded(this.score);
  

 final  int score;

/// Create a copy of GameStatsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoreEventAddedCopyWith<ScoreEventAdded> get copyWith => _$ScoreEventAddedCopyWithImpl<ScoreEventAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreEventAdded&&(identical(other.score, score) || other.score == score));
}


@override
int get hashCode => Object.hash(runtimeType,score);

@override
String toString() {
  return 'GameStatsEvent.scoreEventAdded(score: $score)';
}


}

/// @nodoc
abstract mixin class $ScoreEventAddedCopyWith<$Res> implements $GameStatsEventCopyWith<$Res> {
  factory $ScoreEventAddedCopyWith(ScoreEventAdded value, $Res Function(ScoreEventAdded) _then) = _$ScoreEventAddedCopyWithImpl;
@useResult
$Res call({
 int score
});




}
/// @nodoc
class _$ScoreEventAddedCopyWithImpl<$Res>
    implements $ScoreEventAddedCopyWith<$Res> {
  _$ScoreEventAddedCopyWithImpl(this._self, this._then);

  final ScoreEventAdded _self;
  final $Res Function(ScoreEventAdded) _then;

/// Create a copy of GameStatsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? score = null,}) {
  return _then(ScoreEventAdded(
null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class KnifeNumEvent implements GameStatsEvent {
  const KnifeNumEvent(this.numOfKnives);
  

 final  int numOfKnives;

/// Create a copy of GameStatsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KnifeNumEventCopyWith<KnifeNumEvent> get copyWith => _$KnifeNumEventCopyWithImpl<KnifeNumEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KnifeNumEvent&&(identical(other.numOfKnives, numOfKnives) || other.numOfKnives == numOfKnives));
}


@override
int get hashCode => Object.hash(runtimeType,numOfKnives);

@override
String toString() {
  return 'GameStatsEvent.knifeNumEvent(numOfKnives: $numOfKnives)';
}


}

/// @nodoc
abstract mixin class $KnifeNumEventCopyWith<$Res> implements $GameStatsEventCopyWith<$Res> {
  factory $KnifeNumEventCopyWith(KnifeNumEvent value, $Res Function(KnifeNumEvent) _then) = _$KnifeNumEventCopyWithImpl;
@useResult
$Res call({
 int numOfKnives
});




}
/// @nodoc
class _$KnifeNumEventCopyWithImpl<$Res>
    implements $KnifeNumEventCopyWith<$Res> {
  _$KnifeNumEventCopyWithImpl(this._self, this._then);

  final KnifeNumEvent _self;
  final $Res Function(KnifeNumEvent) _then;

/// Create a copy of GameStatsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? numOfKnives = null,}) {
  return _then(KnifeNumEvent(
null == numOfKnives ? _self.numOfKnives : numOfKnives // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class LevelEventAdded implements GameStatsEvent {
  const LevelEventAdded(this.level);
  

 final  int level;

/// Create a copy of GameStatsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelEventAddedCopyWith<LevelEventAdded> get copyWith => _$LevelEventAddedCopyWithImpl<LevelEventAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelEventAdded&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,level);

@override
String toString() {
  return 'GameStatsEvent.levelEventAdded(level: $level)';
}


}

/// @nodoc
abstract mixin class $LevelEventAddedCopyWith<$Res> implements $GameStatsEventCopyWith<$Res> {
  factory $LevelEventAddedCopyWith(LevelEventAdded value, $Res Function(LevelEventAdded) _then) = _$LevelEventAddedCopyWithImpl;
@useResult
$Res call({
 int level
});




}
/// @nodoc
class _$LevelEventAddedCopyWithImpl<$Res>
    implements $LevelEventAddedCopyWith<$Res> {
  _$LevelEventAddedCopyWithImpl(this._self, this._then);

  final LevelEventAdded _self;
  final $Res Function(LevelEventAdded) _then;

/// Create a copy of GameStatsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? level = null,}) {
  return _then(LevelEventAdded(
null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ScoreEventCleared implements GameStatsEvent {
  const ScoreEventCleared();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreEventCleared);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameStatsEvent.scoreEventCleared()';
}


}




/// @nodoc


class PlayerDied implements GameStatsEvent {
  const PlayerDied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerDied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameStatsEvent.playerDied()';
}


}




/// @nodoc


class PlayerRespawned implements GameStatsEvent {
  const PlayerRespawned();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerRespawned);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameStatsEvent.playerRespawned()';
}


}




/// @nodoc


class GameReset implements GameStatsEvent {
  const GameReset();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameReset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameStatsEvent.gameReset()';
}


}




/// @nodoc
mixin _$GameStatsState {

 int get score; int get numOfKnives; bool get isMute; GameStatus get status; int get level;
/// Create a copy of GameStatsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStatsStateCopyWith<GameStatsState> get copyWith => _$GameStatsStateCopyWithImpl<GameStatsState>(this as GameStatsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameStatsState&&(identical(other.score, score) || other.score == score)&&(identical(other.numOfKnives, numOfKnives) || other.numOfKnives == numOfKnives)&&(identical(other.isMute, isMute) || other.isMute == isMute)&&(identical(other.status, status) || other.status == status)&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,score,numOfKnives,isMute,status,level);

@override
String toString() {
  return 'GameStatsState(score: $score, numOfKnives: $numOfKnives, isMute: $isMute, status: $status, level: $level)';
}


}

/// @nodoc
abstract mixin class $GameStatsStateCopyWith<$Res>  {
  factory $GameStatsStateCopyWith(GameStatsState value, $Res Function(GameStatsState) _then) = _$GameStatsStateCopyWithImpl;
@useResult
$Res call({
 int score, int numOfKnives, bool isMute, GameStatus status, int level
});




}
/// @nodoc
class _$GameStatsStateCopyWithImpl<$Res>
    implements $GameStatsStateCopyWith<$Res> {
  _$GameStatsStateCopyWithImpl(this._self, this._then);

  final GameStatsState _self;
  final $Res Function(GameStatsState) _then;

/// Create a copy of GameStatsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? numOfKnives = null,Object? isMute = null,Object? status = null,Object? level = null,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,numOfKnives: null == numOfKnives ? _self.numOfKnives : numOfKnives // ignore: cast_nullable_to_non_nullable
as int,isMute: null == isMute ? _self.isMute : isMute // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameStatus,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _GameStatsState implements GameStatsState {
  const _GameStatsState({required this.score, required this.numOfKnives, required this.isMute, required this.status, required this.level});
  

@override final  int score;
@override final  int numOfKnives;
@override final  bool isMute;
@override final  GameStatus status;
@override final  int level;

/// Create a copy of GameStatsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStatsStateCopyWith<_GameStatsState> get copyWith => __$GameStatsStateCopyWithImpl<_GameStatsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameStatsState&&(identical(other.score, score) || other.score == score)&&(identical(other.numOfKnives, numOfKnives) || other.numOfKnives == numOfKnives)&&(identical(other.isMute, isMute) || other.isMute == isMute)&&(identical(other.status, status) || other.status == status)&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,score,numOfKnives,isMute,status,level);

@override
String toString() {
  return 'GameStatsState(score: $score, numOfKnives: $numOfKnives, isMute: $isMute, status: $status, level: $level)';
}


}

/// @nodoc
abstract mixin class _$GameStatsStateCopyWith<$Res> implements $GameStatsStateCopyWith<$Res> {
  factory _$GameStatsStateCopyWith(_GameStatsState value, $Res Function(_GameStatsState) _then) = __$GameStatsStateCopyWithImpl;
@override @useResult
$Res call({
 int score, int numOfKnives, bool isMute, GameStatus status, int level
});




}
/// @nodoc
class __$GameStatsStateCopyWithImpl<$Res>
    implements _$GameStatsStateCopyWith<$Res> {
  __$GameStatsStateCopyWithImpl(this._self, this._then);

  final _GameStatsState _self;
  final $Res Function(_GameStatsState) _then;

/// Create a copy of GameStatsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? numOfKnives = null,Object? isMute = null,Object? status = null,Object? level = null,}) {
  return _then(_GameStatsState(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,numOfKnives: null == numOfKnives ? _self.numOfKnives : numOfKnives // ignore: cast_nullable_to_non_nullable
as int,isMute: null == isMute ? _self.isMute : isMute // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameStatus,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
