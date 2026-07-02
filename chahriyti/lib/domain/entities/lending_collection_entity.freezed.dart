// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lending_collection_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LendingCollectionEntity {

 int get id; int get lendingId; int get amount; bool get toSavings; DateTime get createdAt;
/// Create a copy of LendingCollectionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LendingCollectionEntityCopyWith<LendingCollectionEntity> get copyWith => _$LendingCollectionEntityCopyWithImpl<LendingCollectionEntity>(this as LendingCollectionEntity, _$identity);

  /// Serializes this LendingCollectionEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LendingCollectionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.lendingId, lendingId) || other.lendingId == lendingId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.toSavings, toSavings) || other.toSavings == toSavings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lendingId,amount,toSavings,createdAt);

@override
String toString() {
  return 'LendingCollectionEntity(id: $id, lendingId: $lendingId, amount: $amount, toSavings: $toSavings, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LendingCollectionEntityCopyWith<$Res>  {
  factory $LendingCollectionEntityCopyWith(LendingCollectionEntity value, $Res Function(LendingCollectionEntity) _then) = _$LendingCollectionEntityCopyWithImpl;
@useResult
$Res call({
 int id, int lendingId, int amount, bool toSavings, DateTime createdAt
});




}
/// @nodoc
class _$LendingCollectionEntityCopyWithImpl<$Res>
    implements $LendingCollectionEntityCopyWith<$Res> {
  _$LendingCollectionEntityCopyWithImpl(this._self, this._then);

  final LendingCollectionEntity _self;
  final $Res Function(LendingCollectionEntity) _then;

/// Create a copy of LendingCollectionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lendingId = null,Object? amount = null,Object? toSavings = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,lendingId: null == lendingId ? _self.lendingId : lendingId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,toSavings: null == toSavings ? _self.toSavings : toSavings // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LendingCollectionEntity].
extension LendingCollectionEntityPatterns on LendingCollectionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LendingCollectionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LendingCollectionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LendingCollectionEntity value)  $default,){
final _that = this;
switch (_that) {
case _LendingCollectionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LendingCollectionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LendingCollectionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int lendingId,  int amount,  bool toSavings,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LendingCollectionEntity() when $default != null:
return $default(_that.id,_that.lendingId,_that.amount,_that.toSavings,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int lendingId,  int amount,  bool toSavings,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _LendingCollectionEntity():
return $default(_that.id,_that.lendingId,_that.amount,_that.toSavings,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int lendingId,  int amount,  bool toSavings,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _LendingCollectionEntity() when $default != null:
return $default(_that.id,_that.lendingId,_that.amount,_that.toSavings,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LendingCollectionEntity implements LendingCollectionEntity {
  const _LendingCollectionEntity({required this.id, required this.lendingId, required this.amount, this.toSavings = false, required this.createdAt});
  factory _LendingCollectionEntity.fromJson(Map<String, dynamic> json) => _$LendingCollectionEntityFromJson(json);

@override final  int id;
@override final  int lendingId;
@override final  int amount;
@override@JsonKey() final  bool toSavings;
@override final  DateTime createdAt;

/// Create a copy of LendingCollectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LendingCollectionEntityCopyWith<_LendingCollectionEntity> get copyWith => __$LendingCollectionEntityCopyWithImpl<_LendingCollectionEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LendingCollectionEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LendingCollectionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.lendingId, lendingId) || other.lendingId == lendingId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.toSavings, toSavings) || other.toSavings == toSavings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lendingId,amount,toSavings,createdAt);

@override
String toString() {
  return 'LendingCollectionEntity(id: $id, lendingId: $lendingId, amount: $amount, toSavings: $toSavings, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LendingCollectionEntityCopyWith<$Res> implements $LendingCollectionEntityCopyWith<$Res> {
  factory _$LendingCollectionEntityCopyWith(_LendingCollectionEntity value, $Res Function(_LendingCollectionEntity) _then) = __$LendingCollectionEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, int lendingId, int amount, bool toSavings, DateTime createdAt
});




}
/// @nodoc
class __$LendingCollectionEntityCopyWithImpl<$Res>
    implements _$LendingCollectionEntityCopyWith<$Res> {
  __$LendingCollectionEntityCopyWithImpl(this._self, this._then);

  final _LendingCollectionEntity _self;
  final $Res Function(_LendingCollectionEntity) _then;

/// Create a copy of LendingCollectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lendingId = null,Object? amount = null,Object? toSavings = null,Object? createdAt = null,}) {
  return _then(_LendingCollectionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,lendingId: null == lendingId ? _self.lendingId : lendingId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,toSavings: null == toSavings ? _self.toSavings : toSavings // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
