// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'additional_income_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdditionalIncomeEntity {

 int get id; int get cycleId; String get description; int get amount; DateTime get createdAt;
/// Create a copy of AdditionalIncomeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdditionalIncomeEntityCopyWith<AdditionalIncomeEntity> get copyWith => _$AdditionalIncomeEntityCopyWithImpl<AdditionalIncomeEntity>(this as AdditionalIncomeEntity, _$identity);

  /// Serializes this AdditionalIncomeEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdditionalIncomeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cycleId,description,amount,createdAt);

@override
String toString() {
  return 'AdditionalIncomeEntity(id: $id, cycleId: $cycleId, description: $description, amount: $amount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AdditionalIncomeEntityCopyWith<$Res>  {
  factory $AdditionalIncomeEntityCopyWith(AdditionalIncomeEntity value, $Res Function(AdditionalIncomeEntity) _then) = _$AdditionalIncomeEntityCopyWithImpl;
@useResult
$Res call({
 int id, int cycleId, String description, int amount, DateTime createdAt
});




}
/// @nodoc
class _$AdditionalIncomeEntityCopyWithImpl<$Res>
    implements $AdditionalIncomeEntityCopyWith<$Res> {
  _$AdditionalIncomeEntityCopyWithImpl(this._self, this._then);

  final AdditionalIncomeEntity _self;
  final $Res Function(AdditionalIncomeEntity) _then;

/// Create a copy of AdditionalIncomeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cycleId = null,Object? description = null,Object? amount = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AdditionalIncomeEntity].
extension AdditionalIncomeEntityPatterns on AdditionalIncomeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdditionalIncomeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdditionalIncomeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdditionalIncomeEntity value)  $default,){
final _that = this;
switch (_that) {
case _AdditionalIncomeEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdditionalIncomeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AdditionalIncomeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int cycleId,  String description,  int amount,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdditionalIncomeEntity() when $default != null:
return $default(_that.id,_that.cycleId,_that.description,_that.amount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int cycleId,  String description,  int amount,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AdditionalIncomeEntity():
return $default(_that.id,_that.cycleId,_that.description,_that.amount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int cycleId,  String description,  int amount,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AdditionalIncomeEntity() when $default != null:
return $default(_that.id,_that.cycleId,_that.description,_that.amount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdditionalIncomeEntity extends AdditionalIncomeEntity {
  const _AdditionalIncomeEntity({required this.id, required this.cycleId, required this.description, required this.amount, required this.createdAt}): super._();
  factory _AdditionalIncomeEntity.fromJson(Map<String, dynamic> json) => _$AdditionalIncomeEntityFromJson(json);

@override final  int id;
@override final  int cycleId;
@override final  String description;
@override final  int amount;
@override final  DateTime createdAt;

/// Create a copy of AdditionalIncomeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdditionalIncomeEntityCopyWith<_AdditionalIncomeEntity> get copyWith => __$AdditionalIncomeEntityCopyWithImpl<_AdditionalIncomeEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdditionalIncomeEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdditionalIncomeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cycleId,description,amount,createdAt);

@override
String toString() {
  return 'AdditionalIncomeEntity(id: $id, cycleId: $cycleId, description: $description, amount: $amount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AdditionalIncomeEntityCopyWith<$Res> implements $AdditionalIncomeEntityCopyWith<$Res> {
  factory _$AdditionalIncomeEntityCopyWith(_AdditionalIncomeEntity value, $Res Function(_AdditionalIncomeEntity) _then) = __$AdditionalIncomeEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, int cycleId, String description, int amount, DateTime createdAt
});




}
/// @nodoc
class __$AdditionalIncomeEntityCopyWithImpl<$Res>
    implements _$AdditionalIncomeEntityCopyWith<$Res> {
  __$AdditionalIncomeEntityCopyWithImpl(this._self, this._then);

  final _AdditionalIncomeEntity _self;
  final $Res Function(_AdditionalIncomeEntity) _then;

/// Create a copy of AdditionalIncomeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cycleId = null,Object? description = null,Object? amount = null,Object? createdAt = null,}) {
  return _then(_AdditionalIncomeEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
