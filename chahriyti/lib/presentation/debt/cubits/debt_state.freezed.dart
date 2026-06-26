// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DebtState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DebtState()';
}


}

/// @nodoc
class $DebtStateCopyWith<$Res>  {
$DebtStateCopyWith(DebtState _, $Res Function(DebtState) __);
}


/// Adds pattern-matching-related methods to [DebtState].
extension DebtStatePatterns on DebtState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DebtInitial value)?  initial,TResult Function( DebtLoading value)?  loading,TResult Function( DebtsLoaded value)?  debtsLoaded,TResult Function( DebtCreated value)?  debtCreated,TResult Function( DebtUpdated value)?  debtUpdated,TResult Function( DebtDeleted value)?  debtDeleted,TResult Function( PaymentAdded value)?  paymentAdded,TResult Function( DebtError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DebtInitial() when initial != null:
return initial(_that);case DebtLoading() when loading != null:
return loading(_that);case DebtsLoaded() when debtsLoaded != null:
return debtsLoaded(_that);case DebtCreated() when debtCreated != null:
return debtCreated(_that);case DebtUpdated() when debtUpdated != null:
return debtUpdated(_that);case DebtDeleted() when debtDeleted != null:
return debtDeleted(_that);case PaymentAdded() when paymentAdded != null:
return paymentAdded(_that);case DebtError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DebtInitial value)  initial,required TResult Function( DebtLoading value)  loading,required TResult Function( DebtsLoaded value)  debtsLoaded,required TResult Function( DebtCreated value)  debtCreated,required TResult Function( DebtUpdated value)  debtUpdated,required TResult Function( DebtDeleted value)  debtDeleted,required TResult Function( PaymentAdded value)  paymentAdded,required TResult Function( DebtError value)  error,}){
final _that = this;
switch (_that) {
case DebtInitial():
return initial(_that);case DebtLoading():
return loading(_that);case DebtsLoaded():
return debtsLoaded(_that);case DebtCreated():
return debtCreated(_that);case DebtUpdated():
return debtUpdated(_that);case DebtDeleted():
return debtDeleted(_that);case PaymentAdded():
return paymentAdded(_that);case DebtError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DebtInitial value)?  initial,TResult? Function( DebtLoading value)?  loading,TResult? Function( DebtsLoaded value)?  debtsLoaded,TResult? Function( DebtCreated value)?  debtCreated,TResult? Function( DebtUpdated value)?  debtUpdated,TResult? Function( DebtDeleted value)?  debtDeleted,TResult? Function( PaymentAdded value)?  paymentAdded,TResult? Function( DebtError value)?  error,}){
final _that = this;
switch (_that) {
case DebtInitial() when initial != null:
return initial(_that);case DebtLoading() when loading != null:
return loading(_that);case DebtsLoaded() when debtsLoaded != null:
return debtsLoaded(_that);case DebtCreated() when debtCreated != null:
return debtCreated(_that);case DebtUpdated() when debtUpdated != null:
return debtUpdated(_that);case DebtDeleted() when debtDeleted != null:
return debtDeleted(_that);case PaymentAdded() when paymentAdded != null:
return paymentAdded(_that);case DebtError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<DebtEntity> debts,  bool hasMore,  int offset)?  debtsLoaded,TResult Function( int debtId)?  debtCreated,TResult Function()?  debtUpdated,TResult Function()?  debtDeleted,TResult Function()?  paymentAdded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DebtInitial() when initial != null:
return initial();case DebtLoading() when loading != null:
return loading();case DebtsLoaded() when debtsLoaded != null:
return debtsLoaded(_that.debts,_that.hasMore,_that.offset);case DebtCreated() when debtCreated != null:
return debtCreated(_that.debtId);case DebtUpdated() when debtUpdated != null:
return debtUpdated();case DebtDeleted() when debtDeleted != null:
return debtDeleted();case PaymentAdded() when paymentAdded != null:
return paymentAdded();case DebtError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<DebtEntity> debts,  bool hasMore,  int offset)  debtsLoaded,required TResult Function( int debtId)  debtCreated,required TResult Function()  debtUpdated,required TResult Function()  debtDeleted,required TResult Function()  paymentAdded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case DebtInitial():
return initial();case DebtLoading():
return loading();case DebtsLoaded():
return debtsLoaded(_that.debts,_that.hasMore,_that.offset);case DebtCreated():
return debtCreated(_that.debtId);case DebtUpdated():
return debtUpdated();case DebtDeleted():
return debtDeleted();case PaymentAdded():
return paymentAdded();case DebtError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<DebtEntity> debts,  bool hasMore,  int offset)?  debtsLoaded,TResult? Function( int debtId)?  debtCreated,TResult? Function()?  debtUpdated,TResult? Function()?  debtDeleted,TResult? Function()?  paymentAdded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case DebtInitial() when initial != null:
return initial();case DebtLoading() when loading != null:
return loading();case DebtsLoaded() when debtsLoaded != null:
return debtsLoaded(_that.debts,_that.hasMore,_that.offset);case DebtCreated() when debtCreated != null:
return debtCreated(_that.debtId);case DebtUpdated() when debtUpdated != null:
return debtUpdated();case DebtDeleted() when debtDeleted != null:
return debtDeleted();case PaymentAdded() when paymentAdded != null:
return paymentAdded();case DebtError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class DebtInitial implements DebtState {
  const DebtInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DebtState.initial()';
}


}




/// @nodoc


class DebtLoading implements DebtState {
  const DebtLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DebtState.loading()';
}


}




/// @nodoc


class DebtsLoaded implements DebtState {
  const DebtsLoaded(final  List<DebtEntity> debts, {this.hasMore = false, this.offset = 0}): _debts = debts;
  

 final  List<DebtEntity> _debts;
 List<DebtEntity> get debts {
  if (_debts is EqualUnmodifiableListView) return _debts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_debts);
}

@JsonKey() final  bool hasMore;
@JsonKey() final  int offset;

/// Create a copy of DebtState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtsLoadedCopyWith<DebtsLoaded> get copyWith => _$DebtsLoadedCopyWithImpl<DebtsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtsLoaded&&const DeepCollectionEquality().equals(other._debts, _debts)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_debts),hasMore,offset);

@override
String toString() {
  return 'DebtState.debtsLoaded(debts: $debts, hasMore: $hasMore, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $DebtsLoadedCopyWith<$Res> implements $DebtStateCopyWith<$Res> {
  factory $DebtsLoadedCopyWith(DebtsLoaded value, $Res Function(DebtsLoaded) _then) = _$DebtsLoadedCopyWithImpl;
@useResult
$Res call({
 List<DebtEntity> debts, bool hasMore, int offset
});




}
/// @nodoc
class _$DebtsLoadedCopyWithImpl<$Res>
    implements $DebtsLoadedCopyWith<$Res> {
  _$DebtsLoadedCopyWithImpl(this._self, this._then);

  final DebtsLoaded _self;
  final $Res Function(DebtsLoaded) _then;

/// Create a copy of DebtState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? debts = null,Object? hasMore = null,Object? offset = null,}) {
  return _then(DebtsLoaded(
null == debts ? _self._debts : debts // ignore: cast_nullable_to_non_nullable
as List<DebtEntity>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class DebtCreated implements DebtState {
  const DebtCreated(this.debtId);
  

 final  int debtId;

/// Create a copy of DebtState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtCreatedCopyWith<DebtCreated> get copyWith => _$DebtCreatedCopyWithImpl<DebtCreated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtCreated&&(identical(other.debtId, debtId) || other.debtId == debtId));
}


@override
int get hashCode => Object.hash(runtimeType,debtId);

@override
String toString() {
  return 'DebtState.debtCreated(debtId: $debtId)';
}


}

/// @nodoc
abstract mixin class $DebtCreatedCopyWith<$Res> implements $DebtStateCopyWith<$Res> {
  factory $DebtCreatedCopyWith(DebtCreated value, $Res Function(DebtCreated) _then) = _$DebtCreatedCopyWithImpl;
@useResult
$Res call({
 int debtId
});




}
/// @nodoc
class _$DebtCreatedCopyWithImpl<$Res>
    implements $DebtCreatedCopyWith<$Res> {
  _$DebtCreatedCopyWithImpl(this._self, this._then);

  final DebtCreated _self;
  final $Res Function(DebtCreated) _then;

/// Create a copy of DebtState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? debtId = null,}) {
  return _then(DebtCreated(
null == debtId ? _self.debtId : debtId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class DebtUpdated implements DebtState {
  const DebtUpdated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtUpdated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DebtState.debtUpdated()';
}


}




/// @nodoc


class DebtDeleted implements DebtState {
  const DebtDeleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtDeleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DebtState.debtDeleted()';
}


}




/// @nodoc


class PaymentAdded implements DebtState {
  const PaymentAdded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentAdded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DebtState.paymentAdded()';
}


}




/// @nodoc


class DebtError implements DebtState {
  const DebtError(this.message);
  

 final  String message;

/// Create a copy of DebtState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtErrorCopyWith<DebtError> get copyWith => _$DebtErrorCopyWithImpl<DebtError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DebtState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $DebtErrorCopyWith<$Res> implements $DebtStateCopyWith<$Res> {
  factory $DebtErrorCopyWith(DebtError value, $Res Function(DebtError) _then) = _$DebtErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DebtErrorCopyWithImpl<$Res>
    implements $DebtErrorCopyWith<$Res> {
  _$DebtErrorCopyWithImpl(this._self, this._then);

  final DebtError _self;
  final $Res Function(DebtError) _then;

/// Create a copy of DebtState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DebtError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
