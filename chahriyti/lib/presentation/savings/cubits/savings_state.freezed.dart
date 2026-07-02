// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavingsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SavingsState()';
}


}

/// @nodoc
class $SavingsStateCopyWith<$Res>  {
$SavingsStateCopyWith(SavingsState _, $Res Function(SavingsState) __);
}


/// Adds pattern-matching-related methods to [SavingsState].
extension SavingsStatePatterns on SavingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SavingsLoading value)?  loading,TResult Function( SavingsLoaded value)?  loaded,TResult Function( SavingsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SavingsLoading() when loading != null:
return loading(_that);case SavingsLoaded() when loaded != null:
return loaded(_that);case SavingsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SavingsLoading value)  loading,required TResult Function( SavingsLoaded value)  loaded,required TResult Function( SavingsError value)  error,}){
final _that = this;
switch (_that) {
case SavingsLoading():
return loading(_that);case SavingsLoaded():
return loaded(_that);case SavingsError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SavingsLoading value)?  loading,TResult? Function( SavingsLoaded value)?  loaded,TResult? Function( SavingsError value)?  error,}){
final _that = this;
switch (_that) {
case SavingsLoading() when loading != null:
return loading(_that);case SavingsLoaded() when loaded != null:
return loaded(_that);case SavingsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( int balance,  List<SavingsHistoryEntity> history,  bool hasMore,  int offset)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SavingsLoading() when loading != null:
return loading();case SavingsLoaded() when loaded != null:
return loaded(_that.balance,_that.history,_that.hasMore,_that.offset);case SavingsError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( int balance,  List<SavingsHistoryEntity> history,  bool hasMore,  int offset)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case SavingsLoading():
return loading();case SavingsLoaded():
return loaded(_that.balance,_that.history,_that.hasMore,_that.offset);case SavingsError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( int balance,  List<SavingsHistoryEntity> history,  bool hasMore,  int offset)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case SavingsLoading() when loading != null:
return loading();case SavingsLoaded() when loaded != null:
return loaded(_that.balance,_that.history,_that.hasMore,_that.offset);case SavingsError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SavingsLoading implements SavingsState {
  const SavingsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SavingsState.loading()';
}


}




/// @nodoc


class SavingsLoaded implements SavingsState {
  const SavingsLoaded({required this.balance, required final  List<SavingsHistoryEntity> history, this.hasMore = false, this.offset = 0}): _history = history;
  

 final  int balance;
 final  List<SavingsHistoryEntity> _history;
 List<SavingsHistoryEntity> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

@JsonKey() final  bool hasMore;
@JsonKey() final  int offset;

/// Create a copy of SavingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingsLoadedCopyWith<SavingsLoaded> get copyWith => _$SavingsLoadedCopyWithImpl<SavingsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingsLoaded&&(identical(other.balance, balance) || other.balance == balance)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode => Object.hash(runtimeType,balance,const DeepCollectionEquality().hash(_history),hasMore,offset);

@override
String toString() {
  return 'SavingsState.loaded(balance: $balance, history: $history, hasMore: $hasMore, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $SavingsLoadedCopyWith<$Res> implements $SavingsStateCopyWith<$Res> {
  factory $SavingsLoadedCopyWith(SavingsLoaded value, $Res Function(SavingsLoaded) _then) = _$SavingsLoadedCopyWithImpl;
@useResult
$Res call({
 int balance, List<SavingsHistoryEntity> history, bool hasMore, int offset
});




}
/// @nodoc
class _$SavingsLoadedCopyWithImpl<$Res>
    implements $SavingsLoadedCopyWith<$Res> {
  _$SavingsLoadedCopyWithImpl(this._self, this._then);

  final SavingsLoaded _self;
  final $Res Function(SavingsLoaded) _then;

/// Create a copy of SavingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? balance = null,Object? history = null,Object? hasMore = null,Object? offset = null,}) {
  return _then(SavingsLoaded(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<SavingsHistoryEntity>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SavingsError implements SavingsState {
  const SavingsError(this.message);
  

 final  String message;

/// Create a copy of SavingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingsErrorCopyWith<SavingsError> get copyWith => _$SavingsErrorCopyWithImpl<SavingsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingsError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SavingsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $SavingsErrorCopyWith<$Res> implements $SavingsStateCopyWith<$Res> {
  factory $SavingsErrorCopyWith(SavingsError value, $Res Function(SavingsError) _then) = _$SavingsErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SavingsErrorCopyWithImpl<$Res>
    implements $SavingsErrorCopyWith<$Res> {
  _$SavingsErrorCopyWithImpl(this._self, this._then);

  final SavingsError _self;
  final $Res Function(SavingsError) _then;

/// Create a copy of SavingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SavingsError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
