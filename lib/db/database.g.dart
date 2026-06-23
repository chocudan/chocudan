// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('viewer'));
  static const VerificationMeta _canAddPlaceMeta =
      const VerificationMeta('canAddPlace');
  @override
  late final GeneratedColumn<bool> canAddPlace = GeneratedColumn<bool>(
      'can_add_place', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("can_add_place" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _canEditPlaceMeta =
      const VerificationMeta('canEditPlace');
  @override
  late final GeneratedColumn<bool> canEditPlace = GeneratedColumn<bool>(
      'can_edit_place', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("can_edit_place" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _canDeletePlaceMeta =
      const VerificationMeta('canDeletePlace');
  @override
  late final GeneratedColumn<bool> canDeletePlace = GeneratedColumn<bool>(
      'can_delete_place', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("can_delete_place" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _canRateMeta =
      const VerificationMeta('canRate');
  @override
  late final GeneratedColumn<bool> canRate = GeneratedColumn<bool>(
      'can_rate', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("can_rate" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        phone,
        passwordHash,
        role,
        canAddPlace,
        canEditPlace,
        canDeletePlace,
        canRate,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('can_add_place')) {
      context.handle(
          _canAddPlaceMeta,
          canAddPlace.isAcceptableOrUnknown(
              data['can_add_place']!, _canAddPlaceMeta));
    }
    if (data.containsKey('can_edit_place')) {
      context.handle(
          _canEditPlaceMeta,
          canEditPlace.isAcceptableOrUnknown(
              data['can_edit_place']!, _canEditPlaceMeta));
    }
    if (data.containsKey('can_delete_place')) {
      context.handle(
          _canDeletePlaceMeta,
          canDeletePlace.isAcceptableOrUnknown(
              data['can_delete_place']!, _canDeletePlaceMeta));
    }
    if (data.containsKey('can_rate')) {
      context.handle(_canRateMeta,
          canRate.isAcceptableOrUnknown(data['can_rate']!, _canRateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      canAddPlace: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}can_add_place'])!,
      canEditPlace: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}can_edit_place'])!,
      canDeletePlace: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}can_delete_place'])!,
      canRate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}can_rate'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String name;
  final String phone;
  final String passwordHash;
  final String role;
  final bool canAddPlace;
  final bool canEditPlace;
  final bool canDeletePlace;
  final bool canRate;
  final DateTime createdAt;
  const User(
      {required this.id,
      required this.name,
      required this.phone,
      required this.passwordHash,
      required this.role,
      required this.canAddPlace,
      required this.canEditPlace,
      required this.canDeletePlace,
      required this.canRate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['password_hash'] = Variable<String>(passwordHash);
    map['role'] = Variable<String>(role);
    map['can_add_place'] = Variable<bool>(canAddPlace);
    map['can_edit_place'] = Variable<bool>(canEditPlace);
    map['can_delete_place'] = Variable<bool>(canDeletePlace);
    map['can_rate'] = Variable<bool>(canRate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      passwordHash: Value(passwordHash),
      role: Value(role),
      canAddPlace: Value(canAddPlace),
      canEditPlace: Value(canEditPlace),
      canDeletePlace: Value(canDeletePlace),
      canRate: Value(canRate),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      role: serializer.fromJson<String>(json['role']),
      canAddPlace: serializer.fromJson<bool>(json['canAddPlace']),
      canEditPlace: serializer.fromJson<bool>(json['canEditPlace']),
      canDeletePlace: serializer.fromJson<bool>(json['canDeletePlace']),
      canRate: serializer.fromJson<bool>(json['canRate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'role': serializer.toJson<String>(role),
      'canAddPlace': serializer.toJson<bool>(canAddPlace),
      'canEditPlace': serializer.toJson<bool>(canEditPlace),
      'canDeletePlace': serializer.toJson<bool>(canDeletePlace),
      'canRate': serializer.toJson<bool>(canRate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith(
          {String? id,
          String? name,
          String? phone,
          String? passwordHash,
          String? role,
          bool? canAddPlace,
          bool? canEditPlace,
          bool? canDeletePlace,
          bool? canRate,
          DateTime? createdAt}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        passwordHash: passwordHash ?? this.passwordHash,
        role: role ?? this.role,
        canAddPlace: canAddPlace ?? this.canAddPlace,
        canEditPlace: canEditPlace ?? this.canEditPlace,
        canDeletePlace: canDeletePlace ?? this.canDeletePlace,
        canRate: canRate ?? this.canRate,
        createdAt: createdAt ?? this.createdAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      role: data.role.present ? data.role.value : this.role,
      canAddPlace:
          data.canAddPlace.present ? data.canAddPlace.value : this.canAddPlace,
      canEditPlace: data.canEditPlace.present
          ? data.canEditPlace.value
          : this.canEditPlace,
      canDeletePlace: data.canDeletePlace.present
          ? data.canDeletePlace.value
          : this.canDeletePlace,
      canRate: data.canRate.present ? data.canRate.value : this.canRate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('canAddPlace: $canAddPlace, ')
          ..write('canEditPlace: $canEditPlace, ')
          ..write('canDeletePlace: $canDeletePlace, ')
          ..write('canRate: $canRate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, passwordHash, role,
      canAddPlace, canEditPlace, canDeletePlace, canRate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.passwordHash == this.passwordHash &&
          other.role == this.role &&
          other.canAddPlace == this.canAddPlace &&
          other.canEditPlace == this.canEditPlace &&
          other.canDeletePlace == this.canDeletePlace &&
          other.canRate == this.canRate &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> passwordHash;
  final Value<String> role;
  final Value<bool> canAddPlace;
  final Value<bool> canEditPlace;
  final Value<bool> canDeletePlace;
  final Value<bool> canRate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.role = const Value.absent(),
    this.canAddPlace = const Value.absent(),
    this.canEditPlace = const Value.absent(),
    this.canDeletePlace = const Value.absent(),
    this.canRate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    required String phone,
    required String passwordHash,
    this.role = const Value.absent(),
    this.canAddPlace = const Value.absent(),
    this.canEditPlace = const Value.absent(),
    this.canDeletePlace = const Value.absent(),
    this.canRate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        phone = Value(phone),
        passwordHash = Value(passwordHash);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? passwordHash,
    Expression<String>? role,
    Expression<bool>? canAddPlace,
    Expression<bool>? canEditPlace,
    Expression<bool>? canDeletePlace,
    Expression<bool>? canRate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (role != null) 'role': role,
      if (canAddPlace != null) 'can_add_place': canAddPlace,
      if (canEditPlace != null) 'can_edit_place': canEditPlace,
      if (canDeletePlace != null) 'can_delete_place': canDeletePlace,
      if (canRate != null) 'can_rate': canRate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? phone,
      Value<String>? passwordHash,
      Value<String>? role,
      Value<bool>? canAddPlace,
      Value<bool>? canEditPlace,
      Value<bool>? canDeletePlace,
      Value<bool>? canRate,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      canAddPlace: canAddPlace ?? this.canAddPlace,
      canEditPlace: canEditPlace ?? this.canEditPlace,
      canDeletePlace: canDeletePlace ?? this.canDeletePlace,
      canRate: canRate ?? this.canRate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (canAddPlace.present) {
      map['can_add_place'] = Variable<bool>(canAddPlace.value);
    }
    if (canEditPlace.present) {
      map['can_edit_place'] = Variable<bool>(canEditPlace.value);
    }
    if (canDeletePlace.present) {
      map['can_delete_place'] = Variable<bool>(canDeletePlace.value);
    }
    if (canRate.present) {
      map['can_rate'] = Variable<bool>(canRate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('canAddPlace: $canAddPlace, ')
          ..write('canEditPlace: $canEditPlace, ')
          ..write('canDeletePlace: $canDeletePlace, ')
          ..write('canRate: $canRate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlacesTable extends Places with TableInfo<$PlacesTable, Place> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('food'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phone2Meta = const VerificationMeta('phone2');
  @override
  late final GeneratedColumn<String> phone2 = GeneratedColumn<String>(
      'phone2', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rawTextMeta =
      const VerificationMeta('rawText');
  @override
  late final GeneratedColumn<String> rawText = GeneratedColumn<String>(
      'raw_text', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _freeshipMeta =
      const VerificationMeta('freeship');
  @override
  late final GeneratedColumn<bool> freeship = GeneratedColumn<bool>(
      'freeship', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("freeship" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _freeshipNoteMeta =
      const VerificationMeta('freeshipNote');
  @override
  late final GeneratedColumn<String> freeshipNote = GeneratedColumn<String>(
      'freeship_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _openHoursMeta =
      const VerificationMeta('openHours');
  @override
  late final GeneratedColumn<String> openHours = GeneratedColumn<String>(
      'open_hours', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avgPriceRangeMeta =
      const VerificationMeta('avgPriceRange');
  @override
  late final GeneratedColumn<String> avgPriceRange = GeneratedColumn<String>(
      'avg_price_range', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _viewCountMeta =
      const VerificationMeta('viewCount');
  @override
  late final GeneratedColumn<int> viewCount = GeneratedColumn<int>(
      'view_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        name,
        phone,
        phone2,
        address,
        rawText,
        freeship,
        freeshipNote,
        openHours,
        category,
        avgPriceRange,
        note,
        createdBy,
        viewCount,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'places';
  @override
  VerificationContext validateIntegrity(Insertable<Place> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('phone2')) {
      context.handle(_phone2Meta,
          phone2.isAcceptableOrUnknown(data['phone2']!, _phone2Meta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('raw_text')) {
      context.handle(_rawTextMeta,
          rawText.isAcceptableOrUnknown(data['raw_text']!, _rawTextMeta));
    }
    if (data.containsKey('freeship')) {
      context.handle(_freeshipMeta,
          freeship.isAcceptableOrUnknown(data['freeship']!, _freeshipMeta));
    }
    if (data.containsKey('freeship_note')) {
      context.handle(
          _freeshipNoteMeta,
          freeshipNote.isAcceptableOrUnknown(
              data['freeship_note']!, _freeshipNoteMeta));
    }
    if (data.containsKey('open_hours')) {
      context.handle(_openHoursMeta,
          openHours.isAcceptableOrUnknown(data['open_hours']!, _openHoursMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('avg_price_range')) {
      context.handle(
          _avgPriceRangeMeta,
          avgPriceRange.isAcceptableOrUnknown(
              data['avg_price_range']!, _avgPriceRangeMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    if (data.containsKey('view_count')) {
      context.handle(_viewCountMeta,
          viewCount.isAcceptableOrUnknown(data['view_count']!, _viewCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Place map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Place(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      phone2: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone2']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      rawText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}raw_text'])!,
      freeship: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}freeship'])!,
      freeshipNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}freeship_note']),
      openHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}open_hours']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      avgPriceRange: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avg_price_range']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
      viewCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}view_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PlacesTable createAlias(String alias) {
    return $PlacesTable(attachedDatabase, alias);
  }
}

class Place extends DataClass implements Insertable<Place> {
  final String id;
  final String type;
  final String name;
  final String? phone;
  final String? phone2;
  final String? address;
  final String rawText;
  final bool freeship;
  final String? freeshipNote;
  final String? openHours;
  final String? category;
  final String? avgPriceRange;
  final String? note;
  final String? createdBy;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Place(
      {required this.id,
      required this.type,
      required this.name,
      this.phone,
      this.phone2,
      this.address,
      required this.rawText,
      required this.freeship,
      this.freeshipNote,
      this.openHours,
      this.category,
      this.avgPriceRange,
      this.note,
      this.createdBy,
      required this.viewCount,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || phone2 != null) {
      map['phone2'] = Variable<String>(phone2);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['raw_text'] = Variable<String>(rawText);
    map['freeship'] = Variable<bool>(freeship);
    if (!nullToAbsent || freeshipNote != null) {
      map['freeship_note'] = Variable<String>(freeshipNote);
    }
    if (!nullToAbsent || openHours != null) {
      map['open_hours'] = Variable<String>(openHours);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || avgPriceRange != null) {
      map['avg_price_range'] = Variable<String>(avgPriceRange);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['view_count'] = Variable<int>(viewCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlacesCompanion toCompanion(bool nullToAbsent) {
    return PlacesCompanion(
      id: Value(id),
      type: Value(type),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      phone2:
          phone2 == null && nullToAbsent ? const Value.absent() : Value(phone2),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      rawText: Value(rawText),
      freeship: Value(freeship),
      freeshipNote: freeshipNote == null && nullToAbsent
          ? const Value.absent()
          : Value(freeshipNote),
      openHours: openHours == null && nullToAbsent
          ? const Value.absent()
          : Value(openHours),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      avgPriceRange: avgPriceRange == null && nullToAbsent
          ? const Value.absent()
          : Value(avgPriceRange),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      viewCount: Value(viewCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Place.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Place(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      phone2: serializer.fromJson<String?>(json['phone2']),
      address: serializer.fromJson<String?>(json['address']),
      rawText: serializer.fromJson<String>(json['rawText']),
      freeship: serializer.fromJson<bool>(json['freeship']),
      freeshipNote: serializer.fromJson<String?>(json['freeshipNote']),
      openHours: serializer.fromJson<String?>(json['openHours']),
      category: serializer.fromJson<String?>(json['category']),
      avgPriceRange: serializer.fromJson<String?>(json['avgPriceRange']),
      note: serializer.fromJson<String?>(json['note']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      viewCount: serializer.fromJson<int>(json['viewCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'phone2': serializer.toJson<String?>(phone2),
      'address': serializer.toJson<String?>(address),
      'rawText': serializer.toJson<String>(rawText),
      'freeship': serializer.toJson<bool>(freeship),
      'freeshipNote': serializer.toJson<String?>(freeshipNote),
      'openHours': serializer.toJson<String?>(openHours),
      'category': serializer.toJson<String?>(category),
      'avgPriceRange': serializer.toJson<String?>(avgPriceRange),
      'note': serializer.toJson<String?>(note),
      'createdBy': serializer.toJson<String?>(createdBy),
      'viewCount': serializer.toJson<int>(viewCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Place copyWith(
          {String? id,
          String? type,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> phone2 = const Value.absent(),
          Value<String?> address = const Value.absent(),
          String? rawText,
          bool? freeship,
          Value<String?> freeshipNote = const Value.absent(),
          Value<String?> openHours = const Value.absent(),
          Value<String?> category = const Value.absent(),
          Value<String?> avgPriceRange = const Value.absent(),
          Value<String?> note = const Value.absent(),
          Value<String?> createdBy = const Value.absent(),
          int? viewCount,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Place(
        id: id ?? this.id,
        type: type ?? this.type,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        phone2: phone2.present ? phone2.value : this.phone2,
        address: address.present ? address.value : this.address,
        rawText: rawText ?? this.rawText,
        freeship: freeship ?? this.freeship,
        freeshipNote:
            freeshipNote.present ? freeshipNote.value : this.freeshipNote,
        openHours: openHours.present ? openHours.value : this.openHours,
        category: category.present ? category.value : this.category,
        avgPriceRange:
            avgPriceRange.present ? avgPriceRange.value : this.avgPriceRange,
        note: note.present ? note.value : this.note,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
        viewCount: viewCount ?? this.viewCount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Place copyWithCompanion(PlacesCompanion data) {
    return Place(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      phone2: data.phone2.present ? data.phone2.value : this.phone2,
      address: data.address.present ? data.address.value : this.address,
      rawText: data.rawText.present ? data.rawText.value : this.rawText,
      freeship: data.freeship.present ? data.freeship.value : this.freeship,
      freeshipNote: data.freeshipNote.present
          ? data.freeshipNote.value
          : this.freeshipNote,
      openHours: data.openHours.present ? data.openHours.value : this.openHours,
      category: data.category.present ? data.category.value : this.category,
      avgPriceRange: data.avgPriceRange.present
          ? data.avgPriceRange.value
          : this.avgPriceRange,
      note: data.note.present ? data.note.value : this.note,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      viewCount: data.viewCount.present ? data.viewCount.value : this.viewCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Place(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('phone2: $phone2, ')
          ..write('address: $address, ')
          ..write('rawText: $rawText, ')
          ..write('freeship: $freeship, ')
          ..write('freeshipNote: $freeshipNote, ')
          ..write('openHours: $openHours, ')
          ..write('category: $category, ')
          ..write('avgPriceRange: $avgPriceRange, ')
          ..write('note: $note, ')
          ..write('createdBy: $createdBy, ')
          ..write('viewCount: $viewCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      type,
      name,
      phone,
      phone2,
      address,
      rawText,
      freeship,
      freeshipNote,
      openHours,
      category,
      avgPriceRange,
      note,
      createdBy,
      viewCount,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Place &&
          other.id == this.id &&
          other.type == this.type &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.phone2 == this.phone2 &&
          other.address == this.address &&
          other.rawText == this.rawText &&
          other.freeship == this.freeship &&
          other.freeshipNote == this.freeshipNote &&
          other.openHours == this.openHours &&
          other.category == this.category &&
          other.avgPriceRange == this.avgPriceRange &&
          other.note == this.note &&
          other.createdBy == this.createdBy &&
          other.viewCount == this.viewCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlacesCompanion extends UpdateCompanion<Place> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> phone2;
  final Value<String?> address;
  final Value<String> rawText;
  final Value<bool> freeship;
  final Value<String?> freeshipNote;
  final Value<String?> openHours;
  final Value<String?> category;
  final Value<String?> avgPriceRange;
  final Value<String?> note;
  final Value<String?> createdBy;
  final Value<int> viewCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlacesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.phone2 = const Value.absent(),
    this.address = const Value.absent(),
    this.rawText = const Value.absent(),
    this.freeship = const Value.absent(),
    this.freeshipNote = const Value.absent(),
    this.openHours = const Value.absent(),
    this.category = const Value.absent(),
    this.avgPriceRange = const Value.absent(),
    this.note = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.viewCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlacesCompanion.insert({
    required String id,
    this.type = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.phone2 = const Value.absent(),
    this.address = const Value.absent(),
    this.rawText = const Value.absent(),
    this.freeship = const Value.absent(),
    this.freeshipNote = const Value.absent(),
    this.openHours = const Value.absent(),
    this.category = const Value.absent(),
    this.avgPriceRange = const Value.absent(),
    this.note = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.viewCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Place> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? phone2,
    Expression<String>? address,
    Expression<String>? rawText,
    Expression<bool>? freeship,
    Expression<String>? freeshipNote,
    Expression<String>? openHours,
    Expression<String>? category,
    Expression<String>? avgPriceRange,
    Expression<String>? note,
    Expression<String>? createdBy,
    Expression<int>? viewCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (phone2 != null) 'phone2': phone2,
      if (address != null) 'address': address,
      if (rawText != null) 'raw_text': rawText,
      if (freeship != null) 'freeship': freeship,
      if (freeshipNote != null) 'freeship_note': freeshipNote,
      if (openHours != null) 'open_hours': openHours,
      if (category != null) 'category': category,
      if (avgPriceRange != null) 'avg_price_range': avgPriceRange,
      if (note != null) 'note': note,
      if (createdBy != null) 'created_by': createdBy,
      if (viewCount != null) 'view_count': viewCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlacesCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? phone2,
      Value<String?>? address,
      Value<String>? rawText,
      Value<bool>? freeship,
      Value<String?>? freeshipNote,
      Value<String?>? openHours,
      Value<String?>? category,
      Value<String?>? avgPriceRange,
      Value<String?>? note,
      Value<String?>? createdBy,
      Value<int>? viewCount,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PlacesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      phone2: phone2 ?? this.phone2,
      address: address ?? this.address,
      rawText: rawText ?? this.rawText,
      freeship: freeship ?? this.freeship,
      freeshipNote: freeshipNote ?? this.freeshipNote,
      openHours: openHours ?? this.openHours,
      category: category ?? this.category,
      avgPriceRange: avgPriceRange ?? this.avgPriceRange,
      note: note ?? this.note,
      createdBy: createdBy ?? this.createdBy,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (phone2.present) {
      map['phone2'] = Variable<String>(phone2.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (rawText.present) {
      map['raw_text'] = Variable<String>(rawText.value);
    }
    if (freeship.present) {
      map['freeship'] = Variable<bool>(freeship.value);
    }
    if (freeshipNote.present) {
      map['freeship_note'] = Variable<String>(freeshipNote.value);
    }
    if (openHours.present) {
      map['open_hours'] = Variable<String>(openHours.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (avgPriceRange.present) {
      map['avg_price_range'] = Variable<String>(avgPriceRange.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (viewCount.present) {
      map['view_count'] = Variable<int>(viewCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('phone2: $phone2, ')
          ..write('address: $address, ')
          ..write('rawText: $rawText, ')
          ..write('freeship: $freeship, ')
          ..write('freeshipNote: $freeshipNote, ')
          ..write('openHours: $openHours, ')
          ..write('category: $category, ')
          ..write('avgPriceRange: $avgPriceRange, ')
          ..write('note: $note, ')
          ..write('createdBy: $createdBy, ')
          ..write('viewCount: $viewCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MenuItemsTable extends MenuItems
    with TableInfo<$MenuItemsTable, MenuItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenuItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _placeIdMeta =
      const VerificationMeta('placeId');
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
      'place_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryGroupMeta =
      const VerificationMeta('categoryGroup');
  @override
  late final GeneratedColumn<String> categoryGroup = GeneratedColumn<String>(
      'category_group', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceTextMeta =
      const VerificationMeta('priceText');
  @override
  late final GeneratedColumn<String> priceText = GeneratedColumn<String>(
      'price_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isBestSellerMeta =
      const VerificationMeta('isBestSeller');
  @override
  late final GeneratedColumn<bool> isBestSeller = GeneratedColumn<bool>(
      'is_best_seller', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_best_seller" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, placeId, categoryGroup, name, priceText, isBestSeller, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menu_items';
  @override
  VerificationContext validateIntegrity(Insertable<MenuItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta,
          placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('category_group')) {
      context.handle(
          _categoryGroupMeta,
          categoryGroup.isAcceptableOrUnknown(
              data['category_group']!, _categoryGroupMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price_text')) {
      context.handle(_priceTextMeta,
          priceText.isAcceptableOrUnknown(data['price_text']!, _priceTextMeta));
    } else if (isInserting) {
      context.missing(_priceTextMeta);
    }
    if (data.containsKey('is_best_seller')) {
      context.handle(
          _isBestSellerMeta,
          isBestSeller.isAcceptableOrUnknown(
              data['is_best_seller']!, _isBestSellerMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenuItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      placeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}place_id'])!,
      categoryGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_group']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      priceText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price_text'])!,
      isBestSeller: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_best_seller'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MenuItemsTable createAlias(String alias) {
    return $MenuItemsTable(attachedDatabase, alias);
  }
}

class MenuItem extends DataClass implements Insertable<MenuItem> {
  final String id;
  final String placeId;
  final String? categoryGroup;
  final String name;
  final String priceText;
  final bool isBestSeller;
  final DateTime createdAt;
  const MenuItem(
      {required this.id,
      required this.placeId,
      this.categoryGroup,
      required this.name,
      required this.priceText,
      required this.isBestSeller,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['place_id'] = Variable<String>(placeId);
    if (!nullToAbsent || categoryGroup != null) {
      map['category_group'] = Variable<String>(categoryGroup);
    }
    map['name'] = Variable<String>(name);
    map['price_text'] = Variable<String>(priceText);
    map['is_best_seller'] = Variable<bool>(isBestSeller);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MenuItemsCompanion toCompanion(bool nullToAbsent) {
    return MenuItemsCompanion(
      id: Value(id),
      placeId: Value(placeId),
      categoryGroup: categoryGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryGroup),
      name: Value(name),
      priceText: Value(priceText),
      isBestSeller: Value(isBestSeller),
      createdAt: Value(createdAt),
    );
  }

  factory MenuItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuItem(
      id: serializer.fromJson<String>(json['id']),
      placeId: serializer.fromJson<String>(json['placeId']),
      categoryGroup: serializer.fromJson<String?>(json['categoryGroup']),
      name: serializer.fromJson<String>(json['name']),
      priceText: serializer.fromJson<String>(json['priceText']),
      isBestSeller: serializer.fromJson<bool>(json['isBestSeller']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'placeId': serializer.toJson<String>(placeId),
      'categoryGroup': serializer.toJson<String?>(categoryGroup),
      'name': serializer.toJson<String>(name),
      'priceText': serializer.toJson<String>(priceText),
      'isBestSeller': serializer.toJson<bool>(isBestSeller),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MenuItem copyWith(
          {String? id,
          String? placeId,
          Value<String?> categoryGroup = const Value.absent(),
          String? name,
          String? priceText,
          bool? isBestSeller,
          DateTime? createdAt}) =>
      MenuItem(
        id: id ?? this.id,
        placeId: placeId ?? this.placeId,
        categoryGroup:
            categoryGroup.present ? categoryGroup.value : this.categoryGroup,
        name: name ?? this.name,
        priceText: priceText ?? this.priceText,
        isBestSeller: isBestSeller ?? this.isBestSeller,
        createdAt: createdAt ?? this.createdAt,
      );
  MenuItem copyWithCompanion(MenuItemsCompanion data) {
    return MenuItem(
      id: data.id.present ? data.id.value : this.id,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      categoryGroup: data.categoryGroup.present
          ? data.categoryGroup.value
          : this.categoryGroup,
      name: data.name.present ? data.name.value : this.name,
      priceText: data.priceText.present ? data.priceText.value : this.priceText,
      isBestSeller: data.isBestSeller.present
          ? data.isBestSeller.value
          : this.isBestSeller,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuItem(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('categoryGroup: $categoryGroup, ')
          ..write('name: $name, ')
          ..write('priceText: $priceText, ')
          ..write('isBestSeller: $isBestSeller, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, placeId, categoryGroup, name, priceText, isBestSeller, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuItem &&
          other.id == this.id &&
          other.placeId == this.placeId &&
          other.categoryGroup == this.categoryGroup &&
          other.name == this.name &&
          other.priceText == this.priceText &&
          other.isBestSeller == this.isBestSeller &&
          other.createdAt == this.createdAt);
}

class MenuItemsCompanion extends UpdateCompanion<MenuItem> {
  final Value<String> id;
  final Value<String> placeId;
  final Value<String?> categoryGroup;
  final Value<String> name;
  final Value<String> priceText;
  final Value<bool> isBestSeller;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MenuItemsCompanion({
    this.id = const Value.absent(),
    this.placeId = const Value.absent(),
    this.categoryGroup = const Value.absent(),
    this.name = const Value.absent(),
    this.priceText = const Value.absent(),
    this.isBestSeller = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MenuItemsCompanion.insert({
    required String id,
    required String placeId,
    this.categoryGroup = const Value.absent(),
    required String name,
    required String priceText,
    this.isBestSeller = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        placeId = Value(placeId),
        name = Value(name),
        priceText = Value(priceText);
  static Insertable<MenuItem> custom({
    Expression<String>? id,
    Expression<String>? placeId,
    Expression<String>? categoryGroup,
    Expression<String>? name,
    Expression<String>? priceText,
    Expression<bool>? isBestSeller,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (placeId != null) 'place_id': placeId,
      if (categoryGroup != null) 'category_group': categoryGroup,
      if (name != null) 'name': name,
      if (priceText != null) 'price_text': priceText,
      if (isBestSeller != null) 'is_best_seller': isBestSeller,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MenuItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? placeId,
      Value<String?>? categoryGroup,
      Value<String>? name,
      Value<String>? priceText,
      Value<bool>? isBestSeller,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return MenuItemsCompanion(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      categoryGroup: categoryGroup ?? this.categoryGroup,
      name: name ?? this.name,
      priceText: priceText ?? this.priceText,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (categoryGroup.present) {
      map['category_group'] = Variable<String>(categoryGroup.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (priceText.present) {
      map['price_text'] = Variable<String>(priceText.value);
    }
    if (isBestSeller.present) {
      map['is_best_seller'] = Variable<bool>(isBestSeller.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemsCompanion(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('categoryGroup: $categoryGroup, ')
          ..write('name: $name, ')
          ..write('priceText: $priceText, ')
          ..write('isBestSeller: $isBestSeller, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RatingsTable extends Ratings with TableInfo<$RatingsTable, Rating> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RatingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _placeIdMeta =
      const VerificationMeta('placeId');
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
      'place_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
      'stars', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, placeId, userId, stars, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ratings';
  @override
  VerificationContext validateIntegrity(Insertable<Rating> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta,
          placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('stars')) {
      context.handle(
          _starsMeta, stars.isAcceptableOrUnknown(data['stars']!, _starsMeta));
    } else if (isInserting) {
      context.missing(_starsMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rating map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rating(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      placeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}place_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      stars: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stars'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RatingsTable createAlias(String alias) {
    return $RatingsTable(attachedDatabase, alias);
  }
}

class Rating extends DataClass implements Insertable<Rating> {
  final String id;
  final String placeId;
  final String? userId;
  final int stars;
  final String? note;
  final DateTime createdAt;
  const Rating(
      {required this.id,
      required this.placeId,
      this.userId,
      required this.stars,
      this.note,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['place_id'] = Variable<String>(placeId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['stars'] = Variable<int>(stars);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RatingsCompanion toCompanion(bool nullToAbsent) {
    return RatingsCompanion(
      id: Value(id),
      placeId: Value(placeId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      stars: Value(stars),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Rating.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rating(
      id: serializer.fromJson<String>(json['id']),
      placeId: serializer.fromJson<String>(json['placeId']),
      userId: serializer.fromJson<String?>(json['userId']),
      stars: serializer.fromJson<int>(json['stars']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'placeId': serializer.toJson<String>(placeId),
      'userId': serializer.toJson<String?>(userId),
      'stars': serializer.toJson<int>(stars),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Rating copyWith(
          {String? id,
          String? placeId,
          Value<String?> userId = const Value.absent(),
          int? stars,
          Value<String?> note = const Value.absent(),
          DateTime? createdAt}) =>
      Rating(
        id: id ?? this.id,
        placeId: placeId ?? this.placeId,
        userId: userId.present ? userId.value : this.userId,
        stars: stars ?? this.stars,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
      );
  Rating copyWithCompanion(RatingsCompanion data) {
    return Rating(
      id: data.id.present ? data.id.value : this.id,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      userId: data.userId.present ? data.userId.value : this.userId,
      stars: data.stars.present ? data.stars.value : this.stars,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rating(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('userId: $userId, ')
          ..write('stars: $stars, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, placeId, userId, stars, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rating &&
          other.id == this.id &&
          other.placeId == this.placeId &&
          other.userId == this.userId &&
          other.stars == this.stars &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class RatingsCompanion extends UpdateCompanion<Rating> {
  final Value<String> id;
  final Value<String> placeId;
  final Value<String?> userId;
  final Value<int> stars;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RatingsCompanion({
    this.id = const Value.absent(),
    this.placeId = const Value.absent(),
    this.userId = const Value.absent(),
    this.stars = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RatingsCompanion.insert({
    required String id,
    required String placeId,
    this.userId = const Value.absent(),
    required int stars,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        placeId = Value(placeId),
        stars = Value(stars);
  static Insertable<Rating> custom({
    Expression<String>? id,
    Expression<String>? placeId,
    Expression<String>? userId,
    Expression<int>? stars,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (placeId != null) 'place_id': placeId,
      if (userId != null) 'user_id': userId,
      if (stars != null) 'stars': stars,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RatingsCompanion copyWith(
      {Value<String>? id,
      Value<String>? placeId,
      Value<String?>? userId,
      Value<int>? stars,
      Value<String?>? note,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return RatingsCompanion(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      userId: userId ?? this.userId,
      stars: stars ?? this.stars,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RatingsCompanion(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('userId: $userId, ')
          ..write('stars: $stars, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaceImagesTable extends PlaceImages
    with TableInfo<$PlaceImagesTable, PlaceImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaceImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _placeIdMeta =
      const VerificationMeta('placeId');
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
      'place_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isPrimaryMeta =
      const VerificationMeta('isPrimary');
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
      'is_primary', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_primary" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, placeId, localPath, isPrimary, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'place_images';
  @override
  VerificationContext validateIntegrity(Insertable<PlaceImage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta,
          placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('is_primary')) {
      context.handle(_isPrimaryMeta,
          isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaceImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaceImage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      placeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}place_id'])!,
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path'])!,
      isPrimary: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_primary'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PlaceImagesTable createAlias(String alias) {
    return $PlaceImagesTable(attachedDatabase, alias);
  }
}

class PlaceImage extends DataClass implements Insertable<PlaceImage> {
  final String id;
  final String placeId;
  final String localPath;
  final bool isPrimary;
  final DateTime createdAt;
  const PlaceImage(
      {required this.id,
      required this.placeId,
      required this.localPath,
      required this.isPrimary,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['place_id'] = Variable<String>(placeId);
    map['local_path'] = Variable<String>(localPath);
    map['is_primary'] = Variable<bool>(isPrimary);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PlaceImagesCompanion toCompanion(bool nullToAbsent) {
    return PlaceImagesCompanion(
      id: Value(id),
      placeId: Value(placeId),
      localPath: Value(localPath),
      isPrimary: Value(isPrimary),
      createdAt: Value(createdAt),
    );
  }

  factory PlaceImage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaceImage(
      id: serializer.fromJson<String>(json['id']),
      placeId: serializer.fromJson<String>(json['placeId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'placeId': serializer.toJson<String>(placeId),
      'localPath': serializer.toJson<String>(localPath),
      'isPrimary': serializer.toJson<bool>(isPrimary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PlaceImage copyWith(
          {String? id,
          String? placeId,
          String? localPath,
          bool? isPrimary,
          DateTime? createdAt}) =>
      PlaceImage(
        id: id ?? this.id,
        placeId: placeId ?? this.placeId,
        localPath: localPath ?? this.localPath,
        isPrimary: isPrimary ?? this.isPrimary,
        createdAt: createdAt ?? this.createdAt,
      );
  PlaceImage copyWithCompanion(PlaceImagesCompanion data) {
    return PlaceImage(
      id: data.id.present ? data.id.value : this.id,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaceImage(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('localPath: $localPath, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, placeId, localPath, isPrimary, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaceImage &&
          other.id == this.id &&
          other.placeId == this.placeId &&
          other.localPath == this.localPath &&
          other.isPrimary == this.isPrimary &&
          other.createdAt == this.createdAt);
}

class PlaceImagesCompanion extends UpdateCompanion<PlaceImage> {
  final Value<String> id;
  final Value<String> placeId;
  final Value<String> localPath;
  final Value<bool> isPrimary;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PlaceImagesCompanion({
    this.id = const Value.absent(),
    this.placeId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaceImagesCompanion.insert({
    required String id,
    required String placeId,
    required String localPath,
    this.isPrimary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        placeId = Value(placeId),
        localPath = Value(localPath);
  static Insertable<PlaceImage> custom({
    Expression<String>? id,
    Expression<String>? placeId,
    Expression<String>? localPath,
    Expression<bool>? isPrimary,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (placeId != null) 'place_id': placeId,
      if (localPath != null) 'local_path': localPath,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaceImagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? placeId,
      Value<String>? localPath,
      Value<bool>? isPrimary,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PlaceImagesCompanion(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      localPath: localPath ?? this.localPath,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaceImagesCompanion(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('localPath: $localPath, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommentsTable extends Comments with TableInfo<$CommentsTable, Comment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _placeIdMeta =
      const VerificationMeta('placeId');
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
      'place_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isApprovedMeta =
      const VerificationMeta('isApproved');
  @override
  late final GeneratedColumn<bool> isApproved = GeneratedColumn<bool>(
      'is_approved', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_approved" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, placeId, userId, content, isApproved, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'comments';
  @override
  VerificationContext validateIntegrity(Insertable<Comment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta,
          placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_approved')) {
      context.handle(
          _isApprovedMeta,
          isApproved.isAcceptableOrUnknown(
              data['is_approved']!, _isApprovedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Comment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Comment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      placeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}place_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      isApproved: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_approved'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CommentsTable createAlias(String alias) {
    return $CommentsTable(attachedDatabase, alias);
  }
}

class Comment extends DataClass implements Insertable<Comment> {
  final String id;
  final String placeId;
  final String userId;
  final String content;
  final bool isApproved;
  final DateTime createdAt;
  const Comment(
      {required this.id,
      required this.placeId,
      required this.userId,
      required this.content,
      required this.isApproved,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['place_id'] = Variable<String>(placeId);
    map['user_id'] = Variable<String>(userId);
    map['content'] = Variable<String>(content);
    map['is_approved'] = Variable<bool>(isApproved);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CommentsCompanion toCompanion(bool nullToAbsent) {
    return CommentsCompanion(
      id: Value(id),
      placeId: Value(placeId),
      userId: Value(userId),
      content: Value(content),
      isApproved: Value(isApproved),
      createdAt: Value(createdAt),
    );
  }

  factory Comment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Comment(
      id: serializer.fromJson<String>(json['id']),
      placeId: serializer.fromJson<String>(json['placeId']),
      userId: serializer.fromJson<String>(json['userId']),
      content: serializer.fromJson<String>(json['content']),
      isApproved: serializer.fromJson<bool>(json['isApproved']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'placeId': serializer.toJson<String>(placeId),
      'userId': serializer.toJson<String>(userId),
      'content': serializer.toJson<String>(content),
      'isApproved': serializer.toJson<bool>(isApproved),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Comment copyWith(
          {String? id,
          String? placeId,
          String? userId,
          String? content,
          bool? isApproved,
          DateTime? createdAt}) =>
      Comment(
        id: id ?? this.id,
        placeId: placeId ?? this.placeId,
        userId: userId ?? this.userId,
        content: content ?? this.content,
        isApproved: isApproved ?? this.isApproved,
        createdAt: createdAt ?? this.createdAt,
      );
  Comment copyWithCompanion(CommentsCompanion data) {
    return Comment(
      id: data.id.present ? data.id.value : this.id,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      userId: data.userId.present ? data.userId.value : this.userId,
      content: data.content.present ? data.content.value : this.content,
      isApproved:
          data.isApproved.present ? data.isApproved.value : this.isApproved,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Comment(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('userId: $userId, ')
          ..write('content: $content, ')
          ..write('isApproved: $isApproved, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, placeId, userId, content, isApproved, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Comment &&
          other.id == this.id &&
          other.placeId == this.placeId &&
          other.userId == this.userId &&
          other.content == this.content &&
          other.isApproved == this.isApproved &&
          other.createdAt == this.createdAt);
}

class CommentsCompanion extends UpdateCompanion<Comment> {
  final Value<String> id;
  final Value<String> placeId;
  final Value<String> userId;
  final Value<String> content;
  final Value<bool> isApproved;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CommentsCompanion({
    this.id = const Value.absent(),
    this.placeId = const Value.absent(),
    this.userId = const Value.absent(),
    this.content = const Value.absent(),
    this.isApproved = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommentsCompanion.insert({
    required String id,
    required String placeId,
    required String userId,
    required String content,
    this.isApproved = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        placeId = Value(placeId),
        userId = Value(userId),
        content = Value(content);
  static Insertable<Comment> custom({
    Expression<String>? id,
    Expression<String>? placeId,
    Expression<String>? userId,
    Expression<String>? content,
    Expression<bool>? isApproved,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (placeId != null) 'place_id': placeId,
      if (userId != null) 'user_id': userId,
      if (content != null) 'content': content,
      if (isApproved != null) 'is_approved': isApproved,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? placeId,
      Value<String>? userId,
      Value<String>? content,
      Value<bool>? isApproved,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CommentsCompanion(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isApproved.present) {
      map['is_approved'] = Variable<bool>(isApproved.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommentsCompanion(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('userId: $userId, ')
          ..write('content: $content, ')
          ..write('isApproved: $isApproved, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $PlacesTable places = $PlacesTable(this);
  late final $MenuItemsTable menuItems = $MenuItemsTable(this);
  late final $RatingsTable ratings = $RatingsTable(this);
  late final $PlaceImagesTable placeImages = $PlaceImagesTable(this);
  late final $CommentsTable comments = $CommentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, places, menuItems, ratings, placeImages, comments];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String name,
  required String phone,
  required String passwordHash,
  Value<String> role,
  Value<bool> canAddPlace,
  Value<bool> canEditPlace,
  Value<bool> canDeletePlace,
  Value<bool> canRate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> phone,
  Value<String> passwordHash,
  Value<String> role,
  Value<bool> canAddPlace,
  Value<bool> canEditPlace,
  Value<bool> canDeletePlace,
  Value<bool> canRate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get canAddPlace => $composableBuilder(
      column: $table.canAddPlace, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get canEditPlace => $composableBuilder(
      column: $table.canEditPlace, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get canDeletePlace => $composableBuilder(
      column: $table.canDeletePlace,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get canRate => $composableBuilder(
      column: $table.canRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
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
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get canAddPlace => $composableBuilder(
      column: $table.canAddPlace, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get canEditPlace => $composableBuilder(
      column: $table.canEditPlace,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get canDeletePlace => $composableBuilder(
      column: $table.canDeletePlace,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get canRate => $composableBuilder(
      column: $table.canRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get canAddPlace => $composableBuilder(
      column: $table.canAddPlace, builder: (column) => column);

  GeneratedColumn<bool> get canEditPlace => $composableBuilder(
      column: $table.canEditPlace, builder: (column) => column);

  GeneratedColumn<bool> get canDeletePlace => $composableBuilder(
      column: $table.canDeletePlace, builder: (column) => column);

  GeneratedColumn<bool> get canRate =>
      $composableBuilder(column: $table.canRate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<bool> canAddPlace = const Value.absent(),
            Value<bool> canEditPlace = const Value.absent(),
            Value<bool> canDeletePlace = const Value.absent(),
            Value<bool> canRate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            name: name,
            phone: phone,
            passwordHash: passwordHash,
            role: role,
            canAddPlace: canAddPlace,
            canEditPlace: canEditPlace,
            canDeletePlace: canDeletePlace,
            canRate: canRate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String phone,
            required String passwordHash,
            Value<String> role = const Value.absent(),
            Value<bool> canAddPlace = const Value.absent(),
            Value<bool> canEditPlace = const Value.absent(),
            Value<bool> canDeletePlace = const Value.absent(),
            Value<bool> canRate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            passwordHash: passwordHash,
            role: role,
            canAddPlace: canAddPlace,
            canEditPlace: canEditPlace,
            canDeletePlace: canDeletePlace,
            canRate: canRate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$PlacesTableCreateCompanionBuilder = PlacesCompanion Function({
  required String id,
  Value<String> type,
  required String name,
  Value<String?> phone,
  Value<String?> phone2,
  Value<String?> address,
  Value<String> rawText,
  Value<bool> freeship,
  Value<String?> freeshipNote,
  Value<String?> openHours,
  Value<String?> category,
  Value<String?> avgPriceRange,
  Value<String?> note,
  Value<String?> createdBy,
  Value<int> viewCount,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$PlacesTableUpdateCompanionBuilder = PlacesCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> name,
  Value<String?> phone,
  Value<String?> phone2,
  Value<String?> address,
  Value<String> rawText,
  Value<bool> freeship,
  Value<String?> freeshipNote,
  Value<String?> openHours,
  Value<String?> category,
  Value<String?> avgPriceRange,
  Value<String?> note,
  Value<String?> createdBy,
  Value<int> viewCount,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PlacesTableFilterComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone2 => $composableBuilder(
      column: $table.phone2, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawText => $composableBuilder(
      column: $table.rawText, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get freeship => $composableBuilder(
      column: $table.freeship, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get freeshipNote => $composableBuilder(
      column: $table.freeshipNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get openHours => $composableBuilder(
      column: $table.openHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avgPriceRange => $composableBuilder(
      column: $table.avgPriceRange, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get viewCount => $composableBuilder(
      column: $table.viewCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PlacesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone2 => $composableBuilder(
      column: $table.phone2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawText => $composableBuilder(
      column: $table.rawText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get freeship => $composableBuilder(
      column: $table.freeship, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get freeshipNote => $composableBuilder(
      column: $table.freeshipNote,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get openHours => $composableBuilder(
      column: $table.openHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avgPriceRange => $composableBuilder(
      column: $table.avgPriceRange,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get viewCount => $composableBuilder(
      column: $table.viewCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PlacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get phone2 =>
      $composableBuilder(column: $table.phone2, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => column);

  GeneratedColumn<bool> get freeship =>
      $composableBuilder(column: $table.freeship, builder: (column) => column);

  GeneratedColumn<String> get freeshipNote => $composableBuilder(
      column: $table.freeshipNote, builder: (column) => column);

  GeneratedColumn<String> get openHours =>
      $composableBuilder(column: $table.openHours, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get avgPriceRange => $composableBuilder(
      column: $table.avgPriceRange, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<int> get viewCount =>
      $composableBuilder(column: $table.viewCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PlacesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlacesTable,
    Place,
    $$PlacesTableFilterComposer,
    $$PlacesTableOrderingComposer,
    $$PlacesTableAnnotationComposer,
    $$PlacesTableCreateCompanionBuilder,
    $$PlacesTableUpdateCompanionBuilder,
    (Place, BaseReferences<_$AppDatabase, $PlacesTable, Place>),
    Place,
    PrefetchHooks Function()> {
  $$PlacesTableTableManager(_$AppDatabase db, $PlacesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> phone2 = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String> rawText = const Value.absent(),
            Value<bool> freeship = const Value.absent(),
            Value<String?> freeshipNote = const Value.absent(),
            Value<String?> openHours = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String?> avgPriceRange = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<int> viewCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlacesCompanion(
            id: id,
            type: type,
            name: name,
            phone: phone,
            phone2: phone2,
            address: address,
            rawText: rawText,
            freeship: freeship,
            freeshipNote: freeshipNote,
            openHours: openHours,
            category: category,
            avgPriceRange: avgPriceRange,
            note: note,
            createdBy: createdBy,
            viewCount: viewCount,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> type = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> phone2 = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String> rawText = const Value.absent(),
            Value<bool> freeship = const Value.absent(),
            Value<String?> freeshipNote = const Value.absent(),
            Value<String?> openHours = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String?> avgPriceRange = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<int> viewCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlacesCompanion.insert(
            id: id,
            type: type,
            name: name,
            phone: phone,
            phone2: phone2,
            address: address,
            rawText: rawText,
            freeship: freeship,
            freeshipNote: freeshipNote,
            openHours: openHours,
            category: category,
            avgPriceRange: avgPriceRange,
            note: note,
            createdBy: createdBy,
            viewCount: viewCount,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlacesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlacesTable,
    Place,
    $$PlacesTableFilterComposer,
    $$PlacesTableOrderingComposer,
    $$PlacesTableAnnotationComposer,
    $$PlacesTableCreateCompanionBuilder,
    $$PlacesTableUpdateCompanionBuilder,
    (Place, BaseReferences<_$AppDatabase, $PlacesTable, Place>),
    Place,
    PrefetchHooks Function()>;
typedef $$MenuItemsTableCreateCompanionBuilder = MenuItemsCompanion Function({
  required String id,
  required String placeId,
  Value<String?> categoryGroup,
  required String name,
  required String priceText,
  Value<bool> isBestSeller,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$MenuItemsTableUpdateCompanionBuilder = MenuItemsCompanion Function({
  Value<String> id,
  Value<String> placeId,
  Value<String?> categoryGroup,
  Value<String> name,
  Value<String> priceText,
  Value<bool> isBestSeller,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$MenuItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MenuItemsTable> {
  $$MenuItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placeId => $composableBuilder(
      column: $table.placeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryGroup => $composableBuilder(
      column: $table.categoryGroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priceText => $composableBuilder(
      column: $table.priceText, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBestSeller => $composableBuilder(
      column: $table.isBestSeller, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$MenuItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MenuItemsTable> {
  $$MenuItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placeId => $composableBuilder(
      column: $table.placeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryGroup => $composableBuilder(
      column: $table.categoryGroup,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priceText => $composableBuilder(
      column: $table.priceText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBestSeller => $composableBuilder(
      column: $table.isBestSeller,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$MenuItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MenuItemsTable> {
  $$MenuItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<String> get categoryGroup => $composableBuilder(
      column: $table.categoryGroup, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get priceText =>
      $composableBuilder(column: $table.priceText, builder: (column) => column);

  GeneratedColumn<bool> get isBestSeller => $composableBuilder(
      column: $table.isBestSeller, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MenuItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MenuItemsTable,
    MenuItem,
    $$MenuItemsTableFilterComposer,
    $$MenuItemsTableOrderingComposer,
    $$MenuItemsTableAnnotationComposer,
    $$MenuItemsTableCreateCompanionBuilder,
    $$MenuItemsTableUpdateCompanionBuilder,
    (MenuItem, BaseReferences<_$AppDatabase, $MenuItemsTable, MenuItem>),
    MenuItem,
    PrefetchHooks Function()> {
  $$MenuItemsTableTableManager(_$AppDatabase db, $MenuItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenuItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenuItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenuItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> placeId = const Value.absent(),
            Value<String?> categoryGroup = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> priceText = const Value.absent(),
            Value<bool> isBestSeller = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MenuItemsCompanion(
            id: id,
            placeId: placeId,
            categoryGroup: categoryGroup,
            name: name,
            priceText: priceText,
            isBestSeller: isBestSeller,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String placeId,
            Value<String?> categoryGroup = const Value.absent(),
            required String name,
            required String priceText,
            Value<bool> isBestSeller = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MenuItemsCompanion.insert(
            id: id,
            placeId: placeId,
            categoryGroup: categoryGroup,
            name: name,
            priceText: priceText,
            isBestSeller: isBestSeller,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MenuItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MenuItemsTable,
    MenuItem,
    $$MenuItemsTableFilterComposer,
    $$MenuItemsTableOrderingComposer,
    $$MenuItemsTableAnnotationComposer,
    $$MenuItemsTableCreateCompanionBuilder,
    $$MenuItemsTableUpdateCompanionBuilder,
    (MenuItem, BaseReferences<_$AppDatabase, $MenuItemsTable, MenuItem>),
    MenuItem,
    PrefetchHooks Function()>;
typedef $$RatingsTableCreateCompanionBuilder = RatingsCompanion Function({
  required String id,
  required String placeId,
  Value<String?> userId,
  required int stars,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$RatingsTableUpdateCompanionBuilder = RatingsCompanion Function({
  Value<String> id,
  Value<String> placeId,
  Value<String?> userId,
  Value<int> stars,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$RatingsTableFilterComposer
    extends Composer<_$AppDatabase, $RatingsTable> {
  $$RatingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placeId => $composableBuilder(
      column: $table.placeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stars => $composableBuilder(
      column: $table.stars, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$RatingsTableOrderingComposer
    extends Composer<_$AppDatabase, $RatingsTable> {
  $$RatingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placeId => $composableBuilder(
      column: $table.placeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stars => $composableBuilder(
      column: $table.stars, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RatingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RatingsTable> {
  $$RatingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RatingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RatingsTable,
    Rating,
    $$RatingsTableFilterComposer,
    $$RatingsTableOrderingComposer,
    $$RatingsTableAnnotationComposer,
    $$RatingsTableCreateCompanionBuilder,
    $$RatingsTableUpdateCompanionBuilder,
    (Rating, BaseReferences<_$AppDatabase, $RatingsTable, Rating>),
    Rating,
    PrefetchHooks Function()> {
  $$RatingsTableTableManager(_$AppDatabase db, $RatingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RatingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RatingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RatingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> placeId = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<int> stars = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RatingsCompanion(
            id: id,
            placeId: placeId,
            userId: userId,
            stars: stars,
            note: note,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String placeId,
            Value<String?> userId = const Value.absent(),
            required int stars,
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RatingsCompanion.insert(
            id: id,
            placeId: placeId,
            userId: userId,
            stars: stars,
            note: note,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RatingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RatingsTable,
    Rating,
    $$RatingsTableFilterComposer,
    $$RatingsTableOrderingComposer,
    $$RatingsTableAnnotationComposer,
    $$RatingsTableCreateCompanionBuilder,
    $$RatingsTableUpdateCompanionBuilder,
    (Rating, BaseReferences<_$AppDatabase, $RatingsTable, Rating>),
    Rating,
    PrefetchHooks Function()>;
typedef $$PlaceImagesTableCreateCompanionBuilder = PlaceImagesCompanion
    Function({
  required String id,
  required String placeId,
  required String localPath,
  Value<bool> isPrimary,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$PlaceImagesTableUpdateCompanionBuilder = PlaceImagesCompanion
    Function({
  Value<String> id,
  Value<String> placeId,
  Value<String> localPath,
  Value<bool> isPrimary,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$PlaceImagesTableFilterComposer
    extends Composer<_$AppDatabase, $PlaceImagesTable> {
  $$PlaceImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placeId => $composableBuilder(
      column: $table.placeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPrimary => $composableBuilder(
      column: $table.isPrimary, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PlaceImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaceImagesTable> {
  $$PlaceImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placeId => $composableBuilder(
      column: $table.placeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
      column: $table.isPrimary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PlaceImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaceImagesTable> {
  $$PlaceImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PlaceImagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaceImagesTable,
    PlaceImage,
    $$PlaceImagesTableFilterComposer,
    $$PlaceImagesTableOrderingComposer,
    $$PlaceImagesTableAnnotationComposer,
    $$PlaceImagesTableCreateCompanionBuilder,
    $$PlaceImagesTableUpdateCompanionBuilder,
    (PlaceImage, BaseReferences<_$AppDatabase, $PlaceImagesTable, PlaceImage>),
    PlaceImage,
    PrefetchHooks Function()> {
  $$PlaceImagesTableTableManager(_$AppDatabase db, $PlaceImagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaceImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaceImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaceImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> placeId = const Value.absent(),
            Value<String> localPath = const Value.absent(),
            Value<bool> isPrimary = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaceImagesCompanion(
            id: id,
            placeId: placeId,
            localPath: localPath,
            isPrimary: isPrimary,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String placeId,
            required String localPath,
            Value<bool> isPrimary = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaceImagesCompanion.insert(
            id: id,
            placeId: placeId,
            localPath: localPath,
            isPrimary: isPrimary,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlaceImagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlaceImagesTable,
    PlaceImage,
    $$PlaceImagesTableFilterComposer,
    $$PlaceImagesTableOrderingComposer,
    $$PlaceImagesTableAnnotationComposer,
    $$PlaceImagesTableCreateCompanionBuilder,
    $$PlaceImagesTableUpdateCompanionBuilder,
    (PlaceImage, BaseReferences<_$AppDatabase, $PlaceImagesTable, PlaceImage>),
    PlaceImage,
    PrefetchHooks Function()>;
typedef $$CommentsTableCreateCompanionBuilder = CommentsCompanion Function({
  required String id,
  required String placeId,
  required String userId,
  required String content,
  Value<bool> isApproved,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$CommentsTableUpdateCompanionBuilder = CommentsCompanion Function({
  Value<String> id,
  Value<String> placeId,
  Value<String> userId,
  Value<String> content,
  Value<bool> isApproved,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$CommentsTableFilterComposer
    extends Composer<_$AppDatabase, $CommentsTable> {
  $$CommentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placeId => $composableBuilder(
      column: $table.placeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isApproved => $composableBuilder(
      column: $table.isApproved, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CommentsTableOrderingComposer
    extends Composer<_$AppDatabase, $CommentsTable> {
  $$CommentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placeId => $composableBuilder(
      column: $table.placeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isApproved => $composableBuilder(
      column: $table.isApproved, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CommentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CommentsTable> {
  $$CommentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isApproved => $composableBuilder(
      column: $table.isApproved, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CommentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CommentsTable,
    Comment,
    $$CommentsTableFilterComposer,
    $$CommentsTableOrderingComposer,
    $$CommentsTableAnnotationComposer,
    $$CommentsTableCreateCompanionBuilder,
    $$CommentsTableUpdateCompanionBuilder,
    (Comment, BaseReferences<_$AppDatabase, $CommentsTable, Comment>),
    Comment,
    PrefetchHooks Function()> {
  $$CommentsTableTableManager(_$AppDatabase db, $CommentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> placeId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<bool> isApproved = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CommentsCompanion(
            id: id,
            placeId: placeId,
            userId: userId,
            content: content,
            isApproved: isApproved,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String placeId,
            required String userId,
            required String content,
            Value<bool> isApproved = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CommentsCompanion.insert(
            id: id,
            placeId: placeId,
            userId: userId,
            content: content,
            isApproved: isApproved,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CommentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CommentsTable,
    Comment,
    $$CommentsTableFilterComposer,
    $$CommentsTableOrderingComposer,
    $$CommentsTableAnnotationComposer,
    $$CommentsTableCreateCompanionBuilder,
    $$CommentsTableUpdateCompanionBuilder,
    (Comment, BaseReferences<_$AppDatabase, $CommentsTable, Comment>),
    Comment,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$PlacesTableTableManager get places =>
      $$PlacesTableTableManager(_db, _db.places);
  $$MenuItemsTableTableManager get menuItems =>
      $$MenuItemsTableTableManager(_db, _db.menuItems);
  $$RatingsTableTableManager get ratings =>
      $$RatingsTableTableManager(_db, _db.ratings);
  $$PlaceImagesTableTableManager get placeImages =>
      $$PlaceImagesTableTableManager(_db, _db.placeImages);
  $$CommentsTableTableManager get comments =>
      $$CommentsTableTableManager(_db, _db.comments);
}
