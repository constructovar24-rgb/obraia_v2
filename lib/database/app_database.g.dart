// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _apellidosMeta = const VerificationMeta(
    'apellidos',
  );
  @override
  late final GeneratedColumn<String> apellidos = GeneratedColumn<String>(
    'apellidos',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nifMeta = const VerificationMeta('nif');
  @override
  late final GeneratedColumn<String> nif = GeneratedColumn<String>(
    'nif',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _poblacionMeta = const VerificationMeta(
    'poblacion',
  );
  @override
  late final GeneratedColumn<String> poblacion = GeneratedColumn<String>(
    'poblacion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _provinciaMeta = const VerificationMeta(
    'provincia',
  );
  @override
  late final GeneratedColumn<String> provincia = GeneratedColumn<String>(
    'provincia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _codigoPostalMeta = const VerificationMeta(
    'codigoPostal',
  );
  @override
  late final GeneratedColumn<String> codigoPostal = GeneratedColumn<String>(
    'codigo_postal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _paisMeta = const VerificationMeta('pais');
  @override
  late final GeneratedColumn<String> pais = GeneratedColumn<String>(
    'pais',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('España'),
  );
  static const VerificationMeta _empresaMeta = const VerificationMeta(
    'empresa',
  );
  @override
  late final GeneratedColumn<String> empresa = GeneratedColumn<String>(
    'empresa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<int> estado = GeneratedColumn<int>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _eliminadoMeta = const VerificationMeta(
    'eliminado',
  );
  @override
  late final GeneratedColumn<bool> eliminado = GeneratedColumn<bool>(
    'eliminado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("eliminado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _fechaModificacionMeta = const VerificationMeta(
    'fechaModificacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaModificacion =
      GeneratedColumn<DateTime>(
        'fecha_modificacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    apellidos,
    nif,
    telefono,
    email,
    direccion,
    poblacion,
    provincia,
    codigoPostal,
    pais,
    empresa,
    observaciones,
    estado,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('apellidos')) {
      context.handle(
        _apellidosMeta,
        apellidos.isAcceptableOrUnknown(data['apellidos']!, _apellidosMeta),
      );
    }
    if (data.containsKey('nif')) {
      context.handle(
        _nifMeta,
        nif.isAcceptableOrUnknown(data['nif']!, _nifMeta),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    }
    if (data.containsKey('poblacion')) {
      context.handle(
        _poblacionMeta,
        poblacion.isAcceptableOrUnknown(data['poblacion']!, _poblacionMeta),
      );
    }
    if (data.containsKey('provincia')) {
      context.handle(
        _provinciaMeta,
        provincia.isAcceptableOrUnknown(data['provincia']!, _provinciaMeta),
      );
    }
    if (data.containsKey('codigo_postal')) {
      context.handle(
        _codigoPostalMeta,
        codigoPostal.isAcceptableOrUnknown(
          data['codigo_postal']!,
          _codigoPostalMeta,
        ),
      );
    }
    if (data.containsKey('pais')) {
      context.handle(
        _paisMeta,
        pais.isAcceptableOrUnknown(data['pais']!, _paisMeta),
      );
    }
    if (data.containsKey('empresa')) {
      context.handle(
        _empresaMeta,
        empresa.isAcceptableOrUnknown(data['empresa']!, _empresaMeta),
      );
    }
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('eliminado')) {
      context.handle(
        _eliminadoMeta,
        eliminado.isAcceptableOrUnknown(data['eliminado']!, _eliminadoMeta),
      );
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    if (data.containsKey('fecha_modificacion')) {
      context.handle(
        _fechaModificacionMeta,
        fechaModificacion.isAcceptableOrUnknown(
          data['fecha_modificacion']!,
          _fechaModificacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      apellidos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apellidos'],
      )!,
      nif: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nif'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      poblacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poblacion'],
      )!,
      provincia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provincia'],
      )!,
      codigoPostal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_postal'],
      )!,
      pais: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pais'],
      )!,
      empresa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa'],
      )!,
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estado'],
      )!,
      eliminado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}eliminado'],
      )!,
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      fechaModificacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_modificacion'],
      )!,
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final String id;
  final String nombre;
  final String apellidos;
  final String nif;
  final String telefono;
  final String email;
  final String direccion;
  final String poblacion;
  final String provincia;
  final String codigoPostal;
  final String pais;
  final String empresa;
  final String observaciones;
  final int estado;
  final bool eliminado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  const Cliente({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.nif,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.poblacion,
    required this.provincia,
    required this.codigoPostal,
    required this.pais,
    required this.empresa,
    required this.observaciones,
    required this.estado,
    required this.eliminado,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['apellidos'] = Variable<String>(apellidos);
    map['nif'] = Variable<String>(nif);
    map['telefono'] = Variable<String>(telefono);
    map['email'] = Variable<String>(email);
    map['direccion'] = Variable<String>(direccion);
    map['poblacion'] = Variable<String>(poblacion);
    map['provincia'] = Variable<String>(provincia);
    map['codigo_postal'] = Variable<String>(codigoPostal);
    map['pais'] = Variable<String>(pais);
    map['empresa'] = Variable<String>(empresa);
    map['observaciones'] = Variable<String>(observaciones);
    map['estado'] = Variable<int>(estado);
    map['eliminado'] = Variable<bool>(eliminado);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion);
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      apellidos: Value(apellidos),
      nif: Value(nif),
      telefono: Value(telefono),
      email: Value(email),
      direccion: Value(direccion),
      poblacion: Value(poblacion),
      provincia: Value(provincia),
      codigoPostal: Value(codigoPostal),
      pais: Value(pais),
      empresa: Value(empresa),
      observaciones: Value(observaciones),
      estado: Value(estado),
      eliminado: Value(eliminado),
      fechaCreacion: Value(fechaCreacion),
      fechaModificacion: Value(fechaModificacion),
    );
  }

  factory Cliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      apellidos: serializer.fromJson<String>(json['apellidos']),
      nif: serializer.fromJson<String>(json['nif']),
      telefono: serializer.fromJson<String>(json['telefono']),
      email: serializer.fromJson<String>(json['email']),
      direccion: serializer.fromJson<String>(json['direccion']),
      poblacion: serializer.fromJson<String>(json['poblacion']),
      provincia: serializer.fromJson<String>(json['provincia']),
      codigoPostal: serializer.fromJson<String>(json['codigoPostal']),
      pais: serializer.fromJson<String>(json['pais']),
      empresa: serializer.fromJson<String>(json['empresa']),
      observaciones: serializer.fromJson<String>(json['observaciones']),
      estado: serializer.fromJson<int>(json['estado']),
      eliminado: serializer.fromJson<bool>(json['eliminado']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
      fechaModificacion: serializer.fromJson<DateTime>(
        json['fechaModificacion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'apellidos': serializer.toJson<String>(apellidos),
      'nif': serializer.toJson<String>(nif),
      'telefono': serializer.toJson<String>(telefono),
      'email': serializer.toJson<String>(email),
      'direccion': serializer.toJson<String>(direccion),
      'poblacion': serializer.toJson<String>(poblacion),
      'provincia': serializer.toJson<String>(provincia),
      'codigoPostal': serializer.toJson<String>(codigoPostal),
      'pais': serializer.toJson<String>(pais),
      'empresa': serializer.toJson<String>(empresa),
      'observaciones': serializer.toJson<String>(observaciones),
      'estado': serializer.toJson<int>(estado),
      'eliminado': serializer.toJson<bool>(eliminado),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaModificacion': serializer.toJson<DateTime>(fechaModificacion),
    };
  }

  Cliente copyWith({
    String? id,
    String? nombre,
    String? apellidos,
    String? nif,
    String? telefono,
    String? email,
    String? direccion,
    String? poblacion,
    String? provincia,
    String? codigoPostal,
    String? pais,
    String? empresa,
    String? observaciones,
    int? estado,
    bool? eliminado,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
  }) => Cliente(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    apellidos: apellidos ?? this.apellidos,
    nif: nif ?? this.nif,
    telefono: telefono ?? this.telefono,
    email: email ?? this.email,
    direccion: direccion ?? this.direccion,
    poblacion: poblacion ?? this.poblacion,
    provincia: provincia ?? this.provincia,
    codigoPostal: codigoPostal ?? this.codigoPostal,
    pais: pais ?? this.pais,
    empresa: empresa ?? this.empresa,
    observaciones: observaciones ?? this.observaciones,
    estado: estado ?? this.estado,
    eliminado: eliminado ?? this.eliminado,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaModificacion: fechaModificacion ?? this.fechaModificacion,
  );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      apellidos: data.apellidos.present ? data.apellidos.value : this.apellidos,
      nif: data.nif.present ? data.nif.value : this.nif,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      poblacion: data.poblacion.present ? data.poblacion.value : this.poblacion,
      provincia: data.provincia.present ? data.provincia.value : this.provincia,
      codigoPostal: data.codigoPostal.present
          ? data.codigoPostal.value
          : this.codigoPostal,
      pais: data.pais.present ? data.pais.value : this.pais,
      empresa: data.empresa.present ? data.empresa.value : this.empresa,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      estado: data.estado.present ? data.estado.value : this.estado,
      eliminado: data.eliminado.present ? data.eliminado.value : this.eliminado,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaModificacion: data.fechaModificacion.present
          ? data.fechaModificacion.value
          : this.fechaModificacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('apellidos: $apellidos, ')
          ..write('nif: $nif, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('poblacion: $poblacion, ')
          ..write('provincia: $provincia, ')
          ..write('codigoPostal: $codigoPostal, ')
          ..write('pais: $pais, ')
          ..write('empresa: $empresa, ')
          ..write('observaciones: $observaciones, ')
          ..write('estado: $estado, ')
          ..write('eliminado: $eliminado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    apellidos,
    nif,
    telefono,
    email,
    direccion,
    poblacion,
    provincia,
    codigoPostal,
    pais,
    empresa,
    observaciones,
    estado,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.apellidos == this.apellidos &&
          other.nif == this.nif &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.direccion == this.direccion &&
          other.poblacion == this.poblacion &&
          other.provincia == this.provincia &&
          other.codigoPostal == this.codigoPostal &&
          other.pais == this.pais &&
          other.empresa == this.empresa &&
          other.observaciones == this.observaciones &&
          other.estado == this.estado &&
          other.eliminado == this.eliminado &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaModificacion == this.fechaModificacion);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> apellidos;
  final Value<String> nif;
  final Value<String> telefono;
  final Value<String> email;
  final Value<String> direccion;
  final Value<String> poblacion;
  final Value<String> provincia;
  final Value<String> codigoPostal;
  final Value<String> pais;
  final Value<String> empresa;
  final Value<String> observaciones;
  final Value<int> estado;
  final Value<bool> eliminado;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaModificacion;
  final Value<int> rowid;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.apellidos = const Value.absent(),
    this.nif = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.direccion = const Value.absent(),
    this.poblacion = const Value.absent(),
    this.provincia = const Value.absent(),
    this.codigoPostal = const Value.absent(),
    this.pais = const Value.absent(),
    this.empresa = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.estado = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientesCompanion.insert({
    required String id,
    required String nombre,
    this.apellidos = const Value.absent(),
    this.nif = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.direccion = const Value.absent(),
    this.poblacion = const Value.absent(),
    this.provincia = const Value.absent(),
    this.codigoPostal = const Value.absent(),
    this.pais = const Value.absent(),
    this.empresa = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.estado = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre);
  static Insertable<Cliente> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? apellidos,
    Expression<String>? nif,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? direccion,
    Expression<String>? poblacion,
    Expression<String>? provincia,
    Expression<String>? codigoPostal,
    Expression<String>? pais,
    Expression<String>? empresa,
    Expression<String>? observaciones,
    Expression<int>? estado,
    Expression<bool>? eliminado,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaModificacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (apellidos != null) 'apellidos': apellidos,
      if (nif != null) 'nif': nif,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (direccion != null) 'direccion': direccion,
      if (poblacion != null) 'poblacion': poblacion,
      if (provincia != null) 'provincia': provincia,
      if (codigoPostal != null) 'codigo_postal': codigoPostal,
      if (pais != null) 'pais': pais,
      if (empresa != null) 'empresa': empresa,
      if (observaciones != null) 'observaciones': observaciones,
      if (estado != null) 'estado': estado,
      if (eliminado != null) 'eliminado': eliminado,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaModificacion != null) 'fecha_modificacion': fechaModificacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientesCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? apellidos,
    Value<String>? nif,
    Value<String>? telefono,
    Value<String>? email,
    Value<String>? direccion,
    Value<String>? poblacion,
    Value<String>? provincia,
    Value<String>? codigoPostal,
    Value<String>? pais,
    Value<String>? empresa,
    Value<String>? observaciones,
    Value<int>? estado,
    Value<bool>? eliminado,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaModificacion,
    Value<int>? rowid,
  }) {
    return ClientesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellidos: apellidos ?? this.apellidos,
      nif: nif ?? this.nif,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      poblacion: poblacion ?? this.poblacion,
      provincia: provincia ?? this.provincia,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      pais: pais ?? this.pais,
      empresa: empresa ?? this.empresa,
      observaciones: observaciones ?? this.observaciones,
      estado: estado ?? this.estado,
      eliminado: eliminado ?? this.eliminado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaModificacion: fechaModificacion ?? this.fechaModificacion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (apellidos.present) {
      map['apellidos'] = Variable<String>(apellidos.value);
    }
    if (nif.present) {
      map['nif'] = Variable<String>(nif.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (poblacion.present) {
      map['poblacion'] = Variable<String>(poblacion.value);
    }
    if (provincia.present) {
      map['provincia'] = Variable<String>(provincia.value);
    }
    if (codigoPostal.present) {
      map['codigo_postal'] = Variable<String>(codigoPostal.value);
    }
    if (pais.present) {
      map['pais'] = Variable<String>(pais.value);
    }
    if (empresa.present) {
      map['empresa'] = Variable<String>(empresa.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (estado.present) {
      map['estado'] = Variable<int>(estado.value);
    }
    if (eliminado.present) {
      map['eliminado'] = Variable<bool>(eliminado.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (fechaModificacion.present) {
      map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('apellidos: $apellidos, ')
          ..write('nif: $nif, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('poblacion: $poblacion, ')
          ..write('provincia: $provincia, ')
          ..write('codigoPostal: $codigoPostal, ')
          ..write('pais: $pais, ')
          ..write('empresa: $empresa, ')
          ..write('observaciones: $observaciones, ')
          ..write('estado: $estado, ')
          ..write('eliminado: $eliminado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpedientesTable extends Expedientes
    with TableInfo<$ExpedientesTable, Expediente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpedientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clienteMeta = const VerificationMeta(
    'cliente',
  );
  @override
  late final GeneratedColumn<String> cliente = GeneratedColumn<String>(
    'cliente',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
    'cliente_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id)',
    ),
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _poblacionMeta = const VerificationMeta(
    'poblacion',
  );
  @override
  late final GeneratedColumn<String> poblacion = GeneratedColumn<String>(
    'poblacion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _provinciaMeta = const VerificationMeta(
    'provincia',
  );
  @override
  late final GeneratedColumn<String> provincia = GeneratedColumn<String>(
    'provincia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _codigoPostalMeta = const VerificationMeta(
    'codigoPostal',
  );
  @override
  late final GeneratedColumn<String> codigoPostal = GeneratedColumn<String>(
    'codigo_postal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _paisMeta = const VerificationMeta('pais');
  @override
  late final GeneratedColumn<String> pais = GeneratedColumn<String>(
    'pais',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('España'),
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<int> estado = GeneratedColumn<int>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _eliminadoMeta = const VerificationMeta(
    'eliminado',
  );
  @override
  late final GeneratedColumn<bool> eliminado = GeneratedColumn<bool>(
    'eliminado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("eliminado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _fechaModificacionMeta = const VerificationMeta(
    'fechaModificacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaModificacion =
      GeneratedColumn<DateTime>(
        'fecha_modificacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    nombre,
    cliente,
    clienteId,
    direccion,
    poblacion,
    provincia,
    codigoPostal,
    pais,
    estado,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expedientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expediente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('cliente')) {
      context.handle(
        _clienteMeta,
        cliente.isAcceptableOrUnknown(data['cliente']!, _clienteMeta),
      );
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    }
    if (data.containsKey('poblacion')) {
      context.handle(
        _poblacionMeta,
        poblacion.isAcceptableOrUnknown(data['poblacion']!, _poblacionMeta),
      );
    }
    if (data.containsKey('provincia')) {
      context.handle(
        _provinciaMeta,
        provincia.isAcceptableOrUnknown(data['provincia']!, _provinciaMeta),
      );
    }
    if (data.containsKey('codigo_postal')) {
      context.handle(
        _codigoPostalMeta,
        codigoPostal.isAcceptableOrUnknown(
          data['codigo_postal']!,
          _codigoPostalMeta,
        ),
      );
    }
    if (data.containsKey('pais')) {
      context.handle(
        _paisMeta,
        pais.isAcceptableOrUnknown(data['pais']!, _paisMeta),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('eliminado')) {
      context.handle(
        _eliminadoMeta,
        eliminado.isAcceptableOrUnknown(data['eliminado']!, _eliminadoMeta),
      );
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    if (data.containsKey('fecha_modificacion')) {
      context.handle(
        _fechaModificacionMeta,
        fechaModificacion.isAcceptableOrUnknown(
          data['fecha_modificacion']!,
          _fechaModificacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expediente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expediente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      cliente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_id'],
      ),
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      poblacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poblacion'],
      )!,
      provincia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provincia'],
      )!,
      codigoPostal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_postal'],
      )!,
      pais: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pais'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estado'],
      )!,
      eliminado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}eliminado'],
      )!,
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      fechaModificacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_modificacion'],
      )!,
    );
  }

  @override
  $ExpedientesTable createAlias(String alias) {
    return $ExpedientesTable(attachedDatabase, alias);
  }
}

class Expediente extends DataClass implements Insertable<Expediente> {
  final String id;
  final String codigo;
  final String nombre;
  final String cliente;
  final String? clienteId;
  final String direccion;
  final String poblacion;
  final String provincia;
  final String codigoPostal;
  final String pais;
  final int estado;
  final bool eliminado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  const Expediente({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.cliente,
    this.clienteId,
    required this.direccion,
    required this.poblacion,
    required this.provincia,
    required this.codigoPostal,
    required this.pais,
    required this.estado,
    required this.eliminado,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['codigo'] = Variable<String>(codigo);
    map['nombre'] = Variable<String>(nombre);
    map['cliente'] = Variable<String>(cliente);
    if (!nullToAbsent || clienteId != null) {
      map['cliente_id'] = Variable<String>(clienteId);
    }
    map['direccion'] = Variable<String>(direccion);
    map['poblacion'] = Variable<String>(poblacion);
    map['provincia'] = Variable<String>(provincia);
    map['codigo_postal'] = Variable<String>(codigoPostal);
    map['pais'] = Variable<String>(pais);
    map['estado'] = Variable<int>(estado);
    map['eliminado'] = Variable<bool>(eliminado);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion);
    return map;
  }

  ExpedientesCompanion toCompanion(bool nullToAbsent) {
    return ExpedientesCompanion(
      id: Value(id),
      codigo: Value(codigo),
      nombre: Value(nombre),
      cliente: Value(cliente),
      clienteId: clienteId == null && nullToAbsent
          ? const Value.absent()
          : Value(clienteId),
      direccion: Value(direccion),
      poblacion: Value(poblacion),
      provincia: Value(provincia),
      codigoPostal: Value(codigoPostal),
      pais: Value(pais),
      estado: Value(estado),
      eliminado: Value(eliminado),
      fechaCreacion: Value(fechaCreacion),
      fechaModificacion: Value(fechaModificacion),
    );
  }

  factory Expediente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expediente(
      id: serializer.fromJson<String>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      nombre: serializer.fromJson<String>(json['nombre']),
      cliente: serializer.fromJson<String>(json['cliente']),
      clienteId: serializer.fromJson<String?>(json['clienteId']),
      direccion: serializer.fromJson<String>(json['direccion']),
      poblacion: serializer.fromJson<String>(json['poblacion']),
      provincia: serializer.fromJson<String>(json['provincia']),
      codigoPostal: serializer.fromJson<String>(json['codigoPostal']),
      pais: serializer.fromJson<String>(json['pais']),
      estado: serializer.fromJson<int>(json['estado']),
      eliminado: serializer.fromJson<bool>(json['eliminado']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
      fechaModificacion: serializer.fromJson<DateTime>(
        json['fechaModificacion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'codigo': serializer.toJson<String>(codigo),
      'nombre': serializer.toJson<String>(nombre),
      'cliente': serializer.toJson<String>(cliente),
      'clienteId': serializer.toJson<String?>(clienteId),
      'direccion': serializer.toJson<String>(direccion),
      'poblacion': serializer.toJson<String>(poblacion),
      'provincia': serializer.toJson<String>(provincia),
      'codigoPostal': serializer.toJson<String>(codigoPostal),
      'pais': serializer.toJson<String>(pais),
      'estado': serializer.toJson<int>(estado),
      'eliminado': serializer.toJson<bool>(eliminado),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaModificacion': serializer.toJson<DateTime>(fechaModificacion),
    };
  }

  Expediente copyWith({
    String? id,
    String? codigo,
    String? nombre,
    String? cliente,
    Value<String?> clienteId = const Value.absent(),
    String? direccion,
    String? poblacion,
    String? provincia,
    String? codigoPostal,
    String? pais,
    int? estado,
    bool? eliminado,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
  }) => Expediente(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    nombre: nombre ?? this.nombre,
    cliente: cliente ?? this.cliente,
    clienteId: clienteId.present ? clienteId.value : this.clienteId,
    direccion: direccion ?? this.direccion,
    poblacion: poblacion ?? this.poblacion,
    provincia: provincia ?? this.provincia,
    codigoPostal: codigoPostal ?? this.codigoPostal,
    pais: pais ?? this.pais,
    estado: estado ?? this.estado,
    eliminado: eliminado ?? this.eliminado,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaModificacion: fechaModificacion ?? this.fechaModificacion,
  );
  Expediente copyWithCompanion(ExpedientesCompanion data) {
    return Expediente(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      cliente: data.cliente.present ? data.cliente.value : this.cliente,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      poblacion: data.poblacion.present ? data.poblacion.value : this.poblacion,
      provincia: data.provincia.present ? data.provincia.value : this.provincia,
      codigoPostal: data.codigoPostal.present
          ? data.codigoPostal.value
          : this.codigoPostal,
      pais: data.pais.present ? data.pais.value : this.pais,
      estado: data.estado.present ? data.estado.value : this.estado,
      eliminado: data.eliminado.present ? data.eliminado.value : this.eliminado,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaModificacion: data.fechaModificacion.present
          ? data.fechaModificacion.value
          : this.fechaModificacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expediente(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nombre: $nombre, ')
          ..write('cliente: $cliente, ')
          ..write('clienteId: $clienteId, ')
          ..write('direccion: $direccion, ')
          ..write('poblacion: $poblacion, ')
          ..write('provincia: $provincia, ')
          ..write('codigoPostal: $codigoPostal, ')
          ..write('pais: $pais, ')
          ..write('estado: $estado, ')
          ..write('eliminado: $eliminado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    nombre,
    cliente,
    clienteId,
    direccion,
    poblacion,
    provincia,
    codigoPostal,
    pais,
    estado,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expediente &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.nombre == this.nombre &&
          other.cliente == this.cliente &&
          other.clienteId == this.clienteId &&
          other.direccion == this.direccion &&
          other.poblacion == this.poblacion &&
          other.provincia == this.provincia &&
          other.codigoPostal == this.codigoPostal &&
          other.pais == this.pais &&
          other.estado == this.estado &&
          other.eliminado == this.eliminado &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaModificacion == this.fechaModificacion);
}

class ExpedientesCompanion extends UpdateCompanion<Expediente> {
  final Value<String> id;
  final Value<String> codigo;
  final Value<String> nombre;
  final Value<String> cliente;
  final Value<String?> clienteId;
  final Value<String> direccion;
  final Value<String> poblacion;
  final Value<String> provincia;
  final Value<String> codigoPostal;
  final Value<String> pais;
  final Value<int> estado;
  final Value<bool> eliminado;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaModificacion;
  final Value<int> rowid;
  const ExpedientesCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.nombre = const Value.absent(),
    this.cliente = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.direccion = const Value.absent(),
    this.poblacion = const Value.absent(),
    this.provincia = const Value.absent(),
    this.codigoPostal = const Value.absent(),
    this.pais = const Value.absent(),
    this.estado = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpedientesCompanion.insert({
    required String id,
    required String codigo,
    required String nombre,
    this.cliente = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.direccion = const Value.absent(),
    this.poblacion = const Value.absent(),
    this.provincia = const Value.absent(),
    this.codigoPostal = const Value.absent(),
    this.pais = const Value.absent(),
    this.estado = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       codigo = Value(codigo),
       nombre = Value(nombre);
  static Insertable<Expediente> custom({
    Expression<String>? id,
    Expression<String>? codigo,
    Expression<String>? nombre,
    Expression<String>? cliente,
    Expression<String>? clienteId,
    Expression<String>? direccion,
    Expression<String>? poblacion,
    Expression<String>? provincia,
    Expression<String>? codigoPostal,
    Expression<String>? pais,
    Expression<int>? estado,
    Expression<bool>? eliminado,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaModificacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (nombre != null) 'nombre': nombre,
      if (cliente != null) 'cliente': cliente,
      if (clienteId != null) 'cliente_id': clienteId,
      if (direccion != null) 'direccion': direccion,
      if (poblacion != null) 'poblacion': poblacion,
      if (provincia != null) 'provincia': provincia,
      if (codigoPostal != null) 'codigo_postal': codigoPostal,
      if (pais != null) 'pais': pais,
      if (estado != null) 'estado': estado,
      if (eliminado != null) 'eliminado': eliminado,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaModificacion != null) 'fecha_modificacion': fechaModificacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpedientesCompanion copyWith({
    Value<String>? id,
    Value<String>? codigo,
    Value<String>? nombre,
    Value<String>? cliente,
    Value<String?>? clienteId,
    Value<String>? direccion,
    Value<String>? poblacion,
    Value<String>? provincia,
    Value<String>? codigoPostal,
    Value<String>? pais,
    Value<int>? estado,
    Value<bool>? eliminado,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaModificacion,
    Value<int>? rowid,
  }) {
    return ExpedientesCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      cliente: cliente ?? this.cliente,
      clienteId: clienteId ?? this.clienteId,
      direccion: direccion ?? this.direccion,
      poblacion: poblacion ?? this.poblacion,
      provincia: provincia ?? this.provincia,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      pais: pais ?? this.pais,
      estado: estado ?? this.estado,
      eliminado: eliminado ?? this.eliminado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaModificacion: fechaModificacion ?? this.fechaModificacion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (cliente.present) {
      map['cliente'] = Variable<String>(cliente.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (poblacion.present) {
      map['poblacion'] = Variable<String>(poblacion.value);
    }
    if (provincia.present) {
      map['provincia'] = Variable<String>(provincia.value);
    }
    if (codigoPostal.present) {
      map['codigo_postal'] = Variable<String>(codigoPostal.value);
    }
    if (pais.present) {
      map['pais'] = Variable<String>(pais.value);
    }
    if (estado.present) {
      map['estado'] = Variable<int>(estado.value);
    }
    if (eliminado.present) {
      map['eliminado'] = Variable<bool>(eliminado.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (fechaModificacion.present) {
      map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpedientesCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nombre: $nombre, ')
          ..write('cliente: $cliente, ')
          ..write('clienteId: $clienteId, ')
          ..write('direccion: $direccion, ')
          ..write('poblacion: $poblacion, ')
          ..write('provincia: $provincia, ')
          ..write('codigoPostal: $codigoPostal, ')
          ..write('pais: $pais, ')
          ..write('estado: $estado, ')
          ..write('eliminado: $eliminado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PresupuestosTable extends Presupuestos
    with TableInfo<$PresupuestosTable, Presupuesto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresupuestosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expedienteIdMeta = const VerificationMeta(
    'expedienteId',
  );
  @override
  late final GeneratedColumn<String> expedienteId = GeneratedColumn<String>(
    'expediente_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expedientes (id)',
    ),
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _importeTotalMeta = const VerificationMeta(
    'importeTotal',
  );
  @override
  late final GeneratedColumn<double> importeTotal = GeneratedColumn<double>(
    'importe_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ivaPorcentajeMeta = const VerificationMeta(
    'ivaPorcentaje',
  );
  @override
  late final GeneratedColumn<double> ivaPorcentaje = GeneratedColumn<double>(
    'iva_porcentaje',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(21.0),
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Borrador'),
  );
  static const VerificationMeta _eliminadoMeta = const VerificationMeta(
    'eliminado',
  );
  @override
  late final GeneratedColumn<bool> eliminado = GeneratedColumn<bool>(
    'eliminado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("eliminado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _fechaModificacionMeta = const VerificationMeta(
    'fechaModificacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaModificacion =
      GeneratedColumn<DateTime>(
        'fecha_modificacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    expedienteId,
    titulo,
    codigo,
    fecha,
    descripcion,
    importeTotal,
    ivaPorcentaje,
    estado,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'presupuestos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Presupuesto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('expediente_id')) {
      context.handle(
        _expedienteIdMeta,
        expedienteId.isAcceptableOrUnknown(
          data['expediente_id']!,
          _expedienteIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expedienteIdMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('importe_total')) {
      context.handle(
        _importeTotalMeta,
        importeTotal.isAcceptableOrUnknown(
          data['importe_total']!,
          _importeTotalMeta,
        ),
      );
    }
    if (data.containsKey('iva_porcentaje')) {
      context.handle(
        _ivaPorcentajeMeta,
        ivaPorcentaje.isAcceptableOrUnknown(
          data['iva_porcentaje']!,
          _ivaPorcentajeMeta,
        ),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('eliminado')) {
      context.handle(
        _eliminadoMeta,
        eliminado.isAcceptableOrUnknown(data['eliminado']!, _eliminadoMeta),
      );
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    if (data.containsKey('fecha_modificacion')) {
      context.handle(
        _fechaModificacionMeta,
        fechaModificacion.isAcceptableOrUnknown(
          data['fecha_modificacion']!,
          _fechaModificacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Presupuesto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Presupuesto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      expedienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expediente_id'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      importeTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}importe_total'],
      )!,
      ivaPorcentaje: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}iva_porcentaje'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      eliminado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}eliminado'],
      )!,
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      fechaModificacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_modificacion'],
      )!,
    );
  }

  @override
  $PresupuestosTable createAlias(String alias) {
    return $PresupuestosTable(attachedDatabase, alias);
  }
}

class Presupuesto extends DataClass implements Insertable<Presupuesto> {
  final String id;
  final String expedienteId;
  final String titulo;
  final String codigo;
  final DateTime fecha;
  final String descripcion;
  final double importeTotal;
  final double ivaPorcentaje;
  final String estado;
  final bool eliminado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  const Presupuesto({
    required this.id,
    required this.expedienteId,
    required this.titulo,
    required this.codigo,
    required this.fecha,
    required this.descripcion,
    required this.importeTotal,
    required this.ivaPorcentaje,
    required this.estado,
    required this.eliminado,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['expediente_id'] = Variable<String>(expedienteId);
    map['titulo'] = Variable<String>(titulo);
    map['codigo'] = Variable<String>(codigo);
    map['fecha'] = Variable<DateTime>(fecha);
    map['descripcion'] = Variable<String>(descripcion);
    map['importe_total'] = Variable<double>(importeTotal);
    map['iva_porcentaje'] = Variable<double>(ivaPorcentaje);
    map['estado'] = Variable<String>(estado);
    map['eliminado'] = Variable<bool>(eliminado);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion);
    return map;
  }

  PresupuestosCompanion toCompanion(bool nullToAbsent) {
    return PresupuestosCompanion(
      id: Value(id),
      expedienteId: Value(expedienteId),
      titulo: Value(titulo),
      codigo: Value(codigo),
      fecha: Value(fecha),
      descripcion: Value(descripcion),
      importeTotal: Value(importeTotal),
      ivaPorcentaje: Value(ivaPorcentaje),
      estado: Value(estado),
      eliminado: Value(eliminado),
      fechaCreacion: Value(fechaCreacion),
      fechaModificacion: Value(fechaModificacion),
    );
  }

  factory Presupuesto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Presupuesto(
      id: serializer.fromJson<String>(json['id']),
      expedienteId: serializer.fromJson<String>(json['expedienteId']),
      titulo: serializer.fromJson<String>(json['titulo']),
      codigo: serializer.fromJson<String>(json['codigo']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      importeTotal: serializer.fromJson<double>(json['importeTotal']),
      ivaPorcentaje: serializer.fromJson<double>(json['ivaPorcentaje']),
      estado: serializer.fromJson<String>(json['estado']),
      eliminado: serializer.fromJson<bool>(json['eliminado']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
      fechaModificacion: serializer.fromJson<DateTime>(
        json['fechaModificacion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'expedienteId': serializer.toJson<String>(expedienteId),
      'titulo': serializer.toJson<String>(titulo),
      'codigo': serializer.toJson<String>(codigo),
      'fecha': serializer.toJson<DateTime>(fecha),
      'descripcion': serializer.toJson<String>(descripcion),
      'importeTotal': serializer.toJson<double>(importeTotal),
      'ivaPorcentaje': serializer.toJson<double>(ivaPorcentaje),
      'estado': serializer.toJson<String>(estado),
      'eliminado': serializer.toJson<bool>(eliminado),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaModificacion': serializer.toJson<DateTime>(fechaModificacion),
    };
  }

  Presupuesto copyWith({
    String? id,
    String? expedienteId,
    String? titulo,
    String? codigo,
    DateTime? fecha,
    String? descripcion,
    double? importeTotal,
    double? ivaPorcentaje,
    String? estado,
    bool? eliminado,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
  }) => Presupuesto(
    id: id ?? this.id,
    expedienteId: expedienteId ?? this.expedienteId,
    titulo: titulo ?? this.titulo,
    codigo: codigo ?? this.codigo,
    fecha: fecha ?? this.fecha,
    descripcion: descripcion ?? this.descripcion,
    importeTotal: importeTotal ?? this.importeTotal,
    ivaPorcentaje: ivaPorcentaje ?? this.ivaPorcentaje,
    estado: estado ?? this.estado,
    eliminado: eliminado ?? this.eliminado,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaModificacion: fechaModificacion ?? this.fechaModificacion,
  );
  Presupuesto copyWithCompanion(PresupuestosCompanion data) {
    return Presupuesto(
      id: data.id.present ? data.id.value : this.id,
      expedienteId: data.expedienteId.present
          ? data.expedienteId.value
          : this.expedienteId,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      importeTotal: data.importeTotal.present
          ? data.importeTotal.value
          : this.importeTotal,
      ivaPorcentaje: data.ivaPorcentaje.present
          ? data.ivaPorcentaje.value
          : this.ivaPorcentaje,
      estado: data.estado.present ? data.estado.value : this.estado,
      eliminado: data.eliminado.present ? data.eliminado.value : this.eliminado,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaModificacion: data.fechaModificacion.present
          ? data.fechaModificacion.value
          : this.fechaModificacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Presupuesto(')
          ..write('id: $id, ')
          ..write('expedienteId: $expedienteId, ')
          ..write('titulo: $titulo, ')
          ..write('codigo: $codigo, ')
          ..write('fecha: $fecha, ')
          ..write('descripcion: $descripcion, ')
          ..write('importeTotal: $importeTotal, ')
          ..write('ivaPorcentaje: $ivaPorcentaje, ')
          ..write('estado: $estado, ')
          ..write('eliminado: $eliminado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    expedienteId,
    titulo,
    codigo,
    fecha,
    descripcion,
    importeTotal,
    ivaPorcentaje,
    estado,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Presupuesto &&
          other.id == this.id &&
          other.expedienteId == this.expedienteId &&
          other.titulo == this.titulo &&
          other.codigo == this.codigo &&
          other.fecha == this.fecha &&
          other.descripcion == this.descripcion &&
          other.importeTotal == this.importeTotal &&
          other.ivaPorcentaje == this.ivaPorcentaje &&
          other.estado == this.estado &&
          other.eliminado == this.eliminado &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaModificacion == this.fechaModificacion);
}

class PresupuestosCompanion extends UpdateCompanion<Presupuesto> {
  final Value<String> id;
  final Value<String> expedienteId;
  final Value<String> titulo;
  final Value<String> codigo;
  final Value<DateTime> fecha;
  final Value<String> descripcion;
  final Value<double> importeTotal;
  final Value<double> ivaPorcentaje;
  final Value<String> estado;
  final Value<bool> eliminado;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaModificacion;
  final Value<int> rowid;
  const PresupuestosCompanion({
    this.id = const Value.absent(),
    this.expedienteId = const Value.absent(),
    this.titulo = const Value.absent(),
    this.codigo = const Value.absent(),
    this.fecha = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.importeTotal = const Value.absent(),
    this.ivaPorcentaje = const Value.absent(),
    this.estado = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PresupuestosCompanion.insert({
    required String id,
    required String expedienteId,
    this.titulo = const Value.absent(),
    this.codigo = const Value.absent(),
    this.fecha = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.importeTotal = const Value.absent(),
    this.ivaPorcentaje = const Value.absent(),
    this.estado = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       expedienteId = Value(expedienteId);
  static Insertable<Presupuesto> custom({
    Expression<String>? id,
    Expression<String>? expedienteId,
    Expression<String>? titulo,
    Expression<String>? codigo,
    Expression<DateTime>? fecha,
    Expression<String>? descripcion,
    Expression<double>? importeTotal,
    Expression<double>? ivaPorcentaje,
    Expression<String>? estado,
    Expression<bool>? eliminado,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaModificacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (expedienteId != null) 'expediente_id': expedienteId,
      if (titulo != null) 'titulo': titulo,
      if (codigo != null) 'codigo': codigo,
      if (fecha != null) 'fecha': fecha,
      if (descripcion != null) 'descripcion': descripcion,
      if (importeTotal != null) 'importe_total': importeTotal,
      if (ivaPorcentaje != null) 'iva_porcentaje': ivaPorcentaje,
      if (estado != null) 'estado': estado,
      if (eliminado != null) 'eliminado': eliminado,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaModificacion != null) 'fecha_modificacion': fechaModificacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PresupuestosCompanion copyWith({
    Value<String>? id,
    Value<String>? expedienteId,
    Value<String>? titulo,
    Value<String>? codigo,
    Value<DateTime>? fecha,
    Value<String>? descripcion,
    Value<double>? importeTotal,
    Value<double>? ivaPorcentaje,
    Value<String>? estado,
    Value<bool>? eliminado,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaModificacion,
    Value<int>? rowid,
  }) {
    return PresupuestosCompanion(
      id: id ?? this.id,
      expedienteId: expedienteId ?? this.expedienteId,
      titulo: titulo ?? this.titulo,
      codigo: codigo ?? this.codigo,
      fecha: fecha ?? this.fecha,
      descripcion: descripcion ?? this.descripcion,
      importeTotal: importeTotal ?? this.importeTotal,
      ivaPorcentaje: ivaPorcentaje ?? this.ivaPorcentaje,
      estado: estado ?? this.estado,
      eliminado: eliminado ?? this.eliminado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaModificacion: fechaModificacion ?? this.fechaModificacion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (expedienteId.present) {
      map['expediente_id'] = Variable<String>(expedienteId.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (importeTotal.present) {
      map['importe_total'] = Variable<double>(importeTotal.value);
    }
    if (ivaPorcentaje.present) {
      map['iva_porcentaje'] = Variable<double>(ivaPorcentaje.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (eliminado.present) {
      map['eliminado'] = Variable<bool>(eliminado.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (fechaModificacion.present) {
      map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresupuestosCompanion(')
          ..write('id: $id, ')
          ..write('expedienteId: $expedienteId, ')
          ..write('titulo: $titulo, ')
          ..write('codigo: $codigo, ')
          ..write('fecha: $fecha, ')
          ..write('descripcion: $descripcion, ')
          ..write('importeTotal: $importeTotal, ')
          ..write('ivaPorcentaje: $ivaPorcentaje, ')
          ..write('estado: $estado, ')
          ..write('eliminado: $eliminado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LineasPresupuestoTable extends LineasPresupuesto
    with TableInfo<$LineasPresupuestoTable, LineasPresupuestoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LineasPresupuestoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _presupuestoIdMeta = const VerificationMeta(
    'presupuestoId',
  );
  @override
  late final GeneratedColumn<String> presupuestoId = GeneratedColumn<String>(
    'presupuesto_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES presupuestos (id)',
    ),
  );
  static const VerificationMeta _conceptoMeta = const VerificationMeta(
    'concepto',
  );
  @override
  late final GeneratedColumn<String> concepto = GeneratedColumn<String>(
    'concepto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    presupuestoId,
    concepto,
    cantidad,
    precioUnitario,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lineas_presupuesto';
  @override
  VerificationContext validateIntegrity(
    Insertable<LineasPresupuestoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('presupuesto_id')) {
      context.handle(
        _presupuestoIdMeta,
        presupuestoId.isAcceptableOrUnknown(
          data['presupuesto_id']!,
          _presupuestoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_presupuestoIdMeta);
    }
    if (data.containsKey('concepto')) {
      context.handle(
        _conceptoMeta,
        concepto.isAcceptableOrUnknown(data['concepto']!, _conceptoMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LineasPresupuestoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LineasPresupuestoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      presupuestoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}presupuesto_id'],
      )!,
      concepto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concepto'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cantidad'],
      )!,
      precioUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_unitario'],
      )!,
    );
  }

  @override
  $LineasPresupuestoTable createAlias(String alias) {
    return $LineasPresupuestoTable(attachedDatabase, alias);
  }
}

class LineasPresupuestoData extends DataClass
    implements Insertable<LineasPresupuestoData> {
  final String id;
  final String presupuestoId;
  final String concepto;
  final double cantidad;
  final double precioUnitario;
  const LineasPresupuestoData({
    required this.id,
    required this.presupuestoId,
    required this.concepto,
    required this.cantidad,
    required this.precioUnitario,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['presupuesto_id'] = Variable<String>(presupuestoId);
    map['concepto'] = Variable<String>(concepto);
    map['cantidad'] = Variable<double>(cantidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    return map;
  }

  LineasPresupuestoCompanion toCompanion(bool nullToAbsent) {
    return LineasPresupuestoCompanion(
      id: Value(id),
      presupuestoId: Value(presupuestoId),
      concepto: Value(concepto),
      cantidad: Value(cantidad),
      precioUnitario: Value(precioUnitario),
    );
  }

  factory LineasPresupuestoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LineasPresupuestoData(
      id: serializer.fromJson<String>(json['id']),
      presupuestoId: serializer.fromJson<String>(json['presupuestoId']),
      concepto: serializer.fromJson<String>(json['concepto']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'presupuestoId': serializer.toJson<String>(presupuestoId),
      'concepto': serializer.toJson<String>(concepto),
      'cantidad': serializer.toJson<double>(cantidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
    };
  }

  LineasPresupuestoData copyWith({
    String? id,
    String? presupuestoId,
    String? concepto,
    double? cantidad,
    double? precioUnitario,
  }) => LineasPresupuestoData(
    id: id ?? this.id,
    presupuestoId: presupuestoId ?? this.presupuestoId,
    concepto: concepto ?? this.concepto,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
  );
  LineasPresupuestoData copyWithCompanion(LineasPresupuestoCompanion data) {
    return LineasPresupuestoData(
      id: data.id.present ? data.id.value : this.id,
      presupuestoId: data.presupuestoId.present
          ? data.presupuestoId.value
          : this.presupuestoId,
      concepto: data.concepto.present ? data.concepto.value : this.concepto,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LineasPresupuestoData(')
          ..write('id: $id, ')
          ..write('presupuestoId: $presupuestoId, ')
          ..write('concepto: $concepto, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, presupuestoId, concepto, cantidad, precioUnitario);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LineasPresupuestoData &&
          other.id == this.id &&
          other.presupuestoId == this.presupuestoId &&
          other.concepto == this.concepto &&
          other.cantidad == this.cantidad &&
          other.precioUnitario == this.precioUnitario);
}

class LineasPresupuestoCompanion
    extends UpdateCompanion<LineasPresupuestoData> {
  final Value<String> id;
  final Value<String> presupuestoId;
  final Value<String> concepto;
  final Value<double> cantidad;
  final Value<double> precioUnitario;
  final Value<int> rowid;
  const LineasPresupuestoCompanion({
    this.id = const Value.absent(),
    this.presupuestoId = const Value.absent(),
    this.concepto = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LineasPresupuestoCompanion.insert({
    required String id,
    required String presupuestoId,
    required String concepto,
    required double cantidad,
    required double precioUnitario,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       presupuestoId = Value(presupuestoId),
       concepto = Value(concepto),
       cantidad = Value(cantidad),
       precioUnitario = Value(precioUnitario);
  static Insertable<LineasPresupuestoData> custom({
    Expression<String>? id,
    Expression<String>? presupuestoId,
    Expression<String>? concepto,
    Expression<double>? cantidad,
    Expression<double>? precioUnitario,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (presupuestoId != null) 'presupuesto_id': presupuestoId,
      if (concepto != null) 'concepto': concepto,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LineasPresupuestoCompanion copyWith({
    Value<String>? id,
    Value<String>? presupuestoId,
    Value<String>? concepto,
    Value<double>? cantidad,
    Value<double>? precioUnitario,
    Value<int>? rowid,
  }) {
    return LineasPresupuestoCompanion(
      id: id ?? this.id,
      presupuestoId: presupuestoId ?? this.presupuestoId,
      concepto: concepto ?? this.concepto,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (presupuestoId.present) {
      map['presupuesto_id'] = Variable<String>(presupuestoId.value);
    }
    if (concepto.present) {
      map['concepto'] = Variable<String>(concepto.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LineasPresupuestoCompanion(')
          ..write('id: $id, ')
          ..write('presupuestoId: $presupuestoId, ')
          ..write('concepto: $concepto, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmpresaConfiguracionTable extends EmpresaConfiguracion
    with TableInfo<$EmpresaConfiguracionTable, EmpresaConfiguracionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmpresaConfiguracionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreEmpresaMeta = const VerificationMeta(
    'nombreEmpresa',
  );
  @override
  late final GeneratedColumn<String> nombreEmpresa = GeneratedColumn<String>(
    'nombre_empresa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cifMeta = const VerificationMeta('cif');
  @override
  late final GeneratedColumn<String> cif = GeneratedColumn<String>(
    'cif',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _codigoPostalMeta = const VerificationMeta(
    'codigoPostal',
  );
  @override
  late final GeneratedColumn<String> codigoPostal = GeneratedColumn<String>(
    'codigo_postal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _poblacionMeta = const VerificationMeta(
    'poblacion',
  );
  @override
  late final GeneratedColumn<String> poblacion = GeneratedColumn<String>(
    'poblacion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _provinciaMeta = const VerificationMeta(
    'provincia',
  );
  @override
  late final GeneratedColumn<String> provincia = GeneratedColumn<String>(
    'provincia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _webMeta = const VerificationMeta('web');
  @override
  late final GeneratedColumn<String> web = GeneratedColumn<String>(
    'web',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombreEmpresa,
    cif,
    direccion,
    codigoPostal,
    poblacion,
    provincia,
    telefono,
    email,
    web,
    logoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'empresa_configuracion';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmpresaConfiguracionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre_empresa')) {
      context.handle(
        _nombreEmpresaMeta,
        nombreEmpresa.isAcceptableOrUnknown(
          data['nombre_empresa']!,
          _nombreEmpresaMeta,
        ),
      );
    }
    if (data.containsKey('cif')) {
      context.handle(
        _cifMeta,
        cif.isAcceptableOrUnknown(data['cif']!, _cifMeta),
      );
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    }
    if (data.containsKey('codigo_postal')) {
      context.handle(
        _codigoPostalMeta,
        codigoPostal.isAcceptableOrUnknown(
          data['codigo_postal']!,
          _codigoPostalMeta,
        ),
      );
    }
    if (data.containsKey('poblacion')) {
      context.handle(
        _poblacionMeta,
        poblacion.isAcceptableOrUnknown(data['poblacion']!, _poblacionMeta),
      );
    }
    if (data.containsKey('provincia')) {
      context.handle(
        _provinciaMeta,
        provincia.isAcceptableOrUnknown(data['provincia']!, _provinciaMeta),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('web')) {
      context.handle(
        _webMeta,
        web.isAcceptableOrUnknown(data['web']!, _webMeta),
      );
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmpresaConfiguracionData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmpresaConfiguracionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombreEmpresa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_empresa'],
      )!,
      cif: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cif'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      codigoPostal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_postal'],
      )!,
      poblacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poblacion'],
      )!,
      provincia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provincia'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      web: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}web'],
      )!,
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
    );
  }

  @override
  $EmpresaConfiguracionTable createAlias(String alias) {
    return $EmpresaConfiguracionTable(attachedDatabase, alias);
  }
}

class EmpresaConfiguracionData extends DataClass
    implements Insertable<EmpresaConfiguracionData> {
  final String id;
  final String nombreEmpresa;
  final String cif;
  final String direccion;
  final String codigoPostal;
  final String poblacion;
  final String provincia;
  final String telefono;
  final String email;
  final String web;
  final String? logoPath;
  const EmpresaConfiguracionData({
    required this.id,
    required this.nombreEmpresa,
    required this.cif,
    required this.direccion,
    required this.codigoPostal,
    required this.poblacion,
    required this.provincia,
    required this.telefono,
    required this.email,
    required this.web,
    this.logoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre_empresa'] = Variable<String>(nombreEmpresa);
    map['cif'] = Variable<String>(cif);
    map['direccion'] = Variable<String>(direccion);
    map['codigo_postal'] = Variable<String>(codigoPostal);
    map['poblacion'] = Variable<String>(poblacion);
    map['provincia'] = Variable<String>(provincia);
    map['telefono'] = Variable<String>(telefono);
    map['email'] = Variable<String>(email);
    map['web'] = Variable<String>(web);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    return map;
  }

  EmpresaConfiguracionCompanion toCompanion(bool nullToAbsent) {
    return EmpresaConfiguracionCompanion(
      id: Value(id),
      nombreEmpresa: Value(nombreEmpresa),
      cif: Value(cif),
      direccion: Value(direccion),
      codigoPostal: Value(codigoPostal),
      poblacion: Value(poblacion),
      provincia: Value(provincia),
      telefono: Value(telefono),
      email: Value(email),
      web: Value(web),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
    );
  }

  factory EmpresaConfiguracionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmpresaConfiguracionData(
      id: serializer.fromJson<String>(json['id']),
      nombreEmpresa: serializer.fromJson<String>(json['nombreEmpresa']),
      cif: serializer.fromJson<String>(json['cif']),
      direccion: serializer.fromJson<String>(json['direccion']),
      codigoPostal: serializer.fromJson<String>(json['codigoPostal']),
      poblacion: serializer.fromJson<String>(json['poblacion']),
      provincia: serializer.fromJson<String>(json['provincia']),
      telefono: serializer.fromJson<String>(json['telefono']),
      email: serializer.fromJson<String>(json['email']),
      web: serializer.fromJson<String>(json['web']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombreEmpresa': serializer.toJson<String>(nombreEmpresa),
      'cif': serializer.toJson<String>(cif),
      'direccion': serializer.toJson<String>(direccion),
      'codigoPostal': serializer.toJson<String>(codigoPostal),
      'poblacion': serializer.toJson<String>(poblacion),
      'provincia': serializer.toJson<String>(provincia),
      'telefono': serializer.toJson<String>(telefono),
      'email': serializer.toJson<String>(email),
      'web': serializer.toJson<String>(web),
      'logoPath': serializer.toJson<String?>(logoPath),
    };
  }

  EmpresaConfiguracionData copyWith({
    String? id,
    String? nombreEmpresa,
    String? cif,
    String? direccion,
    String? codigoPostal,
    String? poblacion,
    String? provincia,
    String? telefono,
    String? email,
    String? web,
    Value<String?> logoPath = const Value.absent(),
  }) => EmpresaConfiguracionData(
    id: id ?? this.id,
    nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
    cif: cif ?? this.cif,
    direccion: direccion ?? this.direccion,
    codigoPostal: codigoPostal ?? this.codigoPostal,
    poblacion: poblacion ?? this.poblacion,
    provincia: provincia ?? this.provincia,
    telefono: telefono ?? this.telefono,
    email: email ?? this.email,
    web: web ?? this.web,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
  );
  EmpresaConfiguracionData copyWithCompanion(
    EmpresaConfiguracionCompanion data,
  ) {
    return EmpresaConfiguracionData(
      id: data.id.present ? data.id.value : this.id,
      nombreEmpresa: data.nombreEmpresa.present
          ? data.nombreEmpresa.value
          : this.nombreEmpresa,
      cif: data.cif.present ? data.cif.value : this.cif,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      codigoPostal: data.codigoPostal.present
          ? data.codigoPostal.value
          : this.codigoPostal,
      poblacion: data.poblacion.present ? data.poblacion.value : this.poblacion,
      provincia: data.provincia.present ? data.provincia.value : this.provincia,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      web: data.web.present ? data.web.value : this.web,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmpresaConfiguracionData(')
          ..write('id: $id, ')
          ..write('nombreEmpresa: $nombreEmpresa, ')
          ..write('cif: $cif, ')
          ..write('direccion: $direccion, ')
          ..write('codigoPostal: $codigoPostal, ')
          ..write('poblacion: $poblacion, ')
          ..write('provincia: $provincia, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('web: $web, ')
          ..write('logoPath: $logoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombreEmpresa,
    cif,
    direccion,
    codigoPostal,
    poblacion,
    provincia,
    telefono,
    email,
    web,
    logoPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmpresaConfiguracionData &&
          other.id == this.id &&
          other.nombreEmpresa == this.nombreEmpresa &&
          other.cif == this.cif &&
          other.direccion == this.direccion &&
          other.codigoPostal == this.codigoPostal &&
          other.poblacion == this.poblacion &&
          other.provincia == this.provincia &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.web == this.web &&
          other.logoPath == this.logoPath);
}

class EmpresaConfiguracionCompanion
    extends UpdateCompanion<EmpresaConfiguracionData> {
  final Value<String> id;
  final Value<String> nombreEmpresa;
  final Value<String> cif;
  final Value<String> direccion;
  final Value<String> codigoPostal;
  final Value<String> poblacion;
  final Value<String> provincia;
  final Value<String> telefono;
  final Value<String> email;
  final Value<String> web;
  final Value<String?> logoPath;
  final Value<int> rowid;
  const EmpresaConfiguracionCompanion({
    this.id = const Value.absent(),
    this.nombreEmpresa = const Value.absent(),
    this.cif = const Value.absent(),
    this.direccion = const Value.absent(),
    this.codigoPostal = const Value.absent(),
    this.poblacion = const Value.absent(),
    this.provincia = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.web = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmpresaConfiguracionCompanion.insert({
    required String id,
    this.nombreEmpresa = const Value.absent(),
    this.cif = const Value.absent(),
    this.direccion = const Value.absent(),
    this.codigoPostal = const Value.absent(),
    this.poblacion = const Value.absent(),
    this.provincia = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.web = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<EmpresaConfiguracionData> custom({
    Expression<String>? id,
    Expression<String>? nombreEmpresa,
    Expression<String>? cif,
    Expression<String>? direccion,
    Expression<String>? codigoPostal,
    Expression<String>? poblacion,
    Expression<String>? provincia,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? web,
    Expression<String>? logoPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombreEmpresa != null) 'nombre_empresa': nombreEmpresa,
      if (cif != null) 'cif': cif,
      if (direccion != null) 'direccion': direccion,
      if (codigoPostal != null) 'codigo_postal': codigoPostal,
      if (poblacion != null) 'poblacion': poblacion,
      if (provincia != null) 'provincia': provincia,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (web != null) 'web': web,
      if (logoPath != null) 'logo_path': logoPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmpresaConfiguracionCompanion copyWith({
    Value<String>? id,
    Value<String>? nombreEmpresa,
    Value<String>? cif,
    Value<String>? direccion,
    Value<String>? codigoPostal,
    Value<String>? poblacion,
    Value<String>? provincia,
    Value<String>? telefono,
    Value<String>? email,
    Value<String>? web,
    Value<String?>? logoPath,
    Value<int>? rowid,
  }) {
    return EmpresaConfiguracionCompanion(
      id: id ?? this.id,
      nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
      cif: cif ?? this.cif,
      direccion: direccion ?? this.direccion,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      poblacion: poblacion ?? this.poblacion,
      provincia: provincia ?? this.provincia,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      web: web ?? this.web,
      logoPath: logoPath ?? this.logoPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombreEmpresa.present) {
      map['nombre_empresa'] = Variable<String>(nombreEmpresa.value);
    }
    if (cif.present) {
      map['cif'] = Variable<String>(cif.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (codigoPostal.present) {
      map['codigo_postal'] = Variable<String>(codigoPostal.value);
    }
    if (poblacion.present) {
      map['poblacion'] = Variable<String>(poblacion.value);
    }
    if (provincia.present) {
      map['provincia'] = Variable<String>(provincia.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (web.present) {
      map['web'] = Variable<String>(web.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmpresaConfiguracionCompanion(')
          ..write('id: $id, ')
          ..write('nombreEmpresa: $nombreEmpresa, ')
          ..write('cif: $cif, ')
          ..write('direccion: $direccion, ')
          ..write('codigoPostal: $codigoPostal, ')
          ..write('poblacion: $poblacion, ')
          ..write('provincia: $provincia, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('web: $web, ')
          ..write('logoPath: $logoPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FacturasTable extends Facturas with TableInfo<$FacturasTable, Factura> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FacturasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id)',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _fechaVencimientoMeta = const VerificationMeta(
    'fechaVencimiento',
  );
  @override
  late final GeneratedColumn<DateTime> fechaVencimiento =
      GeneratedColumn<DateTime>(
        'fecha_vencimiento',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('borrador'),
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ivaMeta = const VerificationMeta('iva');
  @override
  late final GeneratedColumn<double> iva = GeneratedColumn<double>(
    'iva',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _presupuestoOrigenIdMeta =
      const VerificationMeta('presupuestoOrigenId');
  @override
  late final GeneratedColumn<String> presupuestoOrigenId =
      GeneratedColumn<String>(
        'presupuesto_origen_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES presupuestos (id)',
        ),
      );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _fechaModificacionMeta = const VerificationMeta(
    'fechaModificacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaModificacion =
      GeneratedColumn<DateTime>(
        'fecha_modificacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    clienteId,
    fecha,
    fechaVencimiento,
    estado,
    subtotal,
    iva,
    total,
    observaciones,
    presupuestoOrigenId,
    fechaCreacion,
    fechaModificacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'facturas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Factura> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('fecha_vencimiento')) {
      context.handle(
        _fechaVencimientoMeta,
        fechaVencimiento.isAcceptableOrUnknown(
          data['fecha_vencimiento']!,
          _fechaVencimientoMeta,
        ),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    }
    if (data.containsKey('iva')) {
      context.handle(
        _ivaMeta,
        iva.isAcceptableOrUnknown(data['iva']!, _ivaMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
      );
    }
    if (data.containsKey('presupuesto_origen_id')) {
      context.handle(
        _presupuestoOrigenIdMeta,
        presupuestoOrigenId.isAcceptableOrUnknown(
          data['presupuesto_origen_id']!,
          _presupuestoOrigenIdMeta,
        ),
      );
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    if (data.containsKey('fecha_modificacion')) {
      context.handle(
        _fechaModificacionMeta,
        fechaModificacion.isAcceptableOrUnknown(
          data['fecha_modificacion']!,
          _fechaModificacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Factura map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Factura(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      fechaVencimiento: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_vencimiento'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
      iva: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}iva'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      )!,
      presupuestoOrigenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}presupuesto_origen_id'],
      ),
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      fechaModificacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_modificacion'],
      )!,
    );
  }

  @override
  $FacturasTable createAlias(String alias) {
    return $FacturasTable(attachedDatabase, alias);
  }
}

class Factura extends DataClass implements Insertable<Factura> {
  final String id;
  final String codigo;
  final String clienteId;
  final DateTime fecha;
  final DateTime fechaVencimiento;
  final String estado;
  final double subtotal;
  final double iva;
  final double total;
  final String observaciones;
  final String? presupuestoOrigenId;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  const Factura({
    required this.id,
    required this.codigo,
    required this.clienteId,
    required this.fecha,
    required this.fechaVencimiento,
    required this.estado,
    required this.subtotal,
    required this.iva,
    required this.total,
    required this.observaciones,
    this.presupuestoOrigenId,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['codigo'] = Variable<String>(codigo);
    map['cliente_id'] = Variable<String>(clienteId);
    map['fecha'] = Variable<DateTime>(fecha);
    map['fecha_vencimiento'] = Variable<DateTime>(fechaVencimiento);
    map['estado'] = Variable<String>(estado);
    map['subtotal'] = Variable<double>(subtotal);
    map['iva'] = Variable<double>(iva);
    map['total'] = Variable<double>(total);
    map['observaciones'] = Variable<String>(observaciones);
    if (!nullToAbsent || presupuestoOrigenId != null) {
      map['presupuesto_origen_id'] = Variable<String>(presupuestoOrigenId);
    }
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion);
    return map;
  }

  FacturasCompanion toCompanion(bool nullToAbsent) {
    return FacturasCompanion(
      id: Value(id),
      codigo: Value(codigo),
      clienteId: Value(clienteId),
      fecha: Value(fecha),
      fechaVencimiento: Value(fechaVencimiento),
      estado: Value(estado),
      subtotal: Value(subtotal),
      iva: Value(iva),
      total: Value(total),
      observaciones: Value(observaciones),
      presupuestoOrigenId: presupuestoOrigenId == null && nullToAbsent
          ? const Value.absent()
          : Value(presupuestoOrigenId),
      fechaCreacion: Value(fechaCreacion),
      fechaModificacion: Value(fechaModificacion),
    );
  }

  factory Factura.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Factura(
      id: serializer.fromJson<String>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      clienteId: serializer.fromJson<String>(json['clienteId']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      fechaVencimiento: serializer.fromJson<DateTime>(json['fechaVencimiento']),
      estado: serializer.fromJson<String>(json['estado']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      iva: serializer.fromJson<double>(json['iva']),
      total: serializer.fromJson<double>(json['total']),
      observaciones: serializer.fromJson<String>(json['observaciones']),
      presupuestoOrigenId: serializer.fromJson<String?>(
        json['presupuestoOrigenId'],
      ),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
      fechaModificacion: serializer.fromJson<DateTime>(
        json['fechaModificacion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'codigo': serializer.toJson<String>(codigo),
      'clienteId': serializer.toJson<String>(clienteId),
      'fecha': serializer.toJson<DateTime>(fecha),
      'fechaVencimiento': serializer.toJson<DateTime>(fechaVencimiento),
      'estado': serializer.toJson<String>(estado),
      'subtotal': serializer.toJson<double>(subtotal),
      'iva': serializer.toJson<double>(iva),
      'total': serializer.toJson<double>(total),
      'observaciones': serializer.toJson<String>(observaciones),
      'presupuestoOrigenId': serializer.toJson<String?>(presupuestoOrigenId),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaModificacion': serializer.toJson<DateTime>(fechaModificacion),
    };
  }

  Factura copyWith({
    String? id,
    String? codigo,
    String? clienteId,
    DateTime? fecha,
    DateTime? fechaVencimiento,
    String? estado,
    double? subtotal,
    double? iva,
    double? total,
    String? observaciones,
    Value<String?> presupuestoOrigenId = const Value.absent(),
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
  }) => Factura(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    clienteId: clienteId ?? this.clienteId,
    fecha: fecha ?? this.fecha,
    fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
    estado: estado ?? this.estado,
    subtotal: subtotal ?? this.subtotal,
    iva: iva ?? this.iva,
    total: total ?? this.total,
    observaciones: observaciones ?? this.observaciones,
    presupuestoOrigenId: presupuestoOrigenId.present
        ? presupuestoOrigenId.value
        : this.presupuestoOrigenId,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaModificacion: fechaModificacion ?? this.fechaModificacion,
  );
  Factura copyWithCompanion(FacturasCompanion data) {
    return Factura(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      fechaVencimiento: data.fechaVencimiento.present
          ? data.fechaVencimiento.value
          : this.fechaVencimiento,
      estado: data.estado.present ? data.estado.value : this.estado,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      iva: data.iva.present ? data.iva.value : this.iva,
      total: data.total.present ? data.total.value : this.total,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      presupuestoOrigenId: data.presupuestoOrigenId.present
          ? data.presupuestoOrigenId.value
          : this.presupuestoOrigenId,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaModificacion: data.fechaModificacion.present
          ? data.fechaModificacion.value
          : this.fechaModificacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Factura(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('clienteId: $clienteId, ')
          ..write('fecha: $fecha, ')
          ..write('fechaVencimiento: $fechaVencimiento, ')
          ..write('estado: $estado, ')
          ..write('subtotal: $subtotal, ')
          ..write('iva: $iva, ')
          ..write('total: $total, ')
          ..write('observaciones: $observaciones, ')
          ..write('presupuestoOrigenId: $presupuestoOrigenId, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    clienteId,
    fecha,
    fechaVencimiento,
    estado,
    subtotal,
    iva,
    total,
    observaciones,
    presupuestoOrigenId,
    fechaCreacion,
    fechaModificacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Factura &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.clienteId == this.clienteId &&
          other.fecha == this.fecha &&
          other.fechaVencimiento == this.fechaVencimiento &&
          other.estado == this.estado &&
          other.subtotal == this.subtotal &&
          other.iva == this.iva &&
          other.total == this.total &&
          other.observaciones == this.observaciones &&
          other.presupuestoOrigenId == this.presupuestoOrigenId &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaModificacion == this.fechaModificacion);
}

class FacturasCompanion extends UpdateCompanion<Factura> {
  final Value<String> id;
  final Value<String> codigo;
  final Value<String> clienteId;
  final Value<DateTime> fecha;
  final Value<DateTime> fechaVencimiento;
  final Value<String> estado;
  final Value<double> subtotal;
  final Value<double> iva;
  final Value<double> total;
  final Value<String> observaciones;
  final Value<String?> presupuestoOrigenId;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaModificacion;
  final Value<int> rowid;
  const FacturasCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.fechaVencimiento = const Value.absent(),
    this.estado = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.iva = const Value.absent(),
    this.total = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.presupuestoOrigenId = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FacturasCompanion.insert({
    required String id,
    this.codigo = const Value.absent(),
    required String clienteId,
    this.fecha = const Value.absent(),
    this.fechaVencimiento = const Value.absent(),
    this.estado = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.iva = const Value.absent(),
    this.total = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.presupuestoOrigenId = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clienteId = Value(clienteId);
  static Insertable<Factura> custom({
    Expression<String>? id,
    Expression<String>? codigo,
    Expression<String>? clienteId,
    Expression<DateTime>? fecha,
    Expression<DateTime>? fechaVencimiento,
    Expression<String>? estado,
    Expression<double>? subtotal,
    Expression<double>? iva,
    Expression<double>? total,
    Expression<String>? observaciones,
    Expression<String>? presupuestoOrigenId,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaModificacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (clienteId != null) 'cliente_id': clienteId,
      if (fecha != null) 'fecha': fecha,
      if (fechaVencimiento != null) 'fecha_vencimiento': fechaVencimiento,
      if (estado != null) 'estado': estado,
      if (subtotal != null) 'subtotal': subtotal,
      if (iva != null) 'iva': iva,
      if (total != null) 'total': total,
      if (observaciones != null) 'observaciones': observaciones,
      if (presupuestoOrigenId != null)
        'presupuesto_origen_id': presupuestoOrigenId,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaModificacion != null) 'fecha_modificacion': fechaModificacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FacturasCompanion copyWith({
    Value<String>? id,
    Value<String>? codigo,
    Value<String>? clienteId,
    Value<DateTime>? fecha,
    Value<DateTime>? fechaVencimiento,
    Value<String>? estado,
    Value<double>? subtotal,
    Value<double>? iva,
    Value<double>? total,
    Value<String>? observaciones,
    Value<String?>? presupuestoOrigenId,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaModificacion,
    Value<int>? rowid,
  }) {
    return FacturasCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      clienteId: clienteId ?? this.clienteId,
      fecha: fecha ?? this.fecha,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      estado: estado ?? this.estado,
      subtotal: subtotal ?? this.subtotal,
      iva: iva ?? this.iva,
      total: total ?? this.total,
      observaciones: observaciones ?? this.observaciones,
      presupuestoOrigenId: presupuestoOrigenId ?? this.presupuestoOrigenId,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaModificacion: fechaModificacion ?? this.fechaModificacion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (fechaVencimiento.present) {
      map['fecha_vencimiento'] = Variable<DateTime>(fechaVencimiento.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (iva.present) {
      map['iva'] = Variable<double>(iva.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (presupuestoOrigenId.present) {
      map['presupuesto_origen_id'] = Variable<String>(
        presupuestoOrigenId.value,
      );
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (fechaModificacion.present) {
      map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FacturasCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('clienteId: $clienteId, ')
          ..write('fecha: $fecha, ')
          ..write('fechaVencimiento: $fechaVencimiento, ')
          ..write('estado: $estado, ')
          ..write('subtotal: $subtotal, ')
          ..write('iva: $iva, ')
          ..write('total: $total, ')
          ..write('observaciones: $observaciones, ')
          ..write('presupuestoOrigenId: $presupuestoOrigenId, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FacturaLineasTable extends FacturaLineas
    with TableInfo<$FacturaLineasTable, FacturaLinea> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FacturaLineasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _facturaIdMeta = const VerificationMeta(
    'facturaId',
  );
  @override
  late final GeneratedColumn<String> facturaId = GeneratedColumn<String>(
    'factura_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES facturas (id)',
    ),
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unidadMeta = const VerificationMeta('unidad');
  @override
  late final GeneratedColumn<String> unidad = GeneratedColumn<String>(
    'unidad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ud'),
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descuentoMeta = const VerificationMeta(
    'descuento',
  );
  @override
  late final GeneratedColumn<double> descuento = GeneratedColumn<double>(
    'descuento',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _importeMeta = const VerificationMeta(
    'importe',
  );
  @override
  late final GeneratedColumn<double> importe = GeneratedColumn<double>(
    'importe',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    facturaId,
    descripcion,
    cantidad,
    unidad,
    precioUnitario,
    descuento,
    importe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'factura_lineas';
  @override
  VerificationContext validateIntegrity(
    Insertable<FacturaLinea> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('factura_id')) {
      context.handle(
        _facturaIdMeta,
        facturaId.isAcceptableOrUnknown(data['factura_id']!, _facturaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_facturaIdMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('unidad')) {
      context.handle(
        _unidadMeta,
        unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta),
      );
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioMeta);
    }
    if (data.containsKey('descuento')) {
      context.handle(
        _descuentoMeta,
        descuento.isAcceptableOrUnknown(data['descuento']!, _descuentoMeta),
      );
    }
    if (data.containsKey('importe')) {
      context.handle(
        _importeMeta,
        importe.isAcceptableOrUnknown(data['importe']!, _importeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FacturaLinea map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FacturaLinea(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      facturaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}factura_id'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cantidad'],
      )!,
      unidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad'],
      )!,
      precioUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_unitario'],
      )!,
      descuento: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}descuento'],
      )!,
      importe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}importe'],
      )!,
    );
  }

  @override
  $FacturaLineasTable createAlias(String alias) {
    return $FacturaLineasTable(attachedDatabase, alias);
  }
}

class FacturaLinea extends DataClass implements Insertable<FacturaLinea> {
  final String id;
  final String facturaId;
  final String descripcion;
  final double cantidad;
  final String unidad;
  final double precioUnitario;
  final double descuento;
  final double importe;
  const FacturaLinea({
    required this.id,
    required this.facturaId,
    required this.descripcion,
    required this.cantidad,
    required this.unidad,
    required this.precioUnitario,
    required this.descuento,
    required this.importe,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['factura_id'] = Variable<String>(facturaId);
    map['descripcion'] = Variable<String>(descripcion);
    map['cantidad'] = Variable<double>(cantidad);
    map['unidad'] = Variable<String>(unidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    map['descuento'] = Variable<double>(descuento);
    map['importe'] = Variable<double>(importe);
    return map;
  }

  FacturaLineasCompanion toCompanion(bool nullToAbsent) {
    return FacturaLineasCompanion(
      id: Value(id),
      facturaId: Value(facturaId),
      descripcion: Value(descripcion),
      cantidad: Value(cantidad),
      unidad: Value(unidad),
      precioUnitario: Value(precioUnitario),
      descuento: Value(descuento),
      importe: Value(importe),
    );
  }

  factory FacturaLinea.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FacturaLinea(
      id: serializer.fromJson<String>(json['id']),
      facturaId: serializer.fromJson<String>(json['facturaId']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      unidad: serializer.fromJson<String>(json['unidad']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
      descuento: serializer.fromJson<double>(json['descuento']),
      importe: serializer.fromJson<double>(json['importe']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'facturaId': serializer.toJson<String>(facturaId),
      'descripcion': serializer.toJson<String>(descripcion),
      'cantidad': serializer.toJson<double>(cantidad),
      'unidad': serializer.toJson<String>(unidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
      'descuento': serializer.toJson<double>(descuento),
      'importe': serializer.toJson<double>(importe),
    };
  }

  FacturaLinea copyWith({
    String? id,
    String? facturaId,
    String? descripcion,
    double? cantidad,
    String? unidad,
    double? precioUnitario,
    double? descuento,
    double? importe,
  }) => FacturaLinea(
    id: id ?? this.id,
    facturaId: facturaId ?? this.facturaId,
    descripcion: descripcion ?? this.descripcion,
    cantidad: cantidad ?? this.cantidad,
    unidad: unidad ?? this.unidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    descuento: descuento ?? this.descuento,
    importe: importe ?? this.importe,
  );
  FacturaLinea copyWithCompanion(FacturaLineasCompanion data) {
    return FacturaLinea(
      id: data.id.present ? data.id.value : this.id,
      facturaId: data.facturaId.present ? data.facturaId.value : this.facturaId,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
      descuento: data.descuento.present ? data.descuento.value : this.descuento,
      importe: data.importe.present ? data.importe.value : this.importe,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FacturaLinea(')
          ..write('id: $id, ')
          ..write('facturaId: $facturaId, ')
          ..write('descripcion: $descripcion, ')
          ..write('cantidad: $cantidad, ')
          ..write('unidad: $unidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('descuento: $descuento, ')
          ..write('importe: $importe')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    facturaId,
    descripcion,
    cantidad,
    unidad,
    precioUnitario,
    descuento,
    importe,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FacturaLinea &&
          other.id == this.id &&
          other.facturaId == this.facturaId &&
          other.descripcion == this.descripcion &&
          other.cantidad == this.cantidad &&
          other.unidad == this.unidad &&
          other.precioUnitario == this.precioUnitario &&
          other.descuento == this.descuento &&
          other.importe == this.importe);
}

class FacturaLineasCompanion extends UpdateCompanion<FacturaLinea> {
  final Value<String> id;
  final Value<String> facturaId;
  final Value<String> descripcion;
  final Value<double> cantidad;
  final Value<String> unidad;
  final Value<double> precioUnitario;
  final Value<double> descuento;
  final Value<double> importe;
  final Value<int> rowid;
  const FacturaLineasCompanion({
    this.id = const Value.absent(),
    this.facturaId = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.unidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.descuento = const Value.absent(),
    this.importe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FacturaLineasCompanion.insert({
    required String id,
    required String facturaId,
    required String descripcion,
    required double cantidad,
    this.unidad = const Value.absent(),
    required double precioUnitario,
    this.descuento = const Value.absent(),
    this.importe = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       facturaId = Value(facturaId),
       descripcion = Value(descripcion),
       cantidad = Value(cantidad),
       precioUnitario = Value(precioUnitario);
  static Insertable<FacturaLinea> custom({
    Expression<String>? id,
    Expression<String>? facturaId,
    Expression<String>? descripcion,
    Expression<double>? cantidad,
    Expression<String>? unidad,
    Expression<double>? precioUnitario,
    Expression<double>? descuento,
    Expression<double>? importe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (facturaId != null) 'factura_id': facturaId,
      if (descripcion != null) 'descripcion': descripcion,
      if (cantidad != null) 'cantidad': cantidad,
      if (unidad != null) 'unidad': unidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (descuento != null) 'descuento': descuento,
      if (importe != null) 'importe': importe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FacturaLineasCompanion copyWith({
    Value<String>? id,
    Value<String>? facturaId,
    Value<String>? descripcion,
    Value<double>? cantidad,
    Value<String>? unidad,
    Value<double>? precioUnitario,
    Value<double>? descuento,
    Value<double>? importe,
    Value<int>? rowid,
  }) {
    return FacturaLineasCompanion(
      id: id ?? this.id,
      facturaId: facturaId ?? this.facturaId,
      descripcion: descripcion ?? this.descripcion,
      cantidad: cantidad ?? this.cantidad,
      unidad: unidad ?? this.unidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      descuento: descuento ?? this.descuento,
      importe: importe ?? this.importe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (facturaId.present) {
      map['factura_id'] = Variable<String>(facturaId.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (descuento.present) {
      map['descuento'] = Variable<double>(descuento.value);
    }
    if (importe.present) {
      map['importe'] = Variable<double>(importe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FacturaLineasCompanion(')
          ..write('id: $id, ')
          ..write('facturaId: $facturaId, ')
          ..write('descripcion: $descripcion, ')
          ..write('cantidad: $cantidad, ')
          ..write('unidad: $unidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('descuento: $descuento, ')
          ..write('importe: $importe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CobrosTable extends Cobros with TableInfo<$CobrosTable, Cobro> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CobrosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _facturaIdMeta = const VerificationMeta(
    'facturaId',
  );
  @override
  late final GeneratedColumn<String> facturaId = GeneratedColumn<String>(
    'factura_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES facturas (id)',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _importeMeta = const VerificationMeta(
    'importe',
  );
  @override
  late final GeneratedColumn<double> importe = GeneratedColumn<double>(
    'importe',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _metodoPagoMeta = const VerificationMeta(
    'metodoPago',
  );
  @override
  late final GeneratedColumn<String> metodoPago = GeneratedColumn<String>(
    'metodo_pago',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Transferencia'),
  );
  static const VerificationMeta _referenciaMeta = const VerificationMeta(
    'referencia',
  );
  @override
  late final GeneratedColumn<String> referencia = GeneratedColumn<String>(
    'referencia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _fechaModificacionMeta = const VerificationMeta(
    'fechaModificacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaModificacion =
      GeneratedColumn<DateTime>(
        'fecha_modificacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    facturaId,
    fecha,
    importe,
    metodoPago,
    referencia,
    observaciones,
    fechaCreacion,
    fechaModificacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cobros';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cobro> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('factura_id')) {
      context.handle(
        _facturaIdMeta,
        facturaId.isAcceptableOrUnknown(data['factura_id']!, _facturaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_facturaIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('importe')) {
      context.handle(
        _importeMeta,
        importe.isAcceptableOrUnknown(data['importe']!, _importeMeta),
      );
    }
    if (data.containsKey('metodo_pago')) {
      context.handle(
        _metodoPagoMeta,
        metodoPago.isAcceptableOrUnknown(data['metodo_pago']!, _metodoPagoMeta),
      );
    }
    if (data.containsKey('referencia')) {
      context.handle(
        _referenciaMeta,
        referencia.isAcceptableOrUnknown(data['referencia']!, _referenciaMeta),
      );
    }
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
      );
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    if (data.containsKey('fecha_modificacion')) {
      context.handle(
        _fechaModificacionMeta,
        fechaModificacion.isAcceptableOrUnknown(
          data['fecha_modificacion']!,
          _fechaModificacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cobro map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cobro(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      facturaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}factura_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      importe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}importe'],
      )!,
      metodoPago: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metodo_pago'],
      )!,
      referencia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referencia'],
      )!,
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      )!,
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      fechaModificacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_modificacion'],
      )!,
    );
  }

  @override
  $CobrosTable createAlias(String alias) {
    return $CobrosTable(attachedDatabase, alias);
  }
}

class Cobro extends DataClass implements Insertable<Cobro> {
  final String id;
  final String facturaId;
  final DateTime fecha;
  final double importe;
  final String metodoPago;
  final String referencia;
  final String observaciones;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  const Cobro({
    required this.id,
    required this.facturaId,
    required this.fecha,
    required this.importe,
    required this.metodoPago,
    required this.referencia,
    required this.observaciones,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['factura_id'] = Variable<String>(facturaId);
    map['fecha'] = Variable<DateTime>(fecha);
    map['importe'] = Variable<double>(importe);
    map['metodo_pago'] = Variable<String>(metodoPago);
    map['referencia'] = Variable<String>(referencia);
    map['observaciones'] = Variable<String>(observaciones);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion);
    return map;
  }

  CobrosCompanion toCompanion(bool nullToAbsent) {
    return CobrosCompanion(
      id: Value(id),
      facturaId: Value(facturaId),
      fecha: Value(fecha),
      importe: Value(importe),
      metodoPago: Value(metodoPago),
      referencia: Value(referencia),
      observaciones: Value(observaciones),
      fechaCreacion: Value(fechaCreacion),
      fechaModificacion: Value(fechaModificacion),
    );
  }

  factory Cobro.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cobro(
      id: serializer.fromJson<String>(json['id']),
      facturaId: serializer.fromJson<String>(json['facturaId']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      importe: serializer.fromJson<double>(json['importe']),
      metodoPago: serializer.fromJson<String>(json['metodoPago']),
      referencia: serializer.fromJson<String>(json['referencia']),
      observaciones: serializer.fromJson<String>(json['observaciones']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
      fechaModificacion: serializer.fromJson<DateTime>(
        json['fechaModificacion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'facturaId': serializer.toJson<String>(facturaId),
      'fecha': serializer.toJson<DateTime>(fecha),
      'importe': serializer.toJson<double>(importe),
      'metodoPago': serializer.toJson<String>(metodoPago),
      'referencia': serializer.toJson<String>(referencia),
      'observaciones': serializer.toJson<String>(observaciones),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaModificacion': serializer.toJson<DateTime>(fechaModificacion),
    };
  }

  Cobro copyWith({
    String? id,
    String? facturaId,
    DateTime? fecha,
    double? importe,
    String? metodoPago,
    String? referencia,
    String? observaciones,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
  }) => Cobro(
    id: id ?? this.id,
    facturaId: facturaId ?? this.facturaId,
    fecha: fecha ?? this.fecha,
    importe: importe ?? this.importe,
    metodoPago: metodoPago ?? this.metodoPago,
    referencia: referencia ?? this.referencia,
    observaciones: observaciones ?? this.observaciones,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaModificacion: fechaModificacion ?? this.fechaModificacion,
  );
  Cobro copyWithCompanion(CobrosCompanion data) {
    return Cobro(
      id: data.id.present ? data.id.value : this.id,
      facturaId: data.facturaId.present ? data.facturaId.value : this.facturaId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      importe: data.importe.present ? data.importe.value : this.importe,
      metodoPago: data.metodoPago.present
          ? data.metodoPago.value
          : this.metodoPago,
      referencia: data.referencia.present
          ? data.referencia.value
          : this.referencia,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaModificacion: data.fechaModificacion.present
          ? data.fechaModificacion.value
          : this.fechaModificacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cobro(')
          ..write('id: $id, ')
          ..write('facturaId: $facturaId, ')
          ..write('fecha: $fecha, ')
          ..write('importe: $importe, ')
          ..write('metodoPago: $metodoPago, ')
          ..write('referencia: $referencia, ')
          ..write('observaciones: $observaciones, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    facturaId,
    fecha,
    importe,
    metodoPago,
    referencia,
    observaciones,
    fechaCreacion,
    fechaModificacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cobro &&
          other.id == this.id &&
          other.facturaId == this.facturaId &&
          other.fecha == this.fecha &&
          other.importe == this.importe &&
          other.metodoPago == this.metodoPago &&
          other.referencia == this.referencia &&
          other.observaciones == this.observaciones &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaModificacion == this.fechaModificacion);
}

class CobrosCompanion extends UpdateCompanion<Cobro> {
  final Value<String> id;
  final Value<String> facturaId;
  final Value<DateTime> fecha;
  final Value<double> importe;
  final Value<String> metodoPago;
  final Value<String> referencia;
  final Value<String> observaciones;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaModificacion;
  final Value<int> rowid;
  const CobrosCompanion({
    this.id = const Value.absent(),
    this.facturaId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.importe = const Value.absent(),
    this.metodoPago = const Value.absent(),
    this.referencia = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CobrosCompanion.insert({
    required String id,
    required String facturaId,
    this.fecha = const Value.absent(),
    this.importe = const Value.absent(),
    this.metodoPago = const Value.absent(),
    this.referencia = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       facturaId = Value(facturaId);
  static Insertable<Cobro> custom({
    Expression<String>? id,
    Expression<String>? facturaId,
    Expression<DateTime>? fecha,
    Expression<double>? importe,
    Expression<String>? metodoPago,
    Expression<String>? referencia,
    Expression<String>? observaciones,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaModificacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (facturaId != null) 'factura_id': facturaId,
      if (fecha != null) 'fecha': fecha,
      if (importe != null) 'importe': importe,
      if (metodoPago != null) 'metodo_pago': metodoPago,
      if (referencia != null) 'referencia': referencia,
      if (observaciones != null) 'observaciones': observaciones,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaModificacion != null) 'fecha_modificacion': fechaModificacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CobrosCompanion copyWith({
    Value<String>? id,
    Value<String>? facturaId,
    Value<DateTime>? fecha,
    Value<double>? importe,
    Value<String>? metodoPago,
    Value<String>? referencia,
    Value<String>? observaciones,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaModificacion,
    Value<int>? rowid,
  }) {
    return CobrosCompanion(
      id: id ?? this.id,
      facturaId: facturaId ?? this.facturaId,
      fecha: fecha ?? this.fecha,
      importe: importe ?? this.importe,
      metodoPago: metodoPago ?? this.metodoPago,
      referencia: referencia ?? this.referencia,
      observaciones: observaciones ?? this.observaciones,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaModificacion: fechaModificacion ?? this.fechaModificacion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (facturaId.present) {
      map['factura_id'] = Variable<String>(facturaId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (importe.present) {
      map['importe'] = Variable<double>(importe.value);
    }
    if (metodoPago.present) {
      map['metodo_pago'] = Variable<String>(metodoPago.value);
    }
    if (referencia.present) {
      map['referencia'] = Variable<String>(referencia.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (fechaModificacion.present) {
      map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CobrosCompanion(')
          ..write('id: $id, ')
          ..write('facturaId: $facturaId, ')
          ..write('fecha: $fecha, ')
          ..write('importe: $importe, ')
          ..write('metodoPago: $metodoPago, ')
          ..write('referencia: $referencia, ')
          ..write('observaciones: $observaciones, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $ExpedientesTable expedientes = $ExpedientesTable(this);
  late final $PresupuestosTable presupuestos = $PresupuestosTable(this);
  late final $LineasPresupuestoTable lineasPresupuesto =
      $LineasPresupuestoTable(this);
  late final $EmpresaConfiguracionTable empresaConfiguracion =
      $EmpresaConfiguracionTable(this);
  late final $FacturasTable facturas = $FacturasTable(this);
  late final $FacturaLineasTable facturaLineas = $FacturaLineasTable(this);
  late final $CobrosTable cobros = $CobrosTable(this);
  late final ExpedientesDao expedientesDao = ExpedientesDao(
    this as AppDatabase,
  );
  late final ClientesDao clientesDao = ClientesDao(this as AppDatabase);
  late final PresupuestosDao presupuestosDao = PresupuestosDao(
    this as AppDatabase,
  );
  late final LineasPresupuestoDao lineasPresupuestoDao = LineasPresupuestoDao(
    this as AppDatabase,
  );
  late final EmpresaConfiguracionDao empresaConfiguracionDao =
      EmpresaConfiguracionDao(this as AppDatabase);
  late final FacturasDao facturasDao = FacturasDao(this as AppDatabase);
  late final FacturaLineasDao facturaLineasDao = FacturaLineasDao(
    this as AppDatabase,
  );
  late final CobrosDao cobrosDao = CobrosDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clientes,
    expedientes,
    presupuestos,
    lineasPresupuesto,
    empresaConfiguracion,
    facturas,
    facturaLineas,
    cobros,
  ];
}

typedef $$ClientesTableCreateCompanionBuilder =
    ClientesCompanion Function({
      required String id,
      required String nombre,
      Value<String> apellidos,
      Value<String> nif,
      Value<String> telefono,
      Value<String> email,
      Value<String> direccion,
      Value<String> poblacion,
      Value<String> provincia,
      Value<String> codigoPostal,
      Value<String> pais,
      Value<String> empresa,
      Value<String> observaciones,
      Value<int> estado,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });
typedef $$ClientesTableUpdateCompanionBuilder =
    ClientesCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> apellidos,
      Value<String> nif,
      Value<String> telefono,
      Value<String> email,
      Value<String> direccion,
      Value<String> poblacion,
      Value<String> provincia,
      Value<String> codigoPostal,
      Value<String> pais,
      Value<String> empresa,
      Value<String> observaciones,
      Value<int> estado,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });

final class $$ClientesTableReferences
    extends BaseReferences<_$AppDatabase, $ClientesTable, Cliente> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpedientesTable, List<Expediente>>
  _expedientesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expedientes,
    aliasName: 'clientes__id__expedientes__cliente_id',
  );

  $$ExpedientesTableProcessedTableManager get expedientesRefs {
    final manager = $$ExpedientesTableTableManager(
      $_db,
      $_db.expedientes,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expedientesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FacturasTable, List<Factura>> _facturasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.facturas,
    aliasName: 'clientes__id__facturas__cliente_id',
  );

  $$FacturasTableProcessedTableManager get facturasRefs {
    final manager = $$FacturasTableTableManager(
      $_db,
      $_db.facturas,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_facturasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apellidos => $composableBuilder(
    column: $table.apellidos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nif => $composableBuilder(
    column: $table.nif,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poblacion => $composableBuilder(
    column: $table.poblacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provincia => $composableBuilder(
    column: $table.provincia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoPostal => $composableBuilder(
    column: $table.codigoPostal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pais => $composableBuilder(
    column: $table.pais,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresa => $composableBuilder(
    column: $table.empresa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get eliminado => $composableBuilder(
    column: $table.eliminado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expedientesRefs(
    Expression<bool> Function($$ExpedientesTableFilterComposer f) f,
  ) {
    final $$ExpedientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expedientes,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpedientesTableFilterComposer(
            $db: $db,
            $table: $db.expedientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> facturasRefs(
    Expression<bool> Function($$FacturasTableFilterComposer f) f,
  ) {
    final $$FacturasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.facturas,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacturasTableFilterComposer(
            $db: $db,
            $table: $db.facturas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apellidos => $composableBuilder(
    column: $table.apellidos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nif => $composableBuilder(
    column: $table.nif,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poblacion => $composableBuilder(
    column: $table.poblacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provincia => $composableBuilder(
    column: $table.provincia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoPostal => $composableBuilder(
    column: $table.codigoPostal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pais => $composableBuilder(
    column: $table.pais,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresa => $composableBuilder(
    column: $table.empresa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get eliminado => $composableBuilder(
    column: $table.eliminado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get apellidos =>
      $composableBuilder(column: $table.apellidos, builder: (column) => column);

  GeneratedColumn<String> get nif =>
      $composableBuilder(column: $table.nif, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get poblacion =>
      $composableBuilder(column: $table.poblacion, builder: (column) => column);

  GeneratedColumn<String> get provincia =>
      $composableBuilder(column: $table.provincia, builder: (column) => column);

  GeneratedColumn<String> get codigoPostal => $composableBuilder(
    column: $table.codigoPostal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pais =>
      $composableBuilder(column: $table.pais, builder: (column) => column);

  GeneratedColumn<String> get empresa =>
      $composableBuilder(column: $table.empresa, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<bool> get eliminado =>
      $composableBuilder(column: $table.eliminado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => column,
  );

  Expression<T> expedientesRefs<T extends Object>(
    Expression<T> Function($$ExpedientesTableAnnotationComposer a) f,
  ) {
    final $$ExpedientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expedientes,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpedientesTableAnnotationComposer(
            $db: $db,
            $table: $db.expedientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> facturasRefs<T extends Object>(
    Expression<T> Function($$FacturasTableAnnotationComposer a) f,
  ) {
    final $$FacturasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.facturas,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacturasTableAnnotationComposer(
            $db: $db,
            $table: $db.facturas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientesTable,
          Cliente,
          $$ClientesTableFilterComposer,
          $$ClientesTableOrderingComposer,
          $$ClientesTableAnnotationComposer,
          $$ClientesTableCreateCompanionBuilder,
          $$ClientesTableUpdateCompanionBuilder,
          (Cliente, $$ClientesTableReferences),
          Cliente,
          PrefetchHooks Function({bool expedientesRefs, bool facturasRefs})
        > {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> apellidos = const Value.absent(),
                Value<String> nif = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> poblacion = const Value.absent(),
                Value<String> provincia = const Value.absent(),
                Value<String> codigoPostal = const Value.absent(),
                Value<String> pais = const Value.absent(),
                Value<String> empresa = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<int> estado = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientesCompanion(
                id: id,
                nombre: nombre,
                apellidos: apellidos,
                nif: nif,
                telefono: telefono,
                email: email,
                direccion: direccion,
                poblacion: poblacion,
                provincia: provincia,
                codigoPostal: codigoPostal,
                pais: pais,
                empresa: empresa,
                observaciones: observaciones,
                estado: estado,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                Value<String> apellidos = const Value.absent(),
                Value<String> nif = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> poblacion = const Value.absent(),
                Value<String> provincia = const Value.absent(),
                Value<String> codigoPostal = const Value.absent(),
                Value<String> pais = const Value.absent(),
                Value<String> empresa = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<int> estado = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientesCompanion.insert(
                id: id,
                nombre: nombre,
                apellidos: apellidos,
                nif: nif,
                telefono: telefono,
                email: email,
                direccion: direccion,
                poblacion: poblacion,
                provincia: provincia,
                codigoPostal: codigoPostal,
                pais: pais,
                empresa: empresa,
                observaciones: observaciones,
                estado: estado,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({expedientesRefs = false, facturasRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (expedientesRefs) db.expedientes,
                    if (facturasRefs) db.facturas,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (expedientesRefs)
                        await $_getPrefetchedData<
                          Cliente,
                          $ClientesTable,
                          Expediente
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._expedientesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).expedientesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (facturasRefs)
                        await $_getPrefetchedData<
                          Cliente,
                          $ClientesTable,
                          Factura
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._facturasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).facturasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientesTable,
      Cliente,
      $$ClientesTableFilterComposer,
      $$ClientesTableOrderingComposer,
      $$ClientesTableAnnotationComposer,
      $$ClientesTableCreateCompanionBuilder,
      $$ClientesTableUpdateCompanionBuilder,
      (Cliente, $$ClientesTableReferences),
      Cliente,
      PrefetchHooks Function({bool expedientesRefs, bool facturasRefs})
    >;
typedef $$ExpedientesTableCreateCompanionBuilder =
    ExpedientesCompanion Function({
      required String id,
      required String codigo,
      required String nombre,
      Value<String> cliente,
      Value<String?> clienteId,
      Value<String> direccion,
      Value<String> poblacion,
      Value<String> provincia,
      Value<String> codigoPostal,
      Value<String> pais,
      Value<int> estado,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });
typedef $$ExpedientesTableUpdateCompanionBuilder =
    ExpedientesCompanion Function({
      Value<String> id,
      Value<String> codigo,
      Value<String> nombre,
      Value<String> cliente,
      Value<String?> clienteId,
      Value<String> direccion,
      Value<String> poblacion,
      Value<String> provincia,
      Value<String> codigoPostal,
      Value<String> pais,
      Value<int> estado,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });

final class $$ExpedientesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpedientesTable, Expediente> {
  $$ExpedientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias('expedientes__cliente_id__clientes__id');

  $$ClientesTableProcessedTableManager? get clienteId {
    final $_column = $_itemColumn<String>('cliente_id');
    if ($_column == null) return null;
    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PresupuestosTable, List<Presupuesto>>
  _presupuestosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.presupuestos,
    aliasName: 'expedientes__id__presupuestos__expediente_id',
  );

  $$PresupuestosTableProcessedTableManager get presupuestosRefs {
    final manager = $$PresupuestosTableTableManager(
      $_db,
      $_db.presupuestos,
    ).filter((f) => f.expedienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_presupuestosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExpedientesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpedientesTable> {
  $$ExpedientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cliente => $composableBuilder(
    column: $table.cliente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poblacion => $composableBuilder(
    column: $table.poblacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provincia => $composableBuilder(
    column: $table.provincia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoPostal => $composableBuilder(
    column: $table.codigoPostal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pais => $composableBuilder(
    column: $table.pais,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get eliminado => $composableBuilder(
    column: $table.eliminado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> presupuestosRefs(
    Expression<bool> Function($$PresupuestosTableFilterComposer f) f,
  ) {
    final $$PresupuestosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.expedienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableFilterComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpedientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpedientesTable> {
  $$ExpedientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cliente => $composableBuilder(
    column: $table.cliente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poblacion => $composableBuilder(
    column: $table.poblacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provincia => $composableBuilder(
    column: $table.provincia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoPostal => $composableBuilder(
    column: $table.codigoPostal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pais => $composableBuilder(
    column: $table.pais,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get eliminado => $composableBuilder(
    column: $table.eliminado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpedientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpedientesTable> {
  $$ExpedientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get cliente =>
      $composableBuilder(column: $table.cliente, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get poblacion =>
      $composableBuilder(column: $table.poblacion, builder: (column) => column);

  GeneratedColumn<String> get provincia =>
      $composableBuilder(column: $table.provincia, builder: (column) => column);

  GeneratedColumn<String> get codigoPostal => $composableBuilder(
    column: $table.codigoPostal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pais =>
      $composableBuilder(column: $table.pais, builder: (column) => column);

  GeneratedColumn<int> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<bool> get eliminado =>
      $composableBuilder(column: $table.eliminado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => column,
  );

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> presupuestosRefs<T extends Object>(
    Expression<T> Function($$PresupuestosTableAnnotationComposer a) f,
  ) {
    final $$PresupuestosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.expedienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableAnnotationComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpedientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpedientesTable,
          Expediente,
          $$ExpedientesTableFilterComposer,
          $$ExpedientesTableOrderingComposer,
          $$ExpedientesTableAnnotationComposer,
          $$ExpedientesTableCreateCompanionBuilder,
          $$ExpedientesTableUpdateCompanionBuilder,
          (Expediente, $$ExpedientesTableReferences),
          Expediente,
          PrefetchHooks Function({bool clienteId, bool presupuestosRefs})
        > {
  $$ExpedientesTableTableManager(_$AppDatabase db, $ExpedientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpedientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpedientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpedientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> cliente = const Value.absent(),
                Value<String?> clienteId = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> poblacion = const Value.absent(),
                Value<String> provincia = const Value.absent(),
                Value<String> codigoPostal = const Value.absent(),
                Value<String> pais = const Value.absent(),
                Value<int> estado = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpedientesCompanion(
                id: id,
                codigo: codigo,
                nombre: nombre,
                cliente: cliente,
                clienteId: clienteId,
                direccion: direccion,
                poblacion: poblacion,
                provincia: provincia,
                codigoPostal: codigoPostal,
                pais: pais,
                estado: estado,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String codigo,
                required String nombre,
                Value<String> cliente = const Value.absent(),
                Value<String?> clienteId = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> poblacion = const Value.absent(),
                Value<String> provincia = const Value.absent(),
                Value<String> codigoPostal = const Value.absent(),
                Value<String> pais = const Value.absent(),
                Value<int> estado = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpedientesCompanion.insert(
                id: id,
                codigo: codigo,
                nombre: nombre,
                cliente: cliente,
                clienteId: clienteId,
                direccion: direccion,
                poblacion: poblacion,
                provincia: provincia,
                codigoPostal: codigoPostal,
                pais: pais,
                estado: estado,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpedientesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({clienteId = false, presupuestosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (presupuestosRefs) db.presupuestos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (clienteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.clienteId,
                                    referencedTable:
                                        $$ExpedientesTableReferences
                                            ._clienteIdTable(db),
                                    referencedColumn:
                                        $$ExpedientesTableReferences
                                            ._clienteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (presupuestosRefs)
                        await $_getPrefetchedData<
                          Expediente,
                          $ExpedientesTable,
                          Presupuesto
                        >(
                          currentTable: table,
                          referencedTable: $$ExpedientesTableReferences
                              ._presupuestosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExpedientesTableReferences(
                                db,
                                table,
                                p0,
                              ).presupuestosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.expedienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExpedientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpedientesTable,
      Expediente,
      $$ExpedientesTableFilterComposer,
      $$ExpedientesTableOrderingComposer,
      $$ExpedientesTableAnnotationComposer,
      $$ExpedientesTableCreateCompanionBuilder,
      $$ExpedientesTableUpdateCompanionBuilder,
      (Expediente, $$ExpedientesTableReferences),
      Expediente,
      PrefetchHooks Function({bool clienteId, bool presupuestosRefs})
    >;
typedef $$PresupuestosTableCreateCompanionBuilder =
    PresupuestosCompanion Function({
      required String id,
      required String expedienteId,
      Value<String> titulo,
      Value<String> codigo,
      Value<DateTime> fecha,
      Value<String> descripcion,
      Value<double> importeTotal,
      Value<double> ivaPorcentaje,
      Value<String> estado,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });
typedef $$PresupuestosTableUpdateCompanionBuilder =
    PresupuestosCompanion Function({
      Value<String> id,
      Value<String> expedienteId,
      Value<String> titulo,
      Value<String> codigo,
      Value<DateTime> fecha,
      Value<String> descripcion,
      Value<double> importeTotal,
      Value<double> ivaPorcentaje,
      Value<String> estado,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });

final class $$PresupuestosTableReferences
    extends BaseReferences<_$AppDatabase, $PresupuestosTable, Presupuesto> {
  $$PresupuestosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExpedientesTable _expedienteIdTable(_$AppDatabase db) => db
      .expedientes
      .createAlias('presupuestos__expediente_id__expedientes__id');

  $$ExpedientesTableProcessedTableManager get expedienteId {
    final $_column = $_itemColumn<String>('expediente_id')!;

    final manager = $$ExpedientesTableTableManager(
      $_db,
      $_db.expedientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expedienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $LineasPresupuestoTable,
    List<LineasPresupuestoData>
  >
  _lineasPresupuestoRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.lineasPresupuesto,
        aliasName: 'presupuestos__id__lineas_presupuesto__presupuesto_id',
      );

  $$LineasPresupuestoTableProcessedTableManager get lineasPresupuestoRefs {
    final manager = $$LineasPresupuestoTableTableManager(
      $_db,
      $_db.lineasPresupuesto,
    ).filter((f) => f.presupuestoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _lineasPresupuestoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FacturasTable, List<Factura>> _facturasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.facturas,
    aliasName: 'presupuestos__id__facturas__presupuesto_origen_id',
  );

  $$FacturasTableProcessedTableManager get facturasRefs {
    final manager = $$FacturasTableTableManager($_db, $_db.facturas).filter(
      (f) => f.presupuestoOrigenId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_facturasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PresupuestosTableFilterComposer
    extends Composer<_$AppDatabase, $PresupuestosTable> {
  $$PresupuestosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get importeTotal => $composableBuilder(
    column: $table.importeTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ivaPorcentaje => $composableBuilder(
    column: $table.ivaPorcentaje,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get eliminado => $composableBuilder(
    column: $table.eliminado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => ColumnFilters(column),
  );

  $$ExpedientesTableFilterComposer get expedienteId {
    final $$ExpedientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expedienteId,
      referencedTable: $db.expedientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpedientesTableFilterComposer(
            $db: $db,
            $table: $db.expedientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> lineasPresupuestoRefs(
    Expression<bool> Function($$LineasPresupuestoTableFilterComposer f) f,
  ) {
    final $$LineasPresupuestoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineasPresupuesto,
      getReferencedColumn: (t) => t.presupuestoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineasPresupuestoTableFilterComposer(
            $db: $db,
            $table: $db.lineasPresupuesto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> facturasRefs(
    Expression<bool> Function($$FacturasTableFilterComposer f) f,
  ) {
    final $$FacturasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.facturas,
      getReferencedColumn: (t) => t.presupuestoOrigenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacturasTableFilterComposer(
            $db: $db,
            $table: $db.facturas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PresupuestosTableOrderingComposer
    extends Composer<_$AppDatabase, $PresupuestosTable> {
  $$PresupuestosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get importeTotal => $composableBuilder(
    column: $table.importeTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ivaPorcentaje => $composableBuilder(
    column: $table.ivaPorcentaje,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get eliminado => $composableBuilder(
    column: $table.eliminado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExpedientesTableOrderingComposer get expedienteId {
    final $$ExpedientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expedienteId,
      referencedTable: $db.expedientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpedientesTableOrderingComposer(
            $db: $db,
            $table: $db.expedientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PresupuestosTable> {
  $$PresupuestosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get importeTotal => $composableBuilder(
    column: $table.importeTotal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ivaPorcentaje => $composableBuilder(
    column: $table.ivaPorcentaje,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<bool> get eliminado =>
      $composableBuilder(column: $table.eliminado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => column,
  );

  $$ExpedientesTableAnnotationComposer get expedienteId {
    final $$ExpedientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expedienteId,
      referencedTable: $db.expedientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpedientesTableAnnotationComposer(
            $db: $db,
            $table: $db.expedientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> lineasPresupuestoRefs<T extends Object>(
    Expression<T> Function($$LineasPresupuestoTableAnnotationComposer a) f,
  ) {
    final $$LineasPresupuestoTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.lineasPresupuesto,
          getReferencedColumn: (t) => t.presupuestoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LineasPresupuestoTableAnnotationComposer(
                $db: $db,
                $table: $db.lineasPresupuesto,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> facturasRefs<T extends Object>(
    Expression<T> Function($$FacturasTableAnnotationComposer a) f,
  ) {
    final $$FacturasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.facturas,
      getReferencedColumn: (t) => t.presupuestoOrigenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacturasTableAnnotationComposer(
            $db: $db,
            $table: $db.facturas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PresupuestosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PresupuestosTable,
          Presupuesto,
          $$PresupuestosTableFilterComposer,
          $$PresupuestosTableOrderingComposer,
          $$PresupuestosTableAnnotationComposer,
          $$PresupuestosTableCreateCompanionBuilder,
          $$PresupuestosTableUpdateCompanionBuilder,
          (Presupuesto, $$PresupuestosTableReferences),
          Presupuesto,
          PrefetchHooks Function({
            bool expedienteId,
            bool lineasPresupuestoRefs,
            bool facturasRefs,
          })
        > {
  $$PresupuestosTableTableManager(_$AppDatabase db, $PresupuestosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresupuestosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PresupuestosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PresupuestosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> expedienteId = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<double> importeTotal = const Value.absent(),
                Value<double> ivaPorcentaje = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PresupuestosCompanion(
                id: id,
                expedienteId: expedienteId,
                titulo: titulo,
                codigo: codigo,
                fecha: fecha,
                descripcion: descripcion,
                importeTotal: importeTotal,
                ivaPorcentaje: ivaPorcentaje,
                estado: estado,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String expedienteId,
                Value<String> titulo = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<double> importeTotal = const Value.absent(),
                Value<double> ivaPorcentaje = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PresupuestosCompanion.insert(
                id: id,
                expedienteId: expedienteId,
                titulo: titulo,
                codigo: codigo,
                fecha: fecha,
                descripcion: descripcion,
                importeTotal: importeTotal,
                ivaPorcentaje: ivaPorcentaje,
                estado: estado,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PresupuestosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                expedienteId = false,
                lineasPresupuestoRefs = false,
                facturasRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (lineasPresupuestoRefs) db.lineasPresupuesto,
                    if (facturasRefs) db.facturas,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (expedienteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.expedienteId,
                                    referencedTable:
                                        $$PresupuestosTableReferences
                                            ._expedienteIdTable(db),
                                    referencedColumn:
                                        $$PresupuestosTableReferences
                                            ._expedienteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (lineasPresupuestoRefs)
                        await $_getPrefetchedData<
                          Presupuesto,
                          $PresupuestosTable,
                          LineasPresupuestoData
                        >(
                          currentTable: table,
                          referencedTable: $$PresupuestosTableReferences
                              ._lineasPresupuestoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PresupuestosTableReferences(
                                db,
                                table,
                                p0,
                              ).lineasPresupuestoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.presupuestoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (facturasRefs)
                        await $_getPrefetchedData<
                          Presupuesto,
                          $PresupuestosTable,
                          Factura
                        >(
                          currentTable: table,
                          referencedTable: $$PresupuestosTableReferences
                              ._facturasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PresupuestosTableReferences(
                                db,
                                table,
                                p0,
                              ).facturasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.presupuestoOrigenId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PresupuestosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PresupuestosTable,
      Presupuesto,
      $$PresupuestosTableFilterComposer,
      $$PresupuestosTableOrderingComposer,
      $$PresupuestosTableAnnotationComposer,
      $$PresupuestosTableCreateCompanionBuilder,
      $$PresupuestosTableUpdateCompanionBuilder,
      (Presupuesto, $$PresupuestosTableReferences),
      Presupuesto,
      PrefetchHooks Function({
        bool expedienteId,
        bool lineasPresupuestoRefs,
        bool facturasRefs,
      })
    >;
typedef $$LineasPresupuestoTableCreateCompanionBuilder =
    LineasPresupuestoCompanion Function({
      required String id,
      required String presupuestoId,
      required String concepto,
      required double cantidad,
      required double precioUnitario,
      Value<int> rowid,
    });
typedef $$LineasPresupuestoTableUpdateCompanionBuilder =
    LineasPresupuestoCompanion Function({
      Value<String> id,
      Value<String> presupuestoId,
      Value<String> concepto,
      Value<double> cantidad,
      Value<double> precioUnitario,
      Value<int> rowid,
    });

final class $$LineasPresupuestoTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $LineasPresupuestoTable,
          LineasPresupuestoData
        > {
  $$LineasPresupuestoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PresupuestosTable _presupuestoIdTable(_$AppDatabase db) => db
      .presupuestos
      .createAlias('lineas_presupuesto__presupuesto_id__presupuestos__id');

  $$PresupuestosTableProcessedTableManager get presupuestoId {
    final $_column = $_itemColumn<String>('presupuesto_id')!;

    final manager = $$PresupuestosTableTableManager(
      $_db,
      $_db.presupuestos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_presupuestoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LineasPresupuestoTableFilterComposer
    extends Composer<_$AppDatabase, $LineasPresupuestoTable> {
  $$LineasPresupuestoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  $$PresupuestosTableFilterComposer get presupuestoId {
    final $$PresupuestosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.presupuestoId,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableFilterComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineasPresupuestoTableOrderingComposer
    extends Composer<_$AppDatabase, $LineasPresupuestoTable> {
  $$LineasPresupuestoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  $$PresupuestosTableOrderingComposer get presupuestoId {
    final $$PresupuestosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.presupuestoId,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableOrderingComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineasPresupuestoTableAnnotationComposer
    extends Composer<_$AppDatabase, $LineasPresupuestoTable> {
  $$LineasPresupuestoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get concepto =>
      $composableBuilder(column: $table.concepto, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  $$PresupuestosTableAnnotationComposer get presupuestoId {
    final $$PresupuestosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.presupuestoId,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableAnnotationComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineasPresupuestoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LineasPresupuestoTable,
          LineasPresupuestoData,
          $$LineasPresupuestoTableFilterComposer,
          $$LineasPresupuestoTableOrderingComposer,
          $$LineasPresupuestoTableAnnotationComposer,
          $$LineasPresupuestoTableCreateCompanionBuilder,
          $$LineasPresupuestoTableUpdateCompanionBuilder,
          (LineasPresupuestoData, $$LineasPresupuestoTableReferences),
          LineasPresupuestoData,
          PrefetchHooks Function({bool presupuestoId})
        > {
  $$LineasPresupuestoTableTableManager(
    _$AppDatabase db,
    $LineasPresupuestoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LineasPresupuestoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LineasPresupuestoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LineasPresupuestoTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> presupuestoId = const Value.absent(),
                Value<String> concepto = const Value.absent(),
                Value<double> cantidad = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LineasPresupuestoCompanion(
                id: id,
                presupuestoId: presupuestoId,
                concepto: concepto,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String presupuestoId,
                required String concepto,
                required double cantidad,
                required double precioUnitario,
                Value<int> rowid = const Value.absent(),
              }) => LineasPresupuestoCompanion.insert(
                id: id,
                presupuestoId: presupuestoId,
                concepto: concepto,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LineasPresupuestoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({presupuestoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (presupuestoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.presupuestoId,
                                referencedTable:
                                    $$LineasPresupuestoTableReferences
                                        ._presupuestoIdTable(db),
                                referencedColumn:
                                    $$LineasPresupuestoTableReferences
                                        ._presupuestoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LineasPresupuestoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LineasPresupuestoTable,
      LineasPresupuestoData,
      $$LineasPresupuestoTableFilterComposer,
      $$LineasPresupuestoTableOrderingComposer,
      $$LineasPresupuestoTableAnnotationComposer,
      $$LineasPresupuestoTableCreateCompanionBuilder,
      $$LineasPresupuestoTableUpdateCompanionBuilder,
      (LineasPresupuestoData, $$LineasPresupuestoTableReferences),
      LineasPresupuestoData,
      PrefetchHooks Function({bool presupuestoId})
    >;
typedef $$EmpresaConfiguracionTableCreateCompanionBuilder =
    EmpresaConfiguracionCompanion Function({
      required String id,
      Value<String> nombreEmpresa,
      Value<String> cif,
      Value<String> direccion,
      Value<String> codigoPostal,
      Value<String> poblacion,
      Value<String> provincia,
      Value<String> telefono,
      Value<String> email,
      Value<String> web,
      Value<String?> logoPath,
      Value<int> rowid,
    });
typedef $$EmpresaConfiguracionTableUpdateCompanionBuilder =
    EmpresaConfiguracionCompanion Function({
      Value<String> id,
      Value<String> nombreEmpresa,
      Value<String> cif,
      Value<String> direccion,
      Value<String> codigoPostal,
      Value<String> poblacion,
      Value<String> provincia,
      Value<String> telefono,
      Value<String> email,
      Value<String> web,
      Value<String?> logoPath,
      Value<int> rowid,
    });

class $$EmpresaConfiguracionTableFilterComposer
    extends Composer<_$AppDatabase, $EmpresaConfiguracionTable> {
  $$EmpresaConfiguracionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreEmpresa => $composableBuilder(
    column: $table.nombreEmpresa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cif => $composableBuilder(
    column: $table.cif,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoPostal => $composableBuilder(
    column: $table.codigoPostal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poblacion => $composableBuilder(
    column: $table.poblacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provincia => $composableBuilder(
    column: $table.provincia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get web => $composableBuilder(
    column: $table.web,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmpresaConfiguracionTableOrderingComposer
    extends Composer<_$AppDatabase, $EmpresaConfiguracionTable> {
  $$EmpresaConfiguracionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreEmpresa => $composableBuilder(
    column: $table.nombreEmpresa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cif => $composableBuilder(
    column: $table.cif,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoPostal => $composableBuilder(
    column: $table.codigoPostal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poblacion => $composableBuilder(
    column: $table.poblacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provincia => $composableBuilder(
    column: $table.provincia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get web => $composableBuilder(
    column: $table.web,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmpresaConfiguracionTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmpresaConfiguracionTable> {
  $$EmpresaConfiguracionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombreEmpresa => $composableBuilder(
    column: $table.nombreEmpresa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cif =>
      $composableBuilder(column: $table.cif, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get codigoPostal => $composableBuilder(
    column: $table.codigoPostal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get poblacion =>
      $composableBuilder(column: $table.poblacion, builder: (column) => column);

  GeneratedColumn<String> get provincia =>
      $composableBuilder(column: $table.provincia, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get web =>
      $composableBuilder(column: $table.web, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);
}

class $$EmpresaConfiguracionTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmpresaConfiguracionTable,
          EmpresaConfiguracionData,
          $$EmpresaConfiguracionTableFilterComposer,
          $$EmpresaConfiguracionTableOrderingComposer,
          $$EmpresaConfiguracionTableAnnotationComposer,
          $$EmpresaConfiguracionTableCreateCompanionBuilder,
          $$EmpresaConfiguracionTableUpdateCompanionBuilder,
          (
            EmpresaConfiguracionData,
            BaseReferences<
              _$AppDatabase,
              $EmpresaConfiguracionTable,
              EmpresaConfiguracionData
            >,
          ),
          EmpresaConfiguracionData,
          PrefetchHooks Function()
        > {
  $$EmpresaConfiguracionTableTableManager(
    _$AppDatabase db,
    $EmpresaConfiguracionTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmpresaConfiguracionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmpresaConfiguracionTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EmpresaConfiguracionTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombreEmpresa = const Value.absent(),
                Value<String> cif = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> codigoPostal = const Value.absent(),
                Value<String> poblacion = const Value.absent(),
                Value<String> provincia = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> web = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmpresaConfiguracionCompanion(
                id: id,
                nombreEmpresa: nombreEmpresa,
                cif: cif,
                direccion: direccion,
                codigoPostal: codigoPostal,
                poblacion: poblacion,
                provincia: provincia,
                telefono: telefono,
                email: email,
                web: web,
                logoPath: logoPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> nombreEmpresa = const Value.absent(),
                Value<String> cif = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> codigoPostal = const Value.absent(),
                Value<String> poblacion = const Value.absent(),
                Value<String> provincia = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> web = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmpresaConfiguracionCompanion.insert(
                id: id,
                nombreEmpresa: nombreEmpresa,
                cif: cif,
                direccion: direccion,
                codigoPostal: codigoPostal,
                poblacion: poblacion,
                provincia: provincia,
                telefono: telefono,
                email: email,
                web: web,
                logoPath: logoPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmpresaConfiguracionTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmpresaConfiguracionTable,
      EmpresaConfiguracionData,
      $$EmpresaConfiguracionTableFilterComposer,
      $$EmpresaConfiguracionTableOrderingComposer,
      $$EmpresaConfiguracionTableAnnotationComposer,
      $$EmpresaConfiguracionTableCreateCompanionBuilder,
      $$EmpresaConfiguracionTableUpdateCompanionBuilder,
      (
        EmpresaConfiguracionData,
        BaseReferences<
          _$AppDatabase,
          $EmpresaConfiguracionTable,
          EmpresaConfiguracionData
        >,
      ),
      EmpresaConfiguracionData,
      PrefetchHooks Function()
    >;
typedef $$FacturasTableCreateCompanionBuilder =
    FacturasCompanion Function({
      required String id,
      Value<String> codigo,
      required String clienteId,
      Value<DateTime> fecha,
      Value<DateTime> fechaVencimiento,
      Value<String> estado,
      Value<double> subtotal,
      Value<double> iva,
      Value<double> total,
      Value<String> observaciones,
      Value<String?> presupuestoOrigenId,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });
typedef $$FacturasTableUpdateCompanionBuilder =
    FacturasCompanion Function({
      Value<String> id,
      Value<String> codigo,
      Value<String> clienteId,
      Value<DateTime> fecha,
      Value<DateTime> fechaVencimiento,
      Value<String> estado,
      Value<double> subtotal,
      Value<double> iva,
      Value<double> total,
      Value<String> observaciones,
      Value<String?> presupuestoOrigenId,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });

final class $$FacturasTableReferences
    extends BaseReferences<_$AppDatabase, $FacturasTable, Factura> {
  $$FacturasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias('facturas__cliente_id__clientes__id');

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<String>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PresupuestosTable _presupuestoOrigenIdTable(_$AppDatabase db) => db
      .presupuestos
      .createAlias('facturas__presupuesto_origen_id__presupuestos__id');

  $$PresupuestosTableProcessedTableManager? get presupuestoOrigenId {
    final $_column = $_itemColumn<String>('presupuesto_origen_id');
    if ($_column == null) return null;
    final manager = $$PresupuestosTableTableManager(
      $_db,
      $_db.presupuestos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_presupuestoOrigenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FacturaLineasTable, List<FacturaLinea>>
  _facturaLineasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.facturaLineas,
    aliasName: 'facturas__id__factura_lineas__factura_id',
  );

  $$FacturaLineasTableProcessedTableManager get facturaLineasRefs {
    final manager = $$FacturaLineasTableTableManager(
      $_db,
      $_db.facturaLineas,
    ).filter((f) => f.facturaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_facturaLineasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CobrosTable, List<Cobro>> _cobrosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cobros,
    aliasName: 'facturas__id__cobros__factura_id',
  );

  $$CobrosTableProcessedTableManager get cobrosRefs {
    final manager = $$CobrosTableTableManager(
      $_db,
      $_db.cobros,
    ).filter((f) => f.facturaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cobrosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FacturasTableFilterComposer
    extends Composer<_$AppDatabase, $FacturasTable> {
  $$FacturasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaVencimiento => $composableBuilder(
    column: $table.fechaVencimiento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get iva => $composableBuilder(
    column: $table.iva,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PresupuestosTableFilterComposer get presupuestoOrigenId {
    final $$PresupuestosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.presupuestoOrigenId,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableFilterComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> facturaLineasRefs(
    Expression<bool> Function($$FacturaLineasTableFilterComposer f) f,
  ) {
    final $$FacturaLineasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.facturaLineas,
      getReferencedColumn: (t) => t.facturaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacturaLineasTableFilterComposer(
            $db: $db,
            $table: $db.facturaLineas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cobrosRefs(
    Expression<bool> Function($$CobrosTableFilterComposer f) f,
  ) {
    final $$CobrosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cobros,
      getReferencedColumn: (t) => t.facturaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CobrosTableFilterComposer(
            $db: $db,
            $table: $db.cobros,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FacturasTableOrderingComposer
    extends Composer<_$AppDatabase, $FacturasTable> {
  $$FacturasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaVencimiento => $composableBuilder(
    column: $table.fechaVencimiento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get iva => $composableBuilder(
    column: $table.iva,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PresupuestosTableOrderingComposer get presupuestoOrigenId {
    final $$PresupuestosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.presupuestoOrigenId,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableOrderingComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FacturasTableAnnotationComposer
    extends Composer<_$AppDatabase, $FacturasTable> {
  $$FacturasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaVencimiento => $composableBuilder(
    column: $table.fechaVencimiento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get iva =>
      $composableBuilder(column: $table.iva, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => column,
  );

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PresupuestosTableAnnotationComposer get presupuestoOrigenId {
    final $$PresupuestosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.presupuestoOrigenId,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableAnnotationComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> facturaLineasRefs<T extends Object>(
    Expression<T> Function($$FacturaLineasTableAnnotationComposer a) f,
  ) {
    final $$FacturaLineasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.facturaLineas,
      getReferencedColumn: (t) => t.facturaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacturaLineasTableAnnotationComposer(
            $db: $db,
            $table: $db.facturaLineas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cobrosRefs<T extends Object>(
    Expression<T> Function($$CobrosTableAnnotationComposer a) f,
  ) {
    final $$CobrosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cobros,
      getReferencedColumn: (t) => t.facturaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CobrosTableAnnotationComposer(
            $db: $db,
            $table: $db.cobros,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FacturasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FacturasTable,
          Factura,
          $$FacturasTableFilterComposer,
          $$FacturasTableOrderingComposer,
          $$FacturasTableAnnotationComposer,
          $$FacturasTableCreateCompanionBuilder,
          $$FacturasTableUpdateCompanionBuilder,
          (Factura, $$FacturasTableReferences),
          Factura,
          PrefetchHooks Function({
            bool clienteId,
            bool presupuestoOrigenId,
            bool facturaLineasRefs,
            bool cobrosRefs,
          })
        > {
  $$FacturasTableTableManager(_$AppDatabase db, $FacturasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FacturasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FacturasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FacturasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> clienteId = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<DateTime> fechaVencimiento = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> iva = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<String?> presupuestoOrigenId = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FacturasCompanion(
                id: id,
                codigo: codigo,
                clienteId: clienteId,
                fecha: fecha,
                fechaVencimiento: fechaVencimiento,
                estado: estado,
                subtotal: subtotal,
                iva: iva,
                total: total,
                observaciones: observaciones,
                presupuestoOrigenId: presupuestoOrigenId,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> codigo = const Value.absent(),
                required String clienteId,
                Value<DateTime> fecha = const Value.absent(),
                Value<DateTime> fechaVencimiento = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> iva = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<String?> presupuestoOrigenId = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FacturasCompanion.insert(
                id: id,
                codigo: codigo,
                clienteId: clienteId,
                fecha: fecha,
                fechaVencimiento: fechaVencimiento,
                estado: estado,
                subtotal: subtotal,
                iva: iva,
                total: total,
                observaciones: observaciones,
                presupuestoOrigenId: presupuestoOrigenId,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FacturasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clienteId = false,
                presupuestoOrigenId = false,
                facturaLineasRefs = false,
                cobrosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (facturaLineasRefs) db.facturaLineas,
                    if (cobrosRefs) db.cobros,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (clienteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.clienteId,
                                    referencedTable: $$FacturasTableReferences
                                        ._clienteIdTable(db),
                                    referencedColumn: $$FacturasTableReferences
                                        ._clienteIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (presupuestoOrigenId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.presupuestoOrigenId,
                                    referencedTable: $$FacturasTableReferences
                                        ._presupuestoOrigenIdTable(db),
                                    referencedColumn: $$FacturasTableReferences
                                        ._presupuestoOrigenIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (facturaLineasRefs)
                        await $_getPrefetchedData<
                          Factura,
                          $FacturasTable,
                          FacturaLinea
                        >(
                          currentTable: table,
                          referencedTable: $$FacturasTableReferences
                              ._facturaLineasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FacturasTableReferences(
                                db,
                                table,
                                p0,
                              ).facturaLineasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.facturaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cobrosRefs)
                        await $_getPrefetchedData<
                          Factura,
                          $FacturasTable,
                          Cobro
                        >(
                          currentTable: table,
                          referencedTable: $$FacturasTableReferences
                              ._cobrosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FacturasTableReferences(
                                db,
                                table,
                                p0,
                              ).cobrosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.facturaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FacturasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FacturasTable,
      Factura,
      $$FacturasTableFilterComposer,
      $$FacturasTableOrderingComposer,
      $$FacturasTableAnnotationComposer,
      $$FacturasTableCreateCompanionBuilder,
      $$FacturasTableUpdateCompanionBuilder,
      (Factura, $$FacturasTableReferences),
      Factura,
      PrefetchHooks Function({
        bool clienteId,
        bool presupuestoOrigenId,
        bool facturaLineasRefs,
        bool cobrosRefs,
      })
    >;
typedef $$FacturaLineasTableCreateCompanionBuilder =
    FacturaLineasCompanion Function({
      required String id,
      required String facturaId,
      required String descripcion,
      required double cantidad,
      Value<String> unidad,
      required double precioUnitario,
      Value<double> descuento,
      Value<double> importe,
      Value<int> rowid,
    });
typedef $$FacturaLineasTableUpdateCompanionBuilder =
    FacturaLineasCompanion Function({
      Value<String> id,
      Value<String> facturaId,
      Value<String> descripcion,
      Value<double> cantidad,
      Value<String> unidad,
      Value<double> precioUnitario,
      Value<double> descuento,
      Value<double> importe,
      Value<int> rowid,
    });

final class $$FacturaLineasTableReferences
    extends BaseReferences<_$AppDatabase, $FacturaLineasTable, FacturaLinea> {
  $$FacturaLineasTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FacturasTable _facturaIdTable(_$AppDatabase db) =>
      db.facturas.createAlias('factura_lineas__factura_id__facturas__id');

  $$FacturasTableProcessedTableManager get facturaId {
    final $_column = $_itemColumn<String>('factura_id')!;

    final manager = $$FacturasTableTableManager(
      $_db,
      $_db.facturas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_facturaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FacturaLineasTableFilterComposer
    extends Composer<_$AppDatabase, $FacturaLineasTable> {
  $$FacturaLineasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get descuento => $composableBuilder(
    column: $table.descuento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get importe => $composableBuilder(
    column: $table.importe,
    builder: (column) => ColumnFilters(column),
  );

  $$FacturasTableFilterComposer get facturaId {
    final $$FacturasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.facturaId,
      referencedTable: $db.facturas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacturasTableFilterComposer(
            $db: $db,
            $table: $db.facturas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FacturaLineasTableOrderingComposer
    extends Composer<_$AppDatabase, $FacturaLineasTable> {
  $$FacturaLineasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get descuento => $composableBuilder(
    column: $table.descuento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get importe => $composableBuilder(
    column: $table.importe,
    builder: (column) => ColumnOrderings(column),
  );

  $$FacturasTableOrderingComposer get facturaId {
    final $$FacturasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.facturaId,
      referencedTable: $db.facturas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacturasTableOrderingComposer(
            $db: $db,
            $table: $db.facturas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FacturaLineasTableAnnotationComposer
    extends Composer<_$AppDatabase, $FacturaLineasTable> {
  $$FacturaLineasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<double> get descuento =>
      $composableBuilder(column: $table.descuento, builder: (column) => column);

  GeneratedColumn<double> get importe =>
      $composableBuilder(column: $table.importe, builder: (column) => column);

  $$FacturasTableAnnotationComposer get facturaId {
    final $$FacturasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.facturaId,
      referencedTable: $db.facturas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacturasTableAnnotationComposer(
            $db: $db,
            $table: $db.facturas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FacturaLineasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FacturaLineasTable,
          FacturaLinea,
          $$FacturaLineasTableFilterComposer,
          $$FacturaLineasTableOrderingComposer,
          $$FacturaLineasTableAnnotationComposer,
          $$FacturaLineasTableCreateCompanionBuilder,
          $$FacturaLineasTableUpdateCompanionBuilder,
          (FacturaLinea, $$FacturaLineasTableReferences),
          FacturaLinea,
          PrefetchHooks Function({bool facturaId})
        > {
  $$FacturaLineasTableTableManager(_$AppDatabase db, $FacturaLineasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FacturaLineasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FacturaLineasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FacturaLineasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> facturaId = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<double> cantidad = const Value.absent(),
                Value<String> unidad = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<double> descuento = const Value.absent(),
                Value<double> importe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FacturaLineasCompanion(
                id: id,
                facturaId: facturaId,
                descripcion: descripcion,
                cantidad: cantidad,
                unidad: unidad,
                precioUnitario: precioUnitario,
                descuento: descuento,
                importe: importe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String facturaId,
                required String descripcion,
                required double cantidad,
                Value<String> unidad = const Value.absent(),
                required double precioUnitario,
                Value<double> descuento = const Value.absent(),
                Value<double> importe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FacturaLineasCompanion.insert(
                id: id,
                facturaId: facturaId,
                descripcion: descripcion,
                cantidad: cantidad,
                unidad: unidad,
                precioUnitario: precioUnitario,
                descuento: descuento,
                importe: importe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FacturaLineasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({facturaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (facturaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.facturaId,
                                referencedTable: $$FacturaLineasTableReferences
                                    ._facturaIdTable(db),
                                referencedColumn: $$FacturaLineasTableReferences
                                    ._facturaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FacturaLineasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FacturaLineasTable,
      FacturaLinea,
      $$FacturaLineasTableFilterComposer,
      $$FacturaLineasTableOrderingComposer,
      $$FacturaLineasTableAnnotationComposer,
      $$FacturaLineasTableCreateCompanionBuilder,
      $$FacturaLineasTableUpdateCompanionBuilder,
      (FacturaLinea, $$FacturaLineasTableReferences),
      FacturaLinea,
      PrefetchHooks Function({bool facturaId})
    >;
typedef $$CobrosTableCreateCompanionBuilder =
    CobrosCompanion Function({
      required String id,
      required String facturaId,
      Value<DateTime> fecha,
      Value<double> importe,
      Value<String> metodoPago,
      Value<String> referencia,
      Value<String> observaciones,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });
typedef $$CobrosTableUpdateCompanionBuilder =
    CobrosCompanion Function({
      Value<String> id,
      Value<String> facturaId,
      Value<DateTime> fecha,
      Value<double> importe,
      Value<String> metodoPago,
      Value<String> referencia,
      Value<String> observaciones,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });

final class $$CobrosTableReferences
    extends BaseReferences<_$AppDatabase, $CobrosTable, Cobro> {
  $$CobrosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FacturasTable _facturaIdTable(_$AppDatabase db) =>
      db.facturas.createAlias('cobros__factura_id__facturas__id');

  $$FacturasTableProcessedTableManager get facturaId {
    final $_column = $_itemColumn<String>('factura_id')!;

    final manager = $$FacturasTableTableManager(
      $_db,
      $_db.facturas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_facturaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CobrosTableFilterComposer
    extends Composer<_$AppDatabase, $CobrosTable> {
  $$CobrosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get importe => $composableBuilder(
    column: $table.importe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metodoPago => $composableBuilder(
    column: $table.metodoPago,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => ColumnFilters(column),
  );

  $$FacturasTableFilterComposer get facturaId {
    final $$FacturasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.facturaId,
      referencedTable: $db.facturas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacturasTableFilterComposer(
            $db: $db,
            $table: $db.facturas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CobrosTableOrderingComposer
    extends Composer<_$AppDatabase, $CobrosTable> {
  $$CobrosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get importe => $composableBuilder(
    column: $table.importe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metodoPago => $composableBuilder(
    column: $table.metodoPago,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$FacturasTableOrderingComposer get facturaId {
    final $$FacturasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.facturaId,
      referencedTable: $db.facturas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacturasTableOrderingComposer(
            $db: $db,
            $table: $db.facturas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CobrosTableAnnotationComposer
    extends Composer<_$AppDatabase, $CobrosTable> {
  $$CobrosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<double> get importe =>
      $composableBuilder(column: $table.importe, builder: (column) => column);

  GeneratedColumn<String> get metodoPago => $composableBuilder(
    column: $table.metodoPago,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => column,
  );

  $$FacturasTableAnnotationComposer get facturaId {
    final $$FacturasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.facturaId,
      referencedTable: $db.facturas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacturasTableAnnotationComposer(
            $db: $db,
            $table: $db.facturas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CobrosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CobrosTable,
          Cobro,
          $$CobrosTableFilterComposer,
          $$CobrosTableOrderingComposer,
          $$CobrosTableAnnotationComposer,
          $$CobrosTableCreateCompanionBuilder,
          $$CobrosTableUpdateCompanionBuilder,
          (Cobro, $$CobrosTableReferences),
          Cobro,
          PrefetchHooks Function({bool facturaId})
        > {
  $$CobrosTableTableManager(_$AppDatabase db, $CobrosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CobrosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CobrosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CobrosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> facturaId = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<double> importe = const Value.absent(),
                Value<String> metodoPago = const Value.absent(),
                Value<String> referencia = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CobrosCompanion(
                id: id,
                facturaId: facturaId,
                fecha: fecha,
                importe: importe,
                metodoPago: metodoPago,
                referencia: referencia,
                observaciones: observaciones,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String facturaId,
                Value<DateTime> fecha = const Value.absent(),
                Value<double> importe = const Value.absent(),
                Value<String> metodoPago = const Value.absent(),
                Value<String> referencia = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CobrosCompanion.insert(
                id: id,
                facturaId: facturaId,
                fecha: fecha,
                importe: importe,
                metodoPago: metodoPago,
                referencia: referencia,
                observaciones: observaciones,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CobrosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({facturaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (facturaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.facturaId,
                                referencedTable: $$CobrosTableReferences
                                    ._facturaIdTable(db),
                                referencedColumn: $$CobrosTableReferences
                                    ._facturaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CobrosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CobrosTable,
      Cobro,
      $$CobrosTableFilterComposer,
      $$CobrosTableOrderingComposer,
      $$CobrosTableAnnotationComposer,
      $$CobrosTableCreateCompanionBuilder,
      $$CobrosTableUpdateCompanionBuilder,
      (Cobro, $$CobrosTableReferences),
      Cobro,
      PrefetchHooks Function({bool facturaId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db, _db.expedientes);
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db, _db.presupuestos);
  $$LineasPresupuestoTableTableManager get lineasPresupuesto =>
      $$LineasPresupuestoTableTableManager(_db, _db.lineasPresupuesto);
  $$EmpresaConfiguracionTableTableManager get empresaConfiguracion =>
      $$EmpresaConfiguracionTableTableManager(_db, _db.empresaConfiguracion);
  $$FacturasTableTableManager get facturas =>
      $$FacturasTableTableManager(_db, _db.facturas);
  $$FacturaLineasTableTableManager get facturaLineas =>
      $$FacturaLineasTableTableManager(_db, _db.facturaLineas);
  $$CobrosTableTableManager get cobros =>
      $$CobrosTableTableManager(_db, _db.cobros);
}
