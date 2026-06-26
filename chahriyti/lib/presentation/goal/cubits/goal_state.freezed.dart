// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoalState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GoalState()';
}


}

/// @nodoc
class $GoalStateCopyWith<$Res>  {
$GoalStateCopyWith(GoalState _, $Res Function(GoalState) __);
}


/// Adds pattern-matching-related methods to [GoalState].
extension GoalStatePatterns on GoalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GoalInitial value)?  initial,TResult Function( GoalLoading value)?  loading,TResult Function( GoalsLoaded value)?  goalsLoaded,TResult Function( GoalCreated value)?  goalCreated,TResult Function( GoalUpdated value)?  goalUpdated,TResult Function( GoalDeleted value)?  goalDeleted,TResult Function( GoalError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GoalInitial() when initial != null:
return initial(_that);case GoalLoading() when loading != null:
return loading(_that);case GoalsLoaded() when goalsLoaded != null:
return goalsLoaded(_that);case GoalCreated() when goalCreated != null:
return goalCreated(_that);case GoalUpdated() when goalUpdated != null:
return goalUpdated(_that);case GoalDeleted() when goalDeleted != null:
return goalDeleted(_that);case GoalError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GoalInitial value)  initial,required TResult Function( GoalLoading value)  loading,required TResult Function( GoalsLoaded value)  goalsLoaded,required TResult Function( GoalCreated value)  goalCreated,required TResult Function( GoalUpdated value)  goalUpdated,required TResult Function( GoalDeleted value)  goalDeleted,required TResult Function( GoalError value)  error,}){
final _that = this;
switch (_that) {
case GoalInitial():
return initial(_that);case GoalLoading():
return loading(_that);case GoalsLoaded():
return goalsLoaded(_that);case GoalCreated():
return goalCreated(_that);case GoalUpdated():
return goalUpdated(_that);case GoalDeleted():
return goalDeleted(_that);case GoalError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GoalInitial value)?  initial,TResult? Function( GoalLoading value)?  loading,TResult? Function( GoalsLoaded value)?  goalsLoaded,TResult? Function( GoalCreated value)?  goalCreated,TResult? Function( GoalUpdated value)?  goalUpdated,TResult? Function( GoalDeleted value)?  goalDeleted,TResult? Function( GoalError value)?  error,}){
final _that = this;
switch (_that) {
case GoalInitial() when initial != null:
return initial(_that);case GoalLoading() when loading != null:
return loading(_that);case GoalsLoaded() when goalsLoaded != null:
return goalsLoaded(_that);case GoalCreated() when goalCreated != null:
return goalCreated(_that);case GoalUpdated() when goalUpdated != null:
return goalUpdated(_that);case GoalDeleted() when goalDeleted != null:
return goalDeleted(_that);case GoalError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<GoalEntity> goals,  bool hasMore,  int offset)?  goalsLoaded,TResult Function( int goalId)?  goalCreated,TResult Function()?  goalUpdated,TResult Function()?  goalDeleted,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GoalInitial() when initial != null:
return initial();case GoalLoading() when loading != null:
return loading();case GoalsLoaded() when goalsLoaded != null:
return goalsLoaded(_that.goals,_that.hasMore,_that.offset);case GoalCreated() when goalCreated != null:
return goalCreated(_that.goalId);case GoalUpdated() when goalUpdated != null:
return goalUpdated();case GoalDeleted() when goalDeleted != null:
return goalDeleted();case GoalError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<GoalEntity> goals,  bool hasMore,  int offset)  goalsLoaded,required TResult Function( int goalId)  goalCreated,required TResult Function()  goalUpdated,required TResult Function()  goalDeleted,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case GoalInitial():
return initial();case GoalLoading():
return loading();case GoalsLoaded():
return goalsLoaded(_that.goals,_that.hasMore,_that.offset);case GoalCreated():
return goalCreated(_that.goalId);case GoalUpdated():
return goalUpdated();case GoalDeleted():
return goalDeleted();case GoalError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<GoalEntity> goals,  bool hasMore,  int offset)?  goalsLoaded,TResult? Function( int goalId)?  goalCreated,TResult? Function()?  goalUpdated,TResult? Function()?  goalDeleted,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case GoalInitial() when initial != null:
return initial();case GoalLoading() when loading != null:
return loading();case GoalsLoaded() when goalsLoaded != null:
return goalsLoaded(_that.goals,_that.hasMore,_that.offset);case GoalCreated() when goalCreated != null:
return goalCreated(_that.goalId);case GoalUpdated() when goalUpdated != null:
return goalUpdated();case GoalDeleted() when goalDeleted != null:
return goalDeleted();case GoalError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class GoalInitial implements GoalState {
  const GoalInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GoalState.initial()';
}


}




/// @nodoc


class GoalLoading implements GoalState {
  const GoalLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GoalState.loading()';
}


}




/// @nodoc


class GoalsLoaded implements GoalState {
  const GoalsLoaded(final  List<GoalEntity> goals, {this.hasMore = false, this.offset = 0}): _goals = goals;
  

 final  List<GoalEntity> _goals;
 List<GoalEntity> get goals {
  if (_goals is EqualUnmodifiableListView) return _goals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_goals);
}

@JsonKey() final  bool hasMore;
@JsonKey() final  int offset;

/// Create a copy of GoalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalsLoadedCopyWith<GoalsLoaded> get copyWith => _$GoalsLoadedCopyWithImpl<GoalsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalsLoaded&&const DeepCollectionEquality().equals(other._goals, _goals)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_goals),hasMore,offset);

@override
String toString() {
  return 'GoalState.goalsLoaded(goals: $goals, hasMore: $hasMore, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $GoalsLoadedCopyWith<$Res> implements $GoalStateCopyWith<$Res> {
  factory $GoalsLoadedCopyWith(GoalsLoaded value, $Res Function(GoalsLoaded) _then) = _$GoalsLoadedCopyWithImpl;
@useResult
$Res call({
 List<GoalEntity> goals, bool hasMore, int offset
});




}
/// @nodoc
class _$GoalsLoadedCopyWithImpl<$Res>
    implements $GoalsLoadedCopyWith<$Res> {
  _$GoalsLoadedCopyWithImpl(this._self, this._then);

  final GoalsLoaded _self;
  final $Res Function(GoalsLoaded) _then;

/// Create a copy of GoalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? goals = null,Object? hasMore = null,Object? offset = null,}) {
  return _then(GoalsLoaded(
null == goals ? _self._goals : goals // ignore: cast_nullable_to_non_nullable
as List<GoalEntity>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class GoalCreated implements GoalState {
  const GoalCreated(this.goalId);
  

 final  int goalId;

/// Create a copy of GoalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalCreatedCopyWith<GoalCreated> get copyWith => _$GoalCreatedCopyWithImpl<GoalCreated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalCreated&&(identical(other.goalId, goalId) || other.goalId == goalId));
}


@override
int get hashCode => Object.hash(runtimeType,goalId);

@override
String toString() {
  return 'GoalState.goalCreated(goalId: $goalId)';
}


}

/// @nodoc
abstract mixin class $GoalCreatedCopyWith<$Res> implements $GoalStateCopyWith<$Res> {
  factory $GoalCreatedCopyWith(GoalCreated value, $Res Function(GoalCreated) _then) = _$GoalCreatedCopyWithImpl;
@useResult
$Res call({
 int goalId
});




}
/// @nodoc
class _$GoalCreatedCopyWithImpl<$Res>
    implements $GoalCreatedCopyWith<$Res> {
  _$GoalCreatedCopyWithImpl(this._self, this._then);

  final GoalCreated _self;
  final $Res Function(GoalCreated) _then;

/// Create a copy of GoalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? goalId = null,}) {
  return _then(GoalCreated(
null == goalId ? _self.goalId : goalId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class GoalUpdated implements GoalState {
  const GoalUpdated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalUpdated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GoalState.goalUpdated()';
}


}




/// @nodoc


class GoalDeleted implements GoalState {
  const GoalDeleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalDeleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GoalState.goalDeleted()';
}


}




/// @nodoc


class GoalError implements GoalState {
  const GoalError(this.message);
  

 final  String message;

/// Create a copy of GoalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalErrorCopyWith<GoalError> get copyWith => _$GoalErrorCopyWithImpl<GoalError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'GoalState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $GoalErrorCopyWith<$Res> implements $GoalStateCopyWith<$Res> {
  factory $GoalErrorCopyWith(GoalError value, $Res Function(GoalError) _then) = _$GoalErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$GoalErrorCopyWithImpl<$Res>
    implements $GoalErrorCopyWith<$Res> {
  _$GoalErrorCopyWithImpl(this._self, this._then);

  final GoalError _self;
  final $Res Function(GoalError) _then;

/// Create a copy of GoalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(GoalError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
