// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scanner_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScannerState {

 bool get isConnected; String get lastBarcode; List<String> get logs;
/// Create a copy of ScannerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScannerStateCopyWith<ScannerState> get copyWith => _$ScannerStateCopyWithImpl<ScannerState>(this as ScannerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScannerState&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.lastBarcode, lastBarcode) || other.lastBarcode == lastBarcode)&&const DeepCollectionEquality().equals(other.logs, logs));
}


@override
int get hashCode => Object.hash(runtimeType,isConnected,lastBarcode,const DeepCollectionEquality().hash(logs));

@override
String toString() {
  return 'ScannerState(isConnected: $isConnected, lastBarcode: $lastBarcode, logs: $logs)';
}


}

/// @nodoc
abstract mixin class $ScannerStateCopyWith<$Res>  {
  factory $ScannerStateCopyWith(ScannerState value, $Res Function(ScannerState) _then) = _$ScannerStateCopyWithImpl;
@useResult
$Res call({
 bool isConnected, String lastBarcode, List<String> logs
});




}
/// @nodoc
class _$ScannerStateCopyWithImpl<$Res>
    implements $ScannerStateCopyWith<$Res> {
  _$ScannerStateCopyWithImpl(this._self, this._then);

  final ScannerState _self;
  final $Res Function(ScannerState) _then;

/// Create a copy of ScannerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isConnected = null,Object? lastBarcode = null,Object? logs = null,}) {
  return _then(_self.copyWith(
isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,lastBarcode: null == lastBarcode ? _self.lastBarcode : lastBarcode // ignore: cast_nullable_to_non_nullable
as String,logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScannerState].
extension ScannerStatePatterns on ScannerState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScannerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScannerState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScannerState value)  $default,){
final _that = this;
switch (_that) {
case _ScannerState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScannerState value)?  $default,){
final _that = this;
switch (_that) {
case _ScannerState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isConnected,  String lastBarcode,  List<String> logs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScannerState() when $default != null:
return $default(_that.isConnected,_that.lastBarcode,_that.logs);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isConnected,  String lastBarcode,  List<String> logs)  $default,) {final _that = this;
switch (_that) {
case _ScannerState():
return $default(_that.isConnected,_that.lastBarcode,_that.logs);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isConnected,  String lastBarcode,  List<String> logs)?  $default,) {final _that = this;
switch (_that) {
case _ScannerState() when $default != null:
return $default(_that.isConnected,_that.lastBarcode,_that.logs);case _:
  return null;

}
}

}

/// @nodoc


class _ScannerState implements ScannerState {
  const _ScannerState({this.isConnected = false, this.lastBarcode = '', final  List<String> logs = const []}): _logs = logs;
  

@override@JsonKey() final  bool isConnected;
@override@JsonKey() final  String lastBarcode;
 final  List<String> _logs;
@override@JsonKey() List<String> get logs {
  if (_logs is EqualUnmodifiableListView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_logs);
}


/// Create a copy of ScannerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScannerStateCopyWith<_ScannerState> get copyWith => __$ScannerStateCopyWithImpl<_ScannerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScannerState&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.lastBarcode, lastBarcode) || other.lastBarcode == lastBarcode)&&const DeepCollectionEquality().equals(other._logs, _logs));
}


@override
int get hashCode => Object.hash(runtimeType,isConnected,lastBarcode,const DeepCollectionEquality().hash(_logs));

@override
String toString() {
  return 'ScannerState(isConnected: $isConnected, lastBarcode: $lastBarcode, logs: $logs)';
}


}

/// @nodoc
abstract mixin class _$ScannerStateCopyWith<$Res> implements $ScannerStateCopyWith<$Res> {
  factory _$ScannerStateCopyWith(_ScannerState value, $Res Function(_ScannerState) _then) = __$ScannerStateCopyWithImpl;
@override @useResult
$Res call({
 bool isConnected, String lastBarcode, List<String> logs
});




}
/// @nodoc
class __$ScannerStateCopyWithImpl<$Res>
    implements _$ScannerStateCopyWith<$Res> {
  __$ScannerStateCopyWithImpl(this._self, this._then);

  final _ScannerState _self;
  final $Res Function(_ScannerState) _then;

/// Create a copy of ScannerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isConnected = null,Object? lastBarcode = null,Object? logs = null,}) {
  return _then(_ScannerState(
isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,lastBarcode: null == lastBarcode ? _self.lastBarcode : lastBarcode // ignore: cast_nullable_to_non_nullable
as String,logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
