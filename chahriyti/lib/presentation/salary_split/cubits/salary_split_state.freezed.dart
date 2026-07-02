// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salary_split_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SalarySplitState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalarySplitState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SalarySplitState()';
}


}

/// @nodoc
class $SalarySplitStateCopyWith<$Res>  {
$SalarySplitStateCopyWith(SalarySplitState _, $Res Function(SalarySplitState) __);
}


/// Adds pattern-matching-related methods to [SalarySplitState].
extension SalarySplitStatePatterns on SalarySplitState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SalarySplitInitial value)?  initial,TResult Function( SalarySplitEditing value)?  editing,TResult Function( SalarySplitConfirming value)?  confirming,TResult Function( SalarySplitComplete value)?  complete,TResult Function( SalarySplitError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SalarySplitInitial() when initial != null:
return initial(_that);case SalarySplitEditing() when editing != null:
return editing(_that);case SalarySplitConfirming() when confirming != null:
return confirming(_that);case SalarySplitComplete() when complete != null:
return complete(_that);case SalarySplitError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SalarySplitInitial value)  initial,required TResult Function( SalarySplitEditing value)  editing,required TResult Function( SalarySplitConfirming value)  confirming,required TResult Function( SalarySplitComplete value)  complete,required TResult Function( SalarySplitError value)  error,}){
final _that = this;
switch (_that) {
case SalarySplitInitial():
return initial(_that);case SalarySplitEditing():
return editing(_that);case SalarySplitConfirming():
return confirming(_that);case SalarySplitComplete():
return complete(_that);case SalarySplitError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SalarySplitInitial value)?  initial,TResult? Function( SalarySplitEditing value)?  editing,TResult? Function( SalarySplitConfirming value)?  confirming,TResult? Function( SalarySplitComplete value)?  complete,TResult? Function( SalarySplitError value)?  error,}){
final _that = this;
switch (_that) {
case SalarySplitInitial() when initial != null:
return initial(_that);case SalarySplitEditing() when editing != null:
return editing(_that);case SalarySplitConfirming() when confirming != null:
return confirming(_that);case SalarySplitComplete() when complete != null:
return complete(_that);case SalarySplitError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int salaryAmount)?  initial,TResult Function( int salaryAmount,  int allocationAmount,  int remainingBalance)?  editing,TResult Function()?  confirming,TResult Function()?  complete,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SalarySplitInitial() when initial != null:
return initial(_that.salaryAmount);case SalarySplitEditing() when editing != null:
return editing(_that.salaryAmount,_that.allocationAmount,_that.remainingBalance);case SalarySplitConfirming() when confirming != null:
return confirming();case SalarySplitComplete() when complete != null:
return complete();case SalarySplitError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int salaryAmount)  initial,required TResult Function( int salaryAmount,  int allocationAmount,  int remainingBalance)  editing,required TResult Function()  confirming,required TResult Function()  complete,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case SalarySplitInitial():
return initial(_that.salaryAmount);case SalarySplitEditing():
return editing(_that.salaryAmount,_that.allocationAmount,_that.remainingBalance);case SalarySplitConfirming():
return confirming();case SalarySplitComplete():
return complete();case SalarySplitError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int salaryAmount)?  initial,TResult? Function( int salaryAmount,  int allocationAmount,  int remainingBalance)?  editing,TResult? Function()?  confirming,TResult? Function()?  complete,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case SalarySplitInitial() when initial != null:
return initial(_that.salaryAmount);case SalarySplitEditing() when editing != null:
return editing(_that.salaryAmount,_that.allocationAmount,_that.remainingBalance);case SalarySplitConfirming() when confirming != null:
return confirming();case SalarySplitComplete() when complete != null:
return complete();case SalarySplitError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SalarySplitInitial implements SalarySplitState {
  const SalarySplitInitial({required this.salaryAmount});
  

 final  int salaryAmount;

/// Create a copy of SalarySplitState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalarySplitInitialCopyWith<SalarySplitInitial> get copyWith => _$SalarySplitInitialCopyWithImpl<SalarySplitInitial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalarySplitInitial&&(identical(other.salaryAmount, salaryAmount) || other.salaryAmount == salaryAmount));
}


@override
int get hashCode => Object.hash(runtimeType,salaryAmount);

@override
String toString() {
  return 'SalarySplitState.initial(salaryAmount: $salaryAmount)';
}


}

/// @nodoc
abstract mixin class $SalarySplitInitialCopyWith<$Res> implements $SalarySplitStateCopyWith<$Res> {
  factory $SalarySplitInitialCopyWith(SalarySplitInitial value, $Res Function(SalarySplitInitial) _then) = _$SalarySplitInitialCopyWithImpl;
@useResult
$Res call({
 int salaryAmount
});




}
/// @nodoc
class _$SalarySplitInitialCopyWithImpl<$Res>
    implements $SalarySplitInitialCopyWith<$Res> {
  _$SalarySplitInitialCopyWithImpl(this._self, this._then);

  final SalarySplitInitial _self;
  final $Res Function(SalarySplitInitial) _then;

/// Create a copy of SalarySplitState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? salaryAmount = null,}) {
  return _then(SalarySplitInitial(
salaryAmount: null == salaryAmount ? _self.salaryAmount : salaryAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SalarySplitEditing implements SalarySplitState {
  const SalarySplitEditing({required this.salaryAmount, required this.allocationAmount, required this.remainingBalance});
  

 final  int salaryAmount;
 final  int allocationAmount;
 final  int remainingBalance;

/// Create a copy of SalarySplitState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalarySplitEditingCopyWith<SalarySplitEditing> get copyWith => _$SalarySplitEditingCopyWithImpl<SalarySplitEditing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalarySplitEditing&&(identical(other.salaryAmount, salaryAmount) || other.salaryAmount == salaryAmount)&&(identical(other.allocationAmount, allocationAmount) || other.allocationAmount == allocationAmount)&&(identical(other.remainingBalance, remainingBalance) || other.remainingBalance == remainingBalance));
}


@override
int get hashCode => Object.hash(runtimeType,salaryAmount,allocationAmount,remainingBalance);

@override
String toString() {
  return 'SalarySplitState.editing(salaryAmount: $salaryAmount, allocationAmount: $allocationAmount, remainingBalance: $remainingBalance)';
}


}

/// @nodoc
abstract mixin class $SalarySplitEditingCopyWith<$Res> implements $SalarySplitStateCopyWith<$Res> {
  factory $SalarySplitEditingCopyWith(SalarySplitEditing value, $Res Function(SalarySplitEditing) _then) = _$SalarySplitEditingCopyWithImpl;
@useResult
$Res call({
 int salaryAmount, int allocationAmount, int remainingBalance
});




}
/// @nodoc
class _$SalarySplitEditingCopyWithImpl<$Res>
    implements $SalarySplitEditingCopyWith<$Res> {
  _$SalarySplitEditingCopyWithImpl(this._self, this._then);

  final SalarySplitEditing _self;
  final $Res Function(SalarySplitEditing) _then;

/// Create a copy of SalarySplitState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? salaryAmount = null,Object? allocationAmount = null,Object? remainingBalance = null,}) {
  return _then(SalarySplitEditing(
salaryAmount: null == salaryAmount ? _self.salaryAmount : salaryAmount // ignore: cast_nullable_to_non_nullable
as int,allocationAmount: null == allocationAmount ? _self.allocationAmount : allocationAmount // ignore: cast_nullable_to_non_nullable
as int,remainingBalance: null == remainingBalance ? _self.remainingBalance : remainingBalance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SalarySplitConfirming implements SalarySplitState {
  const SalarySplitConfirming();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalarySplitConfirming);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SalarySplitState.confirming()';
}


}




/// @nodoc


class SalarySplitComplete implements SalarySplitState {
  const SalarySplitComplete();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalarySplitComplete);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SalarySplitState.complete()';
}


}




/// @nodoc


class SalarySplitError implements SalarySplitState {
  const SalarySplitError(this.message);
  

 final  String message;

/// Create a copy of SalarySplitState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalarySplitErrorCopyWith<SalarySplitError> get copyWith => _$SalarySplitErrorCopyWithImpl<SalarySplitError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalarySplitError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SalarySplitState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $SalarySplitErrorCopyWith<$Res> implements $SalarySplitStateCopyWith<$Res> {
  factory $SalarySplitErrorCopyWith(SalarySplitError value, $Res Function(SalarySplitError) _then) = _$SalarySplitErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SalarySplitErrorCopyWithImpl<$Res>
    implements $SalarySplitErrorCopyWith<$Res> {
  _$SalarySplitErrorCopyWithImpl(this._self, this._then);

  final SalarySplitError _self;
  final $Res Function(SalarySplitError) _then;

/// Create a copy of SalarySplitState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SalarySplitError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
