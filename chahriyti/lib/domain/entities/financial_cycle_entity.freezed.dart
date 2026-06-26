// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_cycle_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FinancialCycleEntity {

 int get id; DateTime get startDate; DateTime get endDate; int get salaryAmount; bool get isActive;
/// Create a copy of FinancialCycleEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialCycleEntityCopyWith<FinancialCycleEntity> get copyWith => _$FinancialCycleEntityCopyWithImpl<FinancialCycleEntity>(this as FinancialCycleEntity, _$identity);

  /// Serializes this FinancialCycleEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialCycleEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.salaryAmount, salaryAmount) || other.salaryAmount == salaryAmount)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startDate,endDate,salaryAmount,isActive);

@override
String toString() {
  return 'FinancialCycleEntity(id: $id, startDate: $startDate, endDate: $endDate, salaryAmount: $salaryAmount, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $FinancialCycleEntityCopyWith<$Res>  {
  factory $FinancialCycleEntityCopyWith(FinancialCycleEntity value, $Res Function(FinancialCycleEntity) _then) = _$FinancialCycleEntityCopyWithImpl;
@useResult
$Res call({
 int id, DateTime startDate, DateTime endDate, int salaryAmount, bool isActive
});




}
/// @nodoc
class _$FinancialCycleEntityCopyWithImpl<$Res>
    implements $FinancialCycleEntityCopyWith<$Res> {
  _$FinancialCycleEntityCopyWithImpl(this._self, this._then);

  final FinancialCycleEntity _self;
  final $Res Function(FinancialCycleEntity) _then;

/// Create a copy of FinancialCycleEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? startDate = null,Object? endDate = null,Object? salaryAmount = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,salaryAmount: null == salaryAmount ? _self.salaryAmount : salaryAmount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialCycleEntity].
extension FinancialCycleEntityPatterns on FinancialCycleEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialCycleEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialCycleEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialCycleEntity value)  $default,){
final _that = this;
switch (_that) {
case _FinancialCycleEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialCycleEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialCycleEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  DateTime startDate,  DateTime endDate,  int salaryAmount,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialCycleEntity() when $default != null:
return $default(_that.id,_that.startDate,_that.endDate,_that.salaryAmount,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  DateTime startDate,  DateTime endDate,  int salaryAmount,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _FinancialCycleEntity():
return $default(_that.id,_that.startDate,_that.endDate,_that.salaryAmount,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  DateTime startDate,  DateTime endDate,  int salaryAmount,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _FinancialCycleEntity() when $default != null:
return $default(_that.id,_that.startDate,_that.endDate,_that.salaryAmount,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialCycleEntity extends FinancialCycleEntity {
  const _FinancialCycleEntity({required this.id, required this.startDate, required this.endDate, required this.salaryAmount, required this.isActive}): super._();
  factory _FinancialCycleEntity.fromJson(Map<String, dynamic> json) => _$FinancialCycleEntityFromJson(json);

@override final  int id;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  int salaryAmount;
@override final  bool isActive;

/// Create a copy of FinancialCycleEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialCycleEntityCopyWith<_FinancialCycleEntity> get copyWith => __$FinancialCycleEntityCopyWithImpl<_FinancialCycleEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialCycleEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialCycleEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.salaryAmount, salaryAmount) || other.salaryAmount == salaryAmount)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startDate,endDate,salaryAmount,isActive);

@override
String toString() {
  return 'FinancialCycleEntity(id: $id, startDate: $startDate, endDate: $endDate, salaryAmount: $salaryAmount, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$FinancialCycleEntityCopyWith<$Res> implements $FinancialCycleEntityCopyWith<$Res> {
  factory _$FinancialCycleEntityCopyWith(_FinancialCycleEntity value, $Res Function(_FinancialCycleEntity) _then) = __$FinancialCycleEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, DateTime startDate, DateTime endDate, int salaryAmount, bool isActive
});




}
/// @nodoc
class __$FinancialCycleEntityCopyWithImpl<$Res>
    implements _$FinancialCycleEntityCopyWith<$Res> {
  __$FinancialCycleEntityCopyWithImpl(this._self, this._then);

  final _FinancialCycleEntity _self;
  final $Res Function(_FinancialCycleEntity) _then;

/// Create a copy of FinancialCycleEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? startDate = null,Object? endDate = null,Object? salaryAmount = null,Object? isActive = null,}) {
  return _then(_FinancialCycleEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,salaryAmount: null == salaryAmount ? _self.salaryAmount : salaryAmount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
