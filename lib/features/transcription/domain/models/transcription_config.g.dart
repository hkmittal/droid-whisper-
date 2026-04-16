// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcription_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranscriptionConfigImpl _$$TranscriptionConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$TranscriptionConfigImpl(
      provider: $enumDecodeNullable(
              _$TranscriptionProviderEnumMap, json['provider']) ??
          TranscriptionProvider.local,
      language: json['language'] as String?,
      openAIApiKey: json['openAIApiKey'] as String?,
      geminiApiKey: json['geminiApiKey'] as String?,
      modelName: json['modelName'] as String?,
      includeTimestamps: json['includeTimestamps'] as bool? ?? true,
      prompt: json['prompt'] as String?,
      responseFormat: json['responseFormat'] as String? ?? 'verbose_json',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$TranscriptionConfigImplToJson(
        _$TranscriptionConfigImpl instance) =>
    <String, dynamic>{
      'provider': _$TranscriptionProviderEnumMap[instance.provider]!,
      'language': instance.language,
      'openAIApiKey': instance.openAIApiKey,
      'geminiApiKey': instance.geminiApiKey,
      'modelName': instance.modelName,
      'includeTimestamps': instance.includeTimestamps,
      'prompt': instance.prompt,
      'responseFormat': instance.responseFormat,
      'temperature': instance.temperature,
    };

const _$TranscriptionProviderEnumMap = {
  TranscriptionProvider.local: 'local',
  TranscriptionProvider.openAIWhisper: 'openAIWhisper',
  TranscriptionProvider.geminiFlash: 'geminiFlash',
};
