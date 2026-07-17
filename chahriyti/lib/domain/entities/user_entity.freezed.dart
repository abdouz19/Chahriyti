// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserEntity {

 int get id; int get monthlySalary; int get salaryDay; String get fullName; String get phoneNumber; int get wilayaCode; bool get isActivated; bool get challengesEnabled; int? get initialBalance; bool get hasCompletedFinancialSetup; int? get financialSetupStep; DateTime get createdAt;
/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserEntityCopyWith<UserEntity> get copyWith => _$UserEntityCopyWithImpl<UserEntity>(this as UserEntity, _$identity);

  /// Serializes this UserEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.monthlySalary, monthlySalary) || other.monthlySalary == monthlySalary)&&(identical(other.salaryDay, salaryDay) || other.salaryDay == salaryDay)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.wilayaCode, wilayaCode) || other.wilayaCode == wilayaCode)&&(identical(other.isActivated, isActivated) || other.isActivated == isActivated)&&(identical(other.challengesEnabled, challengesEnabled) || other.challengesEnabled == challengesEnabled)&&(identical(other.initialBalance, initialBalance) || other.initialBalance == initialBalance)&&(identical(other.hasCompletedFinancialSetup, hasCompletedFinancialSetup) || other.hasCompletedFinancialSetup == hasCompletedFinancialSetup)&&(identical(other.financialSetupStep, financialSetupStep) || other.financialSetupStep == financialSetupStep)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,monthlySalary,salaryDay,fullName,phoneNumber,wilayaCode,isActivated,challengesEnabled,initialBalance,hasCompletedFinancialSetup,financialSetupStep,createdAt);

@override
String toString() {
  return 'UserEntity(id: $id, monthlySalary: $monthlySalary, salaryDay: $salaryDay, fullName: $fullName, phoneNumber: $phoneNumber, wilayaCode: $wilayaCode, isActivated: $isActivated, challengesEnabled: $challengesEnabled, initialBalance: $initialBalance, hasCompletedFinancialSetup: $hasCompletedFinancialSetup, financialSetupStep: $financialSetupStep, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserEntityCopyWith<$Res>  {
  factory $UserEntityCopyWith(UserEntity value, $Res Function(UserEntity) _then) = _$UserEntityCopyWithImpl;
@useResult
$Res call({
 int id, int monthlySalary, int salaryDay, String fullName, String phoneNumber, int wilayaCode, bool isActivated, bool challengesEnabled, int? initialBalance, bool hasCompletedFinancialSetup, int? financialSetupStep, DateTime createdAt
});




}
/// @nodoc
class _$UserEntityCopyWithImpl<$Res>
    implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._self, this._then);

  final UserEntity _self;
  final $Res Function(UserEntity) _then;

/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? monthlySalary = null,Object? salaryDay = null,Object? fullName = null,Object? phoneNumber = null,Object? wilayaCode = null,Object? isActivated = null,Object? challengesEnabled = null,Object? initialBalance = freezed,Object? hasCompletedFinancialSetup = null,Object? financialSetupStep = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,monthlySalary: null == monthlySalary ? _self.monthlySalary : monthlySalary // ignore: cast_nullable_to_non_nullable
as int,salaryDay: null == salaryDay ? _self.salaryDay : salaryDay // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,wilayaCode: null == wilayaCode ? _self.wilayaCode : wilayaCode // ignore: cast_nullable_to_non_nullable
as int,isActivated: null == isActivated ? _self.isActivated : isActivated // ignore: cast_nullable_to_non_nullable
as bool,challengesEnabled: null == challengesEnabled ? _self.challengesEnabled : challengesEnabled // ignore: cast_nullable_to_non_nullable
as bool,initialBalance: freezed == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int?,hasCompletedFinancialSetup: null == hasCompletedFinancialSetup ? _self.hasCompletedFinancialSetup : hasCompletedFinancialSetup // ignore: cast_nullable_to_non_nullable
as bool,financialSetupStep: freezed == financialSetupStep ? _self.financialSetupStep : financialSetupStep // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserEntity].
extension UserEntityPatterns on UserEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int monthlySalary,  int salaryDay,  String fullName,  String phoneNumber,  int wilayaCode,  bool isActivated,  bool challengesEnabled,  int? initialBalance,  bool hasCompletedFinancialSetup,  int? financialSetupStep,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
return $default(_that.id,_that.monthlySalary,_that.salaryDay,_that.fullName,_that.phoneNumber,_that.wilayaCode,_that.isActivated,_that.challengesEnabled,_that.initialBalance,_that.hasCompletedFinancialSetup,_that.financialSetupStep,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int monthlySalary,  int salaryDay,  String fullName,  String phoneNumber,  int wilayaCode,  bool isActivated,  bool challengesEnabled,  int? initialBalance,  bool hasCompletedFinancialSetup,  int? financialSetupStep,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserEntity():
return $default(_that.id,_that.monthlySalary,_that.salaryDay,_that.fullName,_that.phoneNumber,_that.wilayaCode,_that.isActivated,_that.challengesEnabled,_that.initialBalance,_that.hasCompletedFinancialSetup,_that.financialSetupStep,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int monthlySalary,  int salaryDay,  String fullName,  String phoneNumber,  int wilayaCode,  bool isActivated,  bool challengesEnabled,  int? initialBalance,  bool hasCompletedFinancialSetup,  int? financialSetupStep,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
return $default(_that.id,_that.monthlySalary,_that.salaryDay,_that.fullName,_that.phoneNumber,_that.wilayaCode,_that.isActivated,_that.challengesEnabled,_that.initialBalance,_that.hasCompletedFinancialSetup,_that.financialSetupStep,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserEntity extends UserEntity {
  const _UserEntity({required this.id, required this.monthlySalary, required this.salaryDay, required this.fullName, required this.phoneNumber, required this.wilayaCode, required this.isActivated, required this.challengesEnabled, this.initialBalance, this.hasCompletedFinancialSetup = false, this.financialSetupStep, required this.createdAt}): super._();
  factory _UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);

@override final  int id;
@override final  int monthlySalary;
@override final  int salaryDay;
@override final  String fullName;
@override final  String phoneNumber;
@override final  int wilayaCode;
@override final  bool isActivated;
@override final  bool challengesEnabled;
@override final  int? initialBalance;
@override@JsonKey() final  bool hasCompletedFinancialSetup;
@override final  int? financialSetupStep;
@override final  DateTime createdAt;

/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserEntityCopyWith<_UserEntity> get copyWith => __$UserEntityCopyWithImpl<_UserEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.monthlySalary, monthlySalary) || other.monthlySalary == monthlySalary)&&(identical(other.salaryDay, salaryDay) || other.salaryDay == salaryDay)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.wilayaCode, wilayaCode) || other.wilayaCode == wilayaCode)&&(identical(other.isActivated, isActivated) || other.isActivated == isActivated)&&(identical(other.challengesEnabled, challengesEnabled) || other.challengesEnabled == challengesEnabled)&&(identical(other.initialBalance, initialBalance) || other.initialBalance == initialBalance)&&(identical(other.hasCompletedFinancialSetup, hasCompletedFinancialSetup) || other.hasCompletedFinancialSetup == hasCompletedFinancialSetup)&&(identical(other.financialSetupStep, financialSetupStep) || other.financialSetupStep == financialSetupStep)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,monthlySalary,salaryDay,fullName,phoneNumber,wilayaCode,isActivated,challengesEnabled,initialBalance,hasCompletedFinancialSetup,financialSetupStep,createdAt);

@override
String toString() {
  return 'UserEntity(id: $id, monthlySalary: $monthlySalary, salaryDay: $salaryDay, fullName: $fullName, phoneNumber: $phoneNumber, wilayaCode: $wilayaCode, isActivated: $isActivated, challengesEnabled: $challengesEnabled, initialBalance: $initialBalance, hasCompletedFinancialSetup: $hasCompletedFinancialSetup, financialSetupStep: $financialSetupStep, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserEntityCopyWith<$Res> implements $UserEntityCopyWith<$Res> {
  factory _$UserEntityCopyWith(_UserEntity value, $Res Function(_UserEntity) _then) = __$UserEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, int monthlySalary, int salaryDay, String fullName, String phoneNumber, int wilayaCode, bool isActivated, bool challengesEnabled, int? initialBalance, bool hasCompletedFinancialSetup, int? financialSetupStep, DateTime createdAt
});




}
/// @nodoc
class __$UserEntityCopyWithImpl<$Res>
    implements _$UserEntityCopyWith<$Res> {
  __$UserEntityCopyWithImpl(this._self, this._then);

  final _UserEntity _self;
  final $Res Function(_UserEntity) _then;

/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? monthlySalary = null,Object? salaryDay = null,Object? fullName = null,Object? phoneNumber = null,Object? wilayaCode = null,Object? isActivated = null,Object? challengesEnabled = null,Object? initialBalance = freezed,Object? hasCompletedFinancialSetup = null,Object? financialSetupStep = freezed,Object? createdAt = null,}) {
  return _then(_UserEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,monthlySalary: null == monthlySalary ? _self.monthlySalary : monthlySalary // ignore: cast_nullable_to_non_nullable
as int,salaryDay: null == salaryDay ? _self.salaryDay : salaryDay // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,wilayaCode: null == wilayaCode ? _self.wilayaCode : wilayaCode // ignore: cast_nullable_to_non_nullable
as int,isActivated: null == isActivated ? _self.isActivated : isActivated // ignore: cast_nullable_to_non_nullable
as bool,challengesEnabled: null == challengesEnabled ? _self.challengesEnabled : challengesEnabled // ignore: cast_nullable_to_non_nullable
as bool,initialBalance: freezed == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int?,hasCompletedFinancialSetup: null == hasCompletedFinancialSetup ? _self.hasCompletedFinancialSetup : hasCompletedFinancialSetup // ignore: cast_nullable_to_non_nullable
as bool,financialSetupStep: freezed == financialSetupStep ? _self.financialSetupStep : financialSetupStep // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
