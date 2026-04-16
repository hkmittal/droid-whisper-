// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcription_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TranscriptionSegment _$TranscriptionSegmentFromJson(Map<String, dynamic> json) {
  return _TranscriptionSegment.fromJson(json);
}

/// @nodoc
mixin _$TranscriptionSegment {
  /// Zero‑based index of this segment.
  int get index => throw _privateConstructorUsedError;

  /// Start time offset in milliseconds.
  int get startMs => throw _privateConstructorUsedError;

  /// End time offset in milliseconds.
  int get endMs => throw _privateConstructorUsedError;

  /// Transcribed text for this segment.
  String get text => throw _privateConstructorUsedError;

  /// Per‑segment confidence score (0.0 – 1.0), if available.
  double? get confidence => throw _privateConstructorUsedError;

  /// Serializes this TranscriptionSegment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranscriptionSegment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranscriptionSegmentCopyWith<TranscriptionSegment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranscriptionSegmentCopyWith<$Res> {
  factory $TranscriptionSegmentCopyWith(TranscriptionSegment value,
          $Res Function(TranscriptionSegment) then) =
      _$TranscriptionSegmentCopyWithImpl<$Res, TranscriptionSegment>;
  @useResult
  $Res call(
      {int index, int startMs, int endMs, String text, double? confidence});
}

/// @nodoc
class _$TranscriptionSegmentCopyWithImpl<$Res,
        $Val extends TranscriptionSegment>
    implements $TranscriptionSegmentCopyWith<$Res> {
  _$TranscriptionSegmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranscriptionSegment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? startMs = null,
    Object? endMs = null,
    Object? text = null,
    Object? confidence = freezed,
  }) {
    return _then(_value.copyWith(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      startMs: null == startMs
          ? _value.startMs
          : startMs // ignore: cast_nullable_to_non_nullable
              as int,
      endMs: null == endMs
          ? _value.endMs
          : endMs // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranscriptionSegmentImplCopyWith<$Res>
    implements $TranscriptionSegmentCopyWith<$Res> {
  factory _$$TranscriptionSegmentImplCopyWith(_$TranscriptionSegmentImpl value,
          $Res Function(_$TranscriptionSegmentImpl) then) =
      __$$TranscriptionSegmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int index, int startMs, int endMs, String text, double? confidence});
}

/// @nodoc
class __$$TranscriptionSegmentImplCopyWithImpl<$Res>
    extends _$TranscriptionSegmentCopyWithImpl<$Res, _$TranscriptionSegmentImpl>
    implements _$$TranscriptionSegmentImplCopyWith<$Res> {
  __$$TranscriptionSegmentImplCopyWithImpl(_$TranscriptionSegmentImpl _value,
      $Res Function(_$TranscriptionSegmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranscriptionSegment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? startMs = null,
    Object? endMs = null,
    Object? text = null,
    Object? confidence = freezed,
  }) {
    return _then(_$TranscriptionSegmentImpl(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      startMs: null == startMs
          ? _value.startMs
          : startMs // ignore: cast_nullable_to_non_nullable
              as int,
      endMs: null == endMs
          ? _value.endMs
          : endMs // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranscriptionSegmentImpl implements _TranscriptionSegment {
  const _$TranscriptionSegmentImpl(
      {required this.index,
      required this.startMs,
      required this.endMs,
      required this.text,
      this.confidence});

  factory _$TranscriptionSegmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranscriptionSegmentImplFromJson(json);

  /// Zero‑based index of this segment.
  @override
  final int index;

  /// Start time offset in milliseconds.
  @override
  final int startMs;

  /// End time offset in milliseconds.
  @override
  final int endMs;

  /// Transcribed text for this segment.
  @override
  final String text;

  /// Per‑segment confidence score (0.0 – 1.0), if available.
  @override
  final double? confidence;

  @override
  String toString() {
    return 'TranscriptionSegment(index: $index, startMs: $startMs, endMs: $endMs, text: $text, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranscriptionSegmentImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.startMs, startMs) || other.startMs == startMs) &&
            (identical(other.endMs, endMs) || other.endMs == endMs) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, index, startMs, endMs, text, confidence);

  /// Create a copy of TranscriptionSegment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranscriptionSegmentImplCopyWith<_$TranscriptionSegmentImpl>
      get copyWith =>
          __$$TranscriptionSegmentImplCopyWithImpl<_$TranscriptionSegmentImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranscriptionSegmentImplToJson(
      this,
    );
  }
}

abstract class _TranscriptionSegment implements TranscriptionSegment {
  const factory _TranscriptionSegment(
      {required final int index,
      required final int startMs,
      required final int endMs,
      required final String text,
      final double? confidence}) = _$TranscriptionSegmentImpl;

  factory _TranscriptionSegment.fromJson(Map<String, dynamic> json) =
      _$TranscriptionSegmentImpl.fromJson;

  /// Zero‑based index of this segment.
  @override
  int get index;

  /// Start time offset in milliseconds.
  @override
  int get startMs;

  /// End time offset in milliseconds.
  @override
  int get endMs;

  /// Transcribed text for this segment.
  @override
  String get text;

  /// Per‑segment confidence score (0.0 – 1.0), if available.
  @override
  double? get confidence;

  /// Create a copy of TranscriptionSegment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranscriptionSegmentImplCopyWith<_$TranscriptionSegmentImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TranscriptionResult _$TranscriptionResultFromJson(Map<String, dynamic> json) {
  return _TranscriptionResult.fromJson(json);
}

/// @nodoc
mixin _$TranscriptionResult {
  /// Full transcribed text.
  String get text => throw _privateConstructorUsedError;

  /// Overall confidence score (0.0 – 1.0). May be `null` when the
  /// provider does not expose one.
  double? get confidence => throw _privateConstructorUsedError;

  /// Wall‑clock duration of the audio that was transcribed.
  Duration get duration => throw _privateConstructorUsedError;

  /// Which provider produced this result.
  TranscriptionProvider get provider => throw _privateConstructorUsedError;

  /// Time‑aligned segments, if available.
  List<TranscriptionSegment> get segments => throw _privateConstructorUsedError;

  /// Detected or requested BCP‑47 language code.
  String? get language => throw _privateConstructorUsedError;

  /// Timestamp when the transcription completed.
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this TranscriptionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranscriptionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranscriptionResultCopyWith<TranscriptionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranscriptionResultCopyWith<$Res> {
  factory $TranscriptionResultCopyWith(
          TranscriptionResult value, $Res Function(TranscriptionResult) then) =
      _$TranscriptionResultCopyWithImpl<$Res, TranscriptionResult>;
  @useResult
  $Res call(
      {String text,
      double? confidence,
      Duration duration,
      TranscriptionProvider provider,
      List<TranscriptionSegment> segments,
      String? language,
      DateTime? completedAt});
}

/// @nodoc
class _$TranscriptionResultCopyWithImpl<$Res, $Val extends TranscriptionResult>
    implements $TranscriptionResultCopyWith<$Res> {
  _$TranscriptionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranscriptionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? confidence = freezed,
    Object? duration = null,
    Object? provider = null,
    Object? segments = null,
    Object? language = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as TranscriptionProvider,
      segments: null == segments
          ? _value.segments
          : segments // ignore: cast_nullable_to_non_nullable
              as List<TranscriptionSegment>,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranscriptionResultImplCopyWith<$Res>
    implements $TranscriptionResultCopyWith<$Res> {
  factory _$$TranscriptionResultImplCopyWith(_$TranscriptionResultImpl value,
          $Res Function(_$TranscriptionResultImpl) then) =
      __$$TranscriptionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String text,
      double? confidence,
      Duration duration,
      TranscriptionProvider provider,
      List<TranscriptionSegment> segments,
      String? language,
      DateTime? completedAt});
}

/// @nodoc
class __$$TranscriptionResultImplCopyWithImpl<$Res>
    extends _$TranscriptionResultCopyWithImpl<$Res, _$TranscriptionResultImpl>
    implements _$$TranscriptionResultImplCopyWith<$Res> {
  __$$TranscriptionResultImplCopyWithImpl(_$TranscriptionResultImpl _value,
      $Res Function(_$TranscriptionResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranscriptionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? confidence = freezed,
    Object? duration = null,
    Object? provider = null,
    Object? segments = null,
    Object? language = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$TranscriptionResultImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as TranscriptionProvider,
      segments: null == segments
          ? _value._segments
          : segments // ignore: cast_nullable_to_non_nullable
              as List<TranscriptionSegment>,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranscriptionResultImpl implements _TranscriptionResult {
  const _$TranscriptionResultImpl(
      {required this.text,
      this.confidence,
      required this.duration,
      required this.provider,
      final List<TranscriptionSegment> segments = const [],
      this.language,
      this.completedAt})
      : _segments = segments;

  factory _$TranscriptionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranscriptionResultImplFromJson(json);

  /// Full transcribed text.
  @override
  final String text;

  /// Overall confidence score (0.0 – 1.0). May be `null` when the
  /// provider does not expose one.
  @override
  final double? confidence;

  /// Wall‑clock duration of the audio that was transcribed.
  @override
  final Duration duration;

  /// Which provider produced this result.
  @override
  final TranscriptionProvider provider;

  /// Time‑aligned segments, if available.
  final List<TranscriptionSegment> _segments;

  /// Time‑aligned segments, if available.
  @override
  @JsonKey()
  List<TranscriptionSegment> get segments {
    if (_segments is EqualUnmodifiableListView) return _segments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_segments);
  }

  /// Detected or requested BCP‑47 language code.
  @override
  final String? language;

  /// Timestamp when the transcription completed.
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'TranscriptionResult(text: $text, confidence: $confidence, duration: $duration, provider: $provider, segments: $segments, language: $language, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranscriptionResultImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            const DeepCollectionEquality().equals(other._segments, _segments) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      text,
      confidence,
      duration,
      provider,
      const DeepCollectionEquality().hash(_segments),
      language,
      completedAt);

  /// Create a copy of TranscriptionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranscriptionResultImplCopyWith<_$TranscriptionResultImpl> get copyWith =>
      __$$TranscriptionResultImplCopyWithImpl<_$TranscriptionResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranscriptionResultImplToJson(
      this,
    );
  }
}

abstract class _TranscriptionResult implements TranscriptionResult {
  const factory _TranscriptionResult(
      {required final String text,
      final double? confidence,
      required final Duration duration,
      required final TranscriptionProvider provider,
      final List<TranscriptionSegment> segments,
      final String? language,
      final DateTime? completedAt}) = _$TranscriptionResultImpl;

  factory _TranscriptionResult.fromJson(Map<String, dynamic> json) =
      _$TranscriptionResultImpl.fromJson;

  /// Full transcribed text.
  @override
  String get text;

  /// Overall confidence score (0.0 – 1.0). May be `null` when the
  /// provider does not expose one.
  @override
  double? get confidence;

  /// Wall‑clock duration of the audio that was transcribed.
  @override
  Duration get duration;

  /// Which provider produced this result.
  @override
  TranscriptionProvider get provider;

  /// Time‑aligned segments, if available.
  @override
  List<TranscriptionSegment> get segments;

  /// Detected or requested BCP‑47 language code.
  @override
  String? get language;

  /// Timestamp when the transcription completed.
  @override
  DateTime? get completedAt;

  /// Create a copy of TranscriptionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranscriptionResultImplCopyWith<_$TranscriptionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
