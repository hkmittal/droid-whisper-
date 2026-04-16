// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcription_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TranscriptionConfig _$TranscriptionConfigFromJson(Map<String, dynamic> json) {
  return _TranscriptionConfig.fromJson(json);
}

/// @nodoc
mixin _$TranscriptionConfig {
  /// The transcription back‑end to use.
  TranscriptionProvider get provider => throw _privateConstructorUsedError;

  /// BCP‑47 language hint (e.g. `'en'`, `'es'`).  `null` = auto‑detect.
  String? get language => throw _privateConstructorUsedError;

  /// Personal API key used for OpenAI Whisper requests.
  String? get openAIApiKey => throw _privateConstructorUsedError;

  /// Personal API key used for Gemini Flash requests.
  String? get geminiApiKey => throw _privateConstructorUsedError;

  /// Model identifier override.  Each provider has a sensible default.
  String? get modelName => throw _privateConstructorUsedError;

  /// Whether to request word‑level or segment‑level timestamps.
  bool get includeTimestamps => throw _privateConstructorUsedError;

  /// Optional prompt / context hint supplied to the model.
  String? get prompt => throw _privateConstructorUsedError;

  /// Response format for OpenAI (`json`, `text`, `srt`, `verbose_json`,
  /// `vtt`).  Defaults to `verbose_json` for richest data.
  String get responseFormat => throw _privateConstructorUsedError;

  /// Temperature (0.0 – 1.0) for sampling. Lower = more deterministic.
  double get temperature => throw _privateConstructorUsedError;

  /// Serializes this TranscriptionConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranscriptionConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranscriptionConfigCopyWith<TranscriptionConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranscriptionConfigCopyWith<$Res> {
  factory $TranscriptionConfigCopyWith(
          TranscriptionConfig value, $Res Function(TranscriptionConfig) then) =
      _$TranscriptionConfigCopyWithImpl<$Res, TranscriptionConfig>;
  @useResult
  $Res call(
      {TranscriptionProvider provider,
      String? language,
      String? openAIApiKey,
      String? geminiApiKey,
      String? modelName,
      bool includeTimestamps,
      String? prompt,
      String responseFormat,
      double temperature});
}

/// @nodoc
class _$TranscriptionConfigCopyWithImpl<$Res, $Val extends TranscriptionConfig>
    implements $TranscriptionConfigCopyWith<$Res> {
  _$TranscriptionConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranscriptionConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? language = freezed,
    Object? openAIApiKey = freezed,
    Object? geminiApiKey = freezed,
    Object? modelName = freezed,
    Object? includeTimestamps = null,
    Object? prompt = freezed,
    Object? responseFormat = null,
    Object? temperature = null,
  }) {
    return _then(_value.copyWith(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as TranscriptionProvider,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      openAIApiKey: freezed == openAIApiKey
          ? _value.openAIApiKey
          : openAIApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      geminiApiKey: freezed == geminiApiKey
          ? _value.geminiApiKey
          : geminiApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      includeTimestamps: null == includeTimestamps
          ? _value.includeTimestamps
          : includeTimestamps // ignore: cast_nullable_to_non_nullable
              as bool,
      prompt: freezed == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      responseFormat: null == responseFormat
          ? _value.responseFormat
          : responseFormat // ignore: cast_nullable_to_non_nullable
              as String,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranscriptionConfigImplCopyWith<$Res>
    implements $TranscriptionConfigCopyWith<$Res> {
  factory _$$TranscriptionConfigImplCopyWith(_$TranscriptionConfigImpl value,
          $Res Function(_$TranscriptionConfigImpl) then) =
      __$$TranscriptionConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TranscriptionProvider provider,
      String? language,
      String? openAIApiKey,
      String? geminiApiKey,
      String? modelName,
      bool includeTimestamps,
      String? prompt,
      String responseFormat,
      double temperature});
}

/// @nodoc
class __$$TranscriptionConfigImplCopyWithImpl<$Res>
    extends _$TranscriptionConfigCopyWithImpl<$Res, _$TranscriptionConfigImpl>
    implements _$$TranscriptionConfigImplCopyWith<$Res> {
  __$$TranscriptionConfigImplCopyWithImpl(_$TranscriptionConfigImpl _value,
      $Res Function(_$TranscriptionConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranscriptionConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? language = freezed,
    Object? openAIApiKey = freezed,
    Object? geminiApiKey = freezed,
    Object? modelName = freezed,
    Object? includeTimestamps = null,
    Object? prompt = freezed,
    Object? responseFormat = null,
    Object? temperature = null,
  }) {
    return _then(_$TranscriptionConfigImpl(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as TranscriptionProvider,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      openAIApiKey: freezed == openAIApiKey
          ? _value.openAIApiKey
          : openAIApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      geminiApiKey: freezed == geminiApiKey
          ? _value.geminiApiKey
          : geminiApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      includeTimestamps: null == includeTimestamps
          ? _value.includeTimestamps
          : includeTimestamps // ignore: cast_nullable_to_non_nullable
              as bool,
      prompt: freezed == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      responseFormat: null == responseFormat
          ? _value.responseFormat
          : responseFormat // ignore: cast_nullable_to_non_nullable
              as String,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranscriptionConfigImpl implements _TranscriptionConfig {
  const _$TranscriptionConfigImpl(
      {this.provider = TranscriptionProvider.local,
      this.language,
      this.openAIApiKey,
      this.geminiApiKey,
      this.modelName,
      this.includeTimestamps = true,
      this.prompt,
      this.responseFormat = 'verbose_json',
      this.temperature = 0.0});

  factory _$TranscriptionConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranscriptionConfigImplFromJson(json);

  /// The transcription back‑end to use.
  @override
  @JsonKey()
  final TranscriptionProvider provider;

  /// BCP‑47 language hint (e.g. `'en'`, `'es'`).  `null` = auto‑detect.
  @override
  final String? language;

  /// Personal API key used for OpenAI Whisper requests.
  @override
  final String? openAIApiKey;

  /// Personal API key used for Gemini Flash requests.
  @override
  final String? geminiApiKey;

  /// Model identifier override.  Each provider has a sensible default.
  @override
  final String? modelName;

  /// Whether to request word‑level or segment‑level timestamps.
  @override
  @JsonKey()
  final bool includeTimestamps;

  /// Optional prompt / context hint supplied to the model.
  @override
  final String? prompt;

  /// Response format for OpenAI (`json`, `text`, `srt`, `verbose_json`,
  /// `vtt`).  Defaults to `verbose_json` for richest data.
  @override
  @JsonKey()
  final String responseFormat;

  /// Temperature (0.0 – 1.0) for sampling. Lower = more deterministic.
  @override
  @JsonKey()
  final double temperature;

  @override
  String toString() {
    return 'TranscriptionConfig(provider: $provider, language: $language, openAIApiKey: $openAIApiKey, geminiApiKey: $geminiApiKey, modelName: $modelName, includeTimestamps: $includeTimestamps, prompt: $prompt, responseFormat: $responseFormat, temperature: $temperature)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranscriptionConfigImpl &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.openAIApiKey, openAIApiKey) ||
                other.openAIApiKey == openAIApiKey) &&
            (identical(other.geminiApiKey, geminiApiKey) ||
                other.geminiApiKey == geminiApiKey) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.includeTimestamps, includeTimestamps) ||
                other.includeTimestamps == includeTimestamps) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.responseFormat, responseFormat) ||
                other.responseFormat == responseFormat) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      provider,
      language,
      openAIApiKey,
      geminiApiKey,
      modelName,
      includeTimestamps,
      prompt,
      responseFormat,
      temperature);

  /// Create a copy of TranscriptionConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranscriptionConfigImplCopyWith<_$TranscriptionConfigImpl> get copyWith =>
      __$$TranscriptionConfigImplCopyWithImpl<_$TranscriptionConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranscriptionConfigImplToJson(
      this,
    );
  }
}

abstract class _TranscriptionConfig implements TranscriptionConfig {
  const factory _TranscriptionConfig(
      {final TranscriptionProvider provider,
      final String? language,
      final String? openAIApiKey,
      final String? geminiApiKey,
      final String? modelName,
      final bool includeTimestamps,
      final String? prompt,
      final String responseFormat,
      final double temperature}) = _$TranscriptionConfigImpl;

  factory _TranscriptionConfig.fromJson(Map<String, dynamic> json) =
      _$TranscriptionConfigImpl.fromJson;

  /// The transcription back‑end to use.
  @override
  TranscriptionProvider get provider;

  /// BCP‑47 language hint (e.g. `'en'`, `'es'`).  `null` = auto‑detect.
  @override
  String? get language;

  /// Personal API key used for OpenAI Whisper requests.
  @override
  String? get openAIApiKey;

  /// Personal API key used for Gemini Flash requests.
  @override
  String? get geminiApiKey;

  /// Model identifier override.  Each provider has a sensible default.
  @override
  String? get modelName;

  /// Whether to request word‑level or segment‑level timestamps.
  @override
  bool get includeTimestamps;

  /// Optional prompt / context hint supplied to the model.
  @override
  String? get prompt;

  /// Response format for OpenAI (`json`, `text`, `srt`, `verbose_json`,
  /// `vtt`).  Defaults to `verbose_json` for richest data.
  @override
  String get responseFormat;

  /// Temperature (0.0 – 1.0) for sampling. Lower = more deterministic.
  @override
  double get temperature;

  /// Create a copy of TranscriptionConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranscriptionConfigImplCopyWith<_$TranscriptionConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
