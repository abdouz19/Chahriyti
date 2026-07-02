// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lending_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LendingState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LendingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LendingState()';
}


}

/// @nodoc
class $LendingStateCopyWith<$Res>  {
$LendingStateCopyWith(LendingState _, $Res Function(LendingState) __);
}


/// Adds pattern-matching-related methods to [LendingState].
extension LendingStatePatterns on LendingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LendingInitial value)?  initial,TResult Function( LendingLoading value)?  loading,TResult Function( LendingsLoaded value)?  lendingsLoaded,TResult Function( LendingLoaded value)?  lendingLoaded,TResult Function( LendingCreated value)?  lendingCreated,TResult Function( LendingDeleted value)?  lendingDeleted,TResult Function( CollectionAdded value)?  collectionAdded,TResult Function( LendingError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LendingInitial() when initial != null:
return initial(_that);case LendingLoading() when loading != null:
return loading(_that);case LendingsLoaded() when lendingsLoaded != null:
return lendingsLoaded(_that);case LendingLoaded() when lendingLoaded != null:
return lendingLoaded(_that);case LendingCreated() when lendingCreated != null:
return lendingCreated(_that);case LendingDeleted() when lendingDeleted != null:
return lendingDeleted(_that);case CollectionAdded() when collectionAdded != null:
return collectionAdded(_that);case LendingError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LendingInitial value)  initial,required TResult Function( LendingLoading value)  loading,required TResult Function( LendingsLoaded value)  lendingsLoaded,required TResult Function( LendingLoaded value)  lendingLoaded,required TResult Function( LendingCreated value)  lendingCreated,required TResult Function( LendingDeleted value)  lendingDeleted,required TResult Function( CollectionAdded value)  collectionAdded,required TResult Function( LendingError value)  error,}){
final _that = this;
switch (_that) {
case LendingInitial():
return initial(_that);case LendingLoading():
return loading(_that);case LendingsLoaded():
return lendingsLoaded(_that);case LendingLoaded():
return lendingLoaded(_that);case LendingCreated():
return lendingCreated(_that);case LendingDeleted():
return lendingDeleted(_that);case CollectionAdded():
return collectionAdded(_that);case LendingError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LendingInitial value)?  initial,TResult? Function( LendingLoading value)?  loading,TResult? Function( LendingsLoaded value)?  lendingsLoaded,TResult? Function( LendingLoaded value)?  lendingLoaded,TResult? Function( LendingCreated value)?  lendingCreated,TResult? Function( LendingDeleted value)?  lendingDeleted,TResult? Function( CollectionAdded value)?  collectionAdded,TResult? Function( LendingError value)?  error,}){
final _that = this;
switch (_that) {
case LendingInitial() when initial != null:
return initial(_that);case LendingLoading() when loading != null:
return loading(_that);case LendingsLoaded() when lendingsLoaded != null:
return lendingsLoaded(_that);case LendingLoaded() when lendingLoaded != null:
return lendingLoaded(_that);case LendingCreated() when lendingCreated != null:
return lendingCreated(_that);case LendingDeleted() when lendingDeleted != null:
return lendingDeleted(_that);case CollectionAdded() when collectionAdded != null:
return collectionAdded(_that);case LendingError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<LendingEntity> lendings,  bool hasMore,  int offset,  bool isCollectedTab)?  lendingsLoaded,TResult Function( LendingEntity lending,  List<LendingCollectionEntity> collections)?  lendingLoaded,TResult Function( LendingEntity lending)?  lendingCreated,TResult Function()?  lendingDeleted,TResult Function()?  collectionAdded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LendingInitial() when initial != null:
return initial();case LendingLoading() when loading != null:
return loading();case LendingsLoaded() when lendingsLoaded != null:
return lendingsLoaded(_that.lendings,_that.hasMore,_that.offset,_that.isCollectedTab);case LendingLoaded() when lendingLoaded != null:
return lendingLoaded(_that.lending,_that.collections);case LendingCreated() when lendingCreated != null:
return lendingCreated(_that.lending);case LendingDeleted() when lendingDeleted != null:
return lendingDeleted();case CollectionAdded() when collectionAdded != null:
return collectionAdded();case LendingError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<LendingEntity> lendings,  bool hasMore,  int offset,  bool isCollectedTab)  lendingsLoaded,required TResult Function( LendingEntity lending,  List<LendingCollectionEntity> collections)  lendingLoaded,required TResult Function( LendingEntity lending)  lendingCreated,required TResult Function()  lendingDeleted,required TResult Function()  collectionAdded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case LendingInitial():
return initial();case LendingLoading():
return loading();case LendingsLoaded():
return lendingsLoaded(_that.lendings,_that.hasMore,_that.offset,_that.isCollectedTab);case LendingLoaded():
return lendingLoaded(_that.lending,_that.collections);case LendingCreated():
return lendingCreated(_that.lending);case LendingDeleted():
return lendingDeleted();case CollectionAdded():
return collectionAdded();case LendingError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<LendingEntity> lendings,  bool hasMore,  int offset,  bool isCollectedTab)?  lendingsLoaded,TResult? Function( LendingEntity lending,  List<LendingCollectionEntity> collections)?  lendingLoaded,TResult? Function( LendingEntity lending)?  lendingCreated,TResult? Function()?  lendingDeleted,TResult? Function()?  collectionAdded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case LendingInitial() when initial != null:
return initial();case LendingLoading() when loading != null:
return loading();case LendingsLoaded() when lendingsLoaded != null:
return lendingsLoaded(_that.lendings,_that.hasMore,_that.offset,_that.isCollectedTab);case LendingLoaded() when lendingLoaded != null:
return lendingLoaded(_that.lending,_that.collections);case LendingCreated() when lendingCreated != null:
return lendingCreated(_that.lending);case LendingDeleted() when lendingDeleted != null:
return lendingDeleted();case CollectionAdded() when collectionAdded != null:
return collectionAdded();case LendingError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class LendingInitial implements LendingState {
  const LendingInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LendingInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LendingState.initial()';
}


}




/// @nodoc


class LendingLoading implements LendingState {
  const LendingLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LendingLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LendingState.loading()';
}


}




/// @nodoc


class LendingsLoaded implements LendingState {
  const LendingsLoaded(final  List<LendingEntity> lendings, {this.hasMore = false, this.offset = 0, this.isCollectedTab = false}): _lendings = lendings;
  

 final  List<LendingEntity> _lendings;
 List<LendingEntity> get lendings {
  if (_lendings is EqualUnmodifiableListView) return _lendings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lendings);
}

@JsonKey() final  bool hasMore;
@JsonKey() final  int offset;
@JsonKey() final  bool isCollectedTab;

/// Create a copy of LendingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LendingsLoadedCopyWith<LendingsLoaded> get copyWith => _$LendingsLoadedCopyWithImpl<LendingsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LendingsLoaded&&const DeepCollectionEquality().equals(other._lendings, _lendings)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.isCollectedTab, isCollectedTab) || other.isCollectedTab == isCollectedTab));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_lendings),hasMore,offset,isCollectedTab);

@override
String toString() {
  return 'LendingState.lendingsLoaded(lendings: $lendings, hasMore: $hasMore, offset: $offset, isCollectedTab: $isCollectedTab)';
}


}

/// @nodoc
abstract mixin class $LendingsLoadedCopyWith<$Res> implements $LendingStateCopyWith<$Res> {
  factory $LendingsLoadedCopyWith(LendingsLoaded value, $Res Function(LendingsLoaded) _then) = _$LendingsLoadedCopyWithImpl;
@useResult
$Res call({
 List<LendingEntity> lendings, bool hasMore, int offset, bool isCollectedTab
});




}
/// @nodoc
class _$LendingsLoadedCopyWithImpl<$Res>
    implements $LendingsLoadedCopyWith<$Res> {
  _$LendingsLoadedCopyWithImpl(this._self, this._then);

  final LendingsLoaded _self;
  final $Res Function(LendingsLoaded) _then;

/// Create a copy of LendingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lendings = null,Object? hasMore = null,Object? offset = null,Object? isCollectedTab = null,}) {
  return _then(LendingsLoaded(
null == lendings ? _self._lendings : lendings // ignore: cast_nullable_to_non_nullable
as List<LendingEntity>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,isCollectedTab: null == isCollectedTab ? _self.isCollectedTab : isCollectedTab // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class LendingLoaded implements LendingState {
  const LendingLoaded(this.lending, final  List<LendingCollectionEntity> collections): _collections = collections;
  

 final  LendingEntity lending;
 final  List<LendingCollectionEntity> _collections;
 List<LendingCollectionEntity> get collections {
  if (_collections is EqualUnmodifiableListView) return _collections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_collections);
}


/// Create a copy of LendingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LendingLoadedCopyWith<LendingLoaded> get copyWith => _$LendingLoadedCopyWithImpl<LendingLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LendingLoaded&&(identical(other.lending, lending) || other.lending == lending)&&const DeepCollectionEquality().equals(other._collections, _collections));
}


@override
int get hashCode => Object.hash(runtimeType,lending,const DeepCollectionEquality().hash(_collections));

@override
String toString() {
  return 'LendingState.lendingLoaded(lending: $lending, collections: $collections)';
}


}

/// @nodoc
abstract mixin class $LendingLoadedCopyWith<$Res> implements $LendingStateCopyWith<$Res> {
  factory $LendingLoadedCopyWith(LendingLoaded value, $Res Function(LendingLoaded) _then) = _$LendingLoadedCopyWithImpl;
@useResult
$Res call({
 LendingEntity lending, List<LendingCollectionEntity> collections
});


$LendingEntityCopyWith<$Res> get lending;

}
/// @nodoc
class _$LendingLoadedCopyWithImpl<$Res>
    implements $LendingLoadedCopyWith<$Res> {
  _$LendingLoadedCopyWithImpl(this._self, this._then);

  final LendingLoaded _self;
  final $Res Function(LendingLoaded) _then;

/// Create a copy of LendingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lending = null,Object? collections = null,}) {
  return _then(LendingLoaded(
null == lending ? _self.lending : lending // ignore: cast_nullable_to_non_nullable
as LendingEntity,null == collections ? _self._collections : collections // ignore: cast_nullable_to_non_nullable
as List<LendingCollectionEntity>,
  ));
}

/// Create a copy of LendingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LendingEntityCopyWith<$Res> get lending {
  
  return $LendingEntityCopyWith<$Res>(_self.lending, (value) {
    return _then(_self.copyWith(lending: value));
  });
}
}

/// @nodoc


class LendingCreated implements LendingState {
  const LendingCreated(this.lending);
  

 final  LendingEntity lending;

/// Create a copy of LendingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LendingCreatedCopyWith<LendingCreated> get copyWith => _$LendingCreatedCopyWithImpl<LendingCreated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LendingCreated&&(identical(other.lending, lending) || other.lending == lending));
}


@override
int get hashCode => Object.hash(runtimeType,lending);

@override
String toString() {
  return 'LendingState.lendingCreated(lending: $lending)';
}


}

/// @nodoc
abstract mixin class $LendingCreatedCopyWith<$Res> implements $LendingStateCopyWith<$Res> {
  factory $LendingCreatedCopyWith(LendingCreated value, $Res Function(LendingCreated) _then) = _$LendingCreatedCopyWithImpl;
@useResult
$Res call({
 LendingEntity lending
});


$LendingEntityCopyWith<$Res> get lending;

}
/// @nodoc
class _$LendingCreatedCopyWithImpl<$Res>
    implements $LendingCreatedCopyWith<$Res> {
  _$LendingCreatedCopyWithImpl(this._self, this._then);

  final LendingCreated _self;
  final $Res Function(LendingCreated) _then;

/// Create a copy of LendingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lending = null,}) {
  return _then(LendingCreated(
null == lending ? _self.lending : lending // ignore: cast_nullable_to_non_nullable
as LendingEntity,
  ));
}

/// Create a copy of LendingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LendingEntityCopyWith<$Res> get lending {
  
  return $LendingEntityCopyWith<$Res>(_self.lending, (value) {
    return _then(_self.copyWith(lending: value));
  });
}
}

/// @nodoc


class LendingDeleted implements LendingState {
  const LendingDeleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LendingDeleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LendingState.lendingDeleted()';
}


}




/// @nodoc


class CollectionAdded implements LendingState {
  const CollectionAdded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionAdded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LendingState.collectionAdded()';
}


}




/// @nodoc


class LendingError implements LendingState {
  const LendingError(this.message);
  

 final  String message;

/// Create a copy of LendingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LendingErrorCopyWith<LendingError> get copyWith => _$LendingErrorCopyWithImpl<LendingError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LendingError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'LendingState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $LendingErrorCopyWith<$Res> implements $LendingStateCopyWith<$Res> {
  factory $LendingErrorCopyWith(LendingError value, $Res Function(LendingError) _then) = _$LendingErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$LendingErrorCopyWithImpl<$Res>
    implements $LendingErrorCopyWith<$Res> {
  _$LendingErrorCopyWithImpl(this._self, this._then);

  final LendingError _self;
  final $Res Function(LendingError) _then;

/// Create a copy of LendingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(LendingError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
