// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, UserRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _monthlySalaryMeta = const VerificationMeta(
    'monthlySalary',
  );
  @override
  late final GeneratedColumn<int> monthlySalary = GeneratedColumn<int>(
    'monthly_salary',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salaryDayMeta = const VerificationMeta(
    'salaryDay',
  );
  @override
  late final GeneratedColumn<int> salaryDay = GeneratedColumn<int>(
    'salary_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _wilayaCodeMeta = const VerificationMeta(
    'wilayaCode',
  );
  @override
  late final GeneratedColumn<int> wilayaCode = GeneratedColumn<int>(
    'wilaya_code',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActivatedMeta = const VerificationMeta(
    'isActivated',
  );
  @override
  late final GeneratedColumn<bool> isActivated = GeneratedColumn<bool>(
    'is_activated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_activated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _challengesEnabledMeta = const VerificationMeta(
    'challengesEnabled',
  );
  @override
  late final GeneratedColumn<bool> challengesEnabled = GeneratedColumn<bool>(
    'challenges_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("challenges_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    monthlySalary,
    salaryDay,
    fullName,
    phoneNumber,
    wilayaCode,
    isActivated,
    challengesEnabled,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('monthly_salary')) {
      context.handle(
        _monthlySalaryMeta,
        monthlySalary.isAcceptableOrUnknown(
          data['monthly_salary']!,
          _monthlySalaryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlySalaryMeta);
    }
    if (data.containsKey('salary_day')) {
      context.handle(
        _salaryDayMeta,
        salaryDay.isAcceptableOrUnknown(data['salary_day']!, _salaryDayMeta),
      );
    } else if (isInserting) {
      context.missing(_salaryDayMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('wilaya_code')) {
      context.handle(
        _wilayaCodeMeta,
        wilayaCode.isAcceptableOrUnknown(data['wilaya_code']!, _wilayaCodeMeta),
      );
    }
    if (data.containsKey('is_activated')) {
      context.handle(
        _isActivatedMeta,
        isActivated.isAcceptableOrUnknown(
          data['is_activated']!,
          _isActivatedMeta,
        ),
      );
    }
    if (data.containsKey('challenges_enabled')) {
      context.handle(
        _challengesEnabledMeta,
        challengesEnabled.isAcceptableOrUnknown(
          data['challenges_enabled']!,
          _challengesEnabledMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      monthlySalary: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_salary'],
      )!,
      salaryDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}salary_day'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      wilayaCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wilaya_code'],
      )!,
      isActivated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_activated'],
      )!,
      challengesEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}challenges_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserRow extends DataClass implements Insertable<UserRow> {
  final int id;
  final int monthlySalary;
  final int salaryDay;
  final String fullName;
  final String phoneNumber;
  final int wilayaCode;
  final bool isActivated;
  final bool challengesEnabled;
  final DateTime createdAt;
  const UserRow({
    required this.id,
    required this.monthlySalary,
    required this.salaryDay,
    required this.fullName,
    required this.phoneNumber,
    required this.wilayaCode,
    required this.isActivated,
    required this.challengesEnabled,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['monthly_salary'] = Variable<int>(monthlySalary);
    map['salary_day'] = Variable<int>(salaryDay);
    map['full_name'] = Variable<String>(fullName);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['wilaya_code'] = Variable<int>(wilayaCode);
    map['is_activated'] = Variable<bool>(isActivated);
    map['challenges_enabled'] = Variable<bool>(challengesEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      monthlySalary: Value(monthlySalary),
      salaryDay: Value(salaryDay),
      fullName: Value(fullName),
      phoneNumber: Value(phoneNumber),
      wilayaCode: Value(wilayaCode),
      isActivated: Value(isActivated),
      challengesEnabled: Value(challengesEnabled),
      createdAt: Value(createdAt),
    );
  }

  factory UserRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserRow(
      id: serializer.fromJson<int>(json['id']),
      monthlySalary: serializer.fromJson<int>(json['monthlySalary']),
      salaryDay: serializer.fromJson<int>(json['salaryDay']),
      fullName: serializer.fromJson<String>(json['fullName']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      wilayaCode: serializer.fromJson<int>(json['wilayaCode']),
      isActivated: serializer.fromJson<bool>(json['isActivated']),
      challengesEnabled: serializer.fromJson<bool>(json['challengesEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'monthlySalary': serializer.toJson<int>(monthlySalary),
      'salaryDay': serializer.toJson<int>(salaryDay),
      'fullName': serializer.toJson<String>(fullName),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'wilayaCode': serializer.toJson<int>(wilayaCode),
      'isActivated': serializer.toJson<bool>(isActivated),
      'challengesEnabled': serializer.toJson<bool>(challengesEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserRow copyWith({
    int? id,
    int? monthlySalary,
    int? salaryDay,
    String? fullName,
    String? phoneNumber,
    int? wilayaCode,
    bool? isActivated,
    bool? challengesEnabled,
    DateTime? createdAt,
  }) => UserRow(
    id: id ?? this.id,
    monthlySalary: monthlySalary ?? this.monthlySalary,
    salaryDay: salaryDay ?? this.salaryDay,
    fullName: fullName ?? this.fullName,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    wilayaCode: wilayaCode ?? this.wilayaCode,
    isActivated: isActivated ?? this.isActivated,
    challengesEnabled: challengesEnabled ?? this.challengesEnabled,
    createdAt: createdAt ?? this.createdAt,
  );
  UserRow copyWithCompanion(UsersCompanion data) {
    return UserRow(
      id: data.id.present ? data.id.value : this.id,
      monthlySalary: data.monthlySalary.present
          ? data.monthlySalary.value
          : this.monthlySalary,
      salaryDay: data.salaryDay.present ? data.salaryDay.value : this.salaryDay,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      wilayaCode: data.wilayaCode.present
          ? data.wilayaCode.value
          : this.wilayaCode,
      isActivated: data.isActivated.present
          ? data.isActivated.value
          : this.isActivated,
      challengesEnabled: data.challengesEnabled.present
          ? data.challengesEnabled.value
          : this.challengesEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserRow(')
          ..write('id: $id, ')
          ..write('monthlySalary: $monthlySalary, ')
          ..write('salaryDay: $salaryDay, ')
          ..write('fullName: $fullName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('wilayaCode: $wilayaCode, ')
          ..write('isActivated: $isActivated, ')
          ..write('challengesEnabled: $challengesEnabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    monthlySalary,
    salaryDay,
    fullName,
    phoneNumber,
    wilayaCode,
    isActivated,
    challengesEnabled,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRow &&
          other.id == this.id &&
          other.monthlySalary == this.monthlySalary &&
          other.salaryDay == this.salaryDay &&
          other.fullName == this.fullName &&
          other.phoneNumber == this.phoneNumber &&
          other.wilayaCode == this.wilayaCode &&
          other.isActivated == this.isActivated &&
          other.challengesEnabled == this.challengesEnabled &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<UserRow> {
  final Value<int> id;
  final Value<int> monthlySalary;
  final Value<int> salaryDay;
  final Value<String> fullName;
  final Value<String> phoneNumber;
  final Value<int> wilayaCode;
  final Value<bool> isActivated;
  final Value<bool> challengesEnabled;
  final Value<DateTime> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.monthlySalary = const Value.absent(),
    this.salaryDay = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.wilayaCode = const Value.absent(),
    this.isActivated = const Value.absent(),
    this.challengesEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required int monthlySalary,
    required int salaryDay,
    this.fullName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.wilayaCode = const Value.absent(),
    this.isActivated = const Value.absent(),
    this.challengesEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : monthlySalary = Value(monthlySalary),
       salaryDay = Value(salaryDay);
  static Insertable<UserRow> custom({
    Expression<int>? id,
    Expression<int>? monthlySalary,
    Expression<int>? salaryDay,
    Expression<String>? fullName,
    Expression<String>? phoneNumber,
    Expression<int>? wilayaCode,
    Expression<bool>? isActivated,
    Expression<bool>? challengesEnabled,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monthlySalary != null) 'monthly_salary': monthlySalary,
      if (salaryDay != null) 'salary_day': salaryDay,
      if (fullName != null) 'full_name': fullName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (wilayaCode != null) 'wilaya_code': wilayaCode,
      if (isActivated != null) 'is_activated': isActivated,
      if (challengesEnabled != null) 'challenges_enabled': challengesEnabled,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<int>? monthlySalary,
    Value<int>? salaryDay,
    Value<String>? fullName,
    Value<String>? phoneNumber,
    Value<int>? wilayaCode,
    Value<bool>? isActivated,
    Value<bool>? challengesEnabled,
    Value<DateTime>? createdAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      salaryDay: salaryDay ?? this.salaryDay,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      wilayaCode: wilayaCode ?? this.wilayaCode,
      isActivated: isActivated ?? this.isActivated,
      challengesEnabled: challengesEnabled ?? this.challengesEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (monthlySalary.present) {
      map['monthly_salary'] = Variable<int>(monthlySalary.value);
    }
    if (salaryDay.present) {
      map['salary_day'] = Variable<int>(salaryDay.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (wilayaCode.present) {
      map['wilaya_code'] = Variable<int>(wilayaCode.value);
    }
    if (isActivated.present) {
      map['is_activated'] = Variable<bool>(isActivated.value);
    }
    if (challengesEnabled.present) {
      map['challenges_enabled'] = Variable<bool>(challengesEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('monthlySalary: $monthlySalary, ')
          ..write('salaryDay: $salaryDay, ')
          ..write('fullName: $fullName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('wilayaCode: $wilayaCode, ')
          ..write('isActivated: $isActivated, ')
          ..write('challengesEnabled: $challengesEnabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FinancialCyclesTable extends FinancialCycles
    with TableInfo<$FinancialCyclesTable, FinancialCycleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialCyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salaryAmountMeta = const VerificationMeta(
    'salaryAmount',
  );
  @override
  late final GeneratedColumn<int> salaryAmount = GeneratedColumn<int>(
    'salary_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salarySplitAmountMeta = const VerificationMeta(
    'salarySplitAmount',
  );
  @override
  late final GeneratedColumn<int> salarySplitAmount = GeneratedColumn<int>(
    'salary_split_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    endDate,
    salaryAmount,
    salarySplitAmount,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinancialCycleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('salary_amount')) {
      context.handle(
        _salaryAmountMeta,
        salaryAmount.isAcceptableOrUnknown(
          data['salary_amount']!,
          _salaryAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_salaryAmountMeta);
    }
    if (data.containsKey('salary_split_amount')) {
      context.handle(
        _salarySplitAmountMeta,
        salarySplitAmount.isAcceptableOrUnknown(
          data['salary_split_amount']!,
          _salarySplitAmountMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancialCycleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialCycleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      salaryAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}salary_amount'],
      )!,
      salarySplitAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}salary_split_amount'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $FinancialCyclesTable createAlias(String alias) {
    return $FinancialCyclesTable(attachedDatabase, alias);
  }
}

class FinancialCycleRow extends DataClass
    implements Insertable<FinancialCycleRow> {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final int salaryAmount;
  final int salarySplitAmount;
  final bool isActive;
  const FinancialCycleRow({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.salaryAmount,
    required this.salarySplitAmount,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['salary_amount'] = Variable<int>(salaryAmount);
    map['salary_split_amount'] = Variable<int>(salarySplitAmount);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  FinancialCyclesCompanion toCompanion(bool nullToAbsent) {
    return FinancialCyclesCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: Value(endDate),
      salaryAmount: Value(salaryAmount),
      salarySplitAmount: Value(salarySplitAmount),
      isActive: Value(isActive),
    );
  }

  factory FinancialCycleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialCycleRow(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      salaryAmount: serializer.fromJson<int>(json['salaryAmount']),
      salarySplitAmount: serializer.fromJson<int>(json['salarySplitAmount']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'salaryAmount': serializer.toJson<int>(salaryAmount),
      'salarySplitAmount': serializer.toJson<int>(salarySplitAmount),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  FinancialCycleRow copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    int? salaryAmount,
    int? salarySplitAmount,
    bool? isActive,
  }) => FinancialCycleRow(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    salaryAmount: salaryAmount ?? this.salaryAmount,
    salarySplitAmount: salarySplitAmount ?? this.salarySplitAmount,
    isActive: isActive ?? this.isActive,
  );
  FinancialCycleRow copyWithCompanion(FinancialCyclesCompanion data) {
    return FinancialCycleRow(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      salaryAmount: data.salaryAmount.present
          ? data.salaryAmount.value
          : this.salaryAmount,
      salarySplitAmount: data.salarySplitAmount.present
          ? data.salarySplitAmount.value
          : this.salarySplitAmount,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialCycleRow(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('salaryAmount: $salaryAmount, ')
          ..write('salarySplitAmount: $salarySplitAmount, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startDate,
    endDate,
    salaryAmount,
    salarySplitAmount,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialCycleRow &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.salaryAmount == this.salaryAmount &&
          other.salarySplitAmount == this.salarySplitAmount &&
          other.isActive == this.isActive);
}

class FinancialCyclesCompanion extends UpdateCompanion<FinancialCycleRow> {
  final Value<int> id;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> salaryAmount;
  final Value<int> salarySplitAmount;
  final Value<bool> isActive;
  const FinancialCyclesCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.salaryAmount = const Value.absent(),
    this.salarySplitAmount = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  FinancialCyclesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    required int salaryAmount,
    this.salarySplitAmount = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : startDate = Value(startDate),
       endDate = Value(endDate),
       salaryAmount = Value(salaryAmount);
  static Insertable<FinancialCycleRow> custom({
    Expression<int>? id,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? salaryAmount,
    Expression<int>? salarySplitAmount,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (salaryAmount != null) 'salary_amount': salaryAmount,
      if (salarySplitAmount != null) 'salary_split_amount': salarySplitAmount,
      if (isActive != null) 'is_active': isActive,
    });
  }

  FinancialCyclesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? salaryAmount,
    Value<int>? salarySplitAmount,
    Value<bool>? isActive,
  }) {
    return FinancialCyclesCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      salaryAmount: salaryAmount ?? this.salaryAmount,
      salarySplitAmount: salarySplitAmount ?? this.salarySplitAmount,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (salaryAmount.present) {
      map['salary_amount'] = Variable<int>(salaryAmount.value);
    }
    if (salarySplitAmount.present) {
      map['salary_split_amount'] = Variable<int>(salarySplitAmount.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialCyclesCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('salaryAmount: $salaryAmount, ')
          ..write('salarySplitAmount: $salarySplitAmount, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses
    with TableInfo<$ExpensesTable, ExpenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subcategoryMeta = const VerificationMeta(
    'subcategory',
  );
  @override
  late final GeneratedColumn<String> subcategory = GeneratedColumn<String>(
    'subcategory',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _fromSavingsMeta = const VerificationMeta(
    'fromSavings',
  );
  @override
  late final GeneratedColumn<bool> fromSavings = GeneratedColumn<bool>(
    'from_savings',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("from_savings" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _savingsAmountMeta = const VerificationMeta(
    'savingsAmount',
  );
  @override
  late final GeneratedColumn<int> savingsAmount = GeneratedColumn<int>(
    'savings_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleId,
    category,
    subcategory,
    itemName,
    amount,
    notes,
    createdAt,
    updatedAt,
    fromSavings,
    savingsAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('subcategory')) {
      context.handle(
        _subcategoryMeta,
        subcategory.isAcceptableOrUnknown(
          data['subcategory']!,
          _subcategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subcategoryMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('from_savings')) {
      context.handle(
        _fromSavingsMeta,
        fromSavings.isAcceptableOrUnknown(
          data['from_savings']!,
          _fromSavingsMeta,
        ),
      );
    }
    if (data.containsKey('savings_amount')) {
      context.handle(
        _savingsAmountMeta,
        savingsAmount.isAcceptableOrUnknown(
          data['savings_amount']!,
          _savingsAmountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      subcategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subcategory'],
      )!,
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      fromSavings: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}from_savings'],
      )!,
      savingsAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}savings_amount'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class ExpenseRow extends DataClass implements Insertable<ExpenseRow> {
  final int id;
  final int cycleId;
  final String category;
  final String subcategory;
  final String itemName;
  final int amount;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool fromSavings;
  final int savingsAmount;
  const ExpenseRow({
    required this.id,
    required this.cycleId,
    required this.category,
    required this.subcategory,
    required this.itemName,
    required this.amount,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.fromSavings,
    required this.savingsAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cycle_id'] = Variable<int>(cycleId);
    map['category'] = Variable<String>(category);
    map['subcategory'] = Variable<String>(subcategory);
    map['item_name'] = Variable<String>(itemName);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['from_savings'] = Variable<bool>(fromSavings);
    map['savings_amount'] = Variable<int>(savingsAmount);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      category: Value(category),
      subcategory: Value(subcategory),
      itemName: Value(itemName),
      amount: Value(amount),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      fromSavings: Value(fromSavings),
      savingsAmount: Value(savingsAmount),
    );
  }

  factory ExpenseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseRow(
      id: serializer.fromJson<int>(json['id']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      category: serializer.fromJson<String>(json['category']),
      subcategory: serializer.fromJson<String>(json['subcategory']),
      itemName: serializer.fromJson<String>(json['itemName']),
      amount: serializer.fromJson<int>(json['amount']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      fromSavings: serializer.fromJson<bool>(json['fromSavings']),
      savingsAmount: serializer.fromJson<int>(json['savingsAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cycleId': serializer.toJson<int>(cycleId),
      'category': serializer.toJson<String>(category),
      'subcategory': serializer.toJson<String>(subcategory),
      'itemName': serializer.toJson<String>(itemName),
      'amount': serializer.toJson<int>(amount),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'fromSavings': serializer.toJson<bool>(fromSavings),
      'savingsAmount': serializer.toJson<int>(savingsAmount),
    };
  }

  ExpenseRow copyWith({
    int? id,
    int? cycleId,
    String? category,
    String? subcategory,
    String? itemName,
    int? amount,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? fromSavings,
    int? savingsAmount,
  }) => ExpenseRow(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    category: category ?? this.category,
    subcategory: subcategory ?? this.subcategory,
    itemName: itemName ?? this.itemName,
    amount: amount ?? this.amount,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    fromSavings: fromSavings ?? this.fromSavings,
    savingsAmount: savingsAmount ?? this.savingsAmount,
  );
  ExpenseRow copyWithCompanion(ExpensesCompanion data) {
    return ExpenseRow(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      category: data.category.present ? data.category.value : this.category,
      subcategory: data.subcategory.present
          ? data.subcategory.value
          : this.subcategory,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      amount: data.amount.present ? data.amount.value : this.amount,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      fromSavings: data.fromSavings.present
          ? data.fromSavings.value
          : this.fromSavings,
      savingsAmount: data.savingsAmount.present
          ? data.savingsAmount.value
          : this.savingsAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseRow(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('category: $category, ')
          ..write('subcategory: $subcategory, ')
          ..write('itemName: $itemName, ')
          ..write('amount: $amount, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fromSavings: $fromSavings, ')
          ..write('savingsAmount: $savingsAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cycleId,
    category,
    subcategory,
    itemName,
    amount,
    notes,
    createdAt,
    updatedAt,
    fromSavings,
    savingsAmount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseRow &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.category == this.category &&
          other.subcategory == this.subcategory &&
          other.itemName == this.itemName &&
          other.amount == this.amount &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.fromSavings == this.fromSavings &&
          other.savingsAmount == this.savingsAmount);
}

class ExpensesCompanion extends UpdateCompanion<ExpenseRow> {
  final Value<int> id;
  final Value<int> cycleId;
  final Value<String> category;
  final Value<String> subcategory;
  final Value<String> itemName;
  final Value<int> amount;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> fromSavings;
  final Value<int> savingsAmount;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.category = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.itemName = const Value.absent(),
    this.amount = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fromSavings = const Value.absent(),
    this.savingsAmount = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int cycleId,
    required String category,
    required String subcategory,
    required String itemName,
    required int amount,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fromSavings = const Value.absent(),
    this.savingsAmount = const Value.absent(),
  }) : cycleId = Value(cycleId),
       category = Value(category),
       subcategory = Value(subcategory),
       itemName = Value(itemName),
       amount = Value(amount);
  static Insertable<ExpenseRow> custom({
    Expression<int>? id,
    Expression<int>? cycleId,
    Expression<String>? category,
    Expression<String>? subcategory,
    Expression<String>? itemName,
    Expression<int>? amount,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? fromSavings,
    Expression<int>? savingsAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (category != null) 'category': category,
      if (subcategory != null) 'subcategory': subcategory,
      if (itemName != null) 'item_name': itemName,
      if (amount != null) 'amount': amount,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fromSavings != null) 'from_savings': fromSavings,
      if (savingsAmount != null) 'savings_amount': savingsAmount,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<int>? cycleId,
    Value<String>? category,
    Value<String>? subcategory,
    Value<String>? itemName,
    Value<int>? amount,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? fromSavings,
    Value<int>? savingsAmount,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      itemName: itemName ?? this.itemName,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fromSavings: fromSavings ?? this.fromSavings,
      savingsAmount: savingsAmount ?? this.savingsAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (subcategory.present) {
      map['subcategory'] = Variable<String>(subcategory.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (fromSavings.present) {
      map['from_savings'] = Variable<bool>(fromSavings.value);
    }
    if (savingsAmount.present) {
      map['savings_amount'] = Variable<int>(savingsAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('category: $category, ')
          ..write('subcategory: $subcategory, ')
          ..write('itemName: $itemName, ')
          ..write('amount: $amount, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fromSavings: $fromSavings, ')
          ..write('savingsAmount: $savingsAmount')
          ..write(')'))
        .toString();
  }
}

class $AdditionalIncomesTable extends AdditionalIncomes
    with TableInfo<$AdditionalIncomesTable, AdditionalIncomeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdditionalIncomesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toSavingsMeta = const VerificationMeta(
    'toSavings',
  );
  @override
  late final GeneratedColumn<bool> toSavings = GeneratedColumn<bool>(
    'to_savings',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("to_savings" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleId,
    description,
    amount,
    toSavings,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'additional_incomes';
  @override
  VerificationContext validateIntegrity(
    Insertable<AdditionalIncomeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('to_savings')) {
      context.handle(
        _toSavingsMeta,
        toSavings.isAcceptableOrUnknown(data['to_savings']!, _toSavingsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdditionalIncomeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdditionalIncomeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      toSavings: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}to_savings'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AdditionalIncomesTable createAlias(String alias) {
    return $AdditionalIncomesTable(attachedDatabase, alias);
  }
}

class AdditionalIncomeRow extends DataClass
    implements Insertable<AdditionalIncomeRow> {
  final int id;
  final int cycleId;
  final String description;
  final int amount;
  final bool toSavings;
  final DateTime createdAt;
  const AdditionalIncomeRow({
    required this.id,
    required this.cycleId,
    required this.description,
    required this.amount,
    required this.toSavings,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cycle_id'] = Variable<int>(cycleId);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<int>(amount);
    map['to_savings'] = Variable<bool>(toSavings);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AdditionalIncomesCompanion toCompanion(bool nullToAbsent) {
    return AdditionalIncomesCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      description: Value(description),
      amount: Value(amount),
      toSavings: Value(toSavings),
      createdAt: Value(createdAt),
    );
  }

  factory AdditionalIncomeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdditionalIncomeRow(
      id: serializer.fromJson<int>(json['id']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<int>(json['amount']),
      toSavings: serializer.fromJson<bool>(json['toSavings']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cycleId': serializer.toJson<int>(cycleId),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<int>(amount),
      'toSavings': serializer.toJson<bool>(toSavings),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AdditionalIncomeRow copyWith({
    int? id,
    int? cycleId,
    String? description,
    int? amount,
    bool? toSavings,
    DateTime? createdAt,
  }) => AdditionalIncomeRow(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    description: description ?? this.description,
    amount: amount ?? this.amount,
    toSavings: toSavings ?? this.toSavings,
    createdAt: createdAt ?? this.createdAt,
  );
  AdditionalIncomeRow copyWithCompanion(AdditionalIncomesCompanion data) {
    return AdditionalIncomeRow(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      description: data.description.present
          ? data.description.value
          : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      toSavings: data.toSavings.present ? data.toSavings.value : this.toSavings,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdditionalIncomeRow(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('toSavings: $toSavings, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cycleId, description, amount, toSavings, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdditionalIncomeRow &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.toSavings == this.toSavings &&
          other.createdAt == this.createdAt);
}

class AdditionalIncomesCompanion extends UpdateCompanion<AdditionalIncomeRow> {
  final Value<int> id;
  final Value<int> cycleId;
  final Value<String> description;
  final Value<int> amount;
  final Value<bool> toSavings;
  final Value<DateTime> createdAt;
  const AdditionalIncomesCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.toSavings = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AdditionalIncomesCompanion.insert({
    this.id = const Value.absent(),
    required int cycleId,
    required String description,
    required int amount,
    this.toSavings = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : cycleId = Value(cycleId),
       description = Value(description),
       amount = Value(amount);
  static Insertable<AdditionalIncomeRow> custom({
    Expression<int>? id,
    Expression<int>? cycleId,
    Expression<String>? description,
    Expression<int>? amount,
    Expression<bool>? toSavings,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (toSavings != null) 'to_savings': toSavings,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AdditionalIncomesCompanion copyWith({
    Value<int>? id,
    Value<int>? cycleId,
    Value<String>? description,
    Value<int>? amount,
    Value<bool>? toSavings,
    Value<DateTime>? createdAt,
  }) {
    return AdditionalIncomesCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      toSavings: toSavings ?? this.toSavings,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (toSavings.present) {
      map['to_savings'] = Variable<bool>(toSavings.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdditionalIncomesCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('toSavings: $toSavings, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DebtsTable extends Debts with TableInfo<$DebtsTable, DebtRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _creditorNameMeta = const VerificationMeta(
    'creditorName',
  );
  @override
  late final GeneratedColumn<String> creditorName = GeneratedColumn<String>(
    'creditor_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAmountMeta = const VerificationMeta(
    'paidAmount',
  );
  @override
  late final GeneratedColumn<int> paidAmount = GeneratedColumn<int>(
    'paid_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFullyPaidMeta = const VerificationMeta(
    'isFullyPaid',
  );
  @override
  late final GeneratedColumn<bool> isFullyPaid = GeneratedColumn<bool>(
    'is_fully_paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_fully_paid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    creditorName,
    totalAmount,
    paidAmount,
    isFullyPaid,
    notes,
    createdAt,
    cycleId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DebtRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('creditor_name')) {
      context.handle(
        _creditorNameMeta,
        creditorName.isAcceptableOrUnknown(
          data['creditor_name']!,
          _creditorNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creditorNameMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
        _paidAmountMeta,
        paidAmount.isAcceptableOrUnknown(data['paid_amount']!, _paidAmountMeta),
      );
    }
    if (data.containsKey('is_fully_paid')) {
      context.handle(
        _isFullyPaidMeta,
        isFullyPaid.isAcceptableOrUnknown(
          data['is_fully_paid']!,
          _isFullyPaidMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebtRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      creditorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creditor_name'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount'],
      )!,
      paidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_amount'],
      )!,
      isFullyPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_fully_paid'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      ),
    );
  }

  @override
  $DebtsTable createAlias(String alias) {
    return $DebtsTable(attachedDatabase, alias);
  }
}

class DebtRow extends DataClass implements Insertable<DebtRow> {
  final int id;
  final String creditorName;
  final int totalAmount;
  final int paidAmount;
  final bool isFullyPaid;
  final String? notes;
  final DateTime createdAt;
  final int? cycleId;
  const DebtRow({
    required this.id,
    required this.creditorName,
    required this.totalAmount,
    required this.paidAmount,
    required this.isFullyPaid,
    this.notes,
    required this.createdAt,
    this.cycleId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['creditor_name'] = Variable<String>(creditorName);
    map['total_amount'] = Variable<int>(totalAmount);
    map['paid_amount'] = Variable<int>(paidAmount);
    map['is_fully_paid'] = Variable<bool>(isFullyPaid);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || cycleId != null) {
      map['cycle_id'] = Variable<int>(cycleId);
    }
    return map;
  }

  DebtsCompanion toCompanion(bool nullToAbsent) {
    return DebtsCompanion(
      id: Value(id),
      creditorName: Value(creditorName),
      totalAmount: Value(totalAmount),
      paidAmount: Value(paidAmount),
      isFullyPaid: Value(isFullyPaid),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      cycleId: cycleId == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleId),
    );
  }

  factory DebtRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtRow(
      id: serializer.fromJson<int>(json['id']),
      creditorName: serializer.fromJson<String>(json['creditorName']),
      totalAmount: serializer.fromJson<int>(json['totalAmount']),
      paidAmount: serializer.fromJson<int>(json['paidAmount']),
      isFullyPaid: serializer.fromJson<bool>(json['isFullyPaid']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      cycleId: serializer.fromJson<int?>(json['cycleId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'creditorName': serializer.toJson<String>(creditorName),
      'totalAmount': serializer.toJson<int>(totalAmount),
      'paidAmount': serializer.toJson<int>(paidAmount),
      'isFullyPaid': serializer.toJson<bool>(isFullyPaid),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'cycleId': serializer.toJson<int?>(cycleId),
    };
  }

  DebtRow copyWith({
    int? id,
    String? creditorName,
    int? totalAmount,
    int? paidAmount,
    bool? isFullyPaid,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    Value<int?> cycleId = const Value.absent(),
  }) => DebtRow(
    id: id ?? this.id,
    creditorName: creditorName ?? this.creditorName,
    totalAmount: totalAmount ?? this.totalAmount,
    paidAmount: paidAmount ?? this.paidAmount,
    isFullyPaid: isFullyPaid ?? this.isFullyPaid,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    cycleId: cycleId.present ? cycleId.value : this.cycleId,
  );
  DebtRow copyWithCompanion(DebtsCompanion data) {
    return DebtRow(
      id: data.id.present ? data.id.value : this.id,
      creditorName: data.creditorName.present
          ? data.creditorName.value
          : this.creditorName,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      paidAmount: data.paidAmount.present
          ? data.paidAmount.value
          : this.paidAmount,
      isFullyPaid: data.isFullyPaid.present
          ? data.isFullyPaid.value
          : this.isFullyPaid,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtRow(')
          ..write('id: $id, ')
          ..write('creditorName: $creditorName, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('isFullyPaid: $isFullyPaid, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('cycleId: $cycleId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    creditorName,
    totalAmount,
    paidAmount,
    isFullyPaid,
    notes,
    createdAt,
    cycleId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtRow &&
          other.id == this.id &&
          other.creditorName == this.creditorName &&
          other.totalAmount == this.totalAmount &&
          other.paidAmount == this.paidAmount &&
          other.isFullyPaid == this.isFullyPaid &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.cycleId == this.cycleId);
}

class DebtsCompanion extends UpdateCompanion<DebtRow> {
  final Value<int> id;
  final Value<String> creditorName;
  final Value<int> totalAmount;
  final Value<int> paidAmount;
  final Value<bool> isFullyPaid;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int?> cycleId;
  const DebtsCompanion({
    this.id = const Value.absent(),
    this.creditorName = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.isFullyPaid = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cycleId = const Value.absent(),
  });
  DebtsCompanion.insert({
    this.id = const Value.absent(),
    required String creditorName,
    required int totalAmount,
    this.paidAmount = const Value.absent(),
    this.isFullyPaid = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cycleId = const Value.absent(),
  }) : creditorName = Value(creditorName),
       totalAmount = Value(totalAmount);
  static Insertable<DebtRow> custom({
    Expression<int>? id,
    Expression<String>? creditorName,
    Expression<int>? totalAmount,
    Expression<int>? paidAmount,
    Expression<bool>? isFullyPaid,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? cycleId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creditorName != null) 'creditor_name': creditorName,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (isFullyPaid != null) 'is_fully_paid': isFullyPaid,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (cycleId != null) 'cycle_id': cycleId,
    });
  }

  DebtsCompanion copyWith({
    Value<int>? id,
    Value<String>? creditorName,
    Value<int>? totalAmount,
    Value<int>? paidAmount,
    Value<bool>? isFullyPaid,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int?>? cycleId,
  }) {
    return DebtsCompanion(
      id: id ?? this.id,
      creditorName: creditorName ?? this.creditorName,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      isFullyPaid: isFullyPaid ?? this.isFullyPaid,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      cycleId: cycleId ?? this.cycleId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (creditorName.present) {
      map['creditor_name'] = Variable<String>(creditorName.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<int>(paidAmount.value);
    }
    if (isFullyPaid.present) {
      map['is_fully_paid'] = Variable<bool>(isFullyPaid.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtsCompanion(')
          ..write('id: $id, ')
          ..write('creditorName: $creditorName, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('isFullyPaid: $isFullyPaid, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('cycleId: $cycleId')
          ..write(')'))
        .toString();
  }
}

class $DebtPaymentsTable extends DebtPayments
    with TableInfo<$DebtPaymentsTable, DebtPaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _debtIdMeta = const VerificationMeta('debtId');
  @override
  late final GeneratedColumn<int> debtId = GeneratedColumn<int>(
    'debt_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _fromSavingsMeta = const VerificationMeta(
    'fromSavings',
  );
  @override
  late final GeneratedColumn<bool> fromSavings = GeneratedColumn<bool>(
    'from_savings',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("from_savings" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _savingsAmountMeta = const VerificationMeta(
    'savingsAmount',
  );
  @override
  late final GeneratedColumn<int> savingsAmount = GeneratedColumn<int>(
    'savings_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    debtId,
    cycleId,
    amount,
    createdAt,
    fromSavings,
    savingsAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debt_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<DebtPaymentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('debt_id')) {
      context.handle(
        _debtIdMeta,
        debtId.isAcceptableOrUnknown(data['debt_id']!, _debtIdMeta),
      );
    } else if (isInserting) {
      context.missing(_debtIdMeta);
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('from_savings')) {
      context.handle(
        _fromSavingsMeta,
        fromSavings.isAcceptableOrUnknown(
          data['from_savings']!,
          _fromSavingsMeta,
        ),
      );
    }
    if (data.containsKey('savings_amount')) {
      context.handle(
        _savingsAmountMeta,
        savingsAmount.isAcceptableOrUnknown(
          data['savings_amount']!,
          _savingsAmountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebtPaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtPaymentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      debtId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}debt_id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      fromSavings: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}from_savings'],
      )!,
      savingsAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}savings_amount'],
      )!,
    );
  }

  @override
  $DebtPaymentsTable createAlias(String alias) {
    return $DebtPaymentsTable(attachedDatabase, alias);
  }
}

class DebtPaymentRow extends DataClass implements Insertable<DebtPaymentRow> {
  final int id;
  final int debtId;
  final int cycleId;
  final int amount;
  final DateTime createdAt;
  final bool fromSavings;
  final int savingsAmount;
  const DebtPaymentRow({
    required this.id,
    required this.debtId,
    required this.cycleId,
    required this.amount,
    required this.createdAt,
    required this.fromSavings,
    required this.savingsAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['debt_id'] = Variable<int>(debtId);
    map['cycle_id'] = Variable<int>(cycleId);
    map['amount'] = Variable<int>(amount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['from_savings'] = Variable<bool>(fromSavings);
    map['savings_amount'] = Variable<int>(savingsAmount);
    return map;
  }

  DebtPaymentsCompanion toCompanion(bool nullToAbsent) {
    return DebtPaymentsCompanion(
      id: Value(id),
      debtId: Value(debtId),
      cycleId: Value(cycleId),
      amount: Value(amount),
      createdAt: Value(createdAt),
      fromSavings: Value(fromSavings),
      savingsAmount: Value(savingsAmount),
    );
  }

  factory DebtPaymentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtPaymentRow(
      id: serializer.fromJson<int>(json['id']),
      debtId: serializer.fromJson<int>(json['debtId']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      amount: serializer.fromJson<int>(json['amount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      fromSavings: serializer.fromJson<bool>(json['fromSavings']),
      savingsAmount: serializer.fromJson<int>(json['savingsAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'debtId': serializer.toJson<int>(debtId),
      'cycleId': serializer.toJson<int>(cycleId),
      'amount': serializer.toJson<int>(amount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'fromSavings': serializer.toJson<bool>(fromSavings),
      'savingsAmount': serializer.toJson<int>(savingsAmount),
    };
  }

  DebtPaymentRow copyWith({
    int? id,
    int? debtId,
    int? cycleId,
    int? amount,
    DateTime? createdAt,
    bool? fromSavings,
    int? savingsAmount,
  }) => DebtPaymentRow(
    id: id ?? this.id,
    debtId: debtId ?? this.debtId,
    cycleId: cycleId ?? this.cycleId,
    amount: amount ?? this.amount,
    createdAt: createdAt ?? this.createdAt,
    fromSavings: fromSavings ?? this.fromSavings,
    savingsAmount: savingsAmount ?? this.savingsAmount,
  );
  DebtPaymentRow copyWithCompanion(DebtPaymentsCompanion data) {
    return DebtPaymentRow(
      id: data.id.present ? data.id.value : this.id,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      fromSavings: data.fromSavings.present
          ? data.fromSavings.value
          : this.fromSavings,
      savingsAmount: data.savingsAmount.present
          ? data.savingsAmount.value
          : this.savingsAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtPaymentRow(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('cycleId: $cycleId, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt, ')
          ..write('fromSavings: $fromSavings, ')
          ..write('savingsAmount: $savingsAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    debtId,
    cycleId,
    amount,
    createdAt,
    fromSavings,
    savingsAmount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtPaymentRow &&
          other.id == this.id &&
          other.debtId == this.debtId &&
          other.cycleId == this.cycleId &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt &&
          other.fromSavings == this.fromSavings &&
          other.savingsAmount == this.savingsAmount);
}

class DebtPaymentsCompanion extends UpdateCompanion<DebtPaymentRow> {
  final Value<int> id;
  final Value<int> debtId;
  final Value<int> cycleId;
  final Value<int> amount;
  final Value<DateTime> createdAt;
  final Value<bool> fromSavings;
  final Value<int> savingsAmount;
  const DebtPaymentsCompanion({
    this.id = const Value.absent(),
    this.debtId = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.fromSavings = const Value.absent(),
    this.savingsAmount = const Value.absent(),
  });
  DebtPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int debtId,
    required int cycleId,
    required int amount,
    this.createdAt = const Value.absent(),
    this.fromSavings = const Value.absent(),
    this.savingsAmount = const Value.absent(),
  }) : debtId = Value(debtId),
       cycleId = Value(cycleId),
       amount = Value(amount);
  static Insertable<DebtPaymentRow> custom({
    Expression<int>? id,
    Expression<int>? debtId,
    Expression<int>? cycleId,
    Expression<int>? amount,
    Expression<DateTime>? createdAt,
    Expression<bool>? fromSavings,
    Expression<int>? savingsAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (debtId != null) 'debt_id': debtId,
      if (cycleId != null) 'cycle_id': cycleId,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
      if (fromSavings != null) 'from_savings': fromSavings,
      if (savingsAmount != null) 'savings_amount': savingsAmount,
    });
  }

  DebtPaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? debtId,
    Value<int>? cycleId,
    Value<int>? amount,
    Value<DateTime>? createdAt,
    Value<bool>? fromSavings,
    Value<int>? savingsAmount,
  }) {
    return DebtPaymentsCompanion(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      cycleId: cycleId ?? this.cycleId,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      fromSavings: fromSavings ?? this.fromSavings,
      savingsAmount: savingsAmount ?? this.savingsAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (debtId.present) {
      map['debt_id'] = Variable<int>(debtId.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (fromSavings.present) {
      map['from_savings'] = Variable<bool>(fromSavings.value);
    }
    if (savingsAmount.present) {
      map['savings_amount'] = Variable<int>(savingsAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('cycleId: $cycleId, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt, ')
          ..write('fromSavings: $fromSavings, ')
          ..write('savingsAmount: $savingsAmount')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTable extends SavingsGoals
    with TableInfo<$SavingsGoalsTable, SavingsGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountMeta = const VerificationMeta(
    'targetAmount',
  );
  @override
  late final GeneratedColumn<int> targetAmount = GeneratedColumn<int>(
    'target_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedAmountMeta = const VerificationMeta(
    'savedAmount',
  );
  @override
  late final GeneratedColumn<int> savedAmount = GeneratedColumn<int>(
    'saved_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isAchievedMeta = const VerificationMeta(
    'isAchieved',
  );
  @override
  late final GeneratedColumn<bool> isAchieved = GeneratedColumn<bool>(
    'is_achieved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_achieved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    targetAmount,
    savedAmount,
    isAchieved,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(
          data['target_amount']!,
          _targetAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('saved_amount')) {
      context.handle(
        _savedAmountMeta,
        savedAmount.isAcceptableOrUnknown(
          data['saved_amount']!,
          _savedAmountMeta,
        ),
      );
    }
    if (data.containsKey('is_achieved')) {
      context.handle(
        _isAchievedMeta,
        isAchieved.isAcceptableOrUnknown(data['is_achieved']!, _isAchievedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_amount'],
      )!,
      savedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saved_amount'],
      )!,
      isAchieved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_achieved'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SavingsGoalsTable createAlias(String alias) {
    return $SavingsGoalsTable(attachedDatabase, alias);
  }
}

class SavingsGoalRow extends DataClass implements Insertable<SavingsGoalRow> {
  final int id;
  final String name;
  final int targetAmount;
  final int savedAmount;
  final bool isAchieved;
  final DateTime createdAt;
  const SavingsGoalRow({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.isAchieved,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['target_amount'] = Variable<int>(targetAmount);
    map['saved_amount'] = Variable<int>(savedAmount);
    map['is_achieved'] = Variable<bool>(isAchieved);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsCompanion(
      id: Value(id),
      name: Value(name),
      targetAmount: Value(targetAmount),
      savedAmount: Value(savedAmount),
      isAchieved: Value(isAchieved),
      createdAt: Value(createdAt),
    );
  }

  factory SavingsGoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoalRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetAmount: serializer.fromJson<int>(json['targetAmount']),
      savedAmount: serializer.fromJson<int>(json['savedAmount']),
      isAchieved: serializer.fromJson<bool>(json['isAchieved']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'targetAmount': serializer.toJson<int>(targetAmount),
      'savedAmount': serializer.toJson<int>(savedAmount),
      'isAchieved': serializer.toJson<bool>(isAchieved),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SavingsGoalRow copyWith({
    int? id,
    String? name,
    int? targetAmount,
    int? savedAmount,
    bool? isAchieved,
    DateTime? createdAt,
  }) => SavingsGoalRow(
    id: id ?? this.id,
    name: name ?? this.name,
    targetAmount: targetAmount ?? this.targetAmount,
    savedAmount: savedAmount ?? this.savedAmount,
    isAchieved: isAchieved ?? this.isAchieved,
    createdAt: createdAt ?? this.createdAt,
  );
  SavingsGoalRow copyWithCompanion(SavingsGoalsCompanion data) {
    return SavingsGoalRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      savedAmount: data.savedAmount.present
          ? data.savedAmount.value
          : this.savedAmount,
      isAchieved: data.isAchieved.present
          ? data.isAchieved.value
          : this.isAchieved,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('savedAmount: $savedAmount, ')
          ..write('isAchieved: $isAchieved, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, targetAmount, savedAmount, isAchieved, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoalRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetAmount == this.targetAmount &&
          other.savedAmount == this.savedAmount &&
          other.isAchieved == this.isAchieved &&
          other.createdAt == this.createdAt);
}

class SavingsGoalsCompanion extends UpdateCompanion<SavingsGoalRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> targetAmount;
  final Value<int> savedAmount;
  final Value<bool> isAchieved;
  final Value<DateTime> createdAt;
  const SavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.savedAmount = const Value.absent(),
    this.isAchieved = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavingsGoalsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int targetAmount,
    this.savedAmount = const Value.absent(),
    this.isAchieved = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       targetAmount = Value(targetAmount);
  static Insertable<SavingsGoalRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? targetAmount,
    Expression<int>? savedAmount,
    Expression<bool>? isAchieved,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (savedAmount != null) 'saved_amount': savedAmount,
      if (isAchieved != null) 'is_achieved': isAchieved,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavingsGoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? targetAmount,
    Value<int>? savedAmount,
    Value<bool>? isAchieved,
    Value<DateTime>? createdAt,
  }) {
    return SavingsGoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      isAchieved: isAchieved ?? this.isAchieved,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<int>(targetAmount.value);
    }
    if (savedAmount.present) {
      map['saved_amount'] = Variable<int>(savedAmount.value);
    }
    if (isAchieved.present) {
      map['is_achieved'] = Variable<bool>(isAchieved.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('savedAmount: $savedAmount, ')
          ..write('isAchieved: $isAchieved, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SavingsContributionsTable extends SavingsContributions
    with TableInfo<$SavingsContributionsTable, SavingsContributionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    cycleId,
    amount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_contributions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsContributionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsContributionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsContributionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SavingsContributionsTable createAlias(String alias) {
    return $SavingsContributionsTable(attachedDatabase, alias);
  }
}

class SavingsContributionRow extends DataClass
    implements Insertable<SavingsContributionRow> {
  final int id;
  final int goalId;
  final int cycleId;
  final int amount;
  final DateTime createdAt;
  const SavingsContributionRow({
    required this.id,
    required this.goalId,
    required this.cycleId,
    required this.amount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_id'] = Variable<int>(goalId);
    map['cycle_id'] = Variable<int>(cycleId);
    map['amount'] = Variable<int>(amount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavingsContributionsCompanion toCompanion(bool nullToAbsent) {
    return SavingsContributionsCompanion(
      id: Value(id),
      goalId: Value(goalId),
      cycleId: Value(cycleId),
      amount: Value(amount),
      createdAt: Value(createdAt),
    );
  }

  factory SavingsContributionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsContributionRow(
      id: serializer.fromJson<int>(json['id']),
      goalId: serializer.fromJson<int>(json['goalId']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      amount: serializer.fromJson<int>(json['amount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalId': serializer.toJson<int>(goalId),
      'cycleId': serializer.toJson<int>(cycleId),
      'amount': serializer.toJson<int>(amount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SavingsContributionRow copyWith({
    int? id,
    int? goalId,
    int? cycleId,
    int? amount,
    DateTime? createdAt,
  }) => SavingsContributionRow(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    cycleId: cycleId ?? this.cycleId,
    amount: amount ?? this.amount,
    createdAt: createdAt ?? this.createdAt,
  );
  SavingsContributionRow copyWithCompanion(SavingsContributionsCompanion data) {
    return SavingsContributionRow(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsContributionRow(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('cycleId: $cycleId, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, cycleId, amount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsContributionRow &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.cycleId == this.cycleId &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt);
}

class SavingsContributionsCompanion
    extends UpdateCompanion<SavingsContributionRow> {
  final Value<int> id;
  final Value<int> goalId;
  final Value<int> cycleId;
  final Value<int> amount;
  final Value<DateTime> createdAt;
  const SavingsContributionsCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavingsContributionsCompanion.insert({
    this.id = const Value.absent(),
    required int goalId,
    required int cycleId,
    required int amount,
    this.createdAt = const Value.absent(),
  }) : goalId = Value(goalId),
       cycleId = Value(cycleId),
       amount = Value(amount);
  static Insertable<SavingsContributionRow> custom({
    Expression<int>? id,
    Expression<int>? goalId,
    Expression<int>? cycleId,
    Expression<int>? amount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (cycleId != null) 'cycle_id': cycleId,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavingsContributionsCompanion copyWith({
    Value<int>? id,
    Value<int>? goalId,
    Value<int>? cycleId,
    Value<int>? amount,
    Value<DateTime>? createdAt,
  }) {
    return SavingsContributionsCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      cycleId: cycleId ?? this.cycleId,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsContributionsCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('cycleId: $cycleId, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WeeklyChallengesTable extends WeeklyChallenges
    with TableInfo<$WeeklyChallengesTable, WeeklyChallengeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyChallengesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekStartMeta = const VerificationMeta(
    'weekStart',
  );
  @override
  late final GeneratedColumn<DateTime> weekStart = GeneratedColumn<DateTime>(
    'week_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountMeta = const VerificationMeta(
    'targetAmount',
  );
  @override
  late final GeneratedColumn<int> targetAmount = GeneratedColumn<int>(
    'target_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleId,
    weekStart,
    targetAmount,
    description,
    isCompleted,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_challenges';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyChallengeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('week_start')) {
      context.handle(
        _weekStartMeta,
        weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta),
      );
    } else if (isInserting) {
      context.missing(_weekStartMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(
          data['target_amount']!,
          _targetAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyChallengeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyChallengeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      weekStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}week_start'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_amount'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WeeklyChallengesTable createAlias(String alias) {
    return $WeeklyChallengesTable(attachedDatabase, alias);
  }
}

class WeeklyChallengeRow extends DataClass
    implements Insertable<WeeklyChallengeRow> {
  final int id;
  final int cycleId;
  final DateTime weekStart;
  final int targetAmount;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  const WeeklyChallengeRow({
    required this.id,
    required this.cycleId,
    required this.weekStart,
    required this.targetAmount,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cycle_id'] = Variable<int>(cycleId);
    map['week_start'] = Variable<DateTime>(weekStart);
    map['target_amount'] = Variable<int>(targetAmount);
    map['description'] = Variable<String>(description);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WeeklyChallengesCompanion toCompanion(bool nullToAbsent) {
    return WeeklyChallengesCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      weekStart: Value(weekStart),
      targetAmount: Value(targetAmount),
      description: Value(description),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
    );
  }

  factory WeeklyChallengeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyChallengeRow(
      id: serializer.fromJson<int>(json['id']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      weekStart: serializer.fromJson<DateTime>(json['weekStart']),
      targetAmount: serializer.fromJson<int>(json['targetAmount']),
      description: serializer.fromJson<String>(json['description']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cycleId': serializer.toJson<int>(cycleId),
      'weekStart': serializer.toJson<DateTime>(weekStart),
      'targetAmount': serializer.toJson<int>(targetAmount),
      'description': serializer.toJson<String>(description),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WeeklyChallengeRow copyWith({
    int? id,
    int? cycleId,
    DateTime? weekStart,
    int? targetAmount,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) => WeeklyChallengeRow(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    weekStart: weekStart ?? this.weekStart,
    targetAmount: targetAmount ?? this.targetAmount,
    description: description ?? this.description,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
  );
  WeeklyChallengeRow copyWithCompanion(WeeklyChallengesCompanion data) {
    return WeeklyChallengeRow(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      description: data.description.present
          ? data.description.value
          : this.description,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyChallengeRow(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('weekStart: $weekStart, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cycleId,
    weekStart,
    targetAmount,
    description,
    isCompleted,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyChallengeRow &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.weekStart == this.weekStart &&
          other.targetAmount == this.targetAmount &&
          other.description == this.description &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt);
}

class WeeklyChallengesCompanion extends UpdateCompanion<WeeklyChallengeRow> {
  final Value<int> id;
  final Value<int> cycleId;
  final Value<DateTime> weekStart;
  final Value<int> targetAmount;
  final Value<String> description;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  const WeeklyChallengesCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WeeklyChallengesCompanion.insert({
    this.id = const Value.absent(),
    required int cycleId,
    required DateTime weekStart,
    required int targetAmount,
    required String description,
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : cycleId = Value(cycleId),
       weekStart = Value(weekStart),
       targetAmount = Value(targetAmount),
       description = Value(description);
  static Insertable<WeeklyChallengeRow> custom({
    Expression<int>? id,
    Expression<int>? cycleId,
    Expression<DateTime>? weekStart,
    Expression<int>? targetAmount,
    Expression<String>? description,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (weekStart != null) 'week_start': weekStart,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (description != null) 'description': description,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WeeklyChallengesCompanion copyWith({
    Value<int>? id,
    Value<int>? cycleId,
    Value<DateTime>? weekStart,
    Value<int>? targetAmount,
    Value<String>? description,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
  }) {
    return WeeklyChallengesCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      weekStart: weekStart ?? this.weekStart,
      targetAmount: targetAmount ?? this.targetAmount,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<DateTime>(weekStart.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<int>(targetAmount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyChallengesCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('weekStart: $weekStart, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FinancialInsightsTable extends FinancialInsights
    with TableInfo<$FinancialInsightsTable, FinancialInsightRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialInsightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _insightTypeMeta = const VerificationMeta(
    'insightType',
  );
  @override
  late final GeneratedColumn<String> insightType = GeneratedColumn<String>(
    'insight_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metricMeta = const VerificationMeta('metric');
  @override
  late final GeneratedColumn<String> metric = GeneratedColumn<String>(
    'metric',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _suggestionMeta = const VerificationMeta(
    'suggestion',
  );
  @override
  late final GeneratedColumn<String> suggestion = GeneratedColumn<String>(
    'suggestion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleId,
    insightType,
    category,
    metric,
    value,
    suggestion,
    createdAt,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_insights';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinancialInsightRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('insight_type')) {
      context.handle(
        _insightTypeMeta,
        insightType.isAcceptableOrUnknown(
          data['insight_type']!,
          _insightTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_insightTypeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('metric')) {
      context.handle(
        _metricMeta,
        metric.isAcceptableOrUnknown(data['metric']!, _metricMeta),
      );
    } else if (isInserting) {
      context.missing(_metricMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('suggestion')) {
      context.handle(
        _suggestionMeta,
        suggestion.isAcceptableOrUnknown(data['suggestion']!, _suggestionMeta),
      );
    } else if (isInserting) {
      context.missing(_suggestionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancialInsightRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialInsightRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      insightType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}insight_type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      metric: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      suggestion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggestion'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
    );
  }

  @override
  $FinancialInsightsTable createAlias(String alias) {
    return $FinancialInsightsTable(attachedDatabase, alias);
  }
}

class FinancialInsightRow extends DataClass
    implements Insertable<FinancialInsightRow> {
  final int id;
  final int cycleId;
  final String insightType;
  final String? category;
  final String metric;
  final double value;
  final String suggestion;
  final DateTime createdAt;
  final DateTime expiresAt;
  const FinancialInsightRow({
    required this.id,
    required this.cycleId,
    required this.insightType,
    this.category,
    required this.metric,
    required this.value,
    required this.suggestion,
    required this.createdAt,
    required this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cycle_id'] = Variable<int>(cycleId);
    map['insight_type'] = Variable<String>(insightType);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['metric'] = Variable<String>(metric);
    map['value'] = Variable<double>(value);
    map['suggestion'] = Variable<String>(suggestion);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    return map;
  }

  FinancialInsightsCompanion toCompanion(bool nullToAbsent) {
    return FinancialInsightsCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      insightType: Value(insightType),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      metric: Value(metric),
      value: Value(value),
      suggestion: Value(suggestion),
      createdAt: Value(createdAt),
      expiresAt: Value(expiresAt),
    );
  }

  factory FinancialInsightRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialInsightRow(
      id: serializer.fromJson<int>(json['id']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      insightType: serializer.fromJson<String>(json['insightType']),
      category: serializer.fromJson<String?>(json['category']),
      metric: serializer.fromJson<String>(json['metric']),
      value: serializer.fromJson<double>(json['value']),
      suggestion: serializer.fromJson<String>(json['suggestion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cycleId': serializer.toJson<int>(cycleId),
      'insightType': serializer.toJson<String>(insightType),
      'category': serializer.toJson<String?>(category),
      'metric': serializer.toJson<String>(metric),
      'value': serializer.toJson<double>(value),
      'suggestion': serializer.toJson<String>(suggestion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
    };
  }

  FinancialInsightRow copyWith({
    int? id,
    int? cycleId,
    String? insightType,
    Value<String?> category = const Value.absent(),
    String? metric,
    double? value,
    String? suggestion,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) => FinancialInsightRow(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    insightType: insightType ?? this.insightType,
    category: category.present ? category.value : this.category,
    metric: metric ?? this.metric,
    value: value ?? this.value,
    suggestion: suggestion ?? this.suggestion,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt ?? this.expiresAt,
  );
  FinancialInsightRow copyWithCompanion(FinancialInsightsCompanion data) {
    return FinancialInsightRow(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      insightType: data.insightType.present
          ? data.insightType.value
          : this.insightType,
      category: data.category.present ? data.category.value : this.category,
      metric: data.metric.present ? data.metric.value : this.metric,
      value: data.value.present ? data.value.value : this.value,
      suggestion: data.suggestion.present
          ? data.suggestion.value
          : this.suggestion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialInsightRow(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('insightType: $insightType, ')
          ..write('category: $category, ')
          ..write('metric: $metric, ')
          ..write('value: $value, ')
          ..write('suggestion: $suggestion, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cycleId,
    insightType,
    category,
    metric,
    value,
    suggestion,
    createdAt,
    expiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialInsightRow &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.insightType == this.insightType &&
          other.category == this.category &&
          other.metric == this.metric &&
          other.value == this.value &&
          other.suggestion == this.suggestion &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt);
}

class FinancialInsightsCompanion extends UpdateCompanion<FinancialInsightRow> {
  final Value<int> id;
  final Value<int> cycleId;
  final Value<String> insightType;
  final Value<String?> category;
  final Value<String> metric;
  final Value<double> value;
  final Value<String> suggestion;
  final Value<DateTime> createdAt;
  final Value<DateTime> expiresAt;
  const FinancialInsightsCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.insightType = const Value.absent(),
    this.category = const Value.absent(),
    this.metric = const Value.absent(),
    this.value = const Value.absent(),
    this.suggestion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
  });
  FinancialInsightsCompanion.insert({
    this.id = const Value.absent(),
    required int cycleId,
    required String insightType,
    this.category = const Value.absent(),
    required String metric,
    required double value,
    required String suggestion,
    this.createdAt = const Value.absent(),
    required DateTime expiresAt,
  }) : cycleId = Value(cycleId),
       insightType = Value(insightType),
       metric = Value(metric),
       value = Value(value),
       suggestion = Value(suggestion),
       expiresAt = Value(expiresAt);
  static Insertable<FinancialInsightRow> custom({
    Expression<int>? id,
    Expression<int>? cycleId,
    Expression<String>? insightType,
    Expression<String>? category,
    Expression<String>? metric,
    Expression<double>? value,
    Expression<String>? suggestion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (insightType != null) 'insight_type': insightType,
      if (category != null) 'category': category,
      if (metric != null) 'metric': metric,
      if (value != null) 'value': value,
      if (suggestion != null) 'suggestion': suggestion,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
    });
  }

  FinancialInsightsCompanion copyWith({
    Value<int>? id,
    Value<int>? cycleId,
    Value<String>? insightType,
    Value<String?>? category,
    Value<String>? metric,
    Value<double>? value,
    Value<String>? suggestion,
    Value<DateTime>? createdAt,
    Value<DateTime>? expiresAt,
  }) {
    return FinancialInsightsCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      insightType: insightType ?? this.insightType,
      category: category ?? this.category,
      metric: metric ?? this.metric,
      value: value ?? this.value,
      suggestion: suggestion ?? this.suggestion,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (insightType.present) {
      map['insight_type'] = Variable<String>(insightType.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (metric.present) {
      map['metric'] = Variable<String>(metric.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (suggestion.present) {
      map['suggestion'] = Variable<String>(suggestion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialInsightsCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('insightType: $insightType, ')
          ..write('category: $category, ')
          ..write('metric: $metric, ')
          ..write('value: $value, ')
          ..write('suggestion: $suggestion, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }
}

class $LicenseActivationsTable extends LicenseActivations
    with TableInfo<$LicenseActivationsTable, LicenseActivationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LicenseActivationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licenseKeyMeta = const VerificationMeta(
    'licenseKey',
  );
  @override
  late final GeneratedColumn<String> licenseKey = GeneratedColumn<String>(
    'license_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<String> expiryDate = GeneratedColumn<String>(
    'expiry_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activatedAtMeta = const VerificationMeta(
    'activatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> activatedAt = GeneratedColumn<DateTime>(
    'activated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    licenseKey,
    expiryDate,
    activatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'license_activations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LicenseActivationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('license_key')) {
      context.handle(
        _licenseKeyMeta,
        licenseKey.isAcceptableOrUnknown(data['license_key']!, _licenseKeyMeta),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    }
    if (data.containsKey('activated_at')) {
      context.handle(
        _activatedAtMeta,
        activatedAt.isAcceptableOrUnknown(
          data['activated_at']!,
          _activatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LicenseActivationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LicenseActivationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      licenseKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_key'],
      ),
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expiry_date'],
      ),
      activatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}activated_at'],
      ),
    );
  }

  @override
  $LicenseActivationsTable createAlias(String alias) {
    return $LicenseActivationsTable(attachedDatabase, alias);
  }
}

class LicenseActivationRow extends DataClass
    implements Insertable<LicenseActivationRow> {
  final int id;
  final String deviceId;
  final String? licenseKey;
  final String? expiryDate;
  final DateTime? activatedAt;
  const LicenseActivationRow({
    required this.id,
    required this.deviceId,
    this.licenseKey,
    this.expiryDate,
    this.activatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    if (!nullToAbsent || licenseKey != null) {
      map['license_key'] = Variable<String>(licenseKey);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<String>(expiryDate);
    }
    if (!nullToAbsent || activatedAt != null) {
      map['activated_at'] = Variable<DateTime>(activatedAt);
    }
    return map;
  }

  LicenseActivationsCompanion toCompanion(bool nullToAbsent) {
    return LicenseActivationsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      licenseKey: licenseKey == null && nullToAbsent
          ? const Value.absent()
          : Value(licenseKey),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      activatedAt: activatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(activatedAt),
    );
  }

  factory LicenseActivationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LicenseActivationRow(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      licenseKey: serializer.fromJson<String?>(json['licenseKey']),
      expiryDate: serializer.fromJson<String?>(json['expiryDate']),
      activatedAt: serializer.fromJson<DateTime?>(json['activatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'licenseKey': serializer.toJson<String?>(licenseKey),
      'expiryDate': serializer.toJson<String?>(expiryDate),
      'activatedAt': serializer.toJson<DateTime?>(activatedAt),
    };
  }

  LicenseActivationRow copyWith({
    int? id,
    String? deviceId,
    Value<String?> licenseKey = const Value.absent(),
    Value<String?> expiryDate = const Value.absent(),
    Value<DateTime?> activatedAt = const Value.absent(),
  }) => LicenseActivationRow(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    licenseKey: licenseKey.present ? licenseKey.value : this.licenseKey,
    expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
    activatedAt: activatedAt.present ? activatedAt.value : this.activatedAt,
  );
  LicenseActivationRow copyWithCompanion(LicenseActivationsCompanion data) {
    return LicenseActivationRow(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      licenseKey: data.licenseKey.present
          ? data.licenseKey.value
          : this.licenseKey,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      activatedAt: data.activatedAt.present
          ? data.activatedAt.value
          : this.activatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LicenseActivationRow(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('licenseKey: $licenseKey, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('activatedAt: $activatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, deviceId, licenseKey, expiryDate, activatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LicenseActivationRow &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.licenseKey == this.licenseKey &&
          other.expiryDate == this.expiryDate &&
          other.activatedAt == this.activatedAt);
}

class LicenseActivationsCompanion
    extends UpdateCompanion<LicenseActivationRow> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<String?> licenseKey;
  final Value<String?> expiryDate;
  final Value<DateTime?> activatedAt;
  const LicenseActivationsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.licenseKey = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.activatedAt = const Value.absent(),
  });
  LicenseActivationsCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    this.licenseKey = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.activatedAt = const Value.absent(),
  }) : deviceId = Value(deviceId);
  static Insertable<LicenseActivationRow> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<String>? licenseKey,
    Expression<String>? expiryDate,
    Expression<DateTime>? activatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (licenseKey != null) 'license_key': licenseKey,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (activatedAt != null) 'activated_at': activatedAt,
    });
  }

  LicenseActivationsCompanion copyWith({
    Value<int>? id,
    Value<String>? deviceId,
    Value<String?>? licenseKey,
    Value<String?>? expiryDate,
    Value<DateTime?>? activatedAt,
  }) {
    return LicenseActivationsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      licenseKey: licenseKey ?? this.licenseKey,
      expiryDate: expiryDate ?? this.expiryDate,
      activatedAt: activatedAt ?? this.activatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (licenseKey.present) {
      map['license_key'] = Variable<String>(licenseKey.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<String>(expiryDate.value);
    }
    if (activatedAt.present) {
      map['activated_at'] = Variable<DateTime>(activatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LicenseActivationsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('licenseKey: $licenseKey, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('activatedAt: $activatedAt')
          ..write(')'))
        .toString();
  }
}

class $SavingsHistoryTable extends SavingsHistory
    with TableInfo<$SavingsHistoryTable, SavingsHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relatedCycleIdMeta = const VerificationMeta(
    'relatedCycleId',
  );
  @override
  late final GeneratedColumn<int> relatedCycleId = GeneratedColumn<int>(
    'related_cycle_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relatedExpenseIdMeta = const VerificationMeta(
    'relatedExpenseId',
  );
  @override
  late final GeneratedColumn<int> relatedExpenseId = GeneratedColumn<int>(
    'related_expense_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relatedDebtPaymentIdMeta =
      const VerificationMeta('relatedDebtPaymentId');
  @override
  late final GeneratedColumn<int> relatedDebtPaymentId = GeneratedColumn<int>(
    'related_debt_payment_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relatedLendingIdMeta = const VerificationMeta(
    'relatedLendingId',
  );
  @override
  late final GeneratedColumn<int> relatedLendingId = GeneratedColumn<int>(
    'related_lending_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    amount,
    description,
    relatedCycleId,
    relatedExpenseId,
    relatedDebtPaymentId,
    relatedLendingId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('related_cycle_id')) {
      context.handle(
        _relatedCycleIdMeta,
        relatedCycleId.isAcceptableOrUnknown(
          data['related_cycle_id']!,
          _relatedCycleIdMeta,
        ),
      );
    }
    if (data.containsKey('related_expense_id')) {
      context.handle(
        _relatedExpenseIdMeta,
        relatedExpenseId.isAcceptableOrUnknown(
          data['related_expense_id']!,
          _relatedExpenseIdMeta,
        ),
      );
    }
    if (data.containsKey('related_debt_payment_id')) {
      context.handle(
        _relatedDebtPaymentIdMeta,
        relatedDebtPaymentId.isAcceptableOrUnknown(
          data['related_debt_payment_id']!,
          _relatedDebtPaymentIdMeta,
        ),
      );
    }
    if (data.containsKey('related_lending_id')) {
      context.handle(
        _relatedLendingIdMeta,
        relatedLendingId.isAcceptableOrUnknown(
          data['related_lending_id']!,
          _relatedLendingIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsHistoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      relatedCycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}related_cycle_id'],
      ),
      relatedExpenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}related_expense_id'],
      ),
      relatedDebtPaymentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}related_debt_payment_id'],
      ),
      relatedLendingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}related_lending_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SavingsHistoryTable createAlias(String alias) {
    return $SavingsHistoryTable(attachedDatabase, alias);
  }
}

class SavingsHistoryRow extends DataClass
    implements Insertable<SavingsHistoryRow> {
  final int id;
  final String type;
  final int amount;
  final String description;
  final int? relatedCycleId;
  final int? relatedExpenseId;
  final int? relatedDebtPaymentId;
  final int? relatedLendingId;
  final DateTime createdAt;
  const SavingsHistoryRow({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    this.relatedCycleId,
    this.relatedExpenseId,
    this.relatedDebtPaymentId,
    this.relatedLendingId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<int>(amount);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || relatedCycleId != null) {
      map['related_cycle_id'] = Variable<int>(relatedCycleId);
    }
    if (!nullToAbsent || relatedExpenseId != null) {
      map['related_expense_id'] = Variable<int>(relatedExpenseId);
    }
    if (!nullToAbsent || relatedDebtPaymentId != null) {
      map['related_debt_payment_id'] = Variable<int>(relatedDebtPaymentId);
    }
    if (!nullToAbsent || relatedLendingId != null) {
      map['related_lending_id'] = Variable<int>(relatedLendingId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavingsHistoryCompanion toCompanion(bool nullToAbsent) {
    return SavingsHistoryCompanion(
      id: Value(id),
      type: Value(type),
      amount: Value(amount),
      description: Value(description),
      relatedCycleId: relatedCycleId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedCycleId),
      relatedExpenseId: relatedExpenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedExpenseId),
      relatedDebtPaymentId: relatedDebtPaymentId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedDebtPaymentId),
      relatedLendingId: relatedLendingId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedLendingId),
      createdAt: Value(createdAt),
    );
  }

  factory SavingsHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsHistoryRow(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<int>(json['amount']),
      description: serializer.fromJson<String>(json['description']),
      relatedCycleId: serializer.fromJson<int?>(json['relatedCycleId']),
      relatedExpenseId: serializer.fromJson<int?>(json['relatedExpenseId']),
      relatedDebtPaymentId: serializer.fromJson<int?>(
        json['relatedDebtPaymentId'],
      ),
      relatedLendingId: serializer.fromJson<int?>(json['relatedLendingId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<int>(amount),
      'description': serializer.toJson<String>(description),
      'relatedCycleId': serializer.toJson<int?>(relatedCycleId),
      'relatedExpenseId': serializer.toJson<int?>(relatedExpenseId),
      'relatedDebtPaymentId': serializer.toJson<int?>(relatedDebtPaymentId),
      'relatedLendingId': serializer.toJson<int?>(relatedLendingId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SavingsHistoryRow copyWith({
    int? id,
    String? type,
    int? amount,
    String? description,
    Value<int?> relatedCycleId = const Value.absent(),
    Value<int?> relatedExpenseId = const Value.absent(),
    Value<int?> relatedDebtPaymentId = const Value.absent(),
    Value<int?> relatedLendingId = const Value.absent(),
    DateTime? createdAt,
  }) => SavingsHistoryRow(
    id: id ?? this.id,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    description: description ?? this.description,
    relatedCycleId: relatedCycleId.present
        ? relatedCycleId.value
        : this.relatedCycleId,
    relatedExpenseId: relatedExpenseId.present
        ? relatedExpenseId.value
        : this.relatedExpenseId,
    relatedDebtPaymentId: relatedDebtPaymentId.present
        ? relatedDebtPaymentId.value
        : this.relatedDebtPaymentId,
    relatedLendingId: relatedLendingId.present
        ? relatedLendingId.value
        : this.relatedLendingId,
    createdAt: createdAt ?? this.createdAt,
  );
  SavingsHistoryRow copyWithCompanion(SavingsHistoryCompanion data) {
    return SavingsHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      description: data.description.present
          ? data.description.value
          : this.description,
      relatedCycleId: data.relatedCycleId.present
          ? data.relatedCycleId.value
          : this.relatedCycleId,
      relatedExpenseId: data.relatedExpenseId.present
          ? data.relatedExpenseId.value
          : this.relatedExpenseId,
      relatedDebtPaymentId: data.relatedDebtPaymentId.present
          ? data.relatedDebtPaymentId.value
          : this.relatedDebtPaymentId,
      relatedLendingId: data.relatedLendingId.present
          ? data.relatedLendingId.value
          : this.relatedLendingId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsHistoryRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('relatedCycleId: $relatedCycleId, ')
          ..write('relatedExpenseId: $relatedExpenseId, ')
          ..write('relatedDebtPaymentId: $relatedDebtPaymentId, ')
          ..write('relatedLendingId: $relatedLendingId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    amount,
    description,
    relatedCycleId,
    relatedExpenseId,
    relatedDebtPaymentId,
    relatedLendingId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsHistoryRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.relatedCycleId == this.relatedCycleId &&
          other.relatedExpenseId == this.relatedExpenseId &&
          other.relatedDebtPaymentId == this.relatedDebtPaymentId &&
          other.relatedLendingId == this.relatedLendingId &&
          other.createdAt == this.createdAt);
}

class SavingsHistoryCompanion extends UpdateCompanion<SavingsHistoryRow> {
  final Value<int> id;
  final Value<String> type;
  final Value<int> amount;
  final Value<String> description;
  final Value<int?> relatedCycleId;
  final Value<int?> relatedExpenseId;
  final Value<int?> relatedDebtPaymentId;
  final Value<int?> relatedLendingId;
  final Value<DateTime> createdAt;
  const SavingsHistoryCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.relatedCycleId = const Value.absent(),
    this.relatedExpenseId = const Value.absent(),
    this.relatedDebtPaymentId = const Value.absent(),
    this.relatedLendingId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavingsHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required int amount,
    required String description,
    this.relatedCycleId = const Value.absent(),
    this.relatedExpenseId = const Value.absent(),
    this.relatedDebtPaymentId = const Value.absent(),
    this.relatedLendingId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : type = Value(type),
       amount = Value(amount),
       description = Value(description);
  static Insertable<SavingsHistoryRow> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? amount,
    Expression<String>? description,
    Expression<int>? relatedCycleId,
    Expression<int>? relatedExpenseId,
    Expression<int>? relatedDebtPaymentId,
    Expression<int>? relatedLendingId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (relatedCycleId != null) 'related_cycle_id': relatedCycleId,
      if (relatedExpenseId != null) 'related_expense_id': relatedExpenseId,
      if (relatedDebtPaymentId != null)
        'related_debt_payment_id': relatedDebtPaymentId,
      if (relatedLendingId != null) 'related_lending_id': relatedLendingId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavingsHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<int>? amount,
    Value<String>? description,
    Value<int?>? relatedCycleId,
    Value<int?>? relatedExpenseId,
    Value<int?>? relatedDebtPaymentId,
    Value<int?>? relatedLendingId,
    Value<DateTime>? createdAt,
  }) {
    return SavingsHistoryCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      relatedCycleId: relatedCycleId ?? this.relatedCycleId,
      relatedExpenseId: relatedExpenseId ?? this.relatedExpenseId,
      relatedDebtPaymentId: relatedDebtPaymentId ?? this.relatedDebtPaymentId,
      relatedLendingId: relatedLendingId ?? this.relatedLendingId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (relatedCycleId.present) {
      map['related_cycle_id'] = Variable<int>(relatedCycleId.value);
    }
    if (relatedExpenseId.present) {
      map['related_expense_id'] = Variable<int>(relatedExpenseId.value);
    }
    if (relatedDebtPaymentId.present) {
      map['related_debt_payment_id'] = Variable<int>(
        relatedDebtPaymentId.value,
      );
    }
    if (relatedLendingId.present) {
      map['related_lending_id'] = Variable<int>(relatedLendingId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsHistoryCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('relatedCycleId: $relatedCycleId, ')
          ..write('relatedExpenseId: $relatedExpenseId, ')
          ..write('relatedDebtPaymentId: $relatedDebtPaymentId, ')
          ..write('relatedLendingId: $relatedLendingId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LendingsTable extends Lendings
    with TableInfo<$LendingsTable, LendingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LendingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _borrowerNameMeta = const VerificationMeta(
    'borrowerName',
  );
  @override
  late final GeneratedColumn<String> borrowerName = GeneratedColumn<String>(
    'borrower_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _collectedAmountMeta = const VerificationMeta(
    'collectedAmount',
  );
  @override
  late final GeneratedColumn<int> collectedAmount = GeneratedColumn<int>(
    'collected_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFullyCollectedMeta = const VerificationMeta(
    'isFullyCollected',
  );
  @override
  late final GeneratedColumn<bool> isFullyCollected = GeneratedColumn<bool>(
    'is_fully_collected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_fully_collected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fromSavingsMeta = const VerificationMeta(
    'fromSavings',
  );
  @override
  late final GeneratedColumn<bool> fromSavings = GeneratedColumn<bool>(
    'from_savings',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("from_savings" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _savingsAmountMeta = const VerificationMeta(
    'savingsAmount',
  );
  @override
  late final GeneratedColumn<int> savingsAmount = GeneratedColumn<int>(
    'savings_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    borrowerName,
    totalAmount,
    collectedAmount,
    isFullyCollected,
    fromSavings,
    savingsAmount,
    cycleId,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lendings';
  @override
  VerificationContext validateIntegrity(
    Insertable<LendingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('borrower_name')) {
      context.handle(
        _borrowerNameMeta,
        borrowerName.isAcceptableOrUnknown(
          data['borrower_name']!,
          _borrowerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_borrowerNameMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('collected_amount')) {
      context.handle(
        _collectedAmountMeta,
        collectedAmount.isAcceptableOrUnknown(
          data['collected_amount']!,
          _collectedAmountMeta,
        ),
      );
    }
    if (data.containsKey('is_fully_collected')) {
      context.handle(
        _isFullyCollectedMeta,
        isFullyCollected.isAcceptableOrUnknown(
          data['is_fully_collected']!,
          _isFullyCollectedMeta,
        ),
      );
    }
    if (data.containsKey('from_savings')) {
      context.handle(
        _fromSavingsMeta,
        fromSavings.isAcceptableOrUnknown(
          data['from_savings']!,
          _fromSavingsMeta,
        ),
      );
    }
    if (data.containsKey('savings_amount')) {
      context.handle(
        _savingsAmountMeta,
        savingsAmount.isAcceptableOrUnknown(
          data['savings_amount']!,
          _savingsAmountMeta,
        ),
      );
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LendingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LendingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      borrowerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}borrower_name'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount'],
      )!,
      collectedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collected_amount'],
      )!,
      isFullyCollected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_fully_collected'],
      )!,
      fromSavings: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}from_savings'],
      )!,
      savingsAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}savings_amount'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LendingsTable createAlias(String alias) {
    return $LendingsTable(attachedDatabase, alias);
  }
}

class LendingRow extends DataClass implements Insertable<LendingRow> {
  final int id;
  final String borrowerName;
  final int totalAmount;
  final int collectedAmount;
  final bool isFullyCollected;
  final bool fromSavings;
  final int savingsAmount;
  final int cycleId;
  final String? notes;
  final DateTime createdAt;
  const LendingRow({
    required this.id,
    required this.borrowerName,
    required this.totalAmount,
    required this.collectedAmount,
    required this.isFullyCollected,
    required this.fromSavings,
    required this.savingsAmount,
    required this.cycleId,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['borrower_name'] = Variable<String>(borrowerName);
    map['total_amount'] = Variable<int>(totalAmount);
    map['collected_amount'] = Variable<int>(collectedAmount);
    map['is_fully_collected'] = Variable<bool>(isFullyCollected);
    map['from_savings'] = Variable<bool>(fromSavings);
    map['savings_amount'] = Variable<int>(savingsAmount);
    map['cycle_id'] = Variable<int>(cycleId);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LendingsCompanion toCompanion(bool nullToAbsent) {
    return LendingsCompanion(
      id: Value(id),
      borrowerName: Value(borrowerName),
      totalAmount: Value(totalAmount),
      collectedAmount: Value(collectedAmount),
      isFullyCollected: Value(isFullyCollected),
      fromSavings: Value(fromSavings),
      savingsAmount: Value(savingsAmount),
      cycleId: Value(cycleId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory LendingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LendingRow(
      id: serializer.fromJson<int>(json['id']),
      borrowerName: serializer.fromJson<String>(json['borrowerName']),
      totalAmount: serializer.fromJson<int>(json['totalAmount']),
      collectedAmount: serializer.fromJson<int>(json['collectedAmount']),
      isFullyCollected: serializer.fromJson<bool>(json['isFullyCollected']),
      fromSavings: serializer.fromJson<bool>(json['fromSavings']),
      savingsAmount: serializer.fromJson<int>(json['savingsAmount']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'borrowerName': serializer.toJson<String>(borrowerName),
      'totalAmount': serializer.toJson<int>(totalAmount),
      'collectedAmount': serializer.toJson<int>(collectedAmount),
      'isFullyCollected': serializer.toJson<bool>(isFullyCollected),
      'fromSavings': serializer.toJson<bool>(fromSavings),
      'savingsAmount': serializer.toJson<int>(savingsAmount),
      'cycleId': serializer.toJson<int>(cycleId),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LendingRow copyWith({
    int? id,
    String? borrowerName,
    int? totalAmount,
    int? collectedAmount,
    bool? isFullyCollected,
    bool? fromSavings,
    int? savingsAmount,
    int? cycleId,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => LendingRow(
    id: id ?? this.id,
    borrowerName: borrowerName ?? this.borrowerName,
    totalAmount: totalAmount ?? this.totalAmount,
    collectedAmount: collectedAmount ?? this.collectedAmount,
    isFullyCollected: isFullyCollected ?? this.isFullyCollected,
    fromSavings: fromSavings ?? this.fromSavings,
    savingsAmount: savingsAmount ?? this.savingsAmount,
    cycleId: cycleId ?? this.cycleId,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  LendingRow copyWithCompanion(LendingsCompanion data) {
    return LendingRow(
      id: data.id.present ? data.id.value : this.id,
      borrowerName: data.borrowerName.present
          ? data.borrowerName.value
          : this.borrowerName,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      collectedAmount: data.collectedAmount.present
          ? data.collectedAmount.value
          : this.collectedAmount,
      isFullyCollected: data.isFullyCollected.present
          ? data.isFullyCollected.value
          : this.isFullyCollected,
      fromSavings: data.fromSavings.present
          ? data.fromSavings.value
          : this.fromSavings,
      savingsAmount: data.savingsAmount.present
          ? data.savingsAmount.value
          : this.savingsAmount,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LendingRow(')
          ..write('id: $id, ')
          ..write('borrowerName: $borrowerName, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('collectedAmount: $collectedAmount, ')
          ..write('isFullyCollected: $isFullyCollected, ')
          ..write('fromSavings: $fromSavings, ')
          ..write('savingsAmount: $savingsAmount, ')
          ..write('cycleId: $cycleId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    borrowerName,
    totalAmount,
    collectedAmount,
    isFullyCollected,
    fromSavings,
    savingsAmount,
    cycleId,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LendingRow &&
          other.id == this.id &&
          other.borrowerName == this.borrowerName &&
          other.totalAmount == this.totalAmount &&
          other.collectedAmount == this.collectedAmount &&
          other.isFullyCollected == this.isFullyCollected &&
          other.fromSavings == this.fromSavings &&
          other.savingsAmount == this.savingsAmount &&
          other.cycleId == this.cycleId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class LendingsCompanion extends UpdateCompanion<LendingRow> {
  final Value<int> id;
  final Value<String> borrowerName;
  final Value<int> totalAmount;
  final Value<int> collectedAmount;
  final Value<bool> isFullyCollected;
  final Value<bool> fromSavings;
  final Value<int> savingsAmount;
  final Value<int> cycleId;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const LendingsCompanion({
    this.id = const Value.absent(),
    this.borrowerName = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.collectedAmount = const Value.absent(),
    this.isFullyCollected = const Value.absent(),
    this.fromSavings = const Value.absent(),
    this.savingsAmount = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LendingsCompanion.insert({
    this.id = const Value.absent(),
    required String borrowerName,
    required int totalAmount,
    this.collectedAmount = const Value.absent(),
    this.isFullyCollected = const Value.absent(),
    this.fromSavings = const Value.absent(),
    this.savingsAmount = const Value.absent(),
    required int cycleId,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : borrowerName = Value(borrowerName),
       totalAmount = Value(totalAmount),
       cycleId = Value(cycleId);
  static Insertable<LendingRow> custom({
    Expression<int>? id,
    Expression<String>? borrowerName,
    Expression<int>? totalAmount,
    Expression<int>? collectedAmount,
    Expression<bool>? isFullyCollected,
    Expression<bool>? fromSavings,
    Expression<int>? savingsAmount,
    Expression<int>? cycleId,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (borrowerName != null) 'borrower_name': borrowerName,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (collectedAmount != null) 'collected_amount': collectedAmount,
      if (isFullyCollected != null) 'is_fully_collected': isFullyCollected,
      if (fromSavings != null) 'from_savings': fromSavings,
      if (savingsAmount != null) 'savings_amount': savingsAmount,
      if (cycleId != null) 'cycle_id': cycleId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LendingsCompanion copyWith({
    Value<int>? id,
    Value<String>? borrowerName,
    Value<int>? totalAmount,
    Value<int>? collectedAmount,
    Value<bool>? isFullyCollected,
    Value<bool>? fromSavings,
    Value<int>? savingsAmount,
    Value<int>? cycleId,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return LendingsCompanion(
      id: id ?? this.id,
      borrowerName: borrowerName ?? this.borrowerName,
      totalAmount: totalAmount ?? this.totalAmount,
      collectedAmount: collectedAmount ?? this.collectedAmount,
      isFullyCollected: isFullyCollected ?? this.isFullyCollected,
      fromSavings: fromSavings ?? this.fromSavings,
      savingsAmount: savingsAmount ?? this.savingsAmount,
      cycleId: cycleId ?? this.cycleId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (borrowerName.present) {
      map['borrower_name'] = Variable<String>(borrowerName.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (collectedAmount.present) {
      map['collected_amount'] = Variable<int>(collectedAmount.value);
    }
    if (isFullyCollected.present) {
      map['is_fully_collected'] = Variable<bool>(isFullyCollected.value);
    }
    if (fromSavings.present) {
      map['from_savings'] = Variable<bool>(fromSavings.value);
    }
    if (savingsAmount.present) {
      map['savings_amount'] = Variable<int>(savingsAmount.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LendingsCompanion(')
          ..write('id: $id, ')
          ..write('borrowerName: $borrowerName, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('collectedAmount: $collectedAmount, ')
          ..write('isFullyCollected: $isFullyCollected, ')
          ..write('fromSavings: $fromSavings, ')
          ..write('savingsAmount: $savingsAmount, ')
          ..write('cycleId: $cycleId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LendingCollectionsTable extends LendingCollections
    with TableInfo<$LendingCollectionsTable, LendingCollectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LendingCollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _lendingIdMeta = const VerificationMeta(
    'lendingId',
  );
  @override
  late final GeneratedColumn<int> lendingId = GeneratedColumn<int>(
    'lending_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toSavingsMeta = const VerificationMeta(
    'toSavings',
  );
  @override
  late final GeneratedColumn<bool> toSavings = GeneratedColumn<bool>(
    'to_savings',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("to_savings" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lendingId,
    amount,
    toSavings,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lending_collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<LendingCollectionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lending_id')) {
      context.handle(
        _lendingIdMeta,
        lendingId.isAcceptableOrUnknown(data['lending_id']!, _lendingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lendingIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('to_savings')) {
      context.handle(
        _toSavingsMeta,
        toSavings.isAcceptableOrUnknown(data['to_savings']!, _toSavingsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LendingCollectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LendingCollectionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lendingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lending_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      toSavings: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}to_savings'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LendingCollectionsTable createAlias(String alias) {
    return $LendingCollectionsTable(attachedDatabase, alias);
  }
}

class LendingCollectionRow extends DataClass
    implements Insertable<LendingCollectionRow> {
  final int id;
  final int lendingId;
  final int amount;
  final bool toSavings;
  final DateTime createdAt;
  const LendingCollectionRow({
    required this.id,
    required this.lendingId,
    required this.amount,
    required this.toSavings,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lending_id'] = Variable<int>(lendingId);
    map['amount'] = Variable<int>(amount);
    map['to_savings'] = Variable<bool>(toSavings);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LendingCollectionsCompanion toCompanion(bool nullToAbsent) {
    return LendingCollectionsCompanion(
      id: Value(id),
      lendingId: Value(lendingId),
      amount: Value(amount),
      toSavings: Value(toSavings),
      createdAt: Value(createdAt),
    );
  }

  factory LendingCollectionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LendingCollectionRow(
      id: serializer.fromJson<int>(json['id']),
      lendingId: serializer.fromJson<int>(json['lendingId']),
      amount: serializer.fromJson<int>(json['amount']),
      toSavings: serializer.fromJson<bool>(json['toSavings']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lendingId': serializer.toJson<int>(lendingId),
      'amount': serializer.toJson<int>(amount),
      'toSavings': serializer.toJson<bool>(toSavings),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LendingCollectionRow copyWith({
    int? id,
    int? lendingId,
    int? amount,
    bool? toSavings,
    DateTime? createdAt,
  }) => LendingCollectionRow(
    id: id ?? this.id,
    lendingId: lendingId ?? this.lendingId,
    amount: amount ?? this.amount,
    toSavings: toSavings ?? this.toSavings,
    createdAt: createdAt ?? this.createdAt,
  );
  LendingCollectionRow copyWithCompanion(LendingCollectionsCompanion data) {
    return LendingCollectionRow(
      id: data.id.present ? data.id.value : this.id,
      lendingId: data.lendingId.present ? data.lendingId.value : this.lendingId,
      amount: data.amount.present ? data.amount.value : this.amount,
      toSavings: data.toSavings.present ? data.toSavings.value : this.toSavings,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LendingCollectionRow(')
          ..write('id: $id, ')
          ..write('lendingId: $lendingId, ')
          ..write('amount: $amount, ')
          ..write('toSavings: $toSavings, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lendingId, amount, toSavings, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LendingCollectionRow &&
          other.id == this.id &&
          other.lendingId == this.lendingId &&
          other.amount == this.amount &&
          other.toSavings == this.toSavings &&
          other.createdAt == this.createdAt);
}

class LendingCollectionsCompanion
    extends UpdateCompanion<LendingCollectionRow> {
  final Value<int> id;
  final Value<int> lendingId;
  final Value<int> amount;
  final Value<bool> toSavings;
  final Value<DateTime> createdAt;
  const LendingCollectionsCompanion({
    this.id = const Value.absent(),
    this.lendingId = const Value.absent(),
    this.amount = const Value.absent(),
    this.toSavings = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LendingCollectionsCompanion.insert({
    this.id = const Value.absent(),
    required int lendingId,
    required int amount,
    this.toSavings = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : lendingId = Value(lendingId),
       amount = Value(amount);
  static Insertable<LendingCollectionRow> custom({
    Expression<int>? id,
    Expression<int>? lendingId,
    Expression<int>? amount,
    Expression<bool>? toSavings,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lendingId != null) 'lending_id': lendingId,
      if (amount != null) 'amount': amount,
      if (toSavings != null) 'to_savings': toSavings,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LendingCollectionsCompanion copyWith({
    Value<int>? id,
    Value<int>? lendingId,
    Value<int>? amount,
    Value<bool>? toSavings,
    Value<DateTime>? createdAt,
  }) {
    return LendingCollectionsCompanion(
      id: id ?? this.id,
      lendingId: lendingId ?? this.lendingId,
      amount: amount ?? this.amount,
      toSavings: toSavings ?? this.toSavings,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lendingId.present) {
      map['lending_id'] = Variable<int>(lendingId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (toSavings.present) {
      map['to_savings'] = Variable<bool>(toSavings.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LendingCollectionsCompanion(')
          ..write('id: $id, ')
          ..write('lendingId: $lendingId, ')
          ..write('amount: $amount, ')
          ..write('toSavings: $toSavings, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $FinancialCyclesTable financialCycles = $FinancialCyclesTable(
    this,
  );
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $AdditionalIncomesTable additionalIncomes =
      $AdditionalIncomesTable(this);
  late final $DebtsTable debts = $DebtsTable(this);
  late final $DebtPaymentsTable debtPayments = $DebtPaymentsTable(this);
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $SavingsContributionsTable savingsContributions =
      $SavingsContributionsTable(this);
  late final $WeeklyChallengesTable weeklyChallenges = $WeeklyChallengesTable(
    this,
  );
  late final $FinancialInsightsTable financialInsights =
      $FinancialInsightsTable(this);
  late final $LicenseActivationsTable licenseActivations =
      $LicenseActivationsTable(this);
  late final $SavingsHistoryTable savingsHistory = $SavingsHistoryTable(this);
  late final $LendingsTable lendings = $LendingsTable(this);
  late final $LendingCollectionsTable lendingCollections =
      $LendingCollectionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    financialCycles,
    expenses,
    additionalIncomes,
    debts,
    debtPayments,
    savingsGoals,
    savingsContributions,
    weeklyChallenges,
    financialInsights,
    licenseActivations,
    savingsHistory,
    lendings,
    lendingCollections,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required int monthlySalary,
      required int salaryDay,
      Value<String> fullName,
      Value<String> phoneNumber,
      Value<int> wilayaCode,
      Value<bool> isActivated,
      Value<bool> challengesEnabled,
      Value<DateTime> createdAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<int> monthlySalary,
      Value<int> salaryDay,
      Value<String> fullName,
      Value<String> phoneNumber,
      Value<int> wilayaCode,
      Value<bool> isActivated,
      Value<bool> challengesEnabled,
      Value<DateTime> createdAt,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlySalary => $composableBuilder(
    column: $table.monthlySalary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get salaryDay => $composableBuilder(
    column: $table.salaryDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wilayaCode => $composableBuilder(
    column: $table.wilayaCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActivated => $composableBuilder(
    column: $table.isActivated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get challengesEnabled => $composableBuilder(
    column: $table.challengesEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlySalary => $composableBuilder(
    column: $table.monthlySalary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salaryDay => $composableBuilder(
    column: $table.salaryDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wilayaCode => $composableBuilder(
    column: $table.wilayaCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActivated => $composableBuilder(
    column: $table.isActivated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get challengesEnabled => $composableBuilder(
    column: $table.challengesEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get monthlySalary => $composableBuilder(
    column: $table.monthlySalary,
    builder: (column) => column,
  );

  GeneratedColumn<int> get salaryDay =>
      $composableBuilder(column: $table.salaryDay, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wilayaCode => $composableBuilder(
    column: $table.wilayaCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActivated => $composableBuilder(
    column: $table.isActivated,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get challengesEnabled => $composableBuilder(
    column: $table.challengesEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          UserRow,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (UserRow, BaseReferences<_$AppDatabase, $UsersTable, UserRow>),
          UserRow,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> monthlySalary = const Value.absent(),
                Value<int> salaryDay = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<int> wilayaCode = const Value.absent(),
                Value<bool> isActivated = const Value.absent(),
                Value<bool> challengesEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                monthlySalary: monthlySalary,
                salaryDay: salaryDay,
                fullName: fullName,
                phoneNumber: phoneNumber,
                wilayaCode: wilayaCode,
                isActivated: isActivated,
                challengesEnabled: challengesEnabled,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int monthlySalary,
                required int salaryDay,
                Value<String> fullName = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<int> wilayaCode = const Value.absent(),
                Value<bool> isActivated = const Value.absent(),
                Value<bool> challengesEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                monthlySalary: monthlySalary,
                salaryDay: salaryDay,
                fullName: fullName,
                phoneNumber: phoneNumber,
                wilayaCode: wilayaCode,
                isActivated: isActivated,
                challengesEnabled: challengesEnabled,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      UserRow,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (UserRow, BaseReferences<_$AppDatabase, $UsersTable, UserRow>),
      UserRow,
      PrefetchHooks Function()
    >;
typedef $$FinancialCyclesTableCreateCompanionBuilder =
    FinancialCyclesCompanion Function({
      Value<int> id,
      required DateTime startDate,
      required DateTime endDate,
      required int salaryAmount,
      Value<int> salarySplitAmount,
      Value<bool> isActive,
    });
typedef $$FinancialCyclesTableUpdateCompanionBuilder =
    FinancialCyclesCompanion Function({
      Value<int> id,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> salaryAmount,
      Value<int> salarySplitAmount,
      Value<bool> isActive,
    });

class $$FinancialCyclesTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialCyclesTable> {
  $$FinancialCyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get salaryAmount => $composableBuilder(
    column: $table.salaryAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get salarySplitAmount => $composableBuilder(
    column: $table.salarySplitAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FinancialCyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialCyclesTable> {
  $$FinancialCyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salaryAmount => $composableBuilder(
    column: $table.salaryAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salarySplitAmount => $composableBuilder(
    column: $table.salarySplitAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FinancialCyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialCyclesTable> {
  $$FinancialCyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get salaryAmount => $composableBuilder(
    column: $table.salaryAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get salarySplitAmount => $composableBuilder(
    column: $table.salarySplitAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$FinancialCyclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinancialCyclesTable,
          FinancialCycleRow,
          $$FinancialCyclesTableFilterComposer,
          $$FinancialCyclesTableOrderingComposer,
          $$FinancialCyclesTableAnnotationComposer,
          $$FinancialCyclesTableCreateCompanionBuilder,
          $$FinancialCyclesTableUpdateCompanionBuilder,
          (
            FinancialCycleRow,
            BaseReferences<
              _$AppDatabase,
              $FinancialCyclesTable,
              FinancialCycleRow
            >,
          ),
          FinancialCycleRow,
          PrefetchHooks Function()
        > {
  $$FinancialCyclesTableTableManager(
    _$AppDatabase db,
    $FinancialCyclesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialCyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialCyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancialCyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> salaryAmount = const Value.absent(),
                Value<int> salarySplitAmount = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => FinancialCyclesCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                salaryAmount: salaryAmount,
                salarySplitAmount: salarySplitAmount,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                required int salaryAmount,
                Value<int> salarySplitAmount = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => FinancialCyclesCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                salaryAmount: salaryAmount,
                salarySplitAmount: salarySplitAmount,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FinancialCyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinancialCyclesTable,
      FinancialCycleRow,
      $$FinancialCyclesTableFilterComposer,
      $$FinancialCyclesTableOrderingComposer,
      $$FinancialCyclesTableAnnotationComposer,
      $$FinancialCyclesTableCreateCompanionBuilder,
      $$FinancialCyclesTableUpdateCompanionBuilder,
      (
        FinancialCycleRow,
        BaseReferences<_$AppDatabase, $FinancialCyclesTable, FinancialCycleRow>,
      ),
      FinancialCycleRow,
      PrefetchHooks Function()
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required int cycleId,
      required String category,
      required String subcategory,
      required String itemName,
      required int amount,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> fromSavings,
      Value<int> savingsAmount,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<int> cycleId,
      Value<String> category,
      Value<String> subcategory,
      Value<String> itemName,
      Value<int> amount,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> fromSavings,
      Value<int> savingsAmount,
    });

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fromSavings => $composableBuilder(
    column: $table.fromSavings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savingsAmount => $composableBuilder(
    column: $table.savingsAmount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fromSavings => $composableBuilder(
    column: $table.fromSavings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savingsAmount => $composableBuilder(
    column: $table.savingsAmount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get fromSavings => $composableBuilder(
    column: $table.fromSavings,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savingsAmount => $composableBuilder(
    column: $table.savingsAmount,
    builder: (column) => column,
  );
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          ExpenseRow,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (
            ExpenseRow,
            BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow>,
          ),
          ExpenseRow,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> subcategory = const Value.absent(),
                Value<String> itemName = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> fromSavings = const Value.absent(),
                Value<int> savingsAmount = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                cycleId: cycleId,
                category: category,
                subcategory: subcategory,
                itemName: itemName,
                amount: amount,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fromSavings: fromSavings,
                savingsAmount: savingsAmount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cycleId,
                required String category,
                required String subcategory,
                required String itemName,
                required int amount,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> fromSavings = const Value.absent(),
                Value<int> savingsAmount = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                cycleId: cycleId,
                category: category,
                subcategory: subcategory,
                itemName: itemName,
                amount: amount,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fromSavings: fromSavings,
                savingsAmount: savingsAmount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      ExpenseRow,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (ExpenseRow, BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow>),
      ExpenseRow,
      PrefetchHooks Function()
    >;
typedef $$AdditionalIncomesTableCreateCompanionBuilder =
    AdditionalIncomesCompanion Function({
      Value<int> id,
      required int cycleId,
      required String description,
      required int amount,
      Value<bool> toSavings,
      Value<DateTime> createdAt,
    });
typedef $$AdditionalIncomesTableUpdateCompanionBuilder =
    AdditionalIncomesCompanion Function({
      Value<int> id,
      Value<int> cycleId,
      Value<String> description,
      Value<int> amount,
      Value<bool> toSavings,
      Value<DateTime> createdAt,
    });

class $$AdditionalIncomesTableFilterComposer
    extends Composer<_$AppDatabase, $AdditionalIncomesTable> {
  $$AdditionalIncomesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get toSavings => $composableBuilder(
    column: $table.toSavings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AdditionalIncomesTableOrderingComposer
    extends Composer<_$AppDatabase, $AdditionalIncomesTable> {
  $$AdditionalIncomesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get toSavings => $composableBuilder(
    column: $table.toSavings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AdditionalIncomesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AdditionalIncomesTable> {
  $$AdditionalIncomesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<bool> get toSavings =>
      $composableBuilder(column: $table.toSavings, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AdditionalIncomesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AdditionalIncomesTable,
          AdditionalIncomeRow,
          $$AdditionalIncomesTableFilterComposer,
          $$AdditionalIncomesTableOrderingComposer,
          $$AdditionalIncomesTableAnnotationComposer,
          $$AdditionalIncomesTableCreateCompanionBuilder,
          $$AdditionalIncomesTableUpdateCompanionBuilder,
          (
            AdditionalIncomeRow,
            BaseReferences<
              _$AppDatabase,
              $AdditionalIncomesTable,
              AdditionalIncomeRow
            >,
          ),
          AdditionalIncomeRow,
          PrefetchHooks Function()
        > {
  $$AdditionalIncomesTableTableManager(
    _$AppDatabase db,
    $AdditionalIncomesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdditionalIncomesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdditionalIncomesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AdditionalIncomesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<bool> toSavings = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AdditionalIncomesCompanion(
                id: id,
                cycleId: cycleId,
                description: description,
                amount: amount,
                toSavings: toSavings,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cycleId,
                required String description,
                required int amount,
                Value<bool> toSavings = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AdditionalIncomesCompanion.insert(
                id: id,
                cycleId: cycleId,
                description: description,
                amount: amount,
                toSavings: toSavings,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AdditionalIncomesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AdditionalIncomesTable,
      AdditionalIncomeRow,
      $$AdditionalIncomesTableFilterComposer,
      $$AdditionalIncomesTableOrderingComposer,
      $$AdditionalIncomesTableAnnotationComposer,
      $$AdditionalIncomesTableCreateCompanionBuilder,
      $$AdditionalIncomesTableUpdateCompanionBuilder,
      (
        AdditionalIncomeRow,
        BaseReferences<
          _$AppDatabase,
          $AdditionalIncomesTable,
          AdditionalIncomeRow
        >,
      ),
      AdditionalIncomeRow,
      PrefetchHooks Function()
    >;
typedef $$DebtsTableCreateCompanionBuilder =
    DebtsCompanion Function({
      Value<int> id,
      required String creditorName,
      required int totalAmount,
      Value<int> paidAmount,
      Value<bool> isFullyPaid,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int?> cycleId,
    });
typedef $$DebtsTableUpdateCompanionBuilder =
    DebtsCompanion Function({
      Value<int> id,
      Value<String> creditorName,
      Value<int> totalAmount,
      Value<int> paidAmount,
      Value<bool> isFullyPaid,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int?> cycleId,
    });

class $$DebtsTableFilterComposer extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creditorName => $composableBuilder(
    column: $table.creditorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFullyPaid => $composableBuilder(
    column: $table.isFullyPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DebtsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creditorName => $composableBuilder(
    column: $table.creditorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFullyPaid => $composableBuilder(
    column: $table.isFullyPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get creditorName => $composableBuilder(
    column: $table.creditorName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFullyPaid => $composableBuilder(
    column: $table.isFullyPaid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);
}

class $$DebtsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebtsTable,
          DebtRow,
          $$DebtsTableFilterComposer,
          $$DebtsTableOrderingComposer,
          $$DebtsTableAnnotationComposer,
          $$DebtsTableCreateCompanionBuilder,
          $$DebtsTableUpdateCompanionBuilder,
          (DebtRow, BaseReferences<_$AppDatabase, $DebtsTable, DebtRow>),
          DebtRow,
          PrefetchHooks Function()
        > {
  $$DebtsTableTableManager(_$AppDatabase db, $DebtsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> creditorName = const Value.absent(),
                Value<int> totalAmount = const Value.absent(),
                Value<int> paidAmount = const Value.absent(),
                Value<bool> isFullyPaid = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> cycleId = const Value.absent(),
              }) => DebtsCompanion(
                id: id,
                creditorName: creditorName,
                totalAmount: totalAmount,
                paidAmount: paidAmount,
                isFullyPaid: isFullyPaid,
                notes: notes,
                createdAt: createdAt,
                cycleId: cycleId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String creditorName,
                required int totalAmount,
                Value<int> paidAmount = const Value.absent(),
                Value<bool> isFullyPaid = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> cycleId = const Value.absent(),
              }) => DebtsCompanion.insert(
                id: id,
                creditorName: creditorName,
                totalAmount: totalAmount,
                paidAmount: paidAmount,
                isFullyPaid: isFullyPaid,
                notes: notes,
                createdAt: createdAt,
                cycleId: cycleId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DebtsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebtsTable,
      DebtRow,
      $$DebtsTableFilterComposer,
      $$DebtsTableOrderingComposer,
      $$DebtsTableAnnotationComposer,
      $$DebtsTableCreateCompanionBuilder,
      $$DebtsTableUpdateCompanionBuilder,
      (DebtRow, BaseReferences<_$AppDatabase, $DebtsTable, DebtRow>),
      DebtRow,
      PrefetchHooks Function()
    >;
typedef $$DebtPaymentsTableCreateCompanionBuilder =
    DebtPaymentsCompanion Function({
      Value<int> id,
      required int debtId,
      required int cycleId,
      required int amount,
      Value<DateTime> createdAt,
      Value<bool> fromSavings,
      Value<int> savingsAmount,
    });
typedef $$DebtPaymentsTableUpdateCompanionBuilder =
    DebtPaymentsCompanion Function({
      Value<int> id,
      Value<int> debtId,
      Value<int> cycleId,
      Value<int> amount,
      Value<DateTime> createdAt,
      Value<bool> fromSavings,
      Value<int> savingsAmount,
    });

class $$DebtPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $DebtPaymentsTable> {
  $$DebtPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get debtId => $composableBuilder(
    column: $table.debtId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fromSavings => $composableBuilder(
    column: $table.fromSavings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savingsAmount => $composableBuilder(
    column: $table.savingsAmount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DebtPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtPaymentsTable> {
  $$DebtPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get debtId => $composableBuilder(
    column: $table.debtId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fromSavings => $composableBuilder(
    column: $table.fromSavings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savingsAmount => $composableBuilder(
    column: $table.savingsAmount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebtPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtPaymentsTable> {
  $$DebtPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get debtId =>
      $composableBuilder(column: $table.debtId, builder: (column) => column);

  GeneratedColumn<int> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get fromSavings => $composableBuilder(
    column: $table.fromSavings,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savingsAmount => $composableBuilder(
    column: $table.savingsAmount,
    builder: (column) => column,
  );
}

class $$DebtPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebtPaymentsTable,
          DebtPaymentRow,
          $$DebtPaymentsTableFilterComposer,
          $$DebtPaymentsTableOrderingComposer,
          $$DebtPaymentsTableAnnotationComposer,
          $$DebtPaymentsTableCreateCompanionBuilder,
          $$DebtPaymentsTableUpdateCompanionBuilder,
          (
            DebtPaymentRow,
            BaseReferences<_$AppDatabase, $DebtPaymentsTable, DebtPaymentRow>,
          ),
          DebtPaymentRow,
          PrefetchHooks Function()
        > {
  $$DebtPaymentsTableTableManager(_$AppDatabase db, $DebtPaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> debtId = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> fromSavings = const Value.absent(),
                Value<int> savingsAmount = const Value.absent(),
              }) => DebtPaymentsCompanion(
                id: id,
                debtId: debtId,
                cycleId: cycleId,
                amount: amount,
                createdAt: createdAt,
                fromSavings: fromSavings,
                savingsAmount: savingsAmount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int debtId,
                required int cycleId,
                required int amount,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> fromSavings = const Value.absent(),
                Value<int> savingsAmount = const Value.absent(),
              }) => DebtPaymentsCompanion.insert(
                id: id,
                debtId: debtId,
                cycleId: cycleId,
                amount: amount,
                createdAt: createdAt,
                fromSavings: fromSavings,
                savingsAmount: savingsAmount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DebtPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebtPaymentsTable,
      DebtPaymentRow,
      $$DebtPaymentsTableFilterComposer,
      $$DebtPaymentsTableOrderingComposer,
      $$DebtPaymentsTableAnnotationComposer,
      $$DebtPaymentsTableCreateCompanionBuilder,
      $$DebtPaymentsTableUpdateCompanionBuilder,
      (
        DebtPaymentRow,
        BaseReferences<_$AppDatabase, $DebtPaymentsTable, DebtPaymentRow>,
      ),
      DebtPaymentRow,
      PrefetchHooks Function()
    >;
typedef $$SavingsGoalsTableCreateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      required String name,
      required int targetAmount,
      Value<int> savedAmount,
      Value<bool> isAchieved,
      Value<DateTime> createdAt,
    });
typedef $$SavingsGoalsTableUpdateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> targetAmount,
      Value<int> savedAmount,
      Value<bool> isAchieved,
      Value<DateTime> createdAt,
    });

class $$SavingsGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savedAmount => $composableBuilder(
    column: $table.savedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAchieved => $composableBuilder(
    column: $table.isAchieved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savedAmount => $composableBuilder(
    column: $table.savedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAchieved => $composableBuilder(
    column: $table.isAchieved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savedAmount => $composableBuilder(
    column: $table.savedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAchieved => $composableBuilder(
    column: $table.isAchieved,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavingsGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsGoalsTable,
          SavingsGoalRow,
          $$SavingsGoalsTableFilterComposer,
          $$SavingsGoalsTableOrderingComposer,
          $$SavingsGoalsTableAnnotationComposer,
          $$SavingsGoalsTableCreateCompanionBuilder,
          $$SavingsGoalsTableUpdateCompanionBuilder,
          (
            SavingsGoalRow,
            BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoalRow>,
          ),
          SavingsGoalRow,
          PrefetchHooks Function()
        > {
  $$SavingsGoalsTableTableManager(_$AppDatabase db, $SavingsGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetAmount = const Value.absent(),
                Value<int> savedAmount = const Value.absent(),
                Value<bool> isAchieved = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavingsGoalsCompanion(
                id: id,
                name: name,
                targetAmount: targetAmount,
                savedAmount: savedAmount,
                isAchieved: isAchieved,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int targetAmount,
                Value<int> savedAmount = const Value.absent(),
                Value<bool> isAchieved = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavingsGoalsCompanion.insert(
                id: id,
                name: name,
                targetAmount: targetAmount,
                savedAmount: savedAmount,
                isAchieved: isAchieved,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsGoalsTable,
      SavingsGoalRow,
      $$SavingsGoalsTableFilterComposer,
      $$SavingsGoalsTableOrderingComposer,
      $$SavingsGoalsTableAnnotationComposer,
      $$SavingsGoalsTableCreateCompanionBuilder,
      $$SavingsGoalsTableUpdateCompanionBuilder,
      (
        SavingsGoalRow,
        BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoalRow>,
      ),
      SavingsGoalRow,
      PrefetchHooks Function()
    >;
typedef $$SavingsContributionsTableCreateCompanionBuilder =
    SavingsContributionsCompanion Function({
      Value<int> id,
      required int goalId,
      required int cycleId,
      required int amount,
      Value<DateTime> createdAt,
    });
typedef $$SavingsContributionsTableUpdateCompanionBuilder =
    SavingsContributionsCompanion Function({
      Value<int> id,
      Value<int> goalId,
      Value<int> cycleId,
      Value<int> amount,
      Value<DateTime> createdAt,
    });

class $$SavingsContributionsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsContributionsTable> {
  $$SavingsContributionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsContributionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsContributionsTable> {
  $$SavingsContributionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsContributionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsContributionsTable> {
  $$SavingsContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<int> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavingsContributionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsContributionsTable,
          SavingsContributionRow,
          $$SavingsContributionsTableFilterComposer,
          $$SavingsContributionsTableOrderingComposer,
          $$SavingsContributionsTableAnnotationComposer,
          $$SavingsContributionsTableCreateCompanionBuilder,
          $$SavingsContributionsTableUpdateCompanionBuilder,
          (
            SavingsContributionRow,
            BaseReferences<
              _$AppDatabase,
              $SavingsContributionsTable,
              SavingsContributionRow
            >,
          ),
          SavingsContributionRow,
          PrefetchHooks Function()
        > {
  $$SavingsContributionsTableTableManager(
    _$AppDatabase db,
    $SavingsContributionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsContributionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsContributionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SavingsContributionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> goalId = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavingsContributionsCompanion(
                id: id,
                goalId: goalId,
                cycleId: cycleId,
                amount: amount,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int goalId,
                required int cycleId,
                required int amount,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavingsContributionsCompanion.insert(
                id: id,
                goalId: goalId,
                cycleId: cycleId,
                amount: amount,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsContributionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsContributionsTable,
      SavingsContributionRow,
      $$SavingsContributionsTableFilterComposer,
      $$SavingsContributionsTableOrderingComposer,
      $$SavingsContributionsTableAnnotationComposer,
      $$SavingsContributionsTableCreateCompanionBuilder,
      $$SavingsContributionsTableUpdateCompanionBuilder,
      (
        SavingsContributionRow,
        BaseReferences<
          _$AppDatabase,
          $SavingsContributionsTable,
          SavingsContributionRow
        >,
      ),
      SavingsContributionRow,
      PrefetchHooks Function()
    >;
typedef $$WeeklyChallengesTableCreateCompanionBuilder =
    WeeklyChallengesCompanion Function({
      Value<int> id,
      required int cycleId,
      required DateTime weekStart,
      required int targetAmount,
      required String description,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
    });
typedef $$WeeklyChallengesTableUpdateCompanionBuilder =
    WeeklyChallengesCompanion Function({
      Value<int> id,
      Value<int> cycleId,
      Value<DateTime> weekStart,
      Value<int> targetAmount,
      Value<String> description,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
    });

class $$WeeklyChallengesTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyChallengesTable> {
  $$WeeklyChallengesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyChallengesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyChallengesTable> {
  $$WeeklyChallengesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyChallengesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyChallengesTable> {
  $$WeeklyChallengesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<DateTime> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WeeklyChallengesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyChallengesTable,
          WeeklyChallengeRow,
          $$WeeklyChallengesTableFilterComposer,
          $$WeeklyChallengesTableOrderingComposer,
          $$WeeklyChallengesTableAnnotationComposer,
          $$WeeklyChallengesTableCreateCompanionBuilder,
          $$WeeklyChallengesTableUpdateCompanionBuilder,
          (
            WeeklyChallengeRow,
            BaseReferences<
              _$AppDatabase,
              $WeeklyChallengesTable,
              WeeklyChallengeRow
            >,
          ),
          WeeklyChallengeRow,
          PrefetchHooks Function()
        > {
  $$WeeklyChallengesTableTableManager(
    _$AppDatabase db,
    $WeeklyChallengesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyChallengesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyChallengesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyChallengesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<DateTime> weekStart = const Value.absent(),
                Value<int> targetAmount = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WeeklyChallengesCompanion(
                id: id,
                cycleId: cycleId,
                weekStart: weekStart,
                targetAmount: targetAmount,
                description: description,
                isCompleted: isCompleted,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cycleId,
                required DateTime weekStart,
                required int targetAmount,
                required String description,
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WeeklyChallengesCompanion.insert(
                id: id,
                cycleId: cycleId,
                weekStart: weekStart,
                targetAmount: targetAmount,
                description: description,
                isCompleted: isCompleted,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyChallengesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyChallengesTable,
      WeeklyChallengeRow,
      $$WeeklyChallengesTableFilterComposer,
      $$WeeklyChallengesTableOrderingComposer,
      $$WeeklyChallengesTableAnnotationComposer,
      $$WeeklyChallengesTableCreateCompanionBuilder,
      $$WeeklyChallengesTableUpdateCompanionBuilder,
      (
        WeeklyChallengeRow,
        BaseReferences<
          _$AppDatabase,
          $WeeklyChallengesTable,
          WeeklyChallengeRow
        >,
      ),
      WeeklyChallengeRow,
      PrefetchHooks Function()
    >;
typedef $$FinancialInsightsTableCreateCompanionBuilder =
    FinancialInsightsCompanion Function({
      Value<int> id,
      required int cycleId,
      required String insightType,
      Value<String?> category,
      required String metric,
      required double value,
      required String suggestion,
      Value<DateTime> createdAt,
      required DateTime expiresAt,
    });
typedef $$FinancialInsightsTableUpdateCompanionBuilder =
    FinancialInsightsCompanion Function({
      Value<int> id,
      Value<int> cycleId,
      Value<String> insightType,
      Value<String?> category,
      Value<String> metric,
      Value<double> value,
      Value<String> suggestion,
      Value<DateTime> createdAt,
      Value<DateTime> expiresAt,
    });

class $$FinancialInsightsTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialInsightsTable> {
  $$FinancialInsightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get insightType => $composableBuilder(
    column: $table.insightType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestion => $composableBuilder(
    column: $table.suggestion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FinancialInsightsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialInsightsTable> {
  $$FinancialInsightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get insightType => $composableBuilder(
    column: $table.insightType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestion => $composableBuilder(
    column: $table.suggestion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FinancialInsightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialInsightsTable> {
  $$FinancialInsightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<String> get insightType => $composableBuilder(
    column: $table.insightType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get metric =>
      $composableBuilder(column: $table.metric, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get suggestion => $composableBuilder(
    column: $table.suggestion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$FinancialInsightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinancialInsightsTable,
          FinancialInsightRow,
          $$FinancialInsightsTableFilterComposer,
          $$FinancialInsightsTableOrderingComposer,
          $$FinancialInsightsTableAnnotationComposer,
          $$FinancialInsightsTableCreateCompanionBuilder,
          $$FinancialInsightsTableUpdateCompanionBuilder,
          (
            FinancialInsightRow,
            BaseReferences<
              _$AppDatabase,
              $FinancialInsightsTable,
              FinancialInsightRow
            >,
          ),
          FinancialInsightRow,
          PrefetchHooks Function()
        > {
  $$FinancialInsightsTableTableManager(
    _$AppDatabase db,
    $FinancialInsightsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialInsightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialInsightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancialInsightsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<String> insightType = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> metric = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> suggestion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
              }) => FinancialInsightsCompanion(
                id: id,
                cycleId: cycleId,
                insightType: insightType,
                category: category,
                metric: metric,
                value: value,
                suggestion: suggestion,
                createdAt: createdAt,
                expiresAt: expiresAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cycleId,
                required String insightType,
                Value<String?> category = const Value.absent(),
                required String metric,
                required double value,
                required String suggestion,
                Value<DateTime> createdAt = const Value.absent(),
                required DateTime expiresAt,
              }) => FinancialInsightsCompanion.insert(
                id: id,
                cycleId: cycleId,
                insightType: insightType,
                category: category,
                metric: metric,
                value: value,
                suggestion: suggestion,
                createdAt: createdAt,
                expiresAt: expiresAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FinancialInsightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinancialInsightsTable,
      FinancialInsightRow,
      $$FinancialInsightsTableFilterComposer,
      $$FinancialInsightsTableOrderingComposer,
      $$FinancialInsightsTableAnnotationComposer,
      $$FinancialInsightsTableCreateCompanionBuilder,
      $$FinancialInsightsTableUpdateCompanionBuilder,
      (
        FinancialInsightRow,
        BaseReferences<
          _$AppDatabase,
          $FinancialInsightsTable,
          FinancialInsightRow
        >,
      ),
      FinancialInsightRow,
      PrefetchHooks Function()
    >;
typedef $$LicenseActivationsTableCreateCompanionBuilder =
    LicenseActivationsCompanion Function({
      Value<int> id,
      required String deviceId,
      Value<String?> licenseKey,
      Value<String?> expiryDate,
      Value<DateTime?> activatedAt,
    });
typedef $$LicenseActivationsTableUpdateCompanionBuilder =
    LicenseActivationsCompanion Function({
      Value<int> id,
      Value<String> deviceId,
      Value<String?> licenseKey,
      Value<String?> expiryDate,
      Value<DateTime?> activatedAt,
    });

class $$LicenseActivationsTableFilterComposer
    extends Composer<_$AppDatabase, $LicenseActivationsTable> {
  $$LicenseActivationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licenseKey => $composableBuilder(
    column: $table.licenseKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get activatedAt => $composableBuilder(
    column: $table.activatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LicenseActivationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LicenseActivationsTable> {
  $$LicenseActivationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licenseKey => $composableBuilder(
    column: $table.licenseKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get activatedAt => $composableBuilder(
    column: $table.activatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LicenseActivationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LicenseActivationsTable> {
  $$LicenseActivationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get licenseKey => $composableBuilder(
    column: $table.licenseKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get activatedAt => $composableBuilder(
    column: $table.activatedAt,
    builder: (column) => column,
  );
}

class $$LicenseActivationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LicenseActivationsTable,
          LicenseActivationRow,
          $$LicenseActivationsTableFilterComposer,
          $$LicenseActivationsTableOrderingComposer,
          $$LicenseActivationsTableAnnotationComposer,
          $$LicenseActivationsTableCreateCompanionBuilder,
          $$LicenseActivationsTableUpdateCompanionBuilder,
          (
            LicenseActivationRow,
            BaseReferences<
              _$AppDatabase,
              $LicenseActivationsTable,
              LicenseActivationRow
            >,
          ),
          LicenseActivationRow,
          PrefetchHooks Function()
        > {
  $$LicenseActivationsTableTableManager(
    _$AppDatabase db,
    $LicenseActivationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LicenseActivationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LicenseActivationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LicenseActivationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String?> licenseKey = const Value.absent(),
                Value<String?> expiryDate = const Value.absent(),
                Value<DateTime?> activatedAt = const Value.absent(),
              }) => LicenseActivationsCompanion(
                id: id,
                deviceId: deviceId,
                licenseKey: licenseKey,
                expiryDate: expiryDate,
                activatedAt: activatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String deviceId,
                Value<String?> licenseKey = const Value.absent(),
                Value<String?> expiryDate = const Value.absent(),
                Value<DateTime?> activatedAt = const Value.absent(),
              }) => LicenseActivationsCompanion.insert(
                id: id,
                deviceId: deviceId,
                licenseKey: licenseKey,
                expiryDate: expiryDate,
                activatedAt: activatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LicenseActivationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LicenseActivationsTable,
      LicenseActivationRow,
      $$LicenseActivationsTableFilterComposer,
      $$LicenseActivationsTableOrderingComposer,
      $$LicenseActivationsTableAnnotationComposer,
      $$LicenseActivationsTableCreateCompanionBuilder,
      $$LicenseActivationsTableUpdateCompanionBuilder,
      (
        LicenseActivationRow,
        BaseReferences<
          _$AppDatabase,
          $LicenseActivationsTable,
          LicenseActivationRow
        >,
      ),
      LicenseActivationRow,
      PrefetchHooks Function()
    >;
typedef $$SavingsHistoryTableCreateCompanionBuilder =
    SavingsHistoryCompanion Function({
      Value<int> id,
      required String type,
      required int amount,
      required String description,
      Value<int?> relatedCycleId,
      Value<int?> relatedExpenseId,
      Value<int?> relatedDebtPaymentId,
      Value<int?> relatedLendingId,
      Value<DateTime> createdAt,
    });
typedef $$SavingsHistoryTableUpdateCompanionBuilder =
    SavingsHistoryCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<int> amount,
      Value<String> description,
      Value<int?> relatedCycleId,
      Value<int?> relatedExpenseId,
      Value<int?> relatedDebtPaymentId,
      Value<int?> relatedLendingId,
      Value<DateTime> createdAt,
    });

class $$SavingsHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsHistoryTable> {
  $$SavingsHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get relatedCycleId => $composableBuilder(
    column: $table.relatedCycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get relatedExpenseId => $composableBuilder(
    column: $table.relatedExpenseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get relatedDebtPaymentId => $composableBuilder(
    column: $table.relatedDebtPaymentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get relatedLendingId => $composableBuilder(
    column: $table.relatedLendingId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsHistoryTable> {
  $$SavingsHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get relatedCycleId => $composableBuilder(
    column: $table.relatedCycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get relatedExpenseId => $composableBuilder(
    column: $table.relatedExpenseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get relatedDebtPaymentId => $composableBuilder(
    column: $table.relatedDebtPaymentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get relatedLendingId => $composableBuilder(
    column: $table.relatedLendingId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsHistoryTable> {
  $$SavingsHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get relatedCycleId => $composableBuilder(
    column: $table.relatedCycleId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get relatedExpenseId => $composableBuilder(
    column: $table.relatedExpenseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get relatedDebtPaymentId => $composableBuilder(
    column: $table.relatedDebtPaymentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get relatedLendingId => $composableBuilder(
    column: $table.relatedLendingId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavingsHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsHistoryTable,
          SavingsHistoryRow,
          $$SavingsHistoryTableFilterComposer,
          $$SavingsHistoryTableOrderingComposer,
          $$SavingsHistoryTableAnnotationComposer,
          $$SavingsHistoryTableCreateCompanionBuilder,
          $$SavingsHistoryTableUpdateCompanionBuilder,
          (
            SavingsHistoryRow,
            BaseReferences<
              _$AppDatabase,
              $SavingsHistoryTable,
              SavingsHistoryRow
            >,
          ),
          SavingsHistoryRow,
          PrefetchHooks Function()
        > {
  $$SavingsHistoryTableTableManager(
    _$AppDatabase db,
    $SavingsHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int?> relatedCycleId = const Value.absent(),
                Value<int?> relatedExpenseId = const Value.absent(),
                Value<int?> relatedDebtPaymentId = const Value.absent(),
                Value<int?> relatedLendingId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavingsHistoryCompanion(
                id: id,
                type: type,
                amount: amount,
                description: description,
                relatedCycleId: relatedCycleId,
                relatedExpenseId: relatedExpenseId,
                relatedDebtPaymentId: relatedDebtPaymentId,
                relatedLendingId: relatedLendingId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required int amount,
                required String description,
                Value<int?> relatedCycleId = const Value.absent(),
                Value<int?> relatedExpenseId = const Value.absent(),
                Value<int?> relatedDebtPaymentId = const Value.absent(),
                Value<int?> relatedLendingId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavingsHistoryCompanion.insert(
                id: id,
                type: type,
                amount: amount,
                description: description,
                relatedCycleId: relatedCycleId,
                relatedExpenseId: relatedExpenseId,
                relatedDebtPaymentId: relatedDebtPaymentId,
                relatedLendingId: relatedLendingId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsHistoryTable,
      SavingsHistoryRow,
      $$SavingsHistoryTableFilterComposer,
      $$SavingsHistoryTableOrderingComposer,
      $$SavingsHistoryTableAnnotationComposer,
      $$SavingsHistoryTableCreateCompanionBuilder,
      $$SavingsHistoryTableUpdateCompanionBuilder,
      (
        SavingsHistoryRow,
        BaseReferences<_$AppDatabase, $SavingsHistoryTable, SavingsHistoryRow>,
      ),
      SavingsHistoryRow,
      PrefetchHooks Function()
    >;
typedef $$LendingsTableCreateCompanionBuilder =
    LendingsCompanion Function({
      Value<int> id,
      required String borrowerName,
      required int totalAmount,
      Value<int> collectedAmount,
      Value<bool> isFullyCollected,
      Value<bool> fromSavings,
      Value<int> savingsAmount,
      required int cycleId,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$LendingsTableUpdateCompanionBuilder =
    LendingsCompanion Function({
      Value<int> id,
      Value<String> borrowerName,
      Value<int> totalAmount,
      Value<int> collectedAmount,
      Value<bool> isFullyCollected,
      Value<bool> fromSavings,
      Value<int> savingsAmount,
      Value<int> cycleId,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

class $$LendingsTableFilterComposer
    extends Composer<_$AppDatabase, $LendingsTable> {
  $$LendingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get borrowerName => $composableBuilder(
    column: $table.borrowerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get collectedAmount => $composableBuilder(
    column: $table.collectedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFullyCollected => $composableBuilder(
    column: $table.isFullyCollected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fromSavings => $composableBuilder(
    column: $table.fromSavings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savingsAmount => $composableBuilder(
    column: $table.savingsAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LendingsTableOrderingComposer
    extends Composer<_$AppDatabase, $LendingsTable> {
  $$LendingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get borrowerName => $composableBuilder(
    column: $table.borrowerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get collectedAmount => $composableBuilder(
    column: $table.collectedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFullyCollected => $composableBuilder(
    column: $table.isFullyCollected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fromSavings => $composableBuilder(
    column: $table.fromSavings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savingsAmount => $composableBuilder(
    column: $table.savingsAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LendingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LendingsTable> {
  $$LendingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get borrowerName => $composableBuilder(
    column: $table.borrowerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get collectedAmount => $composableBuilder(
    column: $table.collectedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFullyCollected => $composableBuilder(
    column: $table.isFullyCollected,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get fromSavings => $composableBuilder(
    column: $table.fromSavings,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savingsAmount => $composableBuilder(
    column: $table.savingsAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LendingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LendingsTable,
          LendingRow,
          $$LendingsTableFilterComposer,
          $$LendingsTableOrderingComposer,
          $$LendingsTableAnnotationComposer,
          $$LendingsTableCreateCompanionBuilder,
          $$LendingsTableUpdateCompanionBuilder,
          (
            LendingRow,
            BaseReferences<_$AppDatabase, $LendingsTable, LendingRow>,
          ),
          LendingRow,
          PrefetchHooks Function()
        > {
  $$LendingsTableTableManager(_$AppDatabase db, $LendingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LendingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LendingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LendingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> borrowerName = const Value.absent(),
                Value<int> totalAmount = const Value.absent(),
                Value<int> collectedAmount = const Value.absent(),
                Value<bool> isFullyCollected = const Value.absent(),
                Value<bool> fromSavings = const Value.absent(),
                Value<int> savingsAmount = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LendingsCompanion(
                id: id,
                borrowerName: borrowerName,
                totalAmount: totalAmount,
                collectedAmount: collectedAmount,
                isFullyCollected: isFullyCollected,
                fromSavings: fromSavings,
                savingsAmount: savingsAmount,
                cycleId: cycleId,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String borrowerName,
                required int totalAmount,
                Value<int> collectedAmount = const Value.absent(),
                Value<bool> isFullyCollected = const Value.absent(),
                Value<bool> fromSavings = const Value.absent(),
                Value<int> savingsAmount = const Value.absent(),
                required int cycleId,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LendingsCompanion.insert(
                id: id,
                borrowerName: borrowerName,
                totalAmount: totalAmount,
                collectedAmount: collectedAmount,
                isFullyCollected: isFullyCollected,
                fromSavings: fromSavings,
                savingsAmount: savingsAmount,
                cycleId: cycleId,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LendingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LendingsTable,
      LendingRow,
      $$LendingsTableFilterComposer,
      $$LendingsTableOrderingComposer,
      $$LendingsTableAnnotationComposer,
      $$LendingsTableCreateCompanionBuilder,
      $$LendingsTableUpdateCompanionBuilder,
      (LendingRow, BaseReferences<_$AppDatabase, $LendingsTable, LendingRow>),
      LendingRow,
      PrefetchHooks Function()
    >;
typedef $$LendingCollectionsTableCreateCompanionBuilder =
    LendingCollectionsCompanion Function({
      Value<int> id,
      required int lendingId,
      required int amount,
      Value<bool> toSavings,
      Value<DateTime> createdAt,
    });
typedef $$LendingCollectionsTableUpdateCompanionBuilder =
    LendingCollectionsCompanion Function({
      Value<int> id,
      Value<int> lendingId,
      Value<int> amount,
      Value<bool> toSavings,
      Value<DateTime> createdAt,
    });

class $$LendingCollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $LendingCollectionsTable> {
  $$LendingCollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lendingId => $composableBuilder(
    column: $table.lendingId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get toSavings => $composableBuilder(
    column: $table.toSavings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LendingCollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LendingCollectionsTable> {
  $$LendingCollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lendingId => $composableBuilder(
    column: $table.lendingId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get toSavings => $composableBuilder(
    column: $table.toSavings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LendingCollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LendingCollectionsTable> {
  $$LendingCollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get lendingId =>
      $composableBuilder(column: $table.lendingId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<bool> get toSavings =>
      $composableBuilder(column: $table.toSavings, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LendingCollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LendingCollectionsTable,
          LendingCollectionRow,
          $$LendingCollectionsTableFilterComposer,
          $$LendingCollectionsTableOrderingComposer,
          $$LendingCollectionsTableAnnotationComposer,
          $$LendingCollectionsTableCreateCompanionBuilder,
          $$LendingCollectionsTableUpdateCompanionBuilder,
          (
            LendingCollectionRow,
            BaseReferences<
              _$AppDatabase,
              $LendingCollectionsTable,
              LendingCollectionRow
            >,
          ),
          LendingCollectionRow,
          PrefetchHooks Function()
        > {
  $$LendingCollectionsTableTableManager(
    _$AppDatabase db,
    $LendingCollectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LendingCollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LendingCollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LendingCollectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lendingId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<bool> toSavings = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LendingCollectionsCompanion(
                id: id,
                lendingId: lendingId,
                amount: amount,
                toSavings: toSavings,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int lendingId,
                required int amount,
                Value<bool> toSavings = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LendingCollectionsCompanion.insert(
                id: id,
                lendingId: lendingId,
                amount: amount,
                toSavings: toSavings,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LendingCollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LendingCollectionsTable,
      LendingCollectionRow,
      $$LendingCollectionsTableFilterComposer,
      $$LendingCollectionsTableOrderingComposer,
      $$LendingCollectionsTableAnnotationComposer,
      $$LendingCollectionsTableCreateCompanionBuilder,
      $$LendingCollectionsTableUpdateCompanionBuilder,
      (
        LendingCollectionRow,
        BaseReferences<
          _$AppDatabase,
          $LendingCollectionsTable,
          LendingCollectionRow
        >,
      ),
      LendingCollectionRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$FinancialCyclesTableTableManager get financialCycles =>
      $$FinancialCyclesTableTableManager(_db, _db.financialCycles);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$AdditionalIncomesTableTableManager get additionalIncomes =>
      $$AdditionalIncomesTableTableManager(_db, _db.additionalIncomes);
  $$DebtsTableTableManager get debts =>
      $$DebtsTableTableManager(_db, _db.debts);
  $$DebtPaymentsTableTableManager get debtPayments =>
      $$DebtPaymentsTableTableManager(_db, _db.debtPayments);
  $$SavingsGoalsTableTableManager get savingsGoals =>
      $$SavingsGoalsTableTableManager(_db, _db.savingsGoals);
  $$SavingsContributionsTableTableManager get savingsContributions =>
      $$SavingsContributionsTableTableManager(_db, _db.savingsContributions);
  $$WeeklyChallengesTableTableManager get weeklyChallenges =>
      $$WeeklyChallengesTableTableManager(_db, _db.weeklyChallenges);
  $$FinancialInsightsTableTableManager get financialInsights =>
      $$FinancialInsightsTableTableManager(_db, _db.financialInsights);
  $$LicenseActivationsTableTableManager get licenseActivations =>
      $$LicenseActivationsTableTableManager(_db, _db.licenseActivations);
  $$SavingsHistoryTableTableManager get savingsHistory =>
      $$SavingsHistoryTableTableManager(_db, _db.savingsHistory);
  $$LendingsTableTableManager get lendings =>
      $$LendingsTableTableManager(_db, _db.lendings);
  $$LendingCollectionsTableTableManager get lendingCollections =>
      $$LendingCollectionsTableTableManager(_db, _db.lendingCollections);
}
