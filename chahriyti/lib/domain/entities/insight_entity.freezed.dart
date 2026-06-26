// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insight_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InsightEntity {

 int get id; int get cycleId; InsightType get type; String? get category; String get metric; double get value; String get suggestion; DateTime get createdAt; DateTime get expiresAt;
/// Create a copy of InsightEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsightEntityCopyWith<InsightEntity> get copyWith => _$InsightEntityCopyWithImpl<InsightEntity>(this as InsightEntity, _$identity);

  /// Serializes this InsightEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.metric, metric) || other.metric == metric)&&(identical(other.value, value) || other.value == value)&&(identical(other.suggestion, suggestion) || other.suggestion == suggestion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cycleId,type,category,metric,value,suggestion,createdAt,expiresAt);

@override
String toString() {
  return 'InsightEntity(id: $id, cycleId: $cycleId, type: $type, category: $category, metric: $metric, value: $value, suggestion: $suggestion, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $InsightEntityCopyWith<$Res>  {
  factory $InsightEntityCopyWith(InsightEntity value, $Res Function(InsightEntity) _then) = _$InsightEntityCopyWithImpl;
@useResult
$Res call({
 int id, int cycleId, InsightType type, String? category, String metric, double value, String suggestion, DateTime createdAt, DateTime expiresAt
});




}
/// @nodoc
class _$InsightEntityCopyWithImpl<$Res>
    implements $InsightEntityCopyWith<$Res> {
  _$InsightEntityCopyWithImpl(this._self, this._then);

  final InsightEntity _self;
  final $Res Function(InsightEntity) _then;

/// Create a copy of InsightEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cycleId = null,Object? type = null,Object? category = freezed,Object? metric = null,Object? value = null,Object? suggestion = null,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InsightType,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,metric: null == metric ? _self.metric : metric // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,suggestion: null == suggestion ? _self.suggestion : suggestion // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InsightEntity].
extension InsightEntityPatterns on InsightEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InsightEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InsightEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InsightEntity value)  $default,){
final _that = this;
switch (_that) {
case _InsightEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InsightEntity value)?  $default,){
final _that = this;
switch (_that) {
case _InsightEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int cycleId,  InsightType type,  String? category,  String metric,  double value,  String suggestion,  DateTime createdAt,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InsightEntity() when $default != null:
return $default(_that.id,_that.cycleId,_that.type,_that.category,_that.metric,_that.value,_that.suggestion,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int cycleId,  InsightType type,  String? category,  String metric,  double value,  String suggestion,  DateTime createdAt,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _InsightEntity():
return $default(_that.id,_that.cycleId,_that.type,_that.category,_that.metric,_that.value,_that.suggestion,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int cycleId,  InsightType type,  String? category,  String metric,  double value,  String suggestion,  DateTime createdAt,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _InsightEntity() when $default != null:
return $default(_that.id,_that.cycleId,_that.type,_that.category,_that.metric,_that.value,_that.suggestion,_that.createdAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InsightEntity extends InsightEntity {
  const _InsightEntity({required this.id, required this.cycleId, required this.type, this.category, required this.metric, required this.value, required this.suggestion, required this.createdAt, required this.expiresAt}): super._();
  factory _InsightEntity.fromJson(Map<String, dynamic> json) => _$InsightEntityFromJson(json);

@override final  int id;
@override final  int cycleId;
@override final  InsightType type;
@override final  String? category;
@override final  String metric;
@override final  double value;
@override final  String suggestion;
@override final  DateTime createdAt;
@override final  DateTime expiresAt;

/// Create a copy of InsightEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsightEntityCopyWith<_InsightEntity> get copyWith => __$InsightEntityCopyWithImpl<_InsightEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InsightEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InsightEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.metric, metric) || other.metric == metric)&&(identical(other.value, value) || other.value == value)&&(identical(other.suggestion, suggestion) || other.suggestion == suggestion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cycleId,type,category,metric,value,suggestion,createdAt,expiresAt);

@override
String toString() {
  return 'InsightEntity(id: $id, cycleId: $cycleId, type: $type, category: $category, metric: $metric, value: $value, suggestion: $suggestion, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$InsightEntityCopyWith<$Res> implements $InsightEntityCopyWith<$Res> {
  factory _$InsightEntityCopyWith(_InsightEntity value, $Res Function(_InsightEntity) _then) = __$InsightEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, int cycleId, InsightType type, String? category, String metric, double value, String suggestion, DateTime createdAt, DateTime expiresAt
});




}
/// @nodoc
class __$InsightEntityCopyWithImpl<$Res>
    implements _$InsightEntityCopyWith<$Res> {
  __$InsightEntityCopyWithImpl(this._self, this._then);

  final _InsightEntity _self;
  final $Res Function(_InsightEntity) _then;

/// Create a copy of InsightEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cycleId = null,Object? type = null,Object? category = freezed,Object? metric = null,Object? value = null,Object? suggestion = null,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_InsightEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InsightType,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,metric: null == metric ? _self.metric : metric // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,suggestion: null == suggestion ? _self.suggestion : suggestion // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
