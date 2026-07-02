// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lending_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LendingEntity {

 int get id; String get borrowerName; int get totalAmount; int get collectedAmount; bool get isFullyCollected; bool get fromSavings; int get savingsAmount; int get cycleId; String? get notes; DateTime get createdAt;
/// Create a copy of LendingEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LendingEntityCopyWith<LendingEntity> get copyWith => _$LendingEntityCopyWithImpl<LendingEntity>(this as LendingEntity, _$identity);

  /// Serializes this LendingEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LendingEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.collectedAmount, collectedAmount) || other.collectedAmount == collectedAmount)&&(identical(other.isFullyCollected, isFullyCollected) || other.isFullyCollected == isFullyCollected)&&(identical(other.fromSavings, fromSavings) || other.fromSavings == fromSavings)&&(identical(other.savingsAmount, savingsAmount) || other.savingsAmount == savingsAmount)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,borrowerName,totalAmount,collectedAmount,isFullyCollected,fromSavings,savingsAmount,cycleId,notes,createdAt);

@override
String toString() {
  return 'LendingEntity(id: $id, borrowerName: $borrowerName, totalAmount: $totalAmount, collectedAmount: $collectedAmount, isFullyCollected: $isFullyCollected, fromSavings: $fromSavings, savingsAmount: $savingsAmount, cycleId: $cycleId, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LendingEntityCopyWith<$Res>  {
  factory $LendingEntityCopyWith(LendingEntity value, $Res Function(LendingEntity) _then) = _$LendingEntityCopyWithImpl;
@useResult
$Res call({
 int id, String borrowerName, int totalAmount, int collectedAmount, bool isFullyCollected, bool fromSavings, int savingsAmount, int cycleId, String? notes, DateTime createdAt
});




}
/// @nodoc
class _$LendingEntityCopyWithImpl<$Res>
    implements $LendingEntityCopyWith<$Res> {
  _$LendingEntityCopyWithImpl(this._self, this._then);

  final LendingEntity _self;
  final $Res Function(LendingEntity) _then;

/// Create a copy of LendingEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? borrowerName = null,Object? totalAmount = null,Object? collectedAmount = null,Object? isFullyCollected = null,Object? fromSavings = null,Object? savingsAmount = null,Object? cycleId = null,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,collectedAmount: null == collectedAmount ? _self.collectedAmount : collectedAmount // ignore: cast_nullable_to_non_nullable
as int,isFullyCollected: null == isFullyCollected ? _self.isFullyCollected : isFullyCollected // ignore: cast_nullable_to_non_nullable
as bool,fromSavings: null == fromSavings ? _self.fromSavings : fromSavings // ignore: cast_nullable_to_non_nullable
as bool,savingsAmount: null == savingsAmount ? _self.savingsAmount : savingsAmount // ignore: cast_nullable_to_non_nullable
as int,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LendingEntity].
extension LendingEntityPatterns on LendingEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LendingEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LendingEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LendingEntity value)  $default,){
final _that = this;
switch (_that) {
case _LendingEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LendingEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LendingEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String borrowerName,  int totalAmount,  int collectedAmount,  bool isFullyCollected,  bool fromSavings,  int savingsAmount,  int cycleId,  String? notes,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LendingEntity() when $default != null:
return $default(_that.id,_that.borrowerName,_that.totalAmount,_that.collectedAmount,_that.isFullyCollected,_that.fromSavings,_that.savingsAmount,_that.cycleId,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String borrowerName,  int totalAmount,  int collectedAmount,  bool isFullyCollected,  bool fromSavings,  int savingsAmount,  int cycleId,  String? notes,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _LendingEntity():
return $default(_that.id,_that.borrowerName,_that.totalAmount,_that.collectedAmount,_that.isFullyCollected,_that.fromSavings,_that.savingsAmount,_that.cycleId,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String borrowerName,  int totalAmount,  int collectedAmount,  bool isFullyCollected,  bool fromSavings,  int savingsAmount,  int cycleId,  String? notes,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _LendingEntity() when $default != null:
return $default(_that.id,_that.borrowerName,_that.totalAmount,_that.collectedAmount,_that.isFullyCollected,_that.fromSavings,_that.savingsAmount,_that.cycleId,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LendingEntity extends LendingEntity {
  const _LendingEntity({required this.id, required this.borrowerName, required this.totalAmount, this.collectedAmount = 0, this.isFullyCollected = false, this.fromSavings = false, this.savingsAmount = 0, required this.cycleId, this.notes, required this.createdAt}): super._();
  factory _LendingEntity.fromJson(Map<String, dynamic> json) => _$LendingEntityFromJson(json);

@override final  int id;
@override final  String borrowerName;
@override final  int totalAmount;
@override@JsonKey() final  int collectedAmount;
@override@JsonKey() final  bool isFullyCollected;
@override@JsonKey() final  bool fromSavings;
@override@JsonKey() final  int savingsAmount;
@override final  int cycleId;
@override final  String? notes;
@override final  DateTime createdAt;

/// Create a copy of LendingEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LendingEntityCopyWith<_LendingEntity> get copyWith => __$LendingEntityCopyWithImpl<_LendingEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LendingEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LendingEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.collectedAmount, collectedAmount) || other.collectedAmount == collectedAmount)&&(identical(other.isFullyCollected, isFullyCollected) || other.isFullyCollected == isFullyCollected)&&(identical(other.fromSavings, fromSavings) || other.fromSavings == fromSavings)&&(identical(other.savingsAmount, savingsAmount) || other.savingsAmount == savingsAmount)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,borrowerName,totalAmount,collectedAmount,isFullyCollected,fromSavings,savingsAmount,cycleId,notes,createdAt);

@override
String toString() {
  return 'LendingEntity(id: $id, borrowerName: $borrowerName, totalAmount: $totalAmount, collectedAmount: $collectedAmount, isFullyCollected: $isFullyCollected, fromSavings: $fromSavings, savingsAmount: $savingsAmount, cycleId: $cycleId, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LendingEntityCopyWith<$Res> implements $LendingEntityCopyWith<$Res> {
  factory _$LendingEntityCopyWith(_LendingEntity value, $Res Function(_LendingEntity) _then) = __$LendingEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String borrowerName, int totalAmount, int collectedAmount, bool isFullyCollected, bool fromSavings, int savingsAmount, int cycleId, String? notes, DateTime createdAt
});




}
/// @nodoc
class __$LendingEntityCopyWithImpl<$Res>
    implements _$LendingEntityCopyWith<$Res> {
  __$LendingEntityCopyWithImpl(this._self, this._then);

  final _LendingEntity _self;
  final $Res Function(_LendingEntity) _then;

/// Create a copy of LendingEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? borrowerName = null,Object? totalAmount = null,Object? collectedAmount = null,Object? isFullyCollected = null,Object? fromSavings = null,Object? savingsAmount = null,Object? cycleId = null,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_LendingEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,collectedAmount: null == collectedAmount ? _self.collectedAmount : collectedAmount // ignore: cast_nullable_to_non_nullable
as int,isFullyCollected: null == isFullyCollected ? _self.isFullyCollected : isFullyCollected // ignore: cast_nullable_to_non_nullable
as bool,fromSavings: null == fromSavings ? _self.fromSavings : fromSavings // ignore: cast_nullable_to_non_nullable
as bool,savingsAmount: null == savingsAmount ? _self.savingsAmount : savingsAmount // ignore: cast_nullable_to_non_nullable
as int,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
