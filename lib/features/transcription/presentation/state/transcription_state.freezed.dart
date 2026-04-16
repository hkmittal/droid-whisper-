// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcription_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TranscriptionState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration elapsed) recording,
    required TResult Function(double? progress) transcribing,
    required TResult Function(TranscriptionResult result) completed,
    required TResult Function(
            String message, TranscriptionResult? previousResult)
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration elapsed)? recording,
    TResult? Function(double? progress)? transcribing,
    TResult? Function(TranscriptionResult result)? completed,
    TResult? Function(String message, TranscriptionResult? previousResult)?
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration elapsed)? recording,
    TResult Function(double? progress)? transcribing,
    TResult Function(TranscriptionResult result)? completed,
    TResult Function(String message, TranscriptionResult? previousResult)?
        error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TranscriptionIdle value) idle,
    required TResult Function(TranscriptionRecording value) recording,
    required TResult Function(TranscriptionTranscribing value) transcribing,
    required TResult Function(TranscriptionCompleted value) completed,
    required TResult Function(TranscriptionError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TranscriptionIdle value)? idle,
    TResult? Function(TranscriptionRecording value)? recording,
    TResult? Function(TranscriptionTranscribing value)? transcribing,
    TResult? Function(TranscriptionCompleted value)? completed,
    TResult? Function(TranscriptionError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TranscriptionIdle value)? idle,
    TResult Function(TranscriptionRecording value)? recording,
    TResult Function(TranscriptionTranscribing value)? transcribing,
    TResult Function(TranscriptionCompleted value)? completed,
    TResult Function(TranscriptionError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranscriptionStateCopyWith<$Res> {
  factory $TranscriptionStateCopyWith(
          TranscriptionState value, $Res Function(TranscriptionState) then) =
      _$TranscriptionStateCopyWithImpl<$Res, TranscriptionState>;
}

/// @nodoc
class _$TranscriptionStateCopyWithImpl<$Res, $Val extends TranscriptionState>
    implements $TranscriptionStateCopyWith<$Res> {
  _$TranscriptionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$TranscriptionIdleImplCopyWith<$Res> {
  factory _$$TranscriptionIdleImplCopyWith(_$TranscriptionIdleImpl value,
          $Res Function(_$TranscriptionIdleImpl) then) =
      __$$TranscriptionIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TranscriptionIdleImplCopyWithImpl<$Res>
    extends _$TranscriptionStateCopyWithImpl<$Res, _$TranscriptionIdleImpl>
    implements _$$TranscriptionIdleImplCopyWith<$Res> {
  __$$TranscriptionIdleImplCopyWithImpl(_$TranscriptionIdleImpl _value,
      $Res Function(_$TranscriptionIdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TranscriptionIdleImpl implements TranscriptionIdle {
  const _$TranscriptionIdleImpl();

  @override
  String toString() {
    return 'TranscriptionState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TranscriptionIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration elapsed) recording,
    required TResult Function(double? progress) transcribing,
    required TResult Function(TranscriptionResult result) completed,
    required TResult Function(
            String message, TranscriptionResult? previousResult)
        error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration elapsed)? recording,
    TResult? Function(double? progress)? transcribing,
    TResult? Function(TranscriptionResult result)? completed,
    TResult? Function(String message, TranscriptionResult? previousResult)?
        error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration elapsed)? recording,
    TResult Function(double? progress)? transcribing,
    TResult Function(TranscriptionResult result)? completed,
    TResult Function(String message, TranscriptionResult? previousResult)?
        error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TranscriptionIdle value) idle,
    required TResult Function(TranscriptionRecording value) recording,
    required TResult Function(TranscriptionTranscribing value) transcribing,
    required TResult Function(TranscriptionCompleted value) completed,
    required TResult Function(TranscriptionError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TranscriptionIdle value)? idle,
    TResult? Function(TranscriptionRecording value)? recording,
    TResult? Function(TranscriptionTranscribing value)? transcribing,
    TResult? Function(TranscriptionCompleted value)? completed,
    TResult? Function(TranscriptionError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TranscriptionIdle value)? idle,
    TResult Function(TranscriptionRecording value)? recording,
    TResult Function(TranscriptionTranscribing value)? transcribing,
    TResult Function(TranscriptionCompleted value)? completed,
    TResult Function(TranscriptionError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class TranscriptionIdle implements TranscriptionState {
  const factory TranscriptionIdle() = _$TranscriptionIdleImpl;
}

/// @nodoc
abstract class _$$TranscriptionRecordingImplCopyWith<$Res> {
  factory _$$TranscriptionRecordingImplCopyWith(
          _$TranscriptionRecordingImpl value,
          $Res Function(_$TranscriptionRecordingImpl) then) =
      __$$TranscriptionRecordingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Duration elapsed});
}

/// @nodoc
class __$$TranscriptionRecordingImplCopyWithImpl<$Res>
    extends _$TranscriptionStateCopyWithImpl<$Res, _$TranscriptionRecordingImpl>
    implements _$$TranscriptionRecordingImplCopyWith<$Res> {
  __$$TranscriptionRecordingImplCopyWithImpl(
      _$TranscriptionRecordingImpl _value,
      $Res Function(_$TranscriptionRecordingImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? elapsed = null,
  }) {
    return _then(_$TranscriptionRecordingImpl(
      elapsed: null == elapsed
          ? _value.elapsed
          : elapsed // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc

class _$TranscriptionRecordingImpl implements TranscriptionRecording {
  const _$TranscriptionRecordingImpl({required this.elapsed});

  /// Elapsed recording time.
  @override
  final Duration elapsed;

  @override
  String toString() {
    return 'TranscriptionState.recording(elapsed: $elapsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranscriptionRecordingImpl &&
            (identical(other.elapsed, elapsed) || other.elapsed == elapsed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, elapsed);

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranscriptionRecordingImplCopyWith<_$TranscriptionRecordingImpl>
      get copyWith => __$$TranscriptionRecordingImplCopyWithImpl<
          _$TranscriptionRecordingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration elapsed) recording,
    required TResult Function(double? progress) transcribing,
    required TResult Function(TranscriptionResult result) completed,
    required TResult Function(
            String message, TranscriptionResult? previousResult)
        error,
  }) {
    return recording(elapsed);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration elapsed)? recording,
    TResult? Function(double? progress)? transcribing,
    TResult? Function(TranscriptionResult result)? completed,
    TResult? Function(String message, TranscriptionResult? previousResult)?
        error,
  }) {
    return recording?.call(elapsed);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration elapsed)? recording,
    TResult Function(double? progress)? transcribing,
    TResult Function(TranscriptionResult result)? completed,
    TResult Function(String message, TranscriptionResult? previousResult)?
        error,
    required TResult orElse(),
  }) {
    if (recording != null) {
      return recording(elapsed);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TranscriptionIdle value) idle,
    required TResult Function(TranscriptionRecording value) recording,
    required TResult Function(TranscriptionTranscribing value) transcribing,
    required TResult Function(TranscriptionCompleted value) completed,
    required TResult Function(TranscriptionError value) error,
  }) {
    return recording(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TranscriptionIdle value)? idle,
    TResult? Function(TranscriptionRecording value)? recording,
    TResult? Function(TranscriptionTranscribing value)? transcribing,
    TResult? Function(TranscriptionCompleted value)? completed,
    TResult? Function(TranscriptionError value)? error,
  }) {
    return recording?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TranscriptionIdle value)? idle,
    TResult Function(TranscriptionRecording value)? recording,
    TResult Function(TranscriptionTranscribing value)? transcribing,
    TResult Function(TranscriptionCompleted value)? completed,
    TResult Function(TranscriptionError value)? error,
    required TResult orElse(),
  }) {
    if (recording != null) {
      return recording(this);
    }
    return orElse();
  }
}

abstract class TranscriptionRecording implements TranscriptionState {
  const factory TranscriptionRecording({required final Duration elapsed}) =
      _$TranscriptionRecordingImpl;

  /// Elapsed recording time.
  Duration get elapsed;

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranscriptionRecordingImplCopyWith<_$TranscriptionRecordingImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TranscriptionTranscribingImplCopyWith<$Res> {
  factory _$$TranscriptionTranscribingImplCopyWith(
          _$TranscriptionTranscribingImpl value,
          $Res Function(_$TranscriptionTranscribingImpl) then) =
      __$$TranscriptionTranscribingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double? progress});
}

/// @nodoc
class __$$TranscriptionTranscribingImplCopyWithImpl<$Res>
    extends _$TranscriptionStateCopyWithImpl<$Res,
        _$TranscriptionTranscribingImpl>
    implements _$$TranscriptionTranscribingImplCopyWith<$Res> {
  __$$TranscriptionTranscribingImplCopyWithImpl(
      _$TranscriptionTranscribingImpl _value,
      $Res Function(_$TranscriptionTranscribingImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = freezed,
  }) {
    return _then(_$TranscriptionTranscribingImpl(
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$TranscriptionTranscribingImpl implements TranscriptionTranscribing {
  const _$TranscriptionTranscribingImpl({this.progress});

  /// Optional progress fraction (0.0 – 1.0), when the provider reports it.
  @override
  final double? progress;

  @override
  String toString() {
    return 'TranscriptionState.transcribing(progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranscriptionTranscribingImpl &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress);

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranscriptionTranscribingImplCopyWith<_$TranscriptionTranscribingImpl>
      get copyWith => __$$TranscriptionTranscribingImplCopyWithImpl<
          _$TranscriptionTranscribingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration elapsed) recording,
    required TResult Function(double? progress) transcribing,
    required TResult Function(TranscriptionResult result) completed,
    required TResult Function(
            String message, TranscriptionResult? previousResult)
        error,
  }) {
    return transcribing(progress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration elapsed)? recording,
    TResult? Function(double? progress)? transcribing,
    TResult? Function(TranscriptionResult result)? completed,
    TResult? Function(String message, TranscriptionResult? previousResult)?
        error,
  }) {
    return transcribing?.call(progress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration elapsed)? recording,
    TResult Function(double? progress)? transcribing,
    TResult Function(TranscriptionResult result)? completed,
    TResult Function(String message, TranscriptionResult? previousResult)?
        error,
    required TResult orElse(),
  }) {
    if (transcribing != null) {
      return transcribing(progress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TranscriptionIdle value) idle,
    required TResult Function(TranscriptionRecording value) recording,
    required TResult Function(TranscriptionTranscribing value) transcribing,
    required TResult Function(TranscriptionCompleted value) completed,
    required TResult Function(TranscriptionError value) error,
  }) {
    return transcribing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TranscriptionIdle value)? idle,
    TResult? Function(TranscriptionRecording value)? recording,
    TResult? Function(TranscriptionTranscribing value)? transcribing,
    TResult? Function(TranscriptionCompleted value)? completed,
    TResult? Function(TranscriptionError value)? error,
  }) {
    return transcribing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TranscriptionIdle value)? idle,
    TResult Function(TranscriptionRecording value)? recording,
    TResult Function(TranscriptionTranscribing value)? transcribing,
    TResult Function(TranscriptionCompleted value)? completed,
    TResult Function(TranscriptionError value)? error,
    required TResult orElse(),
  }) {
    if (transcribing != null) {
      return transcribing(this);
    }
    return orElse();
  }
}

abstract class TranscriptionTranscribing implements TranscriptionState {
  const factory TranscriptionTranscribing({final double? progress}) =
      _$TranscriptionTranscribingImpl;

  /// Optional progress fraction (0.0 – 1.0), when the provider reports it.
  double? get progress;

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranscriptionTranscribingImplCopyWith<_$TranscriptionTranscribingImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TranscriptionCompletedImplCopyWith<$Res> {
  factory _$$TranscriptionCompletedImplCopyWith(
          _$TranscriptionCompletedImpl value,
          $Res Function(_$TranscriptionCompletedImpl) then) =
      __$$TranscriptionCompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TranscriptionResult result});

  $TranscriptionResultCopyWith<$Res> get result;
}

/// @nodoc
class __$$TranscriptionCompletedImplCopyWithImpl<$Res>
    extends _$TranscriptionStateCopyWithImpl<$Res, _$TranscriptionCompletedImpl>
    implements _$$TranscriptionCompletedImplCopyWith<$Res> {
  __$$TranscriptionCompletedImplCopyWithImpl(
      _$TranscriptionCompletedImpl _value,
      $Res Function(_$TranscriptionCompletedImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
  }) {
    return _then(_$TranscriptionCompletedImpl(
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as TranscriptionResult,
    ));
  }

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TranscriptionResultCopyWith<$Res> get result {
    return $TranscriptionResultCopyWith<$Res>(_value.result, (value) {
      return _then(_value.copyWith(result: value));
    });
  }
}

/// @nodoc

class _$TranscriptionCompletedImpl implements TranscriptionCompleted {
  const _$TranscriptionCompletedImpl({required this.result});

  @override
  final TranscriptionResult result;

  @override
  String toString() {
    return 'TranscriptionState.completed(result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranscriptionCompletedImpl &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result);

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranscriptionCompletedImplCopyWith<_$TranscriptionCompletedImpl>
      get copyWith => __$$TranscriptionCompletedImplCopyWithImpl<
          _$TranscriptionCompletedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration elapsed) recording,
    required TResult Function(double? progress) transcribing,
    required TResult Function(TranscriptionResult result) completed,
    required TResult Function(
            String message, TranscriptionResult? previousResult)
        error,
  }) {
    return completed(result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration elapsed)? recording,
    TResult? Function(double? progress)? transcribing,
    TResult? Function(TranscriptionResult result)? completed,
    TResult? Function(String message, TranscriptionResult? previousResult)?
        error,
  }) {
    return completed?.call(result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration elapsed)? recording,
    TResult Function(double? progress)? transcribing,
    TResult Function(TranscriptionResult result)? completed,
    TResult Function(String message, TranscriptionResult? previousResult)?
        error,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TranscriptionIdle value) idle,
    required TResult Function(TranscriptionRecording value) recording,
    required TResult Function(TranscriptionTranscribing value) transcribing,
    required TResult Function(TranscriptionCompleted value) completed,
    required TResult Function(TranscriptionError value) error,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TranscriptionIdle value)? idle,
    TResult? Function(TranscriptionRecording value)? recording,
    TResult? Function(TranscriptionTranscribing value)? transcribing,
    TResult? Function(TranscriptionCompleted value)? completed,
    TResult? Function(TranscriptionError value)? error,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TranscriptionIdle value)? idle,
    TResult Function(TranscriptionRecording value)? recording,
    TResult Function(TranscriptionTranscribing value)? transcribing,
    TResult Function(TranscriptionCompleted value)? completed,
    TResult Function(TranscriptionError value)? error,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class TranscriptionCompleted implements TranscriptionState {
  const factory TranscriptionCompleted(
          {required final TranscriptionResult result}) =
      _$TranscriptionCompletedImpl;

  TranscriptionResult get result;

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranscriptionCompletedImplCopyWith<_$TranscriptionCompletedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TranscriptionErrorImplCopyWith<$Res> {
  factory _$$TranscriptionErrorImplCopyWith(_$TranscriptionErrorImpl value,
          $Res Function(_$TranscriptionErrorImpl) then) =
      __$$TranscriptionErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, TranscriptionResult? previousResult});

  $TranscriptionResultCopyWith<$Res>? get previousResult;
}

/// @nodoc
class __$$TranscriptionErrorImplCopyWithImpl<$Res>
    extends _$TranscriptionStateCopyWithImpl<$Res, _$TranscriptionErrorImpl>
    implements _$$TranscriptionErrorImplCopyWith<$Res> {
  __$$TranscriptionErrorImplCopyWithImpl(_$TranscriptionErrorImpl _value,
      $Res Function(_$TranscriptionErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? previousResult = freezed,
  }) {
    return _then(_$TranscriptionErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      previousResult: freezed == previousResult
          ? _value.previousResult
          : previousResult // ignore: cast_nullable_to_non_nullable
              as TranscriptionResult?,
    ));
  }

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TranscriptionResultCopyWith<$Res>? get previousResult {
    if (_value.previousResult == null) {
      return null;
    }

    return $TranscriptionResultCopyWith<$Res>(_value.previousResult!, (value) {
      return _then(_value.copyWith(previousResult: value));
    });
  }
}

/// @nodoc

class _$TranscriptionErrorImpl implements TranscriptionError {
  const _$TranscriptionErrorImpl({required this.message, this.previousResult});

  @override
  final String message;

  /// Optional previous result so the user doesn’t lose their last output.
  @override
  final TranscriptionResult? previousResult;

  @override
  String toString() {
    return 'TranscriptionState.error(message: $message, previousResult: $previousResult)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranscriptionErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.previousResult, previousResult) ||
                other.previousResult == previousResult));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, previousResult);

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranscriptionErrorImplCopyWith<_$TranscriptionErrorImpl> get copyWith =>
      __$$TranscriptionErrorImplCopyWithImpl<_$TranscriptionErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration elapsed) recording,
    required TResult Function(double? progress) transcribing,
    required TResult Function(TranscriptionResult result) completed,
    required TResult Function(
            String message, TranscriptionResult? previousResult)
        error,
  }) {
    return error(message, previousResult);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration elapsed)? recording,
    TResult? Function(double? progress)? transcribing,
    TResult? Function(TranscriptionResult result)? completed,
    TResult? Function(String message, TranscriptionResult? previousResult)?
        error,
  }) {
    return error?.call(message, previousResult);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration elapsed)? recording,
    TResult Function(double? progress)? transcribing,
    TResult Function(TranscriptionResult result)? completed,
    TResult Function(String message, TranscriptionResult? previousResult)?
        error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, previousResult);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TranscriptionIdle value) idle,
    required TResult Function(TranscriptionRecording value) recording,
    required TResult Function(TranscriptionTranscribing value) transcribing,
    required TResult Function(TranscriptionCompleted value) completed,
    required TResult Function(TranscriptionError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TranscriptionIdle value)? idle,
    TResult? Function(TranscriptionRecording value)? recording,
    TResult? Function(TranscriptionTranscribing value)? transcribing,
    TResult? Function(TranscriptionCompleted value)? completed,
    TResult? Function(TranscriptionError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TranscriptionIdle value)? idle,
    TResult Function(TranscriptionRecording value)? recording,
    TResult Function(TranscriptionTranscribing value)? transcribing,
    TResult Function(TranscriptionCompleted value)? completed,
    TResult Function(TranscriptionError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class TranscriptionError implements TranscriptionState {
  const factory TranscriptionError(
      {required final String message,
      final TranscriptionResult? previousResult}) = _$TranscriptionErrorImpl;

  String get message;

  /// Optional previous result so the user doesn’t lose their last output.
  TranscriptionResult? get previousResult;

  /// Create a copy of TranscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranscriptionErrorImplCopyWith<_$TranscriptionErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
