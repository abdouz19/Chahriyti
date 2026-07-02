// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_challenge_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeeklyChallengeEntity {

 int get id; int get cycleId; DateTime get weekStart; int get targetAmount; String get description; bool get isCompleted; DateTime get createdAt;
/// Create a copy of WeeklyChallengeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyChallengeEntityCopyWith<WeeklyChallengeEntity> get copyWith => _$WeeklyChallengeEntityCopyWithImpl<WeeklyChallengeEntity>(this as WeeklyChallengeEntity, _$identity);

  /// Serializes this WeeklyChallengeEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyChallengeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cycleId,weekStart,targetAmount,description,isCompleted,createdAt);

@override
String toString() {
  return 'WeeklyChallengeEntity(id: $id, cycleId: $cycleId, weekStart: $weekStart, targetAmount: $targetAmount, description: $description, isCompleted: $isCompleted, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WeeklyChallengeEntityCopyWith<$Res>  {
  factory $WeeklyChallengeEntityCopyWith(WeeklyChallengeEntity value, $Res Function(WeeklyChallengeEntity) _then) = _$WeeklyChallengeEntityCopyWithImpl;
@useResult
$Res call({
 int id, int cycleId, DateTime weekStart, int targetAmount, String description, bool isCompleted, DateTime createdAt
});




}
/// @nodoc
class _$WeeklyChallengeEntityCopyWithImpl<$Res>
    implements $WeeklyChallengeEntityCopyWith<$Res> {
  _$WeeklyChallengeEntityCopyWithImpl(this._self, this._then);

  final WeeklyChallengeEntity _self;
  final $Res Function(WeeklyChallengeEntity) _then;

/// Create a copy of WeeklyChallengeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cycleId = null,Object? weekStart = null,Object? targetAmount = null,Object? description = null,Object? isCompleted = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyChallengeEntity].
extension WeeklyChallengeEntityPatterns on WeeklyChallengeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyChallengeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyChallengeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyChallengeEntity value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyChallengeEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyChallengeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyChallengeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int cycleId,  DateTime weekStart,  int targetAmount,  String description,  bool isCompleted,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyChallengeEntity() when $default != null:
return $default(_that.id,_that.cycleId,_that.weekStart,_that.targetAmount,_that.description,_that.isCompleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int cycleId,  DateTime weekStart,  int targetAmount,  String description,  bool isCompleted,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WeeklyChallengeEntity():
return $default(_that.id,_that.cycleId,_that.weekStart,_that.targetAmount,_that.description,_that.isCompleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int cycleId,  DateTime weekStart,  int targetAmount,  String description,  bool isCompleted,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyChallengeEntity() when $default != null:
return $default(_that.id,_that.cycleId,_that.weekStart,_that.targetAmount,_that.description,_that.isCompleted,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklyChallengeEntity extends WeeklyChallengeEntity {
  const _WeeklyChallengeEntity({required this.id, required this.cycleId, required this.weekStart, required this.targetAmount, required this.description, required this.isCompleted, required this.createdAt}): super._();
  factory _WeeklyChallengeEntity.fromJson(Map<String, dynamic> json) => _$WeeklyChallengeEntityFromJson(json);

@override final  int id;
@override final  int cycleId;
@override final  DateTime weekStart;
@override final  int targetAmount;
@override final  String description;
@override final  bool isCompleted;
@override final  DateTime createdAt;

/// Create a copy of WeeklyChallengeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyChallengeEntityCopyWith<_WeeklyChallengeEntity> get copyWith => __$WeeklyChallengeEntityCopyWithImpl<_WeeklyChallengeEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyChallengeEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyChallengeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cycleId,weekStart,targetAmount,description,isCompleted,createdAt);

@override
String toString() {
  return 'WeeklyChallengeEntity(id: $id, cycleId: $cycleId, weekStart: $weekStart, targetAmount: $targetAmount, description: $description, isCompleted: $isCompleted, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WeeklyChallengeEntityCopyWith<$Res> implements $WeeklyChallengeEntityCopyWith<$Res> {
  factory _$WeeklyChallengeEntityCopyWith(_WeeklyChallengeEntity value, $Res Function(_WeeklyChallengeEntity) _then) = __$WeeklyChallengeEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, int cycleId, DateTime weekStart, int targetAmount, String description, bool isCompleted, DateTime createdAt
});




}
/// @nodoc
class __$WeeklyChallengeEntityCopyWithImpl<$Res>
    implements _$WeeklyChallengeEntityCopyWith<$Res> {
  __$WeeklyChallengeEntityCopyWithImpl(this._self, this._then);

  final _WeeklyChallengeEntity _self;
  final $Res Function(_WeeklyChallengeEntity) _then;

/// Create a copy of WeeklyChallengeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cycleId = null,Object? weekStart = null,Object? targetAmount = null,Object? description = null,Object? isCompleted = null,Object? createdAt = null,}) {
  return _then(_WeeklyChallengeEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
