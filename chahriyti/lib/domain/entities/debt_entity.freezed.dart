// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DebtEntity {

 int get id; String get creditorName; int get totalAmount; int get paidAmount; bool get isFullyPaid; DateTime get createdAt; String? get notes;
/// Create a copy of DebtEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtEntityCopyWith<DebtEntity> get copyWith => _$DebtEntityCopyWithImpl<DebtEntity>(this as DebtEntity, _$identity);

  /// Serializes this DebtEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.creditorName, creditorName) || other.creditorName == creditorName)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.isFullyPaid, isFullyPaid) || other.isFullyPaid == isFullyPaid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,creditorName,totalAmount,paidAmount,isFullyPaid,createdAt,notes);

@override
String toString() {
  return 'DebtEntity(id: $id, creditorName: $creditorName, totalAmount: $totalAmount, paidAmount: $paidAmount, isFullyPaid: $isFullyPaid, createdAt: $createdAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $DebtEntityCopyWith<$Res>  {
  factory $DebtEntityCopyWith(DebtEntity value, $Res Function(DebtEntity) _then) = _$DebtEntityCopyWithImpl;
@useResult
$Res call({
 int id, String creditorName, int totalAmount, int paidAmount, bool isFullyPaid, DateTime createdAt, String? notes
});




}
/// @nodoc
class _$DebtEntityCopyWithImpl<$Res>
    implements $DebtEntityCopyWith<$Res> {
  _$DebtEntityCopyWithImpl(this._self, this._then);

  final DebtEntity _self;
  final $Res Function(DebtEntity) _then;

/// Create a copy of DebtEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? creditorName = null,Object? totalAmount = null,Object? paidAmount = null,Object? isFullyPaid = null,Object? createdAt = null,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,creditorName: null == creditorName ? _self.creditorName : creditorName // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as int,isFullyPaid: null == isFullyPaid ? _self.isFullyPaid : isFullyPaid // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtEntity].
extension DebtEntityPatterns on DebtEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtEntity value)  $default,){
final _that = this;
switch (_that) {
case _DebtEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DebtEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String creditorName,  int totalAmount,  int paidAmount,  bool isFullyPaid,  DateTime createdAt,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebtEntity() when $default != null:
return $default(_that.id,_that.creditorName,_that.totalAmount,_that.paidAmount,_that.isFullyPaid,_that.createdAt,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String creditorName,  int totalAmount,  int paidAmount,  bool isFullyPaid,  DateTime createdAt,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _DebtEntity():
return $default(_that.id,_that.creditorName,_that.totalAmount,_that.paidAmount,_that.isFullyPaid,_that.createdAt,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String creditorName,  int totalAmount,  int paidAmount,  bool isFullyPaid,  DateTime createdAt,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _DebtEntity() when $default != null:
return $default(_that.id,_that.creditorName,_that.totalAmount,_that.paidAmount,_that.isFullyPaid,_that.createdAt,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DebtEntity extends DebtEntity {
  const _DebtEntity({required this.id, required this.creditorName, required this.totalAmount, required this.paidAmount, required this.isFullyPaid, required this.createdAt, this.notes}): super._();
  factory _DebtEntity.fromJson(Map<String, dynamic> json) => _$DebtEntityFromJson(json);

@override final  int id;
@override final  String creditorName;
@override final  int totalAmount;
@override final  int paidAmount;
@override final  bool isFullyPaid;
@override final  DateTime createdAt;
@override final  String? notes;

/// Create a copy of DebtEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtEntityCopyWith<_DebtEntity> get copyWith => __$DebtEntityCopyWithImpl<_DebtEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.creditorName, creditorName) || other.creditorName == creditorName)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.isFullyPaid, isFullyPaid) || other.isFullyPaid == isFullyPaid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,creditorName,totalAmount,paidAmount,isFullyPaid,createdAt,notes);

@override
String toString() {
  return 'DebtEntity(id: $id, creditorName: $creditorName, totalAmount: $totalAmount, paidAmount: $paidAmount, isFullyPaid: $isFullyPaid, createdAt: $createdAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$DebtEntityCopyWith<$Res> implements $DebtEntityCopyWith<$Res> {
  factory _$DebtEntityCopyWith(_DebtEntity value, $Res Function(_DebtEntity) _then) = __$DebtEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String creditorName, int totalAmount, int paidAmount, bool isFullyPaid, DateTime createdAt, String? notes
});




}
/// @nodoc
class __$DebtEntityCopyWithImpl<$Res>
    implements _$DebtEntityCopyWith<$Res> {
  __$DebtEntityCopyWithImpl(this._self, this._then);

  final _DebtEntity _self;
  final $Res Function(_DebtEntity) _then;

/// Create a copy of DebtEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? creditorName = null,Object? totalAmount = null,Object? paidAmount = null,Object? isFullyPaid = null,Object? createdAt = null,Object? notes = freezed,}) {
  return _then(_DebtEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,creditorName: null == creditorName ? _self.creditorName : creditorName // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as int,isFullyPaid: null == isFullyPaid ? _self.isFullyPaid : isFullyPaid // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
