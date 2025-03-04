// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_settings_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameSettingsState _$GameSettingsStateFromJson(Map<String, dynamic> json) =>
    _GameSettingsState(
      bestScore: (json['bestScore'] as num).toInt(),
      isMusicOn: json['isMusicOn'] as bool,
      isSoundOn: json['isSoundOn'] as bool,
      highestLevel: (json['highestLevel'] as num).toInt(),
    );

Map<String, dynamic> _$GameSettingsStateToJson(_GameSettingsState instance) =>
    <String, dynamic>{
      'bestScore': instance.bestScore,
      'isMusicOn': instance.isMusicOn,
      'isSoundOn': instance.isSoundOn,
      'highestLevel': instance.highestLevel,
    };
