// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_goal_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavingsGoalEntity {

 int get id; String get name; int get targetAmount; int get savedAmount; bool get isAchieved; DateTime get createdAt;
/// Create a copy of SavingsGoalEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingsGoalEntityCopyWith<SavingsGoalEntity> get copyWith => _$SavingsGoalEntityCopyWithImpl<SavingsGoalEntity>(this as SavingsGoalEntity, _$identity);

  /// Serializes this SavingsGoalEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingsGoalEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.savedAmount, savedAmount) || other.savedAmount == savedAmount)&&(identical(other.isAchieved, isAchieved) || other.isAchieved == isAchieved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,targetAmount,savedAmount,isAchieved,createdAt);

@override
String toString() {
  return 'SavingsGoalEntity(id: $id, name: $name, targetAmount: $targetAmount, savedAmount: $savedAmount, isAchieved: $isAchieved, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SavingsGoalEntityCopyWith<$Res>  {
  factory $SavingsGoalEntityCopyWith(SavingsGoalEntity value, $Res Function(SavingsGoalEntity) _then) = _$SavingsGoalEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, int targetAmount, int savedAmount, bool isAchieved, DateTime createdAt
});




}
/// @nodoc
class _$SavingsGoalEntityCopyWithImpl<$Res>
    implements $SavingsGoalEntityCopyWith<$Res> {
  _$SavingsGoalEntityCopyWithImpl(this._self, this._then);

  final SavingsGoalEntity _self;
  final $Res Function(SavingsGoalEntity) _then;

/// Create a copy of SavingsGoalEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? targetAmount = null,Object? savedAmount = null,Object? isAchieved = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int,savedAmount: null == savedAmount ? _self.savedAmount : savedAmount // ignore: cast_nullable_to_non_nullable
as int,isAchieved: null == isAchieved ? _self.isAchieved : isAchieved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingsGoalEntity].
extension SavingsGoalEntityPatterns on SavingsGoalEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingsGoalEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingsGoalEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingsGoalEntity value)  $default,){
final _that = this;
switch (_that) {
case _SavingsGoalEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingsGoalEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SavingsGoalEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int targetAmount,  int savedAmount,  bool isAchieved,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingsGoalEntity() when $default != null:
return $default(_that.id,_that.name,_that.targetAmount,_that.savedAmount,_that.isAchieved,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int targetAmount,  int savedAmount,  bool isAchieved,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SavingsGoalEntity():
return $default(_that.id,_that.name,_that.targetAmount,_that.savedAmount,_that.isAchieved,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int targetAmount,  int savedAmount,  bool isAchieved,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SavingsGoalEntity() when $default != null:
return $default(_that.id,_that.name,_that.targetAmount,_that.savedAmount,_that.isAchieved,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavingsGoalEntity extends SavingsGoalEntity {
  const _SavingsGoalEntity({required this.id, required this.name, required this.targetAmount, required this.savedAmount, required this.isAchieved, required this.createdAt}): super._();
  factory _SavingsGoalEntity.fromJson(Map<String, dynamic> json) => _$SavingsGoalEntityFromJson(json);

@override final  int id;
@override final  String name;
@override final  int targetAmount;
@override final  int savedAmount;
@override final  bool isAchieved;
@override final  DateTime createdAt;

/// Create a copy of SavingsGoalEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingsGoalEntityCopyWith<_SavingsGoalEntity> get copyWith => __$SavingsGoalEntityCopyWithImpl<_SavingsGoalEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavingsGoalEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingsGoalEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.savedAmount, savedAmount) || other.savedAmount == savedAmount)&&(identical(other.isAchieved, isAchieved) || other.isAchieved == isAchieved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,targetAmount,savedAmount,isAchieved,createdAt);

@override
String toString() {
  return 'SavingsGoalEntity(id: $id, name: $name, targetAmount: $targetAmount, savedAmount: $savedAmount, isAchieved: $isAchieved, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SavingsGoalEntityCopyWith<$Res> implements $SavingsGoalEntityCopyWith<$Res> {
  factory _$SavingsGoalEntityCopyWith(_SavingsGoalEntity value, $Res Function(_SavingsGoalEntity) _then) = __$SavingsGoalEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int targetAmount, int savedAmount, bool isAchieved, DateTime createdAt
});




}
/// @nodoc
class __$SavingsGoalEntityCopyWithImpl<$Res>
    implements _$SavingsGoalEntityCopyWith<$Res> {
  __$SavingsGoalEntityCopyWithImpl(this._self, this._then);

  final _SavingsGoalEntity _self;
  final $Res Function(_SavingsGoalEntity) _then;

/// Create a copy of SavingsGoalEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? targetAmount = null,Object? savedAmount = null,Object? isAchieved = null,Object? createdAt = null,}) {
  return _then(_SavingsGoalEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int,savedAmount: null == savedAmount ? _self.savedAmount : savedAmount // ignore: cast_nullable_to_non_nullable
as int,isAchieved: null == isAchieved ? _self.isAchieved : isAchieved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
