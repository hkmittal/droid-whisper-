// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcription_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranscriptionSegmentImpl _$$TranscriptionSegmentImplFromJson(
        Map<String, dynamic> json) =>
    _$TranscriptionSegmentImpl(
      index: (json['index'] as num).toInt(),
      startMs: (json['startMs'] as num).toInt(),
      endMs: (json['endMs'] as num).toInt(),
      text: json['text'] as String,
      confidence: (json['confidence'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TranscriptionSegmentImplToJson(
        _$TranscriptionSegmentImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'startMs': instance.startMs,
      'endMs': instance.endMs,
      'text': instance.text,
      'confidence': instance.confidence,
    };

_$TranscriptionResultImpl _$$TranscriptionResultImplFromJson(
        Map<String, dynamic> json) =>
    _$TranscriptionResultImpl(
      text: json['text'] as String,
      confidence: (json['confidence'] as num?)?.toDouble(),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      provider: $enumDecode(_$TranscriptionProviderEnumMap, json['provider']),
      segments: (json['segments'] as List<dynamic>?)
              ?.map((e) =>
                  TranscriptionSegment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      language: json['language'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$TranscriptionResultImplToJson(
        _$TranscriptionResultImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'confidence': instance.confidence,
      'duration': instance.duration.inMicroseconds,
      'provider': _$TranscriptionProviderEnumMap[instance.provider]!,
      'segments': instance.segments,
      'language': instance.language,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$TranscriptionProviderEnumMap = {
  TranscriptionProvider.local: 'local',
  TranscriptionProvider.openAIWhisper: 'openAIWhisper',
  TranscriptionProvider.geminiFlash: 'geminiFlash',
};
