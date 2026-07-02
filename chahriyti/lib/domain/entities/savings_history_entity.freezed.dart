// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_history_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavingsHistoryEntity {

 int get id; SavingsTransactionType get type; int get amount; String get description; int? get relatedCycleId; int? get relatedExpenseId; int? get relatedDebtPaymentId; int? get relatedLendingId; DateTime get createdAt;
/// Create a copy of SavingsHistoryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingsHistoryEntityCopyWith<SavingsHistoryEntity> get copyWith => _$SavingsHistoryEntityCopyWithImpl<SavingsHistoryEntity>(this as SavingsHistoryEntity, _$identity);

  /// Serializes this SavingsHistoryEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingsHistoryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.relatedCycleId, relatedCycleId) || other.relatedCycleId == relatedCycleId)&&(identical(other.relatedExpenseId, relatedExpenseId) || other.relatedExpenseId == relatedExpenseId)&&(identical(other.relatedDebtPaymentId, relatedDebtPaymentId) || other.relatedDebtPaymentId == relatedDebtPaymentId)&&(identical(other.relatedLendingId, relatedLendingId) || other.relatedLendingId == relatedLendingId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,amount,description,relatedCycleId,relatedExpenseId,relatedDebtPaymentId,relatedLendingId,createdAt);

@override
String toString() {
  return 'SavingsHistoryEntity(id: $id, type: $type, amount: $amount, description: $description, relatedCycleId: $relatedCycleId, relatedExpenseId: $relatedExpenseId, relatedDebtPaymentId: $relatedDebtPaymentId, relatedLendingId: $relatedLendingId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SavingsHistoryEntityCopyWith<$Res>  {
  factory $SavingsHistoryEntityCopyWith(SavingsHistoryEntity value, $Res Function(SavingsHistoryEntity) _then) = _$SavingsHistoryEntityCopyWithImpl;
@useResult
$Res call({
 int id, SavingsTransactionType type, int amount, String description, int? relatedCycleId, int? relatedExpenseId, int? relatedDebtPaymentId, int? relatedLendingId, DateTime createdAt
});




}
/// @nodoc
class _$SavingsHistoryEntityCopyWithImpl<$Res>
    implements $SavingsHistoryEntityCopyWith<$Res> {
  _$SavingsHistoryEntityCopyWithImpl(this._self, this._then);

  final SavingsHistoryEntity _self;
  final $Res Function(SavingsHistoryEntity) _then;

/// Create a copy of SavingsHistoryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? description = null,Object? relatedCycleId = freezed,Object? relatedExpenseId = freezed,Object? relatedDebtPaymentId = freezed,Object? relatedLendingId = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SavingsTransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,relatedCycleId: freezed == relatedCycleId ? _self.relatedCycleId : relatedCycleId // ignore: cast_nullable_to_non_nullable
as int?,relatedExpenseId: freezed == relatedExpenseId ? _self.relatedExpenseId : relatedExpenseId // ignore: cast_nullable_to_non_nullable
as int?,relatedDebtPaymentId: freezed == relatedDebtPaymentId ? _self.relatedDebtPaymentId : relatedDebtPaymentId // ignore: cast_nullable_to_non_nullable
as int?,relatedLendingId: freezed == relatedLendingId ? _self.relatedLendingId : relatedLendingId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingsHistoryEntity].
extension SavingsHistoryEntityPatterns on SavingsHistoryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingsHistoryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingsHistoryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingsHistoryEntity value)  $default,){
final _that = this;
switch (_that) {
case _SavingsHistoryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingsHistoryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SavingsHistoryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  SavingsTransactionType type,  int amount,  String description,  int? relatedCycleId,  int? relatedExpenseId,  int? relatedDebtPaymentId,  int? relatedLendingId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingsHistoryEntity() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.description,_that.relatedCycleId,_that.relatedExpenseId,_that.relatedDebtPaymentId,_that.relatedLendingId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  SavingsTransactionType type,  int amount,  String description,  int? relatedCycleId,  int? relatedExpenseId,  int? relatedDebtPaymentId,  int? relatedLendingId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SavingsHistoryEntity():
return $default(_that.id,_that.type,_that.amount,_that.description,_that.relatedCycleId,_that.relatedExpenseId,_that.relatedDebtPaymentId,_that.relatedLendingId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  SavingsTransactionType type,  int amount,  String description,  int? relatedCycleId,  int? relatedExpenseId,  int? relatedDebtPaymentId,  int? relatedLendingId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SavingsHistoryEntity() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.description,_that.relatedCycleId,_that.relatedExpenseId,_that.relatedDebtPaymentId,_that.relatedLendingId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavingsHistoryEntity implements SavingsHistoryEntity {
  const _SavingsHistoryEntity({required this.id, required this.type, required this.amount, required this.description, this.relatedCycleId, this.relatedExpenseId, this.relatedDebtPaymentId, this.relatedLendingId, required this.createdAt});
  factory _SavingsHistoryEntity.fromJson(Map<String, dynamic> json) => _$SavingsHistoryEntityFromJson(json);

@override final  int id;
@override final  SavingsTransactionType type;
@override final  int amount;
@override final  String description;
@override final  int? relatedCycleId;
@override final  int? relatedExpenseId;
@override final  int? relatedDebtPaymentId;
@override final  int? relatedLendingId;
@override final  DateTime createdAt;

/// Create a copy of SavingsHistoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingsHistoryEntityCopyWith<_SavingsHistoryEntity> get copyWith => __$SavingsHistoryEntityCopyWithImpl<_SavingsHistoryEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavingsHistoryEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingsHistoryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.relatedCycleId, relatedCycleId) || other.relatedCycleId == relatedCycleId)&&(identical(other.relatedExpenseId, relatedExpenseId) || other.relatedExpenseId == relatedExpenseId)&&(identical(other.relatedDebtPaymentId, relatedDebtPaymentId) || other.relatedDebtPaymentId == relatedDebtPaymentId)&&(identical(other.relatedLendingId, relatedLendingId) || other.relatedLendingId == relatedLendingId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,amount,description,relatedCycleId,relatedExpenseId,relatedDebtPaymentId,relatedLendingId,createdAt);

@override
String toString() {
  return 'SavingsHistoryEntity(id: $id, type: $type, amount: $amount, description: $description, relatedCycleId: $relatedCycleId, relatedExpenseId: $relatedExpenseId, relatedDebtPaymentId: $relatedDebtPaymentId, relatedLendingId: $relatedLendingId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SavingsHistoryEntityCopyWith<$Res> implements $SavingsHistoryEntityCopyWith<$Res> {
  factory _$SavingsHistoryEntityCopyWith(_SavingsHistoryEntity value, $Res Function(_SavingsHistoryEntity) _then) = __$SavingsHistoryEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, SavingsTransactionType type, int amount, String description, int? relatedCycleId, int? relatedExpenseId, int? relatedDebtPaymentId, int? relatedLendingId, DateTime createdAt
});




}
/// @nodoc
class __$SavingsHistoryEntityCopyWithImpl<$Res>
    implements _$SavingsHistoryEntityCopyWith<$Res> {
  __$SavingsHistoryEntityCopyWithImpl(this._self, this._then);

  final _SavingsHistoryEntity _self;
  final $Res Function(_SavingsHistoryEntity) _then;

/// Create a copy of SavingsHistoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? description = null,Object? relatedCycleId = freezed,Object? relatedExpenseId = freezed,Object? relatedDebtPaymentId = freezed,Object? relatedLendingId = freezed,Object? createdAt = null,}) {
  return _then(_SavingsHistoryEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SavingsTransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,relatedCycleId: freezed == relatedCycleId ? _self.relatedCycleId : relatedCycleId // ignore: cast_nullable_to_non_nullable
as int?,relatedExpenseId: freezed == relatedExpenseId ? _self.relatedExpenseId : relatedExpenseId // ignore: cast_nullable_to_non_nullable
as int?,relatedDebtPaymentId: freezed == relatedDebtPaymentId ? _self.relatedDebtPaymentId : relatedDebtPaymentId // ignore: cast_nullable_to_non_nullable
as int?,relatedLendingId: freezed == relatedLendingId ? _self.relatedLendingId : relatedLendingId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
