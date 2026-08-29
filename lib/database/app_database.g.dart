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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    presupuestoId,
    concepto,
    cantidad,
    unidad,
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
      unidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad'],
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
  final String unidad;
  final double precioUnitario;
  const LineasPresupuestoData({
    required this.id,
    required this.presupuestoId,
    required this.concepto,
    required this.cantidad,
    required this.unidad,
    required this.precioUnitario,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['presupuesto_id'] = Variable<String>(presupuestoId);
    map['concepto'] = Variable<String>(concepto);
    map['cantidad'] = Variable<double>(cantidad);
    map['unidad'] = Variable<String>(unidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    return map;
  }

  LineasPresupuestoCompanion toCompanion(bool nullToAbsent) {
    return LineasPresupuestoCompanion(
      id: Value(id),
      presupuestoId: Value(presupuestoId),
      concepto: Value(concepto),
      cantidad: Value(cantidad),
      unidad: Value(unidad),
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
      unidad: serializer.fromJson<String>(json['unidad']),
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
      'unidad': serializer.toJson<String>(unidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
    };
  }

  LineasPresupuestoData copyWith({
    String? id,
    String? presupuestoId,
    String? concepto,
    double? cantidad,
    String? unidad,
    double? precioUnitario,
  }) => LineasPresupuestoData(
    id: id ?? this.id,
    presupuestoId: presupuestoId ?? this.presupuestoId,
    concepto: concepto ?? this.concepto,
    cantidad: cantidad ?? this.cantidad,
    unidad: unidad ?? this.unidad,
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
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
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
          ..write('unidad: $unidad, ')
          ..write('precioUnitario: $precioUnitario')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    presupuestoId,
    concepto,
    cantidad,
    unidad,
    precioUnitario,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LineasPresupuestoData &&
          other.id == this.id &&
          other.presupuestoId == this.presupuestoId &&
          other.concepto == this.concepto &&
          other.cantidad == this.cantidad &&
          other.unidad == this.unidad &&
          other.precioUnitario == this.precioUnitario);
}

class LineasPresupuestoCompanion
    extends UpdateCompanion<LineasPresupuestoData> {
  final Value<String> id;
  final Value<String> presupuestoId;
  final Value<String> concepto;
  final Value<double> cantidad;
  final Value<String> unidad;
  final Value<double> precioUnitario;
  final Value<int> rowid;
  const LineasPresupuestoCompanion({
    this.id = const Value.absent(),
    this.presupuestoId = const Value.absent(),
    this.concepto = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.unidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LineasPresupuestoCompanion.insert({
    required String id,
    required String presupuestoId,
    required String concepto,
    required double cantidad,
    this.unidad = const Value.absent(),
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
    Expression<String>? unidad,
    Expression<double>? precioUnitario,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (presupuestoId != null) 'presupuesto_id': presupuestoId,
      if (concepto != null) 'concepto': concepto,
      if (cantidad != null) 'cantidad': cantidad,
      if (unidad != null) 'unidad': unidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LineasPresupuestoCompanion copyWith({
    Value<String>? id,
    Value<String>? presupuestoId,
    Value<String>? concepto,
    Value<double>? cantidad,
    Value<String>? unidad,
    Value<double>? precioUnitario,
    Value<int>? rowid,
  }) {
    return LineasPresupuestoCompanion(
      id: id ?? this.id,
      presupuestoId: presupuestoId ?? this.presupuestoId,
      concepto: concepto ?? this.concepto,
      cantidad: cantidad ?? this.cantidad,
      unidad: unidad ?? this.unidad,
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
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
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
          ..write('unidad: $unidad, ')
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
  static const VerificationMeta _anioNumeracionMeta = const VerificationMeta(
    'anioNumeracion',
  );
  @override
  late final GeneratedColumn<int> anioNumeracion = GeneratedColumn<int>(
    'anio_numeracion',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numeroLegalMeta = const VerificationMeta(
    'numeroLegal',
  );
  @override
  late final GeneratedColumn<int> numeroLegal = GeneratedColumn<int>(
    'numero_legal',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    defaultValue: const Constant(21),
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
  static const VerificationMeta _fechaEmisionMeta = const VerificationMeta(
    'fechaEmision',
  );
  @override
  late final GeneratedColumn<DateTime> fechaEmision = GeneratedColumn<DateTime>(
    'fecha_emision',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clienteNombreHistoricoMeta =
      const VerificationMeta('clienteNombreHistorico');
  @override
  late final GeneratedColumn<String> clienteNombreHistorico =
      GeneratedColumn<String>(
        'cliente_nombre_historico',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _clienteNifHistoricoMeta =
      const VerificationMeta('clienteNifHistorico');
  @override
  late final GeneratedColumn<String> clienteNifHistorico =
      GeneratedColumn<String>(
        'cliente_nif_historico',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _clienteDireccionHistoricaMeta =
      const VerificationMeta('clienteDireccionHistorica');
  @override
  late final GeneratedColumn<String> clienteDireccionHistorica =
      GeneratedColumn<String>(
        'cliente_direccion_historica',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _clienteTelefonoHistoricoMeta =
      const VerificationMeta('clienteTelefonoHistorico');
  @override
  late final GeneratedColumn<String> clienteTelefonoHistorico =
      GeneratedColumn<String>(
        'cliente_telefono_historico',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _clienteEmailHistoricoMeta =
      const VerificationMeta('clienteEmailHistorico');
  @override
  late final GeneratedColumn<String> clienteEmailHistorico =
      GeneratedColumn<String>(
        'cliente_email_historico',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _empresaNombreHistoricoMeta =
      const VerificationMeta('empresaNombreHistorico');
  @override
  late final GeneratedColumn<String> empresaNombreHistorico =
      GeneratedColumn<String>(
        'empresa_nombre_historico',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _empresaCifHistoricoMeta =
      const VerificationMeta('empresaCifHistorico');
  @override
  late final GeneratedColumn<String> empresaCifHistorico =
      GeneratedColumn<String>(
        'empresa_cif_historico',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _empresaDireccionHistoricaMeta =
      const VerificationMeta('empresaDireccionHistorica');
  @override
  late final GeneratedColumn<String> empresaDireccionHistorica =
      GeneratedColumn<String>(
        'empresa_direccion_historica',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _empresaCodigoPostalHistoricoMeta =
      const VerificationMeta('empresaCodigoPostalHistorico');
  @override
  late final GeneratedColumn<String> empresaCodigoPostalHistorico =
      GeneratedColumn<String>(
        'empresa_codigo_postal_historico',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _empresaPoblacionHistoricaMeta =
      const VerificationMeta('empresaPoblacionHistorica');
  @override
  late final GeneratedColumn<String> empresaPoblacionHistorica =
      GeneratedColumn<String>(
        'empresa_poblacion_historica',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _empresaProvinciaHistoricaMeta =
      const VerificationMeta('empresaProvinciaHistorica');
  @override
  late final GeneratedColumn<String> empresaProvinciaHistorica =
      GeneratedColumn<String>(
        'empresa_provincia_historica',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _empresaTelefonoHistoricoMeta =
      const VerificationMeta('empresaTelefonoHistorico');
  @override
  late final GeneratedColumn<String> empresaTelefonoHistorico =
      GeneratedColumn<String>(
        'empresa_telefono_historico',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _empresaEmailHistoricoMeta =
      const VerificationMeta('empresaEmailHistorico');
  @override
  late final GeneratedColumn<String> empresaEmailHistorico =
      GeneratedColumn<String>(
        'empresa_email_historico',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _empresaWebHistoricaMeta =
      const VerificationMeta('empresaWebHistorica');
  @override
  late final GeneratedColumn<String> empresaWebHistorica =
      GeneratedColumn<String>(
        'empresa_web_historica',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _expedienteOrigenIdHistoricoMeta =
      const VerificationMeta('expedienteOrigenIdHistorico');
  @override
  late final GeneratedColumn<String> expedienteOrigenIdHistorico =
      GeneratedColumn<String>(
        'expediente_origen_id_historico',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _expedienteCodigoHistoricoMeta =
      const VerificationMeta('expedienteCodigoHistorico');
  @override
  late final GeneratedColumn<String> expedienteCodigoHistorico =
      GeneratedColumn<String>(
        'expediente_codigo_historico',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _expedienteNombreHistoricoMeta =
      const VerificationMeta('expedienteNombreHistorico');
  @override
  late final GeneratedColumn<String> expedienteNombreHistorico =
      GeneratedColumn<String>(
        'expediente_nombre_historico',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _presupuestoCodigoHistoricoMeta =
      const VerificationMeta('presupuestoCodigoHistorico');
  @override
  late final GeneratedColumn<String> presupuestoCodigoHistorico =
      GeneratedColumn<String>(
        'presupuesto_codigo_historico',
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
    codigo,
    anioNumeracion,
    numeroLegal,
    clienteId,
    fecha,
    fechaVencimiento,
    estado,
    subtotal,
    iva,
    ivaPorcentaje,
    total,
    observaciones,
    presupuestoOrigenId,
    fechaEmision,
    clienteNombreHistorico,
    clienteNifHistorico,
    clienteDireccionHistorica,
    clienteTelefonoHistorico,
    clienteEmailHistorico,
    empresaNombreHistorico,
    empresaCifHistorico,
    empresaDireccionHistorica,
    empresaCodigoPostalHistorico,
    empresaPoblacionHistorica,
    empresaProvinciaHistorica,
    empresaTelefonoHistorico,
    empresaEmailHistorico,
    empresaWebHistorica,
    expedienteOrigenIdHistorico,
    expedienteCodigoHistorico,
    expedienteNombreHistorico,
    presupuestoCodigoHistorico,
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
    if (data.containsKey('anio_numeracion')) {
      context.handle(
        _anioNumeracionMeta,
        anioNumeracion.isAcceptableOrUnknown(
          data['anio_numeracion']!,
          _anioNumeracionMeta,
        ),
      );
    }
    if (data.containsKey('numero_legal')) {
      context.handle(
        _numeroLegalMeta,
        numeroLegal.isAcceptableOrUnknown(
          data['numero_legal']!,
          _numeroLegalMeta,
        ),
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
    if (data.containsKey('iva_porcentaje')) {
      context.handle(
        _ivaPorcentajeMeta,
        ivaPorcentaje.isAcceptableOrUnknown(
          data['iva_porcentaje']!,
          _ivaPorcentajeMeta,
        ),
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
    if (data.containsKey('fecha_emision')) {
      context.handle(
        _fechaEmisionMeta,
        fechaEmision.isAcceptableOrUnknown(
          data['fecha_emision']!,
          _fechaEmisionMeta,
        ),
      );
    }
    if (data.containsKey('cliente_nombre_historico')) {
      context.handle(
        _clienteNombreHistoricoMeta,
        clienteNombreHistorico.isAcceptableOrUnknown(
          data['cliente_nombre_historico']!,
          _clienteNombreHistoricoMeta,
        ),
      );
    }
    if (data.containsKey('cliente_nif_historico')) {
      context.handle(
        _clienteNifHistoricoMeta,
        clienteNifHistorico.isAcceptableOrUnknown(
          data['cliente_nif_historico']!,
          _clienteNifHistoricoMeta,
        ),
      );
    }
    if (data.containsKey('cliente_direccion_historica')) {
      context.handle(
        _clienteDireccionHistoricaMeta,
        clienteDireccionHistorica.isAcceptableOrUnknown(
          data['cliente_direccion_historica']!,
          _clienteDireccionHistoricaMeta,
        ),
      );
    }
    if (data.containsKey('cliente_telefono_historico')) {
      context.handle(
        _clienteTelefonoHistoricoMeta,
        clienteTelefonoHistorico.isAcceptableOrUnknown(
          data['cliente_telefono_historico']!,
          _clienteTelefonoHistoricoMeta,
        ),
      );
    }
    if (data.containsKey('cliente_email_historico')) {
      context.handle(
        _clienteEmailHistoricoMeta,
        clienteEmailHistorico.isAcceptableOrUnknown(
          data['cliente_email_historico']!,
          _clienteEmailHistoricoMeta,
        ),
      );
    }
    if (data.containsKey('empresa_nombre_historico')) {
      context.handle(
        _empresaNombreHistoricoMeta,
        empresaNombreHistorico.isAcceptableOrUnknown(
          data['empresa_nombre_historico']!,
          _empresaNombreHistoricoMeta,
        ),
      );
    }
    if (data.containsKey('empresa_cif_historico')) {
      context.handle(
        _empresaCifHistoricoMeta,
        empresaCifHistorico.isAcceptableOrUnknown(
          data['empresa_cif_historico']!,
          _empresaCifHistoricoMeta,
        ),
      );
    }
    if (data.containsKey('empresa_direccion_historica')) {
      context.handle(
        _empresaDireccionHistoricaMeta,
        empresaDireccionHistorica.isAcceptableOrUnknown(
          data['empresa_direccion_historica']!,
          _empresaDireccionHistoricaMeta,
        ),
      );
    }
    if (data.containsKey('empresa_codigo_postal_historico')) {
      context.handle(
        _empresaCodigoPostalHistoricoMeta,
        empresaCodigoPostalHistorico.isAcceptableOrUnknown(
          data['empresa_codigo_postal_historico']!,
          _empresaCodigoPostalHistoricoMeta,
        ),
      );
    }
    if (data.containsKey('empresa_poblacion_historica')) {
      context.handle(
        _empresaPoblacionHistoricaMeta,
        empresaPoblacionHistorica.isAcceptableOrUnknown(
          data['empresa_poblacion_historica']!,
          _empresaPoblacionHistoricaMeta,
        ),
      );
    }
    if (data.containsKey('empresa_provincia_historica')) {
      context.handle(
        _empresaProvinciaHistoricaMeta,
        empresaProvinciaHistorica.isAcceptableOrUnknown(
          data['empresa_provincia_historica']!,
          _empresaProvinciaHistoricaMeta,
        ),
      );
    }
    if (data.containsKey('empresa_telefono_historico')) {
      context.handle(
        _empresaTelefonoHistoricoMeta,
        empresaTelefonoHistorico.isAcceptableOrUnknown(
          data['empresa_telefono_historico']!,
          _empresaTelefonoHistoricoMeta,
        ),
      );
    }
    if (data.containsKey('empresa_email_historico')) {
      context.handle(
        _empresaEmailHistoricoMeta,
        empresaEmailHistorico.isAcceptableOrUnknown(
          data['empresa_email_historico']!,
          _empresaEmailHistoricoMeta,
        ),
      );
    }
    if (data.containsKey('empresa_web_historica')) {
      context.handle(
        _empresaWebHistoricaMeta,
        empresaWebHistorica.isAcceptableOrUnknown(
          data['empresa_web_historica']!,
          _empresaWebHistoricaMeta,
        ),
      );
    }
    if (data.containsKey('expediente_origen_id_historico')) {
      context.handle(
        _expedienteOrigenIdHistoricoMeta,
        expedienteOrigenIdHistorico.isAcceptableOrUnknown(
          data['expediente_origen_id_historico']!,
          _expedienteOrigenIdHistoricoMeta,
        ),
      );
    }
    if (data.containsKey('expediente_codigo_historico')) {
      context.handle(
        _expedienteCodigoHistoricoMeta,
        expedienteCodigoHistorico.isAcceptableOrUnknown(
          data['expediente_codigo_historico']!,
          _expedienteCodigoHistoricoMeta,
        ),
      );
    }
    if (data.containsKey('expediente_nombre_historico')) {
      context.handle(
        _expedienteNombreHistoricoMeta,
        expedienteNombreHistorico.isAcceptableOrUnknown(
          data['expediente_nombre_historico']!,
          _expedienteNombreHistoricoMeta,
        ),
      );
    }
    if (data.containsKey('presupuesto_codigo_historico')) {
      context.handle(
        _presupuestoCodigoHistoricoMeta,
        presupuestoCodigoHistorico.isAcceptableOrUnknown(
          data['presupuesto_codigo_historico']!,
          _presupuestoCodigoHistoricoMeta,
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
      anioNumeracion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anio_numeracion'],
      ),
      numeroLegal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero_legal'],
      ),
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
      ivaPorcentaje: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}iva_porcentaje'],
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
      fechaEmision: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_emision'],
      ),
      clienteNombreHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_nombre_historico'],
      )!,
      clienteNifHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_nif_historico'],
      )!,
      clienteDireccionHistorica: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_direccion_historica'],
      )!,
      clienteTelefonoHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_telefono_historico'],
      )!,
      clienteEmailHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_email_historico'],
      )!,
      empresaNombreHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa_nombre_historico'],
      )!,
      empresaCifHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa_cif_historico'],
      )!,
      empresaDireccionHistorica: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa_direccion_historica'],
      )!,
      empresaCodigoPostalHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa_codigo_postal_historico'],
      )!,
      empresaPoblacionHistorica: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa_poblacion_historica'],
      )!,
      empresaProvinciaHistorica: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa_provincia_historica'],
      )!,
      empresaTelefonoHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa_telefono_historico'],
      )!,
      empresaEmailHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa_email_historico'],
      )!,
      empresaWebHistorica: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa_web_historica'],
      )!,
      expedienteOrigenIdHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expediente_origen_id_historico'],
      )!,
      expedienteCodigoHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expediente_codigo_historico'],
      )!,
      expedienteNombreHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expediente_nombre_historico'],
      )!,
      presupuestoCodigoHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}presupuesto_codigo_historico'],
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
  $FacturasTable createAlias(String alias) {
    return $FacturasTable(attachedDatabase, alias);
  }
}

class Factura extends DataClass implements Insertable<Factura> {
  final String id;
  final String codigo;
  final int? anioNumeracion;
  final int? numeroLegal;
  final String clienteId;
  final DateTime fecha;
  final DateTime fechaVencimiento;
  final String estado;
  final double subtotal;
  final double iva;
  final double ivaPorcentaje;
  final double total;
  final String observaciones;
  final String? presupuestoOrigenId;
  final DateTime? fechaEmision;
  final String clienteNombreHistorico;
  final String clienteNifHistorico;
  final String clienteDireccionHistorica;
  final String clienteTelefonoHistorico;
  final String clienteEmailHistorico;
  final String empresaNombreHistorico;
  final String empresaCifHistorico;
  final String empresaDireccionHistorica;
  final String empresaCodigoPostalHistorico;
  final String empresaPoblacionHistorica;
  final String empresaProvinciaHistorica;
  final String empresaTelefonoHistorico;
  final String empresaEmailHistorico;
  final String empresaWebHistorica;
  final String expedienteOrigenIdHistorico;
  final String expedienteCodigoHistorico;
  final String expedienteNombreHistorico;
  final String presupuestoCodigoHistorico;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  const Factura({
    required this.id,
    required this.codigo,
    this.anioNumeracion,
    this.numeroLegal,
    required this.clienteId,
    required this.fecha,
    required this.fechaVencimiento,
    required this.estado,
    required this.subtotal,
    required this.iva,
    required this.ivaPorcentaje,
    required this.total,
    required this.observaciones,
    this.presupuestoOrigenId,
    this.fechaEmision,
    required this.clienteNombreHistorico,
    required this.clienteNifHistorico,
    required this.clienteDireccionHistorica,
    required this.clienteTelefonoHistorico,
    required this.clienteEmailHistorico,
    required this.empresaNombreHistorico,
    required this.empresaCifHistorico,
    required this.empresaDireccionHistorica,
    required this.empresaCodigoPostalHistorico,
    required this.empresaPoblacionHistorica,
    required this.empresaProvinciaHistorica,
    required this.empresaTelefonoHistorico,
    required this.empresaEmailHistorico,
    required this.empresaWebHistorica,
    required this.expedienteOrigenIdHistorico,
    required this.expedienteCodigoHistorico,
    required this.expedienteNombreHistorico,
    required this.presupuestoCodigoHistorico,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['codigo'] = Variable<String>(codigo);
    if (!nullToAbsent || anioNumeracion != null) {
      map['anio_numeracion'] = Variable<int>(anioNumeracion);
    }
    if (!nullToAbsent || numeroLegal != null) {
      map['numero_legal'] = Variable<int>(numeroLegal);
    }
    map['cliente_id'] = Variable<String>(clienteId);
    map['fecha'] = Variable<DateTime>(fecha);
    map['fecha_vencimiento'] = Variable<DateTime>(fechaVencimiento);
    map['estado'] = Variable<String>(estado);
    map['subtotal'] = Variable<double>(subtotal);
    map['iva'] = Variable<double>(iva);
    map['iva_porcentaje'] = Variable<double>(ivaPorcentaje);
    map['total'] = Variable<double>(total);
    map['observaciones'] = Variable<String>(observaciones);
    if (!nullToAbsent || presupuestoOrigenId != null) {
      map['presupuesto_origen_id'] = Variable<String>(presupuestoOrigenId);
    }
    if (!nullToAbsent || fechaEmision != null) {
      map['fecha_emision'] = Variable<DateTime>(fechaEmision);
    }
    map['cliente_nombre_historico'] = Variable<String>(clienteNombreHistorico);
    map['cliente_nif_historico'] = Variable<String>(clienteNifHistorico);
    map['cliente_direccion_historica'] = Variable<String>(
      clienteDireccionHistorica,
    );
    map['cliente_telefono_historico'] = Variable<String>(
      clienteTelefonoHistorico,
    );
    map['cliente_email_historico'] = Variable<String>(clienteEmailHistorico);
    map['empresa_nombre_historico'] = Variable<String>(empresaNombreHistorico);
    map['empresa_cif_historico'] = Variable<String>(empresaCifHistorico);
    map['empresa_direccion_historica'] = Variable<String>(
      empresaDireccionHistorica,
    );
    map['empresa_codigo_postal_historico'] = Variable<String>(
      empresaCodigoPostalHistorico,
    );
    map['empresa_poblacion_historica'] = Variable<String>(
      empresaPoblacionHistorica,
    );
    map['empresa_provincia_historica'] = Variable<String>(
      empresaProvinciaHistorica,
    );
    map['empresa_telefono_historico'] = Variable<String>(
      empresaTelefonoHistorico,
    );
    map['empresa_email_historico'] = Variable<String>(empresaEmailHistorico);
    map['empresa_web_historica'] = Variable<String>(empresaWebHistorica);
    map['expediente_origen_id_historico'] = Variable<String>(
      expedienteOrigenIdHistorico,
    );
    map['expediente_codigo_historico'] = Variable<String>(
      expedienteCodigoHistorico,
    );
    map['expediente_nombre_historico'] = Variable<String>(
      expedienteNombreHistorico,
    );
    map['presupuesto_codigo_historico'] = Variable<String>(
      presupuestoCodigoHistorico,
    );
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion);
    return map;
  }

  FacturasCompanion toCompanion(bool nullToAbsent) {
    return FacturasCompanion(
      id: Value(id),
      codigo: Value(codigo),
      anioNumeracion: anioNumeracion == null && nullToAbsent
          ? const Value.absent()
          : Value(anioNumeracion),
      numeroLegal: numeroLegal == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroLegal),
      clienteId: Value(clienteId),
      fecha: Value(fecha),
      fechaVencimiento: Value(fechaVencimiento),
      estado: Value(estado),
      subtotal: Value(subtotal),
      iva: Value(iva),
      ivaPorcentaje: Value(ivaPorcentaje),
      total: Value(total),
      observaciones: Value(observaciones),
      presupuestoOrigenId: presupuestoOrigenId == null && nullToAbsent
          ? const Value.absent()
          : Value(presupuestoOrigenId),
      fechaEmision: fechaEmision == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaEmision),
      clienteNombreHistorico: Value(clienteNombreHistorico),
      clienteNifHistorico: Value(clienteNifHistorico),
      clienteDireccionHistorica: Value(clienteDireccionHistorica),
      clienteTelefonoHistorico: Value(clienteTelefonoHistorico),
      clienteEmailHistorico: Value(clienteEmailHistorico),
      empresaNombreHistorico: Value(empresaNombreHistorico),
      empresaCifHistorico: Value(empresaCifHistorico),
      empresaDireccionHistorica: Value(empresaDireccionHistorica),
      empresaCodigoPostalHistorico: Value(empresaCodigoPostalHistorico),
      empresaPoblacionHistorica: Value(empresaPoblacionHistorica),
      empresaProvinciaHistorica: Value(empresaProvinciaHistorica),
      empresaTelefonoHistorico: Value(empresaTelefonoHistorico),
      empresaEmailHistorico: Value(empresaEmailHistorico),
      empresaWebHistorica: Value(empresaWebHistorica),
      expedienteOrigenIdHistorico: Value(expedienteOrigenIdHistorico),
      expedienteCodigoHistorico: Value(expedienteCodigoHistorico),
      expedienteNombreHistorico: Value(expedienteNombreHistorico),
      presupuestoCodigoHistorico: Value(presupuestoCodigoHistorico),
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
      anioNumeracion: serializer.fromJson<int?>(json['anioNumeracion']),
      numeroLegal: serializer.fromJson<int?>(json['numeroLegal']),
      clienteId: serializer.fromJson<String>(json['clienteId']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      fechaVencimiento: serializer.fromJson<DateTime>(json['fechaVencimiento']),
      estado: serializer.fromJson<String>(json['estado']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      iva: serializer.fromJson<double>(json['iva']),
      ivaPorcentaje: serializer.fromJson<double>(json['ivaPorcentaje']),
      total: serializer.fromJson<double>(json['total']),
      observaciones: serializer.fromJson<String>(json['observaciones']),
      presupuestoOrigenId: serializer.fromJson<String?>(
        json['presupuestoOrigenId'],
      ),
      fechaEmision: serializer.fromJson<DateTime?>(json['fechaEmision']),
      clienteNombreHistorico: serializer.fromJson<String>(
        json['clienteNombreHistorico'],
      ),
      clienteNifHistorico: serializer.fromJson<String>(
        json['clienteNifHistorico'],
      ),
      clienteDireccionHistorica: serializer.fromJson<String>(
        json['clienteDireccionHistorica'],
      ),
      clienteTelefonoHistorico: serializer.fromJson<String>(
        json['clienteTelefonoHistorico'],
      ),
      clienteEmailHistorico: serializer.fromJson<String>(
        json['clienteEmailHistorico'],
      ),
      empresaNombreHistorico: serializer.fromJson<String>(
        json['empresaNombreHistorico'],
      ),
      empresaCifHistorico: serializer.fromJson<String>(
        json['empresaCifHistorico'],
      ),
      empresaDireccionHistorica: serializer.fromJson<String>(
        json['empresaDireccionHistorica'],
      ),
      empresaCodigoPostalHistorico: serializer.fromJson<String>(
        json['empresaCodigoPostalHistorico'],
      ),
      empresaPoblacionHistorica: serializer.fromJson<String>(
        json['empresaPoblacionHistorica'],
      ),
      empresaProvinciaHistorica: serializer.fromJson<String>(
        json['empresaProvinciaHistorica'],
      ),
      empresaTelefonoHistorico: serializer.fromJson<String>(
        json['empresaTelefonoHistorico'],
      ),
      empresaEmailHistorico: serializer.fromJson<String>(
        json['empresaEmailHistorico'],
      ),
      empresaWebHistorica: serializer.fromJson<String>(
        json['empresaWebHistorica'],
      ),
      expedienteOrigenIdHistorico: serializer.fromJson<String>(
        json['expedienteOrigenIdHistorico'],
      ),
      expedienteCodigoHistorico: serializer.fromJson<String>(
        json['expedienteCodigoHistorico'],
      ),
      expedienteNombreHistorico: serializer.fromJson<String>(
        json['expedienteNombreHistorico'],
      ),
      presupuestoCodigoHistorico: serializer.fromJson<String>(
        json['presupuestoCodigoHistorico'],
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
      'anioNumeracion': serializer.toJson<int?>(anioNumeracion),
      'numeroLegal': serializer.toJson<int?>(numeroLegal),
      'clienteId': serializer.toJson<String>(clienteId),
      'fecha': serializer.toJson<DateTime>(fecha),
      'fechaVencimiento': serializer.toJson<DateTime>(fechaVencimiento),
      'estado': serializer.toJson<String>(estado),
      'subtotal': serializer.toJson<double>(subtotal),
      'iva': serializer.toJson<double>(iva),
      'ivaPorcentaje': serializer.toJson<double>(ivaPorcentaje),
      'total': serializer.toJson<double>(total),
      'observaciones': serializer.toJson<String>(observaciones),
      'presupuestoOrigenId': serializer.toJson<String?>(presupuestoOrigenId),
      'fechaEmision': serializer.toJson<DateTime?>(fechaEmision),
      'clienteNombreHistorico': serializer.toJson<String>(
        clienteNombreHistorico,
      ),
      'clienteNifHistorico': serializer.toJson<String>(clienteNifHistorico),
      'clienteDireccionHistorica': serializer.toJson<String>(
        clienteDireccionHistorica,
      ),
      'clienteTelefonoHistorico': serializer.toJson<String>(
        clienteTelefonoHistorico,
      ),
      'clienteEmailHistorico': serializer.toJson<String>(clienteEmailHistorico),
      'empresaNombreHistorico': serializer.toJson<String>(
        empresaNombreHistorico,
      ),
      'empresaCifHistorico': serializer.toJson<String>(empresaCifHistorico),
      'empresaDireccionHistorica': serializer.toJson<String>(
        empresaDireccionHistorica,
      ),
      'empresaCodigoPostalHistorico': serializer.toJson<String>(
        empresaCodigoPostalHistorico,
      ),
      'empresaPoblacionHistorica': serializer.toJson<String>(
        empresaPoblacionHistorica,
      ),
      'empresaProvinciaHistorica': serializer.toJson<String>(
        empresaProvinciaHistorica,
      ),
      'empresaTelefonoHistorico': serializer.toJson<String>(
        empresaTelefonoHistorico,
      ),
      'empresaEmailHistorico': serializer.toJson<String>(empresaEmailHistorico),
      'empresaWebHistorica': serializer.toJson<String>(empresaWebHistorica),
      'expedienteOrigenIdHistorico': serializer.toJson<String>(
        expedienteOrigenIdHistorico,
      ),
      'expedienteCodigoHistorico': serializer.toJson<String>(
        expedienteCodigoHistorico,
      ),
      'expedienteNombreHistorico': serializer.toJson<String>(
        expedienteNombreHistorico,
      ),
      'presupuestoCodigoHistorico': serializer.toJson<String>(
        presupuestoCodigoHistorico,
      ),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaModificacion': serializer.toJson<DateTime>(fechaModificacion),
    };
  }

  Factura copyWith({
    String? id,
    String? codigo,
    Value<int?> anioNumeracion = const Value.absent(),
    Value<int?> numeroLegal = const Value.absent(),
    String? clienteId,
    DateTime? fecha,
    DateTime? fechaVencimiento,
    String? estado,
    double? subtotal,
    double? iva,
    double? ivaPorcentaje,
    double? total,
    String? observaciones,
    Value<String?> presupuestoOrigenId = const Value.absent(),
    Value<DateTime?> fechaEmision = const Value.absent(),
    String? clienteNombreHistorico,
    String? clienteNifHistorico,
    String? clienteDireccionHistorica,
    String? clienteTelefonoHistorico,
    String? clienteEmailHistorico,
    String? empresaNombreHistorico,
    String? empresaCifHistorico,
    String? empresaDireccionHistorica,
    String? empresaCodigoPostalHistorico,
    String? empresaPoblacionHistorica,
    String? empresaProvinciaHistorica,
    String? empresaTelefonoHistorico,
    String? empresaEmailHistorico,
    String? empresaWebHistorica,
    String? expedienteOrigenIdHistorico,
    String? expedienteCodigoHistorico,
    String? expedienteNombreHistorico,
    String? presupuestoCodigoHistorico,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
  }) => Factura(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    anioNumeracion: anioNumeracion.present
        ? anioNumeracion.value
        : this.anioNumeracion,
    numeroLegal: numeroLegal.present ? numeroLegal.value : this.numeroLegal,
    clienteId: clienteId ?? this.clienteId,
    fecha: fecha ?? this.fecha,
    fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
    estado: estado ?? this.estado,
    subtotal: subtotal ?? this.subtotal,
    iva: iva ?? this.iva,
    ivaPorcentaje: ivaPorcentaje ?? this.ivaPorcentaje,
    total: total ?? this.total,
    observaciones: observaciones ?? this.observaciones,
    presupuestoOrigenId: presupuestoOrigenId.present
        ? presupuestoOrigenId.value
        : this.presupuestoOrigenId,
    fechaEmision: fechaEmision.present ? fechaEmision.value : this.fechaEmision,
    clienteNombreHistorico:
        clienteNombreHistorico ?? this.clienteNombreHistorico,
    clienteNifHistorico: clienteNifHistorico ?? this.clienteNifHistorico,
    clienteDireccionHistorica:
        clienteDireccionHistorica ?? this.clienteDireccionHistorica,
    clienteTelefonoHistorico:
        clienteTelefonoHistorico ?? this.clienteTelefonoHistorico,
    clienteEmailHistorico: clienteEmailHistorico ?? this.clienteEmailHistorico,
    empresaNombreHistorico:
        empresaNombreHistorico ?? this.empresaNombreHistorico,
    empresaCifHistorico: empresaCifHistorico ?? this.empresaCifHistorico,
    empresaDireccionHistorica:
        empresaDireccionHistorica ?? this.empresaDireccionHistorica,
    empresaCodigoPostalHistorico:
        empresaCodigoPostalHistorico ?? this.empresaCodigoPostalHistorico,
    empresaPoblacionHistorica:
        empresaPoblacionHistorica ?? this.empresaPoblacionHistorica,
    empresaProvinciaHistorica:
        empresaProvinciaHistorica ?? this.empresaProvinciaHistorica,
    empresaTelefonoHistorico:
        empresaTelefonoHistorico ?? this.empresaTelefonoHistorico,
    empresaEmailHistorico: empresaEmailHistorico ?? this.empresaEmailHistorico,
    empresaWebHistorica: empresaWebHistorica ?? this.empresaWebHistorica,
    expedienteOrigenIdHistorico:
        expedienteOrigenIdHistorico ?? this.expedienteOrigenIdHistorico,
    expedienteCodigoHistorico:
        expedienteCodigoHistorico ?? this.expedienteCodigoHistorico,
    expedienteNombreHistorico:
        expedienteNombreHistorico ?? this.expedienteNombreHistorico,
    presupuestoCodigoHistorico:
        presupuestoCodigoHistorico ?? this.presupuestoCodigoHistorico,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaModificacion: fechaModificacion ?? this.fechaModificacion,
  );
  Factura copyWithCompanion(FacturasCompanion data) {
    return Factura(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      anioNumeracion: data.anioNumeracion.present
          ? data.anioNumeracion.value
          : this.anioNumeracion,
      numeroLegal: data.numeroLegal.present
          ? data.numeroLegal.value
          : this.numeroLegal,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      fechaVencimiento: data.fechaVencimiento.present
          ? data.fechaVencimiento.value
          : this.fechaVencimiento,
      estado: data.estado.present ? data.estado.value : this.estado,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      iva: data.iva.present ? data.iva.value : this.iva,
      ivaPorcentaje: data.ivaPorcentaje.present
          ? data.ivaPorcentaje.value
          : this.ivaPorcentaje,
      total: data.total.present ? data.total.value : this.total,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      presupuestoOrigenId: data.presupuestoOrigenId.present
          ? data.presupuestoOrigenId.value
          : this.presupuestoOrigenId,
      fechaEmision: data.fechaEmision.present
          ? data.fechaEmision.value
          : this.fechaEmision,
      clienteNombreHistorico: data.clienteNombreHistorico.present
          ? data.clienteNombreHistorico.value
          : this.clienteNombreHistorico,
      clienteNifHistorico: data.clienteNifHistorico.present
          ? data.clienteNifHistorico.value
          : this.clienteNifHistorico,
      clienteDireccionHistorica: data.clienteDireccionHistorica.present
          ? data.clienteDireccionHistorica.value
          : this.clienteDireccionHistorica,
      clienteTelefonoHistorico: data.clienteTelefonoHistorico.present
          ? data.clienteTelefonoHistorico.value
          : this.clienteTelefonoHistorico,
      clienteEmailHistorico: data.clienteEmailHistorico.present
          ? data.clienteEmailHistorico.value
          : this.clienteEmailHistorico,
      empresaNombreHistorico: data.empresaNombreHistorico.present
          ? data.empresaNombreHistorico.value
          : this.empresaNombreHistorico,
      empresaCifHistorico: data.empresaCifHistorico.present
          ? data.empresaCifHistorico.value
          : this.empresaCifHistorico,
      empresaDireccionHistorica: data.empresaDireccionHistorica.present
          ? data.empresaDireccionHistorica.value
          : this.empresaDireccionHistorica,
      empresaCodigoPostalHistorico: data.empresaCodigoPostalHistorico.present
          ? data.empresaCodigoPostalHistorico.value
          : this.empresaCodigoPostalHistorico,
      empresaPoblacionHistorica: data.empresaPoblacionHistorica.present
          ? data.empresaPoblacionHistorica.value
          : this.empresaPoblacionHistorica,
      empresaProvinciaHistorica: data.empresaProvinciaHistorica.present
          ? data.empresaProvinciaHistorica.value
          : this.empresaProvinciaHistorica,
      empresaTelefonoHistorico: data.empresaTelefonoHistorico.present
          ? data.empresaTelefonoHistorico.value
          : this.empresaTelefonoHistorico,
      empresaEmailHistorico: data.empresaEmailHistorico.present
          ? data.empresaEmailHistorico.value
          : this.empresaEmailHistorico,
      empresaWebHistorica: data.empresaWebHistorica.present
          ? data.empresaWebHistorica.value
          : this.empresaWebHistorica,
      expedienteOrigenIdHistorico: data.expedienteOrigenIdHistorico.present
          ? data.expedienteOrigenIdHistorico.value
          : this.expedienteOrigenIdHistorico,
      expedienteCodigoHistorico: data.expedienteCodigoHistorico.present
          ? data.expedienteCodigoHistorico.value
          : this.expedienteCodigoHistorico,
      expedienteNombreHistorico: data.expedienteNombreHistorico.present
          ? data.expedienteNombreHistorico.value
          : this.expedienteNombreHistorico,
      presupuestoCodigoHistorico: data.presupuestoCodigoHistorico.present
          ? data.presupuestoCodigoHistorico.value
          : this.presupuestoCodigoHistorico,
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
          ..write('anioNumeracion: $anioNumeracion, ')
          ..write('numeroLegal: $numeroLegal, ')
          ..write('clienteId: $clienteId, ')
          ..write('fecha: $fecha, ')
          ..write('fechaVencimiento: $fechaVencimiento, ')
          ..write('estado: $estado, ')
          ..write('subtotal: $subtotal, ')
          ..write('iva: $iva, ')
          ..write('ivaPorcentaje: $ivaPorcentaje, ')
          ..write('total: $total, ')
          ..write('observaciones: $observaciones, ')
          ..write('presupuestoOrigenId: $presupuestoOrigenId, ')
          ..write('fechaEmision: $fechaEmision, ')
          ..write('clienteNombreHistorico: $clienteNombreHistorico, ')
          ..write('clienteNifHistorico: $clienteNifHistorico, ')
          ..write('clienteDireccionHistorica: $clienteDireccionHistorica, ')
          ..write('clienteTelefonoHistorico: $clienteTelefonoHistorico, ')
          ..write('clienteEmailHistorico: $clienteEmailHistorico, ')
          ..write('empresaNombreHistorico: $empresaNombreHistorico, ')
          ..write('empresaCifHistorico: $empresaCifHistorico, ')
          ..write('empresaDireccionHistorica: $empresaDireccionHistorica, ')
          ..write(
            'empresaCodigoPostalHistorico: $empresaCodigoPostalHistorico, ',
          )
          ..write('empresaPoblacionHistorica: $empresaPoblacionHistorica, ')
          ..write('empresaProvinciaHistorica: $empresaProvinciaHistorica, ')
          ..write('empresaTelefonoHistorico: $empresaTelefonoHistorico, ')
          ..write('empresaEmailHistorico: $empresaEmailHistorico, ')
          ..write('empresaWebHistorica: $empresaWebHistorica, ')
          ..write('expedienteOrigenIdHistorico: $expedienteOrigenIdHistorico, ')
          ..write('expedienteCodigoHistorico: $expedienteCodigoHistorico, ')
          ..write('expedienteNombreHistorico: $expedienteNombreHistorico, ')
          ..write('presupuestoCodigoHistorico: $presupuestoCodigoHistorico, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    codigo,
    anioNumeracion,
    numeroLegal,
    clienteId,
    fecha,
    fechaVencimiento,
    estado,
    subtotal,
    iva,
    ivaPorcentaje,
    total,
    observaciones,
    presupuestoOrigenId,
    fechaEmision,
    clienteNombreHistorico,
    clienteNifHistorico,
    clienteDireccionHistorica,
    clienteTelefonoHistorico,
    clienteEmailHistorico,
    empresaNombreHistorico,
    empresaCifHistorico,
    empresaDireccionHistorica,
    empresaCodigoPostalHistorico,
    empresaPoblacionHistorica,
    empresaProvinciaHistorica,
    empresaTelefonoHistorico,
    empresaEmailHistorico,
    empresaWebHistorica,
    expedienteOrigenIdHistorico,
    expedienteCodigoHistorico,
    expedienteNombreHistorico,
    presupuestoCodigoHistorico,
    fechaCreacion,
    fechaModificacion,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Factura &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.anioNumeracion == this.anioNumeracion &&
          other.numeroLegal == this.numeroLegal &&
          other.clienteId == this.clienteId &&
          other.fecha == this.fecha &&
          other.fechaVencimiento == this.fechaVencimiento &&
          other.estado == this.estado &&
          other.subtotal == this.subtotal &&
          other.iva == this.iva &&
          other.ivaPorcentaje == this.ivaPorcentaje &&
          other.total == this.total &&
          other.observaciones == this.observaciones &&
          other.presupuestoOrigenId == this.presupuestoOrigenId &&
          other.fechaEmision == this.fechaEmision &&
          other.clienteNombreHistorico == this.clienteNombreHistorico &&
          other.clienteNifHistorico == this.clienteNifHistorico &&
          other.clienteDireccionHistorica == this.clienteDireccionHistorica &&
          other.clienteTelefonoHistorico == this.clienteTelefonoHistorico &&
          other.clienteEmailHistorico == this.clienteEmailHistorico &&
          other.empresaNombreHistorico == this.empresaNombreHistorico &&
          other.empresaCifHistorico == this.empresaCifHistorico &&
          other.empresaDireccionHistorica == this.empresaDireccionHistorica &&
          other.empresaCodigoPostalHistorico ==
              this.empresaCodigoPostalHistorico &&
          other.empresaPoblacionHistorica == this.empresaPoblacionHistorica &&
          other.empresaProvinciaHistorica == this.empresaProvinciaHistorica &&
          other.empresaTelefonoHistorico == this.empresaTelefonoHistorico &&
          other.empresaEmailHistorico == this.empresaEmailHistorico &&
          other.empresaWebHistorica == this.empresaWebHistorica &&
          other.expedienteOrigenIdHistorico ==
              this.expedienteOrigenIdHistorico &&
          other.expedienteCodigoHistorico == this.expedienteCodigoHistorico &&
          other.expedienteNombreHistorico == this.expedienteNombreHistorico &&
          other.presupuestoCodigoHistorico == this.presupuestoCodigoHistorico &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaModificacion == this.fechaModificacion);
}

class FacturasCompanion extends UpdateCompanion<Factura> {
  final Value<String> id;
  final Value<String> codigo;
  final Value<int?> anioNumeracion;
  final Value<int?> numeroLegal;
  final Value<String> clienteId;
  final Value<DateTime> fecha;
  final Value<DateTime> fechaVencimiento;
  final Value<String> estado;
  final Value<double> subtotal;
  final Value<double> iva;
  final Value<double> ivaPorcentaje;
  final Value<double> total;
  final Value<String> observaciones;
  final Value<String?> presupuestoOrigenId;
  final Value<DateTime?> fechaEmision;
  final Value<String> clienteNombreHistorico;
  final Value<String> clienteNifHistorico;
  final Value<String> clienteDireccionHistorica;
  final Value<String> clienteTelefonoHistorico;
  final Value<String> clienteEmailHistorico;
  final Value<String> empresaNombreHistorico;
  final Value<String> empresaCifHistorico;
  final Value<String> empresaDireccionHistorica;
  final Value<String> empresaCodigoPostalHistorico;
  final Value<String> empresaPoblacionHistorica;
  final Value<String> empresaProvinciaHistorica;
  final Value<String> empresaTelefonoHistorico;
  final Value<String> empresaEmailHistorico;
  final Value<String> empresaWebHistorica;
  final Value<String> expedienteOrigenIdHistorico;
  final Value<String> expedienteCodigoHistorico;
  final Value<String> expedienteNombreHistorico;
  final Value<String> presupuestoCodigoHistorico;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaModificacion;
  final Value<int> rowid;
  const FacturasCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.anioNumeracion = const Value.absent(),
    this.numeroLegal = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.fechaVencimiento = const Value.absent(),
    this.estado = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.iva = const Value.absent(),
    this.ivaPorcentaje = const Value.absent(),
    this.total = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.presupuestoOrigenId = const Value.absent(),
    this.fechaEmision = const Value.absent(),
    this.clienteNombreHistorico = const Value.absent(),
    this.clienteNifHistorico = const Value.absent(),
    this.clienteDireccionHistorica = const Value.absent(),
    this.clienteTelefonoHistorico = const Value.absent(),
    this.clienteEmailHistorico = const Value.absent(),
    this.empresaNombreHistorico = const Value.absent(),
    this.empresaCifHistorico = const Value.absent(),
    this.empresaDireccionHistorica = const Value.absent(),
    this.empresaCodigoPostalHistorico = const Value.absent(),
    this.empresaPoblacionHistorica = const Value.absent(),
    this.empresaProvinciaHistorica = const Value.absent(),
    this.empresaTelefonoHistorico = const Value.absent(),
    this.empresaEmailHistorico = const Value.absent(),
    this.empresaWebHistorica = const Value.absent(),
    this.expedienteOrigenIdHistorico = const Value.absent(),
    this.expedienteCodigoHistorico = const Value.absent(),
    this.expedienteNombreHistorico = const Value.absent(),
    this.presupuestoCodigoHistorico = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FacturasCompanion.insert({
    required String id,
    this.codigo = const Value.absent(),
    this.anioNumeracion = const Value.absent(),
    this.numeroLegal = const Value.absent(),
    required String clienteId,
    this.fecha = const Value.absent(),
    this.fechaVencimiento = const Value.absent(),
    this.estado = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.iva = const Value.absent(),
    this.ivaPorcentaje = const Value.absent(),
    this.total = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.presupuestoOrigenId = const Value.absent(),
    this.fechaEmision = const Value.absent(),
    this.clienteNombreHistorico = const Value.absent(),
    this.clienteNifHistorico = const Value.absent(),
    this.clienteDireccionHistorica = const Value.absent(),
    this.clienteTelefonoHistorico = const Value.absent(),
    this.clienteEmailHistorico = const Value.absent(),
    this.empresaNombreHistorico = const Value.absent(),
    this.empresaCifHistorico = const Value.absent(),
    this.empresaDireccionHistorica = const Value.absent(),
    this.empresaCodigoPostalHistorico = const Value.absent(),
    this.empresaPoblacionHistorica = const Value.absent(),
    this.empresaProvinciaHistorica = const Value.absent(),
    this.empresaTelefonoHistorico = const Value.absent(),
    this.empresaEmailHistorico = const Value.absent(),
    this.empresaWebHistorica = const Value.absent(),
    this.expedienteOrigenIdHistorico = const Value.absent(),
    this.expedienteCodigoHistorico = const Value.absent(),
    this.expedienteNombreHistorico = const Value.absent(),
    this.presupuestoCodigoHistorico = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clienteId = Value(clienteId);
  static Insertable<Factura> custom({
    Expression<String>? id,
    Expression<String>? codigo,
    Expression<int>? anioNumeracion,
    Expression<int>? numeroLegal,
    Expression<String>? clienteId,
    Expression<DateTime>? fecha,
    Expression<DateTime>? fechaVencimiento,
    Expression<String>? estado,
    Expression<double>? subtotal,
    Expression<double>? iva,
    Expression<double>? ivaPorcentaje,
    Expression<double>? total,
    Expression<String>? observaciones,
    Expression<String>? presupuestoOrigenId,
    Expression<DateTime>? fechaEmision,
    Expression<String>? clienteNombreHistorico,
    Expression<String>? clienteNifHistorico,
    Expression<String>? clienteDireccionHistorica,
    Expression<String>? clienteTelefonoHistorico,
    Expression<String>? clienteEmailHistorico,
    Expression<String>? empresaNombreHistorico,
    Expression<String>? empresaCifHistorico,
    Expression<String>? empresaDireccionHistorica,
    Expression<String>? empresaCodigoPostalHistorico,
    Expression<String>? empresaPoblacionHistorica,
    Expression<String>? empresaProvinciaHistorica,
    Expression<String>? empresaTelefonoHistorico,
    Expression<String>? empresaEmailHistorico,
    Expression<String>? empresaWebHistorica,
    Expression<String>? expedienteOrigenIdHistorico,
    Expression<String>? expedienteCodigoHistorico,
    Expression<String>? expedienteNombreHistorico,
    Expression<String>? presupuestoCodigoHistorico,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaModificacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (anioNumeracion != null) 'anio_numeracion': anioNumeracion,
      if (numeroLegal != null) 'numero_legal': numeroLegal,
      if (clienteId != null) 'cliente_id': clienteId,
      if (fecha != null) 'fecha': fecha,
      if (fechaVencimiento != null) 'fecha_vencimiento': fechaVencimiento,
      if (estado != null) 'estado': estado,
      if (subtotal != null) 'subtotal': subtotal,
      if (iva != null) 'iva': iva,
      if (ivaPorcentaje != null) 'iva_porcentaje': ivaPorcentaje,
      if (total != null) 'total': total,
      if (observaciones != null) 'observaciones': observaciones,
      if (presupuestoOrigenId != null)
        'presupuesto_origen_id': presupuestoOrigenId,
      if (fechaEmision != null) 'fecha_emision': fechaEmision,
      if (clienteNombreHistorico != null)
        'cliente_nombre_historico': clienteNombreHistorico,
      if (clienteNifHistorico != null)
        'cliente_nif_historico': clienteNifHistorico,
      if (clienteDireccionHistorica != null)
        'cliente_direccion_historica': clienteDireccionHistorica,
      if (clienteTelefonoHistorico != null)
        'cliente_telefono_historico': clienteTelefonoHistorico,
      if (clienteEmailHistorico != null)
        'cliente_email_historico': clienteEmailHistorico,
      if (empresaNombreHistorico != null)
        'empresa_nombre_historico': empresaNombreHistorico,
      if (empresaCifHistorico != null)
        'empresa_cif_historico': empresaCifHistorico,
      if (empresaDireccionHistorica != null)
        'empresa_direccion_historica': empresaDireccionHistorica,
      if (empresaCodigoPostalHistorico != null)
        'empresa_codigo_postal_historico': empresaCodigoPostalHistorico,
      if (empresaPoblacionHistorica != null)
        'empresa_poblacion_historica': empresaPoblacionHistorica,
      if (empresaProvinciaHistorica != null)
        'empresa_provincia_historica': empresaProvinciaHistorica,
      if (empresaTelefonoHistorico != null)
        'empresa_telefono_historico': empresaTelefonoHistorico,
      if (empresaEmailHistorico != null)
        'empresa_email_historico': empresaEmailHistorico,
      if (empresaWebHistorica != null)
        'empresa_web_historica': empresaWebHistorica,
      if (expedienteOrigenIdHistorico != null)
        'expediente_origen_id_historico': expedienteOrigenIdHistorico,
      if (expedienteCodigoHistorico != null)
        'expediente_codigo_historico': expedienteCodigoHistorico,
      if (expedienteNombreHistorico != null)
        'expediente_nombre_historico': expedienteNombreHistorico,
      if (presupuestoCodigoHistorico != null)
        'presupuesto_codigo_historico': presupuestoCodigoHistorico,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaModificacion != null) 'fecha_modificacion': fechaModificacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FacturasCompanion copyWith({
    Value<String>? id,
    Value<String>? codigo,
    Value<int?>? anioNumeracion,
    Value<int?>? numeroLegal,
    Value<String>? clienteId,
    Value<DateTime>? fecha,
    Value<DateTime>? fechaVencimiento,
    Value<String>? estado,
    Value<double>? subtotal,
    Value<double>? iva,
    Value<double>? ivaPorcentaje,
    Value<double>? total,
    Value<String>? observaciones,
    Value<String?>? presupuestoOrigenId,
    Value<DateTime?>? fechaEmision,
    Value<String>? clienteNombreHistorico,
    Value<String>? clienteNifHistorico,
    Value<String>? clienteDireccionHistorica,
    Value<String>? clienteTelefonoHistorico,
    Value<String>? clienteEmailHistorico,
    Value<String>? empresaNombreHistorico,
    Value<String>? empresaCifHistorico,
    Value<String>? empresaDireccionHistorica,
    Value<String>? empresaCodigoPostalHistorico,
    Value<String>? empresaPoblacionHistorica,
    Value<String>? empresaProvinciaHistorica,
    Value<String>? empresaTelefonoHistorico,
    Value<String>? empresaEmailHistorico,
    Value<String>? empresaWebHistorica,
    Value<String>? expedienteOrigenIdHistorico,
    Value<String>? expedienteCodigoHistorico,
    Value<String>? expedienteNombreHistorico,
    Value<String>? presupuestoCodigoHistorico,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaModificacion,
    Value<int>? rowid,
  }) {
    return FacturasCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      anioNumeracion: anioNumeracion ?? this.anioNumeracion,
      numeroLegal: numeroLegal ?? this.numeroLegal,
      clienteId: clienteId ?? this.clienteId,
      fecha: fecha ?? this.fecha,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      estado: estado ?? this.estado,
      subtotal: subtotal ?? this.subtotal,
      iva: iva ?? this.iva,
      ivaPorcentaje: ivaPorcentaje ?? this.ivaPorcentaje,
      total: total ?? this.total,
      observaciones: observaciones ?? this.observaciones,
      presupuestoOrigenId: presupuestoOrigenId ?? this.presupuestoOrigenId,
      fechaEmision: fechaEmision ?? this.fechaEmision,
      clienteNombreHistorico:
          clienteNombreHistorico ?? this.clienteNombreHistorico,
      clienteNifHistorico: clienteNifHistorico ?? this.clienteNifHistorico,
      clienteDireccionHistorica:
          clienteDireccionHistorica ?? this.clienteDireccionHistorica,
      clienteTelefonoHistorico:
          clienteTelefonoHistorico ?? this.clienteTelefonoHistorico,
      clienteEmailHistorico:
          clienteEmailHistorico ?? this.clienteEmailHistorico,
      empresaNombreHistorico:
          empresaNombreHistorico ?? this.empresaNombreHistorico,
      empresaCifHistorico: empresaCifHistorico ?? this.empresaCifHistorico,
      empresaDireccionHistorica:
          empresaDireccionHistorica ?? this.empresaDireccionHistorica,
      empresaCodigoPostalHistorico:
          empresaCodigoPostalHistorico ?? this.empresaCodigoPostalHistorico,
      empresaPoblacionHistorica:
          empresaPoblacionHistorica ?? this.empresaPoblacionHistorica,
      empresaProvinciaHistorica:
          empresaProvinciaHistorica ?? this.empresaProvinciaHistorica,
      empresaTelefonoHistorico:
          empresaTelefonoHistorico ?? this.empresaTelefonoHistorico,
      empresaEmailHistorico:
          empresaEmailHistorico ?? this.empresaEmailHistorico,
      empresaWebHistorica: empresaWebHistorica ?? this.empresaWebHistorica,
      expedienteOrigenIdHistorico:
          expedienteOrigenIdHistorico ?? this.expedienteOrigenIdHistorico,
      expedienteCodigoHistorico:
          expedienteCodigoHistorico ?? this.expedienteCodigoHistorico,
      expedienteNombreHistorico:
          expedienteNombreHistorico ?? this.expedienteNombreHistorico,
      presupuestoCodigoHistorico:
          presupuestoCodigoHistorico ?? this.presupuestoCodigoHistorico,
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
    if (anioNumeracion.present) {
      map['anio_numeracion'] = Variable<int>(anioNumeracion.value);
    }
    if (numeroLegal.present) {
      map['numero_legal'] = Variable<int>(numeroLegal.value);
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
    if (ivaPorcentaje.present) {
      map['iva_porcentaje'] = Variable<double>(ivaPorcentaje.value);
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
    if (fechaEmision.present) {
      map['fecha_emision'] = Variable<DateTime>(fechaEmision.value);
    }
    if (clienteNombreHistorico.present) {
      map['cliente_nombre_historico'] = Variable<String>(
        clienteNombreHistorico.value,
      );
    }
    if (clienteNifHistorico.present) {
      map['cliente_nif_historico'] = Variable<String>(
        clienteNifHistorico.value,
      );
    }
    if (clienteDireccionHistorica.present) {
      map['cliente_direccion_historica'] = Variable<String>(
        clienteDireccionHistorica.value,
      );
    }
    if (clienteTelefonoHistorico.present) {
      map['cliente_telefono_historico'] = Variable<String>(
        clienteTelefonoHistorico.value,
      );
    }
    if (clienteEmailHistorico.present) {
      map['cliente_email_historico'] = Variable<String>(
        clienteEmailHistorico.value,
      );
    }
    if (empresaNombreHistorico.present) {
      map['empresa_nombre_historico'] = Variable<String>(
        empresaNombreHistorico.value,
      );
    }
    if (empresaCifHistorico.present) {
      map['empresa_cif_historico'] = Variable<String>(
        empresaCifHistorico.value,
      );
    }
    if (empresaDireccionHistorica.present) {
      map['empresa_direccion_historica'] = Variable<String>(
        empresaDireccionHistorica.value,
      );
    }
    if (empresaCodigoPostalHistorico.present) {
      map['empresa_codigo_postal_historico'] = Variable<String>(
        empresaCodigoPostalHistorico.value,
      );
    }
    if (empresaPoblacionHistorica.present) {
      map['empresa_poblacion_historica'] = Variable<String>(
        empresaPoblacionHistorica.value,
      );
    }
    if (empresaProvinciaHistorica.present) {
      map['empresa_provincia_historica'] = Variable<String>(
        empresaProvinciaHistorica.value,
      );
    }
    if (empresaTelefonoHistorico.present) {
      map['empresa_telefono_historico'] = Variable<String>(
        empresaTelefonoHistorico.value,
      );
    }
    if (empresaEmailHistorico.present) {
      map['empresa_email_historico'] = Variable<String>(
        empresaEmailHistorico.value,
      );
    }
    if (empresaWebHistorica.present) {
      map['empresa_web_historica'] = Variable<String>(
        empresaWebHistorica.value,
      );
    }
    if (expedienteOrigenIdHistorico.present) {
      map['expediente_origen_id_historico'] = Variable<String>(
        expedienteOrigenIdHistorico.value,
      );
    }
    if (expedienteCodigoHistorico.present) {
      map['expediente_codigo_historico'] = Variable<String>(
        expedienteCodigoHistorico.value,
      );
    }
    if (expedienteNombreHistorico.present) {
      map['expediente_nombre_historico'] = Variable<String>(
        expedienteNombreHistorico.value,
      );
    }
    if (presupuestoCodigoHistorico.present) {
      map['presupuesto_codigo_historico'] = Variable<String>(
        presupuestoCodigoHistorico.value,
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
          ..write('anioNumeracion: $anioNumeracion, ')
          ..write('numeroLegal: $numeroLegal, ')
          ..write('clienteId: $clienteId, ')
          ..write('fecha: $fecha, ')
          ..write('fechaVencimiento: $fechaVencimiento, ')
          ..write('estado: $estado, ')
          ..write('subtotal: $subtotal, ')
          ..write('iva: $iva, ')
          ..write('ivaPorcentaje: $ivaPorcentaje, ')
          ..write('total: $total, ')
          ..write('observaciones: $observaciones, ')
          ..write('presupuestoOrigenId: $presupuestoOrigenId, ')
          ..write('fechaEmision: $fechaEmision, ')
          ..write('clienteNombreHistorico: $clienteNombreHistorico, ')
          ..write('clienteNifHistorico: $clienteNifHistorico, ')
          ..write('clienteDireccionHistorica: $clienteDireccionHistorica, ')
          ..write('clienteTelefonoHistorico: $clienteTelefonoHistorico, ')
          ..write('clienteEmailHistorico: $clienteEmailHistorico, ')
          ..write('empresaNombreHistorico: $empresaNombreHistorico, ')
          ..write('empresaCifHistorico: $empresaCifHistorico, ')
          ..write('empresaDireccionHistorica: $empresaDireccionHistorica, ')
          ..write(
            'empresaCodigoPostalHistorico: $empresaCodigoPostalHistorico, ',
          )
          ..write('empresaPoblacionHistorica: $empresaPoblacionHistorica, ')
          ..write('empresaProvinciaHistorica: $empresaProvinciaHistorica, ')
          ..write('empresaTelefonoHistorico: $empresaTelefonoHistorico, ')
          ..write('empresaEmailHistorico: $empresaEmailHistorico, ')
          ..write('empresaWebHistorica: $empresaWebHistorica, ')
          ..write('expedienteOrigenIdHistorico: $expedienteOrigenIdHistorico, ')
          ..write('expedienteCodigoHistorico: $expedienteCodigoHistorico, ')
          ..write('expedienteNombreHistorico: $expedienteNombreHistorico, ')
          ..write('presupuestoCodigoHistorico: $presupuestoCodigoHistorico, ')
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
  static const VerificationMeta _tipoMovimientoMeta = const VerificationMeta(
    'tipoMovimiento',
  );
  @override
  late final GeneratedColumn<String> tipoMovimiento = GeneratedColumn<String>(
    'tipo_movimiento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('cobro'),
  );
  static const VerificationMeta _cobroOrigenIdMeta = const VerificationMeta(
    'cobroOrigenId',
  );
  @override
  late final GeneratedColumn<String> cobroOrigenId = GeneratedColumn<String>(
    'cobro_origen_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cobros (id)',
    ),
  );
  static const VerificationMeta _motivoMeta = const VerificationMeta('motivo');
  @override
  late final GeneratedColumn<String> motivo = GeneratedColumn<String>(
    'motivo',
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
    tipoMovimiento,
    cobroOrigenId,
    motivo,
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
    if (data.containsKey('tipo_movimiento')) {
      context.handle(
        _tipoMovimientoMeta,
        tipoMovimiento.isAcceptableOrUnknown(
          data['tipo_movimiento']!,
          _tipoMovimientoMeta,
        ),
      );
    }
    if (data.containsKey('cobro_origen_id')) {
      context.handle(
        _cobroOrigenIdMeta,
        cobroOrigenId.isAcceptableOrUnknown(
          data['cobro_origen_id']!,
          _cobroOrigenIdMeta,
        ),
      );
    }
    if (data.containsKey('motivo')) {
      context.handle(
        _motivoMeta,
        motivo.isAcceptableOrUnknown(data['motivo']!, _motivoMeta),
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
      tipoMovimiento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_movimiento'],
      )!,
      cobroOrigenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cobro_origen_id'],
      ),
      motivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivo'],
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
  final String tipoMovimiento;
  final String? cobroOrigenId;
  final String motivo;
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
    required this.tipoMovimiento,
    this.cobroOrigenId,
    required this.motivo,
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
    map['tipo_movimiento'] = Variable<String>(tipoMovimiento);
    if (!nullToAbsent || cobroOrigenId != null) {
      map['cobro_origen_id'] = Variable<String>(cobroOrigenId);
    }
    map['motivo'] = Variable<String>(motivo);
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
      tipoMovimiento: Value(tipoMovimiento),
      cobroOrigenId: cobroOrigenId == null && nullToAbsent
          ? const Value.absent()
          : Value(cobroOrigenId),
      motivo: Value(motivo),
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
      tipoMovimiento: serializer.fromJson<String>(json['tipoMovimiento']),
      cobroOrigenId: serializer.fromJson<String?>(json['cobroOrigenId']),
      motivo: serializer.fromJson<String>(json['motivo']),
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
      'tipoMovimiento': serializer.toJson<String>(tipoMovimiento),
      'cobroOrigenId': serializer.toJson<String?>(cobroOrigenId),
      'motivo': serializer.toJson<String>(motivo),
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
    String? tipoMovimiento,
    Value<String?> cobroOrigenId = const Value.absent(),
    String? motivo,
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
    tipoMovimiento: tipoMovimiento ?? this.tipoMovimiento,
    cobroOrigenId: cobroOrigenId.present
        ? cobroOrigenId.value
        : this.cobroOrigenId,
    motivo: motivo ?? this.motivo,
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
      tipoMovimiento: data.tipoMovimiento.present
          ? data.tipoMovimiento.value
          : this.tipoMovimiento,
      cobroOrigenId: data.cobroOrigenId.present
          ? data.cobroOrigenId.value
          : this.cobroOrigenId,
      motivo: data.motivo.present ? data.motivo.value : this.motivo,
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
          ..write('tipoMovimiento: $tipoMovimiento, ')
          ..write('cobroOrigenId: $cobroOrigenId, ')
          ..write('motivo: $motivo, ')
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
    tipoMovimiento,
    cobroOrigenId,
    motivo,
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
          other.tipoMovimiento == this.tipoMovimiento &&
          other.cobroOrigenId == this.cobroOrigenId &&
          other.motivo == this.motivo &&
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
  final Value<String> tipoMovimiento;
  final Value<String?> cobroOrigenId;
  final Value<String> motivo;
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
    this.tipoMovimiento = const Value.absent(),
    this.cobroOrigenId = const Value.absent(),
    this.motivo = const Value.absent(),
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
    this.tipoMovimiento = const Value.absent(),
    this.cobroOrigenId = const Value.absent(),
    this.motivo = const Value.absent(),
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
    Expression<String>? tipoMovimiento,
    Expression<String>? cobroOrigenId,
    Expression<String>? motivo,
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
      if (tipoMovimiento != null) 'tipo_movimiento': tipoMovimiento,
      if (cobroOrigenId != null) 'cobro_origen_id': cobroOrigenId,
      if (motivo != null) 'motivo': motivo,
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
    Value<String>? tipoMovimiento,
    Value<String?>? cobroOrigenId,
    Value<String>? motivo,
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
      tipoMovimiento: tipoMovimiento ?? this.tipoMovimiento,
      cobroOrigenId: cobroOrigenId ?? this.cobroOrigenId,
      motivo: motivo ?? this.motivo,
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
    if (tipoMovimiento.present) {
      map['tipo_movimiento'] = Variable<String>(tipoMovimiento.value);
    }
    if (cobroOrigenId.present) {
      map['cobro_origen_id'] = Variable<String>(cobroOrigenId.value);
    }
    if (motivo.present) {
      map['motivo'] = Variable<String>(motivo.value);
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
          ..write('tipoMovimiento: $tipoMovimiento, ')
          ..write('cobroOrigenId: $cobroOrigenId, ')
          ..write('motivo: $motivo, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ComprasTable extends Compras with TableInfo<$ComprasTable, Compra> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComprasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _proveedorIdMeta = const VerificationMeta(
    'proveedorId',
  );
  @override
  late final GeneratedColumn<String> proveedorId = GeneratedColumn<String>(
    'proveedor_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proveedorNombreMeta = const VerificationMeta(
    'proveedorNombre',
  );
  @override
  late final GeneratedColumn<String> proveedorNombre = GeneratedColumn<String>(
    'proveedor_nombre',
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
  static const VerificationMeta _numeroFacturaMeta = const VerificationMeta(
    'numeroFactura',
  );
  @override
  late final GeneratedColumn<String> numeroFactura = GeneratedColumn<String>(
    'numero_factura',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _baseImponibleMeta = const VerificationMeta(
    'baseImponible',
  );
  @override
  late final GeneratedColumn<double> baseImponible = GeneratedColumn<double>(
    'base_imponible',
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
    defaultValue: const Constant(21),
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
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    proveedorId,
    proveedorNombre,
    fecha,
    numeroFactura,
    concepto,
    baseImponible,
    ivaPorcentaje,
    importeTotal,
    estado,
    observaciones,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compras';
  @override
  VerificationContext validateIntegrity(
    Insertable<Compra> instance, {
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
    if (data.containsKey('proveedor_id')) {
      context.handle(
        _proveedorIdMeta,
        proveedorId.isAcceptableOrUnknown(
          data['proveedor_id']!,
          _proveedorIdMeta,
        ),
      );
    }
    if (data.containsKey('proveedor_nombre')) {
      context.handle(
        _proveedorNombreMeta,
        proveedorNombre.isAcceptableOrUnknown(
          data['proveedor_nombre']!,
          _proveedorNombreMeta,
        ),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('numero_factura')) {
      context.handle(
        _numeroFacturaMeta,
        numeroFactura.isAcceptableOrUnknown(
          data['numero_factura']!,
          _numeroFacturaMeta,
        ),
      );
    }
    if (data.containsKey('concepto')) {
      context.handle(
        _conceptoMeta,
        concepto.isAcceptableOrUnknown(data['concepto']!, _conceptoMeta),
      );
    }
    if (data.containsKey('base_imponible')) {
      context.handle(
        _baseImponibleMeta,
        baseImponible.isAcceptableOrUnknown(
          data['base_imponible']!,
          _baseImponibleMeta,
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
    if (data.containsKey('importe_total')) {
      context.handle(
        _importeTotalMeta,
        importeTotal.isAcceptableOrUnknown(
          data['importe_total']!,
          _importeTotalMeta,
        ),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
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
  Compra map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Compra(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      expedienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expediente_id'],
      )!,
      proveedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor_id'],
      ),
      proveedorNombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor_nombre'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      numeroFactura: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_factura'],
      ),
      concepto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concepto'],
      )!,
      baseImponible: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}base_imponible'],
      )!,
      ivaPorcentaje: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}iva_porcentaje'],
      )!,
      importeTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}importe_total'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      ),
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
  $ComprasTable createAlias(String alias) {
    return $ComprasTable(attachedDatabase, alias);
  }
}

class Compra extends DataClass implements Insertable<Compra> {
  final String id;
  final String expedienteId;
  final String? proveedorId;
  final String proveedorNombre;
  final DateTime fecha;
  final String? numeroFactura;
  final String concepto;
  final double baseImponible;
  final double ivaPorcentaje;
  final double importeTotal;
  final String estado;
  final String? observaciones;
  final bool eliminado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  const Compra({
    required this.id,
    required this.expedienteId,
    this.proveedorId,
    required this.proveedorNombre,
    required this.fecha,
    this.numeroFactura,
    required this.concepto,
    required this.baseImponible,
    required this.ivaPorcentaje,
    required this.importeTotal,
    required this.estado,
    this.observaciones,
    required this.eliminado,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['expediente_id'] = Variable<String>(expedienteId);
    if (!nullToAbsent || proveedorId != null) {
      map['proveedor_id'] = Variable<String>(proveedorId);
    }
    map['proveedor_nombre'] = Variable<String>(proveedorNombre);
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || numeroFactura != null) {
      map['numero_factura'] = Variable<String>(numeroFactura);
    }
    map['concepto'] = Variable<String>(concepto);
    map['base_imponible'] = Variable<double>(baseImponible);
    map['iva_porcentaje'] = Variable<double>(ivaPorcentaje);
    map['importe_total'] = Variable<double>(importeTotal);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    map['eliminado'] = Variable<bool>(eliminado);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion);
    return map;
  }

  ComprasCompanion toCompanion(bool nullToAbsent) {
    return ComprasCompanion(
      id: Value(id),
      expedienteId: Value(expedienteId),
      proveedorId: proveedorId == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedorId),
      proveedorNombre: Value(proveedorNombre),
      fecha: Value(fecha),
      numeroFactura: numeroFactura == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroFactura),
      concepto: Value(concepto),
      baseImponible: Value(baseImponible),
      ivaPorcentaje: Value(ivaPorcentaje),
      importeTotal: Value(importeTotal),
      estado: Value(estado),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
      eliminado: Value(eliminado),
      fechaCreacion: Value(fechaCreacion),
      fechaModificacion: Value(fechaModificacion),
    );
  }

  factory Compra.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Compra(
      id: serializer.fromJson<String>(json['id']),
      expedienteId: serializer.fromJson<String>(json['expedienteId']),
      proveedorId: serializer.fromJson<String?>(json['proveedorId']),
      proveedorNombre: serializer.fromJson<String>(json['proveedorNombre']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      numeroFactura: serializer.fromJson<String?>(json['numeroFactura']),
      concepto: serializer.fromJson<String>(json['concepto']),
      baseImponible: serializer.fromJson<double>(json['baseImponible']),
      ivaPorcentaje: serializer.fromJson<double>(json['ivaPorcentaje']),
      importeTotal: serializer.fromJson<double>(json['importeTotal']),
      estado: serializer.fromJson<String>(json['estado']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
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
      'proveedorId': serializer.toJson<String?>(proveedorId),
      'proveedorNombre': serializer.toJson<String>(proveedorNombre),
      'fecha': serializer.toJson<DateTime>(fecha),
      'numeroFactura': serializer.toJson<String?>(numeroFactura),
      'concepto': serializer.toJson<String>(concepto),
      'baseImponible': serializer.toJson<double>(baseImponible),
      'ivaPorcentaje': serializer.toJson<double>(ivaPorcentaje),
      'importeTotal': serializer.toJson<double>(importeTotal),
      'estado': serializer.toJson<String>(estado),
      'observaciones': serializer.toJson<String?>(observaciones),
      'eliminado': serializer.toJson<bool>(eliminado),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaModificacion': serializer.toJson<DateTime>(fechaModificacion),
    };
  }

  Compra copyWith({
    String? id,
    String? expedienteId,
    Value<String?> proveedorId = const Value.absent(),
    String? proveedorNombre,
    DateTime? fecha,
    Value<String?> numeroFactura = const Value.absent(),
    String? concepto,
    double? baseImponible,
    double? ivaPorcentaje,
    double? importeTotal,
    String? estado,
    Value<String?> observaciones = const Value.absent(),
    bool? eliminado,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
  }) => Compra(
    id: id ?? this.id,
    expedienteId: expedienteId ?? this.expedienteId,
    proveedorId: proveedorId.present ? proveedorId.value : this.proveedorId,
    proveedorNombre: proveedorNombre ?? this.proveedorNombre,
    fecha: fecha ?? this.fecha,
    numeroFactura: numeroFactura.present
        ? numeroFactura.value
        : this.numeroFactura,
    concepto: concepto ?? this.concepto,
    baseImponible: baseImponible ?? this.baseImponible,
    ivaPorcentaje: ivaPorcentaje ?? this.ivaPorcentaje,
    importeTotal: importeTotal ?? this.importeTotal,
    estado: estado ?? this.estado,
    observaciones: observaciones.present
        ? observaciones.value
        : this.observaciones,
    eliminado: eliminado ?? this.eliminado,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaModificacion: fechaModificacion ?? this.fechaModificacion,
  );
  Compra copyWithCompanion(ComprasCompanion data) {
    return Compra(
      id: data.id.present ? data.id.value : this.id,
      expedienteId: data.expedienteId.present
          ? data.expedienteId.value
          : this.expedienteId,
      proveedorId: data.proveedorId.present
          ? data.proveedorId.value
          : this.proveedorId,
      proveedorNombre: data.proveedorNombre.present
          ? data.proveedorNombre.value
          : this.proveedorNombre,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      numeroFactura: data.numeroFactura.present
          ? data.numeroFactura.value
          : this.numeroFactura,
      concepto: data.concepto.present ? data.concepto.value : this.concepto,
      baseImponible: data.baseImponible.present
          ? data.baseImponible.value
          : this.baseImponible,
      ivaPorcentaje: data.ivaPorcentaje.present
          ? data.ivaPorcentaje.value
          : this.ivaPorcentaje,
      importeTotal: data.importeTotal.present
          ? data.importeTotal.value
          : this.importeTotal,
      estado: data.estado.present ? data.estado.value : this.estado,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
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
    return (StringBuffer('Compra(')
          ..write('id: $id, ')
          ..write('expedienteId: $expedienteId, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('proveedorNombre: $proveedorNombre, ')
          ..write('fecha: $fecha, ')
          ..write('numeroFactura: $numeroFactura, ')
          ..write('concepto: $concepto, ')
          ..write('baseImponible: $baseImponible, ')
          ..write('ivaPorcentaje: $ivaPorcentaje, ')
          ..write('importeTotal: $importeTotal, ')
          ..write('estado: $estado, ')
          ..write('observaciones: $observaciones, ')
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
    proveedorId,
    proveedorNombre,
    fecha,
    numeroFactura,
    concepto,
    baseImponible,
    ivaPorcentaje,
    importeTotal,
    estado,
    observaciones,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Compra &&
          other.id == this.id &&
          other.expedienteId == this.expedienteId &&
          other.proveedorId == this.proveedorId &&
          other.proveedorNombre == this.proveedorNombre &&
          other.fecha == this.fecha &&
          other.numeroFactura == this.numeroFactura &&
          other.concepto == this.concepto &&
          other.baseImponible == this.baseImponible &&
          other.ivaPorcentaje == this.ivaPorcentaje &&
          other.importeTotal == this.importeTotal &&
          other.estado == this.estado &&
          other.observaciones == this.observaciones &&
          other.eliminado == this.eliminado &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaModificacion == this.fechaModificacion);
}

class ComprasCompanion extends UpdateCompanion<Compra> {
  final Value<String> id;
  final Value<String> expedienteId;
  final Value<String?> proveedorId;
  final Value<String> proveedorNombre;
  final Value<DateTime> fecha;
  final Value<String?> numeroFactura;
  final Value<String> concepto;
  final Value<double> baseImponible;
  final Value<double> ivaPorcentaje;
  final Value<double> importeTotal;
  final Value<String> estado;
  final Value<String?> observaciones;
  final Value<bool> eliminado;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaModificacion;
  final Value<int> rowid;
  const ComprasCompanion({
    this.id = const Value.absent(),
    this.expedienteId = const Value.absent(),
    this.proveedorId = const Value.absent(),
    this.proveedorNombre = const Value.absent(),
    this.fecha = const Value.absent(),
    this.numeroFactura = const Value.absent(),
    this.concepto = const Value.absent(),
    this.baseImponible = const Value.absent(),
    this.ivaPorcentaje = const Value.absent(),
    this.importeTotal = const Value.absent(),
    this.estado = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComprasCompanion.insert({
    required String id,
    required String expedienteId,
    this.proveedorId = const Value.absent(),
    this.proveedorNombre = const Value.absent(),
    this.fecha = const Value.absent(),
    this.numeroFactura = const Value.absent(),
    this.concepto = const Value.absent(),
    this.baseImponible = const Value.absent(),
    this.ivaPorcentaje = const Value.absent(),
    this.importeTotal = const Value.absent(),
    this.estado = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       expedienteId = Value(expedienteId);
  static Insertable<Compra> custom({
    Expression<String>? id,
    Expression<String>? expedienteId,
    Expression<String>? proveedorId,
    Expression<String>? proveedorNombre,
    Expression<DateTime>? fecha,
    Expression<String>? numeroFactura,
    Expression<String>? concepto,
    Expression<double>? baseImponible,
    Expression<double>? ivaPorcentaje,
    Expression<double>? importeTotal,
    Expression<String>? estado,
    Expression<String>? observaciones,
    Expression<bool>? eliminado,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaModificacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (expedienteId != null) 'expediente_id': expedienteId,
      if (proveedorId != null) 'proveedor_id': proveedorId,
      if (proveedorNombre != null) 'proveedor_nombre': proveedorNombre,
      if (fecha != null) 'fecha': fecha,
      if (numeroFactura != null) 'numero_factura': numeroFactura,
      if (concepto != null) 'concepto': concepto,
      if (baseImponible != null) 'base_imponible': baseImponible,
      if (ivaPorcentaje != null) 'iva_porcentaje': ivaPorcentaje,
      if (importeTotal != null) 'importe_total': importeTotal,
      if (estado != null) 'estado': estado,
      if (observaciones != null) 'observaciones': observaciones,
      if (eliminado != null) 'eliminado': eliminado,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaModificacion != null) 'fecha_modificacion': fechaModificacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComprasCompanion copyWith({
    Value<String>? id,
    Value<String>? expedienteId,
    Value<String?>? proveedorId,
    Value<String>? proveedorNombre,
    Value<DateTime>? fecha,
    Value<String?>? numeroFactura,
    Value<String>? concepto,
    Value<double>? baseImponible,
    Value<double>? ivaPorcentaje,
    Value<double>? importeTotal,
    Value<String>? estado,
    Value<String?>? observaciones,
    Value<bool>? eliminado,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaModificacion,
    Value<int>? rowid,
  }) {
    return ComprasCompanion(
      id: id ?? this.id,
      expedienteId: expedienteId ?? this.expedienteId,
      proveedorId: proveedorId ?? this.proveedorId,
      proveedorNombre: proveedorNombre ?? this.proveedorNombre,
      fecha: fecha ?? this.fecha,
      numeroFactura: numeroFactura ?? this.numeroFactura,
      concepto: concepto ?? this.concepto,
      baseImponible: baseImponible ?? this.baseImponible,
      ivaPorcentaje: ivaPorcentaje ?? this.ivaPorcentaje,
      importeTotal: importeTotal ?? this.importeTotal,
      estado: estado ?? this.estado,
      observaciones: observaciones ?? this.observaciones,
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
    if (proveedorId.present) {
      map['proveedor_id'] = Variable<String>(proveedorId.value);
    }
    if (proveedorNombre.present) {
      map['proveedor_nombre'] = Variable<String>(proveedorNombre.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (numeroFactura.present) {
      map['numero_factura'] = Variable<String>(numeroFactura.value);
    }
    if (concepto.present) {
      map['concepto'] = Variable<String>(concepto.value);
    }
    if (baseImponible.present) {
      map['base_imponible'] = Variable<double>(baseImponible.value);
    }
    if (ivaPorcentaje.present) {
      map['iva_porcentaje'] = Variable<double>(ivaPorcentaje.value);
    }
    if (importeTotal.present) {
      map['importe_total'] = Variable<double>(importeTotal.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
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
    return (StringBuffer('ComprasCompanion(')
          ..write('id: $id, ')
          ..write('expedienteId: $expedienteId, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('proveedorNombre: $proveedorNombre, ')
          ..write('fecha: $fecha, ')
          ..write('numeroFactura: $numeroFactura, ')
          ..write('concepto: $concepto, ')
          ..write('baseImponible: $baseImponible, ')
          ..write('ivaPorcentaje: $ivaPorcentaje, ')
          ..write('importeTotal: $importeTotal, ')
          ..write('estado: $estado, ')
          ..write('observaciones: $observaciones, ')
          ..write('eliminado: $eliminado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProveedoresTable extends Proveedores
    with TableInfo<$ProveedoresTable, Proveedore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProveedoresTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _personaContactoMeta = const VerificationMeta(
    'personaContacto',
  );
  @override
  late final GeneratedColumn<String> personaContacto = GeneratedColumn<String>(
    'persona_contacto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    personaContacto,
    nif,
    telefono,
    email,
    direccion,
    poblacion,
    provincia,
    codigoPostal,
    pais,
    observaciones,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proveedores';
  @override
  VerificationContext validateIntegrity(
    Insertable<Proveedore> instance, {
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
    if (data.containsKey('persona_contacto')) {
      context.handle(
        _personaContactoMeta,
        personaContacto.isAcceptableOrUnknown(
          data['persona_contacto']!,
          _personaContactoMeta,
        ),
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
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
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
  Proveedore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Proveedore(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      personaContacto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}persona_contacto'],
      ),
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
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
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
  $ProveedoresTable createAlias(String alias) {
    return $ProveedoresTable(attachedDatabase, alias);
  }
}

class Proveedore extends DataClass implements Insertable<Proveedore> {
  final String id;
  final String nombre;
  final String? personaContacto;
  final String nif;
  final String telefono;
  final String email;
  final String direccion;
  final String poblacion;
  final String provincia;
  final String codigoPostal;
  final String pais;
  final String observaciones;
  final bool eliminado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  const Proveedore({
    required this.id,
    required this.nombre,
    this.personaContacto,
    required this.nif,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.poblacion,
    required this.provincia,
    required this.codigoPostal,
    required this.pais,
    required this.observaciones,
    required this.eliminado,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || personaContacto != null) {
      map['persona_contacto'] = Variable<String>(personaContacto);
    }
    map['nif'] = Variable<String>(nif);
    map['telefono'] = Variable<String>(telefono);
    map['email'] = Variable<String>(email);
    map['direccion'] = Variable<String>(direccion);
    map['poblacion'] = Variable<String>(poblacion);
    map['provincia'] = Variable<String>(provincia);
    map['codigo_postal'] = Variable<String>(codigoPostal);
    map['pais'] = Variable<String>(pais);
    map['observaciones'] = Variable<String>(observaciones);
    map['eliminado'] = Variable<bool>(eliminado);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion);
    return map;
  }

  ProveedoresCompanion toCompanion(bool nullToAbsent) {
    return ProveedoresCompanion(
      id: Value(id),
      nombre: Value(nombre),
      personaContacto: personaContacto == null && nullToAbsent
          ? const Value.absent()
          : Value(personaContacto),
      nif: Value(nif),
      telefono: Value(telefono),
      email: Value(email),
      direccion: Value(direccion),
      poblacion: Value(poblacion),
      provincia: Value(provincia),
      codigoPostal: Value(codigoPostal),
      pais: Value(pais),
      observaciones: Value(observaciones),
      eliminado: Value(eliminado),
      fechaCreacion: Value(fechaCreacion),
      fechaModificacion: Value(fechaModificacion),
    );
  }

  factory Proveedore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Proveedore(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      personaContacto: serializer.fromJson<String?>(json['personaContacto']),
      nif: serializer.fromJson<String>(json['nif']),
      telefono: serializer.fromJson<String>(json['telefono']),
      email: serializer.fromJson<String>(json['email']),
      direccion: serializer.fromJson<String>(json['direccion']),
      poblacion: serializer.fromJson<String>(json['poblacion']),
      provincia: serializer.fromJson<String>(json['provincia']),
      codigoPostal: serializer.fromJson<String>(json['codigoPostal']),
      pais: serializer.fromJson<String>(json['pais']),
      observaciones: serializer.fromJson<String>(json['observaciones']),
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
      'personaContacto': serializer.toJson<String?>(personaContacto),
      'nif': serializer.toJson<String>(nif),
      'telefono': serializer.toJson<String>(telefono),
      'email': serializer.toJson<String>(email),
      'direccion': serializer.toJson<String>(direccion),
      'poblacion': serializer.toJson<String>(poblacion),
      'provincia': serializer.toJson<String>(provincia),
      'codigoPostal': serializer.toJson<String>(codigoPostal),
      'pais': serializer.toJson<String>(pais),
      'observaciones': serializer.toJson<String>(observaciones),
      'eliminado': serializer.toJson<bool>(eliminado),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaModificacion': serializer.toJson<DateTime>(fechaModificacion),
    };
  }

  Proveedore copyWith({
    String? id,
    String? nombre,
    Value<String?> personaContacto = const Value.absent(),
    String? nif,
    String? telefono,
    String? email,
    String? direccion,
    String? poblacion,
    String? provincia,
    String? codigoPostal,
    String? pais,
    String? observaciones,
    bool? eliminado,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
  }) => Proveedore(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    personaContacto: personaContacto.present
        ? personaContacto.value
        : this.personaContacto,
    nif: nif ?? this.nif,
    telefono: telefono ?? this.telefono,
    email: email ?? this.email,
    direccion: direccion ?? this.direccion,
    poblacion: poblacion ?? this.poblacion,
    provincia: provincia ?? this.provincia,
    codigoPostal: codigoPostal ?? this.codigoPostal,
    pais: pais ?? this.pais,
    observaciones: observaciones ?? this.observaciones,
    eliminado: eliminado ?? this.eliminado,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaModificacion: fechaModificacion ?? this.fechaModificacion,
  );
  Proveedore copyWithCompanion(ProveedoresCompanion data) {
    return Proveedore(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      personaContacto: data.personaContacto.present
          ? data.personaContacto.value
          : this.personaContacto,
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
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
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
    return (StringBuffer('Proveedore(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('personaContacto: $personaContacto, ')
          ..write('nif: $nif, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('poblacion: $poblacion, ')
          ..write('provincia: $provincia, ')
          ..write('codigoPostal: $codigoPostal, ')
          ..write('pais: $pais, ')
          ..write('observaciones: $observaciones, ')
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
    personaContacto,
    nif,
    telefono,
    email,
    direccion,
    poblacion,
    provincia,
    codigoPostal,
    pais,
    observaciones,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Proveedore &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.personaContacto == this.personaContacto &&
          other.nif == this.nif &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.direccion == this.direccion &&
          other.poblacion == this.poblacion &&
          other.provincia == this.provincia &&
          other.codigoPostal == this.codigoPostal &&
          other.pais == this.pais &&
          other.observaciones == this.observaciones &&
          other.eliminado == this.eliminado &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaModificacion == this.fechaModificacion);
}

class ProveedoresCompanion extends UpdateCompanion<Proveedore> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String?> personaContacto;
  final Value<String> nif;
  final Value<String> telefono;
  final Value<String> email;
  final Value<String> direccion;
  final Value<String> poblacion;
  final Value<String> provincia;
  final Value<String> codigoPostal;
  final Value<String> pais;
  final Value<String> observaciones;
  final Value<bool> eliminado;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaModificacion;
  final Value<int> rowid;
  const ProveedoresCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.personaContacto = const Value.absent(),
    this.nif = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.direccion = const Value.absent(),
    this.poblacion = const Value.absent(),
    this.provincia = const Value.absent(),
    this.codigoPostal = const Value.absent(),
    this.pais = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProveedoresCompanion.insert({
    required String id,
    required String nombre,
    this.personaContacto = const Value.absent(),
    this.nif = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.direccion = const Value.absent(),
    this.poblacion = const Value.absent(),
    this.provincia = const Value.absent(),
    this.codigoPostal = const Value.absent(),
    this.pais = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre);
  static Insertable<Proveedore> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? personaContacto,
    Expression<String>? nif,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? direccion,
    Expression<String>? poblacion,
    Expression<String>? provincia,
    Expression<String>? codigoPostal,
    Expression<String>? pais,
    Expression<String>? observaciones,
    Expression<bool>? eliminado,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaModificacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (personaContacto != null) 'persona_contacto': personaContacto,
      if (nif != null) 'nif': nif,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (direccion != null) 'direccion': direccion,
      if (poblacion != null) 'poblacion': poblacion,
      if (provincia != null) 'provincia': provincia,
      if (codigoPostal != null) 'codigo_postal': codigoPostal,
      if (pais != null) 'pais': pais,
      if (observaciones != null) 'observaciones': observaciones,
      if (eliminado != null) 'eliminado': eliminado,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaModificacion != null) 'fecha_modificacion': fechaModificacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProveedoresCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String?>? personaContacto,
    Value<String>? nif,
    Value<String>? telefono,
    Value<String>? email,
    Value<String>? direccion,
    Value<String>? poblacion,
    Value<String>? provincia,
    Value<String>? codigoPostal,
    Value<String>? pais,
    Value<String>? observaciones,
    Value<bool>? eliminado,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaModificacion,
    Value<int>? rowid,
  }) {
    return ProveedoresCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      personaContacto: personaContacto ?? this.personaContacto,
      nif: nif ?? this.nif,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      poblacion: poblacion ?? this.poblacion,
      provincia: provincia ?? this.provincia,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      pais: pais ?? this.pais,
      observaciones: observaciones ?? this.observaciones,
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
    if (personaContacto.present) {
      map['persona_contacto'] = Variable<String>(personaContacto.value);
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
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
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
    return (StringBuffer('ProveedoresCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('personaContacto: $personaContacto, ')
          ..write('nif: $nif, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('poblacion: $poblacion, ')
          ..write('provincia: $provincia, ')
          ..write('codigoPostal: $codigoPostal, ')
          ..write('pais: $pais, ')
          ..write('observaciones: $observaciones, ')
          ..write('eliminado: $eliminado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CertificacionesTable extends Certificaciones
    with TableInfo<$CertificacionesTable, Certificacione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CertificacionesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _presupuestoIdMeta = const VerificationMeta(
    'presupuestoId',
  );
  @override
  late final GeneratedColumn<String> presupuestoId = GeneratedColumn<String>(
    'presupuesto_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES presupuestos (id)',
    ),
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
  static const VerificationMeta _baseImponibleMeta = const VerificationMeta(
    'baseImponible',
  );
  @override
  late final GeneratedColumn<double> baseImponible = GeneratedColumn<double>(
    'base_imponible',
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
    defaultValue: const Constant(0),
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
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    presupuestoId,
    codigo,
    fecha,
    descripcion,
    baseImponible,
    ivaPorcentaje,
    importeTotal,
    estado,
    observaciones,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'certificaciones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Certificacione> instance, {
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
    if (data.containsKey('presupuesto_id')) {
      context.handle(
        _presupuestoIdMeta,
        presupuestoId.isAcceptableOrUnknown(
          data['presupuesto_id']!,
          _presupuestoIdMeta,
        ),
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
    if (data.containsKey('base_imponible')) {
      context.handle(
        _baseImponibleMeta,
        baseImponible.isAcceptableOrUnknown(
          data['base_imponible']!,
          _baseImponibleMeta,
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
    if (data.containsKey('importe_total')) {
      context.handle(
        _importeTotalMeta,
        importeTotal.isAcceptableOrUnknown(
          data['importe_total']!,
          _importeTotalMeta,
        ),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
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
  Certificacione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Certificacione(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      expedienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expediente_id'],
      )!,
      presupuestoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}presupuesto_id'],
      ),
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
      baseImponible: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}base_imponible'],
      )!,
      ivaPorcentaje: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}iva_porcentaje'],
      )!,
      importeTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}importe_total'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      ),
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
  $CertificacionesTable createAlias(String alias) {
    return $CertificacionesTable(attachedDatabase, alias);
  }
}

class Certificacione extends DataClass implements Insertable<Certificacione> {
  final String id;
  final String expedienteId;
  final String? presupuestoId;
  final String codigo;
  final DateTime fecha;
  final String descripcion;
  final double baseImponible;
  final double ivaPorcentaje;
  final double importeTotal;
  final String estado;
  final String? observaciones;
  final bool eliminado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  const Certificacione({
    required this.id,
    required this.expedienteId,
    this.presupuestoId,
    required this.codigo,
    required this.fecha,
    required this.descripcion,
    required this.baseImponible,
    required this.ivaPorcentaje,
    required this.importeTotal,
    required this.estado,
    this.observaciones,
    required this.eliminado,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['expediente_id'] = Variable<String>(expedienteId);
    if (!nullToAbsent || presupuestoId != null) {
      map['presupuesto_id'] = Variable<String>(presupuestoId);
    }
    map['codigo'] = Variable<String>(codigo);
    map['fecha'] = Variable<DateTime>(fecha);
    map['descripcion'] = Variable<String>(descripcion);
    map['base_imponible'] = Variable<double>(baseImponible);
    map['iva_porcentaje'] = Variable<double>(ivaPorcentaje);
    map['importe_total'] = Variable<double>(importeTotal);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    map['eliminado'] = Variable<bool>(eliminado);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion);
    return map;
  }

  CertificacionesCompanion toCompanion(bool nullToAbsent) {
    return CertificacionesCompanion(
      id: Value(id),
      expedienteId: Value(expedienteId),
      presupuestoId: presupuestoId == null && nullToAbsent
          ? const Value.absent()
          : Value(presupuestoId),
      codigo: Value(codigo),
      fecha: Value(fecha),
      descripcion: Value(descripcion),
      baseImponible: Value(baseImponible),
      ivaPorcentaje: Value(ivaPorcentaje),
      importeTotal: Value(importeTotal),
      estado: Value(estado),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
      eliminado: Value(eliminado),
      fechaCreacion: Value(fechaCreacion),
      fechaModificacion: Value(fechaModificacion),
    );
  }

  factory Certificacione.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Certificacione(
      id: serializer.fromJson<String>(json['id']),
      expedienteId: serializer.fromJson<String>(json['expedienteId']),
      presupuestoId: serializer.fromJson<String?>(json['presupuestoId']),
      codigo: serializer.fromJson<String>(json['codigo']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      baseImponible: serializer.fromJson<double>(json['baseImponible']),
      ivaPorcentaje: serializer.fromJson<double>(json['ivaPorcentaje']),
      importeTotal: serializer.fromJson<double>(json['importeTotal']),
      estado: serializer.fromJson<String>(json['estado']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
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
      'presupuestoId': serializer.toJson<String?>(presupuestoId),
      'codigo': serializer.toJson<String>(codigo),
      'fecha': serializer.toJson<DateTime>(fecha),
      'descripcion': serializer.toJson<String>(descripcion),
      'baseImponible': serializer.toJson<double>(baseImponible),
      'ivaPorcentaje': serializer.toJson<double>(ivaPorcentaje),
      'importeTotal': serializer.toJson<double>(importeTotal),
      'estado': serializer.toJson<String>(estado),
      'observaciones': serializer.toJson<String?>(observaciones),
      'eliminado': serializer.toJson<bool>(eliminado),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaModificacion': serializer.toJson<DateTime>(fechaModificacion),
    };
  }

  Certificacione copyWith({
    String? id,
    String? expedienteId,
    Value<String?> presupuestoId = const Value.absent(),
    String? codigo,
    DateTime? fecha,
    String? descripcion,
    double? baseImponible,
    double? ivaPorcentaje,
    double? importeTotal,
    String? estado,
    Value<String?> observaciones = const Value.absent(),
    bool? eliminado,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
  }) => Certificacione(
    id: id ?? this.id,
    expedienteId: expedienteId ?? this.expedienteId,
    presupuestoId: presupuestoId.present
        ? presupuestoId.value
        : this.presupuestoId,
    codigo: codigo ?? this.codigo,
    fecha: fecha ?? this.fecha,
    descripcion: descripcion ?? this.descripcion,
    baseImponible: baseImponible ?? this.baseImponible,
    ivaPorcentaje: ivaPorcentaje ?? this.ivaPorcentaje,
    importeTotal: importeTotal ?? this.importeTotal,
    estado: estado ?? this.estado,
    observaciones: observaciones.present
        ? observaciones.value
        : this.observaciones,
    eliminado: eliminado ?? this.eliminado,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaModificacion: fechaModificacion ?? this.fechaModificacion,
  );
  Certificacione copyWithCompanion(CertificacionesCompanion data) {
    return Certificacione(
      id: data.id.present ? data.id.value : this.id,
      expedienteId: data.expedienteId.present
          ? data.expedienteId.value
          : this.expedienteId,
      presupuestoId: data.presupuestoId.present
          ? data.presupuestoId.value
          : this.presupuestoId,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      baseImponible: data.baseImponible.present
          ? data.baseImponible.value
          : this.baseImponible,
      ivaPorcentaje: data.ivaPorcentaje.present
          ? data.ivaPorcentaje.value
          : this.ivaPorcentaje,
      importeTotal: data.importeTotal.present
          ? data.importeTotal.value
          : this.importeTotal,
      estado: data.estado.present ? data.estado.value : this.estado,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
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
    return (StringBuffer('Certificacione(')
          ..write('id: $id, ')
          ..write('expedienteId: $expedienteId, ')
          ..write('presupuestoId: $presupuestoId, ')
          ..write('codigo: $codigo, ')
          ..write('fecha: $fecha, ')
          ..write('descripcion: $descripcion, ')
          ..write('baseImponible: $baseImponible, ')
          ..write('ivaPorcentaje: $ivaPorcentaje, ')
          ..write('importeTotal: $importeTotal, ')
          ..write('estado: $estado, ')
          ..write('observaciones: $observaciones, ')
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
    presupuestoId,
    codigo,
    fecha,
    descripcion,
    baseImponible,
    ivaPorcentaje,
    importeTotal,
    estado,
    observaciones,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Certificacione &&
          other.id == this.id &&
          other.expedienteId == this.expedienteId &&
          other.presupuestoId == this.presupuestoId &&
          other.codigo == this.codigo &&
          other.fecha == this.fecha &&
          other.descripcion == this.descripcion &&
          other.baseImponible == this.baseImponible &&
          other.ivaPorcentaje == this.ivaPorcentaje &&
          other.importeTotal == this.importeTotal &&
          other.estado == this.estado &&
          other.observaciones == this.observaciones &&
          other.eliminado == this.eliminado &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaModificacion == this.fechaModificacion);
}

class CertificacionesCompanion extends UpdateCompanion<Certificacione> {
  final Value<String> id;
  final Value<String> expedienteId;
  final Value<String?> presupuestoId;
  final Value<String> codigo;
  final Value<DateTime> fecha;
  final Value<String> descripcion;
  final Value<double> baseImponible;
  final Value<double> ivaPorcentaje;
  final Value<double> importeTotal;
  final Value<String> estado;
  final Value<String?> observaciones;
  final Value<bool> eliminado;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaModificacion;
  final Value<int> rowid;
  const CertificacionesCompanion({
    this.id = const Value.absent(),
    this.expedienteId = const Value.absent(),
    this.presupuestoId = const Value.absent(),
    this.codigo = const Value.absent(),
    this.fecha = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.baseImponible = const Value.absent(),
    this.ivaPorcentaje = const Value.absent(),
    this.importeTotal = const Value.absent(),
    this.estado = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CertificacionesCompanion.insert({
    required String id,
    required String expedienteId,
    this.presupuestoId = const Value.absent(),
    this.codigo = const Value.absent(),
    this.fecha = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.baseImponible = const Value.absent(),
    this.ivaPorcentaje = const Value.absent(),
    this.importeTotal = const Value.absent(),
    this.estado = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       expedienteId = Value(expedienteId);
  static Insertable<Certificacione> custom({
    Expression<String>? id,
    Expression<String>? expedienteId,
    Expression<String>? presupuestoId,
    Expression<String>? codigo,
    Expression<DateTime>? fecha,
    Expression<String>? descripcion,
    Expression<double>? baseImponible,
    Expression<double>? ivaPorcentaje,
    Expression<double>? importeTotal,
    Expression<String>? estado,
    Expression<String>? observaciones,
    Expression<bool>? eliminado,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaModificacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (expedienteId != null) 'expediente_id': expedienteId,
      if (presupuestoId != null) 'presupuesto_id': presupuestoId,
      if (codigo != null) 'codigo': codigo,
      if (fecha != null) 'fecha': fecha,
      if (descripcion != null) 'descripcion': descripcion,
      if (baseImponible != null) 'base_imponible': baseImponible,
      if (ivaPorcentaje != null) 'iva_porcentaje': ivaPorcentaje,
      if (importeTotal != null) 'importe_total': importeTotal,
      if (estado != null) 'estado': estado,
      if (observaciones != null) 'observaciones': observaciones,
      if (eliminado != null) 'eliminado': eliminado,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaModificacion != null) 'fecha_modificacion': fechaModificacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CertificacionesCompanion copyWith({
    Value<String>? id,
    Value<String>? expedienteId,
    Value<String?>? presupuestoId,
    Value<String>? codigo,
    Value<DateTime>? fecha,
    Value<String>? descripcion,
    Value<double>? baseImponible,
    Value<double>? ivaPorcentaje,
    Value<double>? importeTotal,
    Value<String>? estado,
    Value<String?>? observaciones,
    Value<bool>? eliminado,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaModificacion,
    Value<int>? rowid,
  }) {
    return CertificacionesCompanion(
      id: id ?? this.id,
      expedienteId: expedienteId ?? this.expedienteId,
      presupuestoId: presupuestoId ?? this.presupuestoId,
      codigo: codigo ?? this.codigo,
      fecha: fecha ?? this.fecha,
      descripcion: descripcion ?? this.descripcion,
      baseImponible: baseImponible ?? this.baseImponible,
      ivaPorcentaje: ivaPorcentaje ?? this.ivaPorcentaje,
      importeTotal: importeTotal ?? this.importeTotal,
      estado: estado ?? this.estado,
      observaciones: observaciones ?? this.observaciones,
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
    if (presupuestoId.present) {
      map['presupuesto_id'] = Variable<String>(presupuestoId.value);
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
    if (baseImponible.present) {
      map['base_imponible'] = Variable<double>(baseImponible.value);
    }
    if (ivaPorcentaje.present) {
      map['iva_porcentaje'] = Variable<double>(ivaPorcentaje.value);
    }
    if (importeTotal.present) {
      map['importe_total'] = Variable<double>(importeTotal.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
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
    return (StringBuffer('CertificacionesCompanion(')
          ..write('id: $id, ')
          ..write('expedienteId: $expedienteId, ')
          ..write('presupuestoId: $presupuestoId, ')
          ..write('codigo: $codigo, ')
          ..write('fecha: $fecha, ')
          ..write('descripcion: $descripcion, ')
          ..write('baseImponible: $baseImponible, ')
          ..write('ivaPorcentaje: $ivaPorcentaje, ')
          ..write('importeTotal: $importeTotal, ')
          ..write('estado: $estado, ')
          ..write('observaciones: $observaciones, ')
          ..write('eliminado: $eliminado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentosTable extends Documentos
    with TableInfo<$DocumentosTable, Documento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentosTable(this.attachedDatabase, [this._alias]);
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreArchivoMeta = const VerificationMeta(
    'nombreArchivo',
  );
  @override
  late final GeneratedColumn<String> nombreArchivo = GeneratedColumn<String>(
    'nombre_archivo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutaArchivoMeta = const VerificationMeta(
    'rutaArchivo',
  );
  @override
  late final GeneratedColumn<String> rutaArchivo = GeneratedColumn<String>(
    'ruta_archivo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tamanoBytesMeta = const VerificationMeta(
    'tamanoBytes',
  );
  @override
  late final GeneratedColumn<int> tamanoBytes = GeneratedColumn<int>(
    'tamano_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('otro'),
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
    nombreArchivo,
    rutaArchivo,
    mimeType,
    tamanoBytes,
    fecha,
    observaciones,
    tipo,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documentos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Documento> instance, {
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
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('nombre_archivo')) {
      context.handle(
        _nombreArchivoMeta,
        nombreArchivo.isAcceptableOrUnknown(
          data['nombre_archivo']!,
          _nombreArchivoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreArchivoMeta);
    }
    if (data.containsKey('ruta_archivo')) {
      context.handle(
        _rutaArchivoMeta,
        rutaArchivo.isAcceptableOrUnknown(
          data['ruta_archivo']!,
          _rutaArchivoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rutaArchivoMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('tamano_bytes')) {
      context.handle(
        _tamanoBytesMeta,
        tamanoBytes.isAcceptableOrUnknown(
          data['tamano_bytes']!,
          _tamanoBytesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tamanoBytesMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
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
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
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
  Documento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Documento(
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
      nombreArchivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_archivo'],
      )!,
      rutaArchivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruta_archivo'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      tamanoBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tamano_bytes'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      ),
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
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
  $DocumentosTable createAlias(String alias) {
    return $DocumentosTable(attachedDatabase, alias);
  }
}

class Documento extends DataClass implements Insertable<Documento> {
  final String id;
  final String expedienteId;
  final String titulo;
  final String nombreArchivo;
  final String rutaArchivo;
  final String? mimeType;
  final int tamanoBytes;
  final DateTime fecha;
  final String? observaciones;
  final String tipo;
  final bool eliminado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  const Documento({
    required this.id,
    required this.expedienteId,
    required this.titulo,
    required this.nombreArchivo,
    required this.rutaArchivo,
    this.mimeType,
    required this.tamanoBytes,
    required this.fecha,
    this.observaciones,
    required this.tipo,
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
    map['nombre_archivo'] = Variable<String>(nombreArchivo);
    map['ruta_archivo'] = Variable<String>(rutaArchivo);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    map['tamano_bytes'] = Variable<int>(tamanoBytes);
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    map['tipo'] = Variable<String>(tipo);
    map['eliminado'] = Variable<bool>(eliminado);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion);
    return map;
  }

  DocumentosCompanion toCompanion(bool nullToAbsent) {
    return DocumentosCompanion(
      id: Value(id),
      expedienteId: Value(expedienteId),
      titulo: Value(titulo),
      nombreArchivo: Value(nombreArchivo),
      rutaArchivo: Value(rutaArchivo),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      tamanoBytes: Value(tamanoBytes),
      fecha: Value(fecha),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
      tipo: Value(tipo),
      eliminado: Value(eliminado),
      fechaCreacion: Value(fechaCreacion),
      fechaModificacion: Value(fechaModificacion),
    );
  }

  factory Documento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Documento(
      id: serializer.fromJson<String>(json['id']),
      expedienteId: serializer.fromJson<String>(json['expedienteId']),
      titulo: serializer.fromJson<String>(json['titulo']),
      nombreArchivo: serializer.fromJson<String>(json['nombreArchivo']),
      rutaArchivo: serializer.fromJson<String>(json['rutaArchivo']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      tamanoBytes: serializer.fromJson<int>(json['tamanoBytes']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
      tipo: serializer.fromJson<String>(json['tipo']),
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
      'nombreArchivo': serializer.toJson<String>(nombreArchivo),
      'rutaArchivo': serializer.toJson<String>(rutaArchivo),
      'mimeType': serializer.toJson<String?>(mimeType),
      'tamanoBytes': serializer.toJson<int>(tamanoBytes),
      'fecha': serializer.toJson<DateTime>(fecha),
      'observaciones': serializer.toJson<String?>(observaciones),
      'tipo': serializer.toJson<String>(tipo),
      'eliminado': serializer.toJson<bool>(eliminado),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaModificacion': serializer.toJson<DateTime>(fechaModificacion),
    };
  }

  Documento copyWith({
    String? id,
    String? expedienteId,
    String? titulo,
    String? nombreArchivo,
    String? rutaArchivo,
    Value<String?> mimeType = const Value.absent(),
    int? tamanoBytes,
    DateTime? fecha,
    Value<String?> observaciones = const Value.absent(),
    String? tipo,
    bool? eliminado,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
  }) => Documento(
    id: id ?? this.id,
    expedienteId: expedienteId ?? this.expedienteId,
    titulo: titulo ?? this.titulo,
    nombreArchivo: nombreArchivo ?? this.nombreArchivo,
    rutaArchivo: rutaArchivo ?? this.rutaArchivo,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    tamanoBytes: tamanoBytes ?? this.tamanoBytes,
    fecha: fecha ?? this.fecha,
    observaciones: observaciones.present
        ? observaciones.value
        : this.observaciones,
    tipo: tipo ?? this.tipo,
    eliminado: eliminado ?? this.eliminado,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaModificacion: fechaModificacion ?? this.fechaModificacion,
  );
  Documento copyWithCompanion(DocumentosCompanion data) {
    return Documento(
      id: data.id.present ? data.id.value : this.id,
      expedienteId: data.expedienteId.present
          ? data.expedienteId.value
          : this.expedienteId,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      nombreArchivo: data.nombreArchivo.present
          ? data.nombreArchivo.value
          : this.nombreArchivo,
      rutaArchivo: data.rutaArchivo.present
          ? data.rutaArchivo.value
          : this.rutaArchivo,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      tamanoBytes: data.tamanoBytes.present
          ? data.tamanoBytes.value
          : this.tamanoBytes,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
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
    return (StringBuffer('Documento(')
          ..write('id: $id, ')
          ..write('expedienteId: $expedienteId, ')
          ..write('titulo: $titulo, ')
          ..write('nombreArchivo: $nombreArchivo, ')
          ..write('rutaArchivo: $rutaArchivo, ')
          ..write('mimeType: $mimeType, ')
          ..write('tamanoBytes: $tamanoBytes, ')
          ..write('fecha: $fecha, ')
          ..write('observaciones: $observaciones, ')
          ..write('tipo: $tipo, ')
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
    nombreArchivo,
    rutaArchivo,
    mimeType,
    tamanoBytes,
    fecha,
    observaciones,
    tipo,
    eliminado,
    fechaCreacion,
    fechaModificacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Documento &&
          other.id == this.id &&
          other.expedienteId == this.expedienteId &&
          other.titulo == this.titulo &&
          other.nombreArchivo == this.nombreArchivo &&
          other.rutaArchivo == this.rutaArchivo &&
          other.mimeType == this.mimeType &&
          other.tamanoBytes == this.tamanoBytes &&
          other.fecha == this.fecha &&
          other.observaciones == this.observaciones &&
          other.tipo == this.tipo &&
          other.eliminado == this.eliminado &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaModificacion == this.fechaModificacion);
}

class DocumentosCompanion extends UpdateCompanion<Documento> {
  final Value<String> id;
  final Value<String> expedienteId;
  final Value<String> titulo;
  final Value<String> nombreArchivo;
  final Value<String> rutaArchivo;
  final Value<String?> mimeType;
  final Value<int> tamanoBytes;
  final Value<DateTime> fecha;
  final Value<String?> observaciones;
  final Value<String> tipo;
  final Value<bool> eliminado;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaModificacion;
  final Value<int> rowid;
  const DocumentosCompanion({
    this.id = const Value.absent(),
    this.expedienteId = const Value.absent(),
    this.titulo = const Value.absent(),
    this.nombreArchivo = const Value.absent(),
    this.rutaArchivo = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.tamanoBytes = const Value.absent(),
    this.fecha = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.tipo = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentosCompanion.insert({
    required String id,
    required String expedienteId,
    required String titulo,
    required String nombreArchivo,
    required String rutaArchivo,
    this.mimeType = const Value.absent(),
    required int tamanoBytes,
    this.fecha = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.tipo = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       expedienteId = Value(expedienteId),
       titulo = Value(titulo),
       nombreArchivo = Value(nombreArchivo),
       rutaArchivo = Value(rutaArchivo),
       tamanoBytes = Value(tamanoBytes);
  static Insertable<Documento> custom({
    Expression<String>? id,
    Expression<String>? expedienteId,
    Expression<String>? titulo,
    Expression<String>? nombreArchivo,
    Expression<String>? rutaArchivo,
    Expression<String>? mimeType,
    Expression<int>? tamanoBytes,
    Expression<DateTime>? fecha,
    Expression<String>? observaciones,
    Expression<String>? tipo,
    Expression<bool>? eliminado,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaModificacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (expedienteId != null) 'expediente_id': expedienteId,
      if (titulo != null) 'titulo': titulo,
      if (nombreArchivo != null) 'nombre_archivo': nombreArchivo,
      if (rutaArchivo != null) 'ruta_archivo': rutaArchivo,
      if (mimeType != null) 'mime_type': mimeType,
      if (tamanoBytes != null) 'tamano_bytes': tamanoBytes,
      if (fecha != null) 'fecha': fecha,
      if (observaciones != null) 'observaciones': observaciones,
      if (tipo != null) 'tipo': tipo,
      if (eliminado != null) 'eliminado': eliminado,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaModificacion != null) 'fecha_modificacion': fechaModificacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentosCompanion copyWith({
    Value<String>? id,
    Value<String>? expedienteId,
    Value<String>? titulo,
    Value<String>? nombreArchivo,
    Value<String>? rutaArchivo,
    Value<String?>? mimeType,
    Value<int>? tamanoBytes,
    Value<DateTime>? fecha,
    Value<String?>? observaciones,
    Value<String>? tipo,
    Value<bool>? eliminado,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaModificacion,
    Value<int>? rowid,
  }) {
    return DocumentosCompanion(
      id: id ?? this.id,
      expedienteId: expedienteId ?? this.expedienteId,
      titulo: titulo ?? this.titulo,
      nombreArchivo: nombreArchivo ?? this.nombreArchivo,
      rutaArchivo: rutaArchivo ?? this.rutaArchivo,
      mimeType: mimeType ?? this.mimeType,
      tamanoBytes: tamanoBytes ?? this.tamanoBytes,
      fecha: fecha ?? this.fecha,
      observaciones: observaciones ?? this.observaciones,
      tipo: tipo ?? this.tipo,
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
    if (nombreArchivo.present) {
      map['nombre_archivo'] = Variable<String>(nombreArchivo.value);
    }
    if (rutaArchivo.present) {
      map['ruta_archivo'] = Variable<String>(rutaArchivo.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (tamanoBytes.present) {
      map['tamano_bytes'] = Variable<int>(tamanoBytes.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
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
    return (StringBuffer('DocumentosCompanion(')
          ..write('id: $id, ')
          ..write('expedienteId: $expedienteId, ')
          ..write('titulo: $titulo, ')
          ..write('nombreArchivo: $nombreArchivo, ')
          ..write('rutaArchivo: $rutaArchivo, ')
          ..write('mimeType: $mimeType, ')
          ..write('tamanoBytes: $tamanoBytes, ')
          ..write('fecha: $fecha, ')
          ..write('observaciones: $observaciones, ')
          ..write('tipo: $tipo, ')
          ..write('eliminado: $eliminado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimelineEventsTable extends TimelineEvents
    with TableInfo<$TimelineEventsTable, TimelineEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimelineEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenciaIdMeta = const VerificationMeta(
    'referenciaId',
  );
  @override
  late final GeneratedColumn<String> referenciaId = GeneratedColumn<String>(
    'referencia_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    expedienteId,
    fecha,
    tipo,
    titulo,
    descripcion,
    referenciaId,
    fechaCreacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timeline_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimelineEvent> instance, {
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
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
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
    if (data.containsKey('referencia_id')) {
      context.handle(
        _referenciaIdMeta,
        referenciaId.isAcceptableOrUnknown(
          data['referencia_id']!,
          _referenciaIdMeta,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimelineEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimelineEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      expedienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expediente_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      referenciaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referencia_id'],
      ),
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
    );
  }

  @override
  $TimelineEventsTable createAlias(String alias) {
    return $TimelineEventsTable(attachedDatabase, alias);
  }
}

class TimelineEvent extends DataClass implements Insertable<TimelineEvent> {
  final String id;
  final String expedienteId;
  final DateTime fecha;
  final String tipo;
  final String titulo;
  final String? descripcion;
  final String? referenciaId;
  final DateTime fechaCreacion;
  const TimelineEvent({
    required this.id,
    required this.expedienteId,
    required this.fecha,
    required this.tipo,
    required this.titulo,
    this.descripcion,
    this.referenciaId,
    required this.fechaCreacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['expediente_id'] = Variable<String>(expedienteId);
    map['fecha'] = Variable<DateTime>(fecha);
    map['tipo'] = Variable<String>(tipo);
    map['titulo'] = Variable<String>(titulo);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || referenciaId != null) {
      map['referencia_id'] = Variable<String>(referenciaId);
    }
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    return map;
  }

  TimelineEventsCompanion toCompanion(bool nullToAbsent) {
    return TimelineEventsCompanion(
      id: Value(id),
      expedienteId: Value(expedienteId),
      fecha: Value(fecha),
      tipo: Value(tipo),
      titulo: Value(titulo),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      referenciaId: referenciaId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenciaId),
      fechaCreacion: Value(fechaCreacion),
    );
  }

  factory TimelineEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimelineEvent(
      id: serializer.fromJson<String>(json['id']),
      expedienteId: serializer.fromJson<String>(json['expedienteId']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      tipo: serializer.fromJson<String>(json['tipo']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      referenciaId: serializer.fromJson<String?>(json['referenciaId']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'expedienteId': serializer.toJson<String>(expedienteId),
      'fecha': serializer.toJson<DateTime>(fecha),
      'tipo': serializer.toJson<String>(tipo),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String?>(descripcion),
      'referenciaId': serializer.toJson<String?>(referenciaId),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
    };
  }

  TimelineEvent copyWith({
    String? id,
    String? expedienteId,
    DateTime? fecha,
    String? tipo,
    String? titulo,
    Value<String?> descripcion = const Value.absent(),
    Value<String?> referenciaId = const Value.absent(),
    DateTime? fechaCreacion,
  }) => TimelineEvent(
    id: id ?? this.id,
    expedienteId: expedienteId ?? this.expedienteId,
    fecha: fecha ?? this.fecha,
    tipo: tipo ?? this.tipo,
    titulo: titulo ?? this.titulo,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    referenciaId: referenciaId.present ? referenciaId.value : this.referenciaId,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
  );
  TimelineEvent copyWithCompanion(TimelineEventsCompanion data) {
    return TimelineEvent(
      id: data.id.present ? data.id.value : this.id,
      expedienteId: data.expedienteId.present
          ? data.expedienteId.value
          : this.expedienteId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      referenciaId: data.referenciaId.present
          ? data.referenciaId.value
          : this.referenciaId,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimelineEvent(')
          ..write('id: $id, ')
          ..write('expedienteId: $expedienteId, ')
          ..write('fecha: $fecha, ')
          ..write('tipo: $tipo, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    expedienteId,
    fecha,
    tipo,
    titulo,
    descripcion,
    referenciaId,
    fechaCreacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimelineEvent &&
          other.id == this.id &&
          other.expedienteId == this.expedienteId &&
          other.fecha == this.fecha &&
          other.tipo == this.tipo &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion &&
          other.referenciaId == this.referenciaId &&
          other.fechaCreacion == this.fechaCreacion);
}

class TimelineEventsCompanion extends UpdateCompanion<TimelineEvent> {
  final Value<String> id;
  final Value<String> expedienteId;
  final Value<DateTime> fecha;
  final Value<String> tipo;
  final Value<String> titulo;
  final Value<String?> descripcion;
  final Value<String?> referenciaId;
  final Value<DateTime> fechaCreacion;
  final Value<int> rowid;
  const TimelineEventsCompanion({
    this.id = const Value.absent(),
    this.expedienteId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.tipo = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimelineEventsCompanion.insert({
    required String id,
    required String expedienteId,
    this.fecha = const Value.absent(),
    required String tipo,
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       expedienteId = Value(expedienteId),
       tipo = Value(tipo);
  static Insertable<TimelineEvent> custom({
    Expression<String>? id,
    Expression<String>? expedienteId,
    Expression<DateTime>? fecha,
    Expression<String>? tipo,
    Expression<String>? titulo,
    Expression<String>? descripcion,
    Expression<String>? referenciaId,
    Expression<DateTime>? fechaCreacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (expedienteId != null) 'expediente_id': expedienteId,
      if (fecha != null) 'fecha': fecha,
      if (tipo != null) 'tipo': tipo,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (referenciaId != null) 'referencia_id': referenciaId,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimelineEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? expedienteId,
    Value<DateTime>? fecha,
    Value<String>? tipo,
    Value<String>? titulo,
    Value<String?>? descripcion,
    Value<String?>? referenciaId,
    Value<DateTime>? fechaCreacion,
    Value<int>? rowid,
  }) {
    return TimelineEventsCompanion(
      id: id ?? this.id,
      expedienteId: expedienteId ?? this.expedienteId,
      fecha: fecha ?? this.fecha,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      referenciaId: referenciaId ?? this.referenciaId,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
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
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (referenciaId.present) {
      map['referencia_id'] = Variable<String>(referenciaId.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimelineEventsCompanion(')
          ..write('id: $id, ')
          ..write('expedienteId: $expedienteId, ')
          ..write('fecha: $fecha, ')
          ..write('tipo: $tipo, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('fechaCreacion: $fechaCreacion, ')
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
  late final $ComprasTable compras = $ComprasTable(this);
  late final $ProveedoresTable proveedores = $ProveedoresTable(this);
  late final $CertificacionesTable certificaciones = $CertificacionesTable(
    this,
  );
  late final $DocumentosTable documentos = $DocumentosTable(this);
  late final $TimelineEventsTable timelineEvents = $TimelineEventsTable(this);
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
  late final ComprasDao comprasDao = ComprasDao(this as AppDatabase);
  late final ProveedoresDao proveedoresDao = ProveedoresDao(
    this as AppDatabase,
  );
  late final CertificacionesDao certificacionesDao = CertificacionesDao(
    this as AppDatabase,
  );
  late final DocumentosDao documentosDao = DocumentosDao(this as AppDatabase);
  late final TimelineEventsDao timelineEventsDao = TimelineEventsDao(
    this as AppDatabase,
  );
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
    compras,
    proveedores,
    certificaciones,
    documentos,
    timelineEvents,
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

  static MultiTypedResultKey<$ComprasTable, List<Compra>> _comprasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.compras,
    aliasName: 'expedientes__id__compras__expediente_id',
  );

  $$ComprasTableProcessedTableManager get comprasRefs {
    final manager = $$ComprasTableTableManager(
      $_db,
      $_db.compras,
    ).filter((f) => f.expedienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_comprasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CertificacionesTable, List<Certificacione>>
  _certificacionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.certificaciones,
    aliasName: 'expedientes__id__certificaciones__expediente_id',
  );

  $$CertificacionesTableProcessedTableManager get certificacionesRefs {
    final manager = $$CertificacionesTableTableManager(
      $_db,
      $_db.certificaciones,
    ).filter((f) => f.expedienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _certificacionesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DocumentosTable, List<Documento>>
  _documentosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.documentos,
    aliasName: 'expedientes__id__documentos__expediente_id',
  );

  $$DocumentosTableProcessedTableManager get documentosRefs {
    final manager = $$DocumentosTableTableManager(
      $_db,
      $_db.documentos,
    ).filter((f) => f.expedienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_documentosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimelineEventsTable, List<TimelineEvent>>
  _timelineEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timelineEvents,
    aliasName: 'expedientes__id__timeline_events__expediente_id',
  );

  $$TimelineEventsTableProcessedTableManager get timelineEventsRefs {
    final manager = $$TimelineEventsTableTableManager(
      $_db,
      $_db.timelineEvents,
    ).filter((f) => f.expedienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_timelineEventsRefsTable($_db));
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

  Expression<bool> comprasRefs(
    Expression<bool> Function($$ComprasTableFilterComposer f) f,
  ) {
    final $$ComprasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compras,
      getReferencedColumn: (t) => t.expedienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComprasTableFilterComposer(
            $db: $db,
            $table: $db.compras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> certificacionesRefs(
    Expression<bool> Function($$CertificacionesTableFilterComposer f) f,
  ) {
    final $$CertificacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.certificaciones,
      getReferencedColumn: (t) => t.expedienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CertificacionesTableFilterComposer(
            $db: $db,
            $table: $db.certificaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> documentosRefs(
    Expression<bool> Function($$DocumentosTableFilterComposer f) f,
  ) {
    final $$DocumentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentos,
      getReferencedColumn: (t) => t.expedienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentosTableFilterComposer(
            $db: $db,
            $table: $db.documentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timelineEventsRefs(
    Expression<bool> Function($$TimelineEventsTableFilterComposer f) f,
  ) {
    final $$TimelineEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timelineEvents,
      getReferencedColumn: (t) => t.expedienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimelineEventsTableFilterComposer(
            $db: $db,
            $table: $db.timelineEvents,
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

  Expression<T> comprasRefs<T extends Object>(
    Expression<T> Function($$ComprasTableAnnotationComposer a) f,
  ) {
    final $$ComprasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compras,
      getReferencedColumn: (t) => t.expedienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComprasTableAnnotationComposer(
            $db: $db,
            $table: $db.compras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> certificacionesRefs<T extends Object>(
    Expression<T> Function($$CertificacionesTableAnnotationComposer a) f,
  ) {
    final $$CertificacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.certificaciones,
      getReferencedColumn: (t) => t.expedienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CertificacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.certificaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> documentosRefs<T extends Object>(
    Expression<T> Function($$DocumentosTableAnnotationComposer a) f,
  ) {
    final $$DocumentosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentos,
      getReferencedColumn: (t) => t.expedienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentosTableAnnotationComposer(
            $db: $db,
            $table: $db.documentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timelineEventsRefs<T extends Object>(
    Expression<T> Function($$TimelineEventsTableAnnotationComposer a) f,
  ) {
    final $$TimelineEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timelineEvents,
      getReferencedColumn: (t) => t.expedienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimelineEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.timelineEvents,
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
          PrefetchHooks Function({
            bool clienteId,
            bool presupuestosRefs,
            bool comprasRefs,
            bool certificacionesRefs,
            bool documentosRefs,
            bool timelineEventsRefs,
          })
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
              ({
                clienteId = false,
                presupuestosRefs = false,
                comprasRefs = false,
                certificacionesRefs = false,
                documentosRefs = false,
                timelineEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (presupuestosRefs) db.presupuestos,
                    if (comprasRefs) db.compras,
                    if (certificacionesRefs) db.certificaciones,
                    if (documentosRefs) db.documentos,
                    if (timelineEventsRefs) db.timelineEvents,
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
                      if (comprasRefs)
                        await $_getPrefetchedData<
                          Expediente,
                          $ExpedientesTable,
                          Compra
                        >(
                          currentTable: table,
                          referencedTable: $$ExpedientesTableReferences
                              ._comprasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExpedientesTableReferences(
                                db,
                                table,
                                p0,
                              ).comprasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.expedienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (certificacionesRefs)
                        await $_getPrefetchedData<
                          Expediente,
                          $ExpedientesTable,
                          Certificacione
                        >(
                          currentTable: table,
                          referencedTable: $$ExpedientesTableReferences
                              ._certificacionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExpedientesTableReferences(
                                db,
                                table,
                                p0,
                              ).certificacionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.expedienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (documentosRefs)
                        await $_getPrefetchedData<
                          Expediente,
                          $ExpedientesTable,
                          Documento
                        >(
                          currentTable: table,
                          referencedTable: $$ExpedientesTableReferences
                              ._documentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExpedientesTableReferences(
                                db,
                                table,
                                p0,
                              ).documentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.expedienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (timelineEventsRefs)
                        await $_getPrefetchedData<
                          Expediente,
                          $ExpedientesTable,
                          TimelineEvent
                        >(
                          currentTable: table,
                          referencedTable: $$ExpedientesTableReferences
                              ._timelineEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExpedientesTableReferences(
                                db,
                                table,
                                p0,
                              ).timelineEventsRefs,
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
      PrefetchHooks Function({
        bool clienteId,
        bool presupuestosRefs,
        bool comprasRefs,
        bool certificacionesRefs,
        bool documentosRefs,
        bool timelineEventsRefs,
      })
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

  static MultiTypedResultKey<$CertificacionesTable, List<Certificacione>>
  _certificacionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.certificaciones,
    aliasName: 'presupuestos__id__certificaciones__presupuesto_id',
  );

  $$CertificacionesTableProcessedTableManager get certificacionesRefs {
    final manager = $$CertificacionesTableTableManager(
      $_db,
      $_db.certificaciones,
    ).filter((f) => f.presupuestoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _certificacionesRefsTable($_db),
    );
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

  Expression<bool> certificacionesRefs(
    Expression<bool> Function($$CertificacionesTableFilterComposer f) f,
  ) {
    final $$CertificacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.certificaciones,
      getReferencedColumn: (t) => t.presupuestoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CertificacionesTableFilterComposer(
            $db: $db,
            $table: $db.certificaciones,
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

  Expression<T> certificacionesRefs<T extends Object>(
    Expression<T> Function($$CertificacionesTableAnnotationComposer a) f,
  ) {
    final $$CertificacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.certificaciones,
      getReferencedColumn: (t) => t.presupuestoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CertificacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.certificaciones,
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
            bool certificacionesRefs,
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
                certificacionesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (lineasPresupuestoRefs) db.lineasPresupuesto,
                    if (facturasRefs) db.facturas,
                    if (certificacionesRefs) db.certificaciones,
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
                      if (certificacionesRefs)
                        await $_getPrefetchedData<
                          Presupuesto,
                          $PresupuestosTable,
                          Certificacione
                        >(
                          currentTable: table,
                          referencedTable: $$PresupuestosTableReferences
                              ._certificacionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PresupuestosTableReferences(
                                db,
                                table,
                                p0,
                              ).certificacionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.presupuestoId == item.id,
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
        bool certificacionesRefs,
      })
    >;
typedef $$LineasPresupuestoTableCreateCompanionBuilder =
    LineasPresupuestoCompanion Function({
      required String id,
      required String presupuestoId,
      required String concepto,
      required double cantidad,
      Value<String> unidad,
      required double precioUnitario,
      Value<int> rowid,
    });
typedef $$LineasPresupuestoTableUpdateCompanionBuilder =
    LineasPresupuestoCompanion Function({
      Value<String> id,
      Value<String> presupuestoId,
      Value<String> concepto,
      Value<double> cantidad,
      Value<String> unidad,
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

  ColumnFilters<String> get unidad => $composableBuilder(
    column: $table.unidad,
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

  ColumnOrderings<String> get unidad => $composableBuilder(
    column: $table.unidad,
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

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

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
                Value<String> unidad = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LineasPresupuestoCompanion(
                id: id,
                presupuestoId: presupuestoId,
                concepto: concepto,
                cantidad: cantidad,
                unidad: unidad,
                precioUnitario: precioUnitario,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String presupuestoId,
                required String concepto,
                required double cantidad,
                Value<String> unidad = const Value.absent(),
                required double precioUnitario,
                Value<int> rowid = const Value.absent(),
              }) => LineasPresupuestoCompanion.insert(
                id: id,
                presupuestoId: presupuestoId,
                concepto: concepto,
                cantidad: cantidad,
                unidad: unidad,
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
      Value<int?> anioNumeracion,
      Value<int?> numeroLegal,
      required String clienteId,
      Value<DateTime> fecha,
      Value<DateTime> fechaVencimiento,
      Value<String> estado,
      Value<double> subtotal,
      Value<double> iva,
      Value<double> ivaPorcentaje,
      Value<double> total,
      Value<String> observaciones,
      Value<String?> presupuestoOrigenId,
      Value<DateTime?> fechaEmision,
      Value<String> clienteNombreHistorico,
      Value<String> clienteNifHistorico,
      Value<String> clienteDireccionHistorica,
      Value<String> clienteTelefonoHistorico,
      Value<String> clienteEmailHistorico,
      Value<String> empresaNombreHistorico,
      Value<String> empresaCifHistorico,
      Value<String> empresaDireccionHistorica,
      Value<String> empresaCodigoPostalHistorico,
      Value<String> empresaPoblacionHistorica,
      Value<String> empresaProvinciaHistorica,
      Value<String> empresaTelefonoHistorico,
      Value<String> empresaEmailHistorico,
      Value<String> empresaWebHistorica,
      Value<String> expedienteOrigenIdHistorico,
      Value<String> expedienteCodigoHistorico,
      Value<String> expedienteNombreHistorico,
      Value<String> presupuestoCodigoHistorico,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });
typedef $$FacturasTableUpdateCompanionBuilder =
    FacturasCompanion Function({
      Value<String> id,
      Value<String> codigo,
      Value<int?> anioNumeracion,
      Value<int?> numeroLegal,
      Value<String> clienteId,
      Value<DateTime> fecha,
      Value<DateTime> fechaVencimiento,
      Value<String> estado,
      Value<double> subtotal,
      Value<double> iva,
      Value<double> ivaPorcentaje,
      Value<double> total,
      Value<String> observaciones,
      Value<String?> presupuestoOrigenId,
      Value<DateTime?> fechaEmision,
      Value<String> clienteNombreHistorico,
      Value<String> clienteNifHistorico,
      Value<String> clienteDireccionHistorica,
      Value<String> clienteTelefonoHistorico,
      Value<String> clienteEmailHistorico,
      Value<String> empresaNombreHistorico,
      Value<String> empresaCifHistorico,
      Value<String> empresaDireccionHistorica,
      Value<String> empresaCodigoPostalHistorico,
      Value<String> empresaPoblacionHistorica,
      Value<String> empresaProvinciaHistorica,
      Value<String> empresaTelefonoHistorico,
      Value<String> empresaEmailHistorico,
      Value<String> empresaWebHistorica,
      Value<String> expedienteOrigenIdHistorico,
      Value<String> expedienteCodigoHistorico,
      Value<String> expedienteNombreHistorico,
      Value<String> presupuestoCodigoHistorico,
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

  ColumnFilters<int> get anioNumeracion => $composableBuilder(
    column: $table.anioNumeracion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numeroLegal => $composableBuilder(
    column: $table.numeroLegal,
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

  ColumnFilters<double> get ivaPorcentaje => $composableBuilder(
    column: $table.ivaPorcentaje,
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

  ColumnFilters<DateTime> get fechaEmision => $composableBuilder(
    column: $table.fechaEmision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clienteNombreHistorico => $composableBuilder(
    column: $table.clienteNombreHistorico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clienteNifHistorico => $composableBuilder(
    column: $table.clienteNifHistorico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clienteDireccionHistorica => $composableBuilder(
    column: $table.clienteDireccionHistorica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clienteTelefonoHistorico => $composableBuilder(
    column: $table.clienteTelefonoHistorico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clienteEmailHistorico => $composableBuilder(
    column: $table.clienteEmailHistorico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresaNombreHistorico => $composableBuilder(
    column: $table.empresaNombreHistorico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresaCifHistorico => $composableBuilder(
    column: $table.empresaCifHistorico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresaDireccionHistorica => $composableBuilder(
    column: $table.empresaDireccionHistorica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresaCodigoPostalHistorico => $composableBuilder(
    column: $table.empresaCodigoPostalHistorico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresaPoblacionHistorica => $composableBuilder(
    column: $table.empresaPoblacionHistorica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresaProvinciaHistorica => $composableBuilder(
    column: $table.empresaProvinciaHistorica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresaTelefonoHistorico => $composableBuilder(
    column: $table.empresaTelefonoHistorico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresaEmailHistorico => $composableBuilder(
    column: $table.empresaEmailHistorico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresaWebHistorica => $composableBuilder(
    column: $table.empresaWebHistorica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expedienteOrigenIdHistorico => $composableBuilder(
    column: $table.expedienteOrigenIdHistorico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expedienteCodigoHistorico => $composableBuilder(
    column: $table.expedienteCodigoHistorico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expedienteNombreHistorico => $composableBuilder(
    column: $table.expedienteNombreHistorico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get presupuestoCodigoHistorico => $composableBuilder(
    column: $table.presupuestoCodigoHistorico,
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

  ColumnOrderings<int> get anioNumeracion => $composableBuilder(
    column: $table.anioNumeracion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numeroLegal => $composableBuilder(
    column: $table.numeroLegal,
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

  ColumnOrderings<double> get ivaPorcentaje => $composableBuilder(
    column: $table.ivaPorcentaje,
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

  ColumnOrderings<DateTime> get fechaEmision => $composableBuilder(
    column: $table.fechaEmision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clienteNombreHistorico => $composableBuilder(
    column: $table.clienteNombreHistorico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clienteNifHistorico => $composableBuilder(
    column: $table.clienteNifHistorico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clienteDireccionHistorica => $composableBuilder(
    column: $table.clienteDireccionHistorica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clienteTelefonoHistorico => $composableBuilder(
    column: $table.clienteTelefonoHistorico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clienteEmailHistorico => $composableBuilder(
    column: $table.clienteEmailHistorico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresaNombreHistorico => $composableBuilder(
    column: $table.empresaNombreHistorico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresaCifHistorico => $composableBuilder(
    column: $table.empresaCifHistorico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresaDireccionHistorica => $composableBuilder(
    column: $table.empresaDireccionHistorica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresaCodigoPostalHistorico =>
      $composableBuilder(
        column: $table.empresaCodigoPostalHistorico,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get empresaPoblacionHistorica => $composableBuilder(
    column: $table.empresaPoblacionHistorica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresaProvinciaHistorica => $composableBuilder(
    column: $table.empresaProvinciaHistorica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresaTelefonoHistorico => $composableBuilder(
    column: $table.empresaTelefonoHistorico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresaEmailHistorico => $composableBuilder(
    column: $table.empresaEmailHistorico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresaWebHistorica => $composableBuilder(
    column: $table.empresaWebHistorica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expedienteOrigenIdHistorico => $composableBuilder(
    column: $table.expedienteOrigenIdHistorico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expedienteCodigoHistorico => $composableBuilder(
    column: $table.expedienteCodigoHistorico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expedienteNombreHistorico => $composableBuilder(
    column: $table.expedienteNombreHistorico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get presupuestoCodigoHistorico => $composableBuilder(
    column: $table.presupuestoCodigoHistorico,
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

  GeneratedColumn<int> get anioNumeracion => $composableBuilder(
    column: $table.anioNumeracion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numeroLegal => $composableBuilder(
    column: $table.numeroLegal,
    builder: (column) => column,
  );

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

  GeneratedColumn<double> get ivaPorcentaje => $composableBuilder(
    column: $table.ivaPorcentaje,
    builder: (column) => column,
  );

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaEmision => $composableBuilder(
    column: $table.fechaEmision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clienteNombreHistorico => $composableBuilder(
    column: $table.clienteNombreHistorico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clienteNifHistorico => $composableBuilder(
    column: $table.clienteNifHistorico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clienteDireccionHistorica => $composableBuilder(
    column: $table.clienteDireccionHistorica,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clienteTelefonoHistorico => $composableBuilder(
    column: $table.clienteTelefonoHistorico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clienteEmailHistorico => $composableBuilder(
    column: $table.clienteEmailHistorico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get empresaNombreHistorico => $composableBuilder(
    column: $table.empresaNombreHistorico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get empresaCifHistorico => $composableBuilder(
    column: $table.empresaCifHistorico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get empresaDireccionHistorica => $composableBuilder(
    column: $table.empresaDireccionHistorica,
    builder: (column) => column,
  );

  GeneratedColumn<String> get empresaCodigoPostalHistorico =>
      $composableBuilder(
        column: $table.empresaCodigoPostalHistorico,
        builder: (column) => column,
      );

  GeneratedColumn<String> get empresaPoblacionHistorica => $composableBuilder(
    column: $table.empresaPoblacionHistorica,
    builder: (column) => column,
  );

  GeneratedColumn<String> get empresaProvinciaHistorica => $composableBuilder(
    column: $table.empresaProvinciaHistorica,
    builder: (column) => column,
  );

  GeneratedColumn<String> get empresaTelefonoHistorico => $composableBuilder(
    column: $table.empresaTelefonoHistorico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get empresaEmailHistorico => $composableBuilder(
    column: $table.empresaEmailHistorico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get empresaWebHistorica => $composableBuilder(
    column: $table.empresaWebHistorica,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expedienteOrigenIdHistorico => $composableBuilder(
    column: $table.expedienteOrigenIdHistorico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expedienteCodigoHistorico => $composableBuilder(
    column: $table.expedienteCodigoHistorico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expedienteNombreHistorico => $composableBuilder(
    column: $table.expedienteNombreHistorico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get presupuestoCodigoHistorico => $composableBuilder(
    column: $table.presupuestoCodigoHistorico,
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
                Value<int?> anioNumeracion = const Value.absent(),
                Value<int?> numeroLegal = const Value.absent(),
                Value<String> clienteId = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<DateTime> fechaVencimiento = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> iva = const Value.absent(),
                Value<double> ivaPorcentaje = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<String?> presupuestoOrigenId = const Value.absent(),
                Value<DateTime?> fechaEmision = const Value.absent(),
                Value<String> clienteNombreHistorico = const Value.absent(),
                Value<String> clienteNifHistorico = const Value.absent(),
                Value<String> clienteDireccionHistorica = const Value.absent(),
                Value<String> clienteTelefonoHistorico = const Value.absent(),
                Value<String> clienteEmailHistorico = const Value.absent(),
                Value<String> empresaNombreHistorico = const Value.absent(),
                Value<String> empresaCifHistorico = const Value.absent(),
                Value<String> empresaDireccionHistorica = const Value.absent(),
                Value<String> empresaCodigoPostalHistorico =
                    const Value.absent(),
                Value<String> empresaPoblacionHistorica = const Value.absent(),
                Value<String> empresaProvinciaHistorica = const Value.absent(),
                Value<String> empresaTelefonoHistorico = const Value.absent(),
                Value<String> empresaEmailHistorico = const Value.absent(),
                Value<String> empresaWebHistorica = const Value.absent(),
                Value<String> expedienteOrigenIdHistorico =
                    const Value.absent(),
                Value<String> expedienteCodigoHistorico = const Value.absent(),
                Value<String> expedienteNombreHistorico = const Value.absent(),
                Value<String> presupuestoCodigoHistorico = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FacturasCompanion(
                id: id,
                codigo: codigo,
                anioNumeracion: anioNumeracion,
                numeroLegal: numeroLegal,
                clienteId: clienteId,
                fecha: fecha,
                fechaVencimiento: fechaVencimiento,
                estado: estado,
                subtotal: subtotal,
                iva: iva,
                ivaPorcentaje: ivaPorcentaje,
                total: total,
                observaciones: observaciones,
                presupuestoOrigenId: presupuestoOrigenId,
                fechaEmision: fechaEmision,
                clienteNombreHistorico: clienteNombreHistorico,
                clienteNifHistorico: clienteNifHistorico,
                clienteDireccionHistorica: clienteDireccionHistorica,
                clienteTelefonoHistorico: clienteTelefonoHistorico,
                clienteEmailHistorico: clienteEmailHistorico,
                empresaNombreHistorico: empresaNombreHistorico,
                empresaCifHistorico: empresaCifHistorico,
                empresaDireccionHistorica: empresaDireccionHistorica,
                empresaCodigoPostalHistorico: empresaCodigoPostalHistorico,
                empresaPoblacionHistorica: empresaPoblacionHistorica,
                empresaProvinciaHistorica: empresaProvinciaHistorica,
                empresaTelefonoHistorico: empresaTelefonoHistorico,
                empresaEmailHistorico: empresaEmailHistorico,
                empresaWebHistorica: empresaWebHistorica,
                expedienteOrigenIdHistorico: expedienteOrigenIdHistorico,
                expedienteCodigoHistorico: expedienteCodigoHistorico,
                expedienteNombreHistorico: expedienteNombreHistorico,
                presupuestoCodigoHistorico: presupuestoCodigoHistorico,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> codigo = const Value.absent(),
                Value<int?> anioNumeracion = const Value.absent(),
                Value<int?> numeroLegal = const Value.absent(),
                required String clienteId,
                Value<DateTime> fecha = const Value.absent(),
                Value<DateTime> fechaVencimiento = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> iva = const Value.absent(),
                Value<double> ivaPorcentaje = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<String?> presupuestoOrigenId = const Value.absent(),
                Value<DateTime?> fechaEmision = const Value.absent(),
                Value<String> clienteNombreHistorico = const Value.absent(),
                Value<String> clienteNifHistorico = const Value.absent(),
                Value<String> clienteDireccionHistorica = const Value.absent(),
                Value<String> clienteTelefonoHistorico = const Value.absent(),
                Value<String> clienteEmailHistorico = const Value.absent(),
                Value<String> empresaNombreHistorico = const Value.absent(),
                Value<String> empresaCifHistorico = const Value.absent(),
                Value<String> empresaDireccionHistorica = const Value.absent(),
                Value<String> empresaCodigoPostalHistorico =
                    const Value.absent(),
                Value<String> empresaPoblacionHistorica = const Value.absent(),
                Value<String> empresaProvinciaHistorica = const Value.absent(),
                Value<String> empresaTelefonoHistorico = const Value.absent(),
                Value<String> empresaEmailHistorico = const Value.absent(),
                Value<String> empresaWebHistorica = const Value.absent(),
                Value<String> expedienteOrigenIdHistorico =
                    const Value.absent(),
                Value<String> expedienteCodigoHistorico = const Value.absent(),
                Value<String> expedienteNombreHistorico = const Value.absent(),
                Value<String> presupuestoCodigoHistorico = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FacturasCompanion.insert(
                id: id,
                codigo: codigo,
                anioNumeracion: anioNumeracion,
                numeroLegal: numeroLegal,
                clienteId: clienteId,
                fecha: fecha,
                fechaVencimiento: fechaVencimiento,
                estado: estado,
                subtotal: subtotal,
                iva: iva,
                ivaPorcentaje: ivaPorcentaje,
                total: total,
                observaciones: observaciones,
                presupuestoOrigenId: presupuestoOrigenId,
                fechaEmision: fechaEmision,
                clienteNombreHistorico: clienteNombreHistorico,
                clienteNifHistorico: clienteNifHistorico,
                clienteDireccionHistorica: clienteDireccionHistorica,
                clienteTelefonoHistorico: clienteTelefonoHistorico,
                clienteEmailHistorico: clienteEmailHistorico,
                empresaNombreHistorico: empresaNombreHistorico,
                empresaCifHistorico: empresaCifHistorico,
                empresaDireccionHistorica: empresaDireccionHistorica,
                empresaCodigoPostalHistorico: empresaCodigoPostalHistorico,
                empresaPoblacionHistorica: empresaPoblacionHistorica,
                empresaProvinciaHistorica: empresaProvinciaHistorica,
                empresaTelefonoHistorico: empresaTelefonoHistorico,
                empresaEmailHistorico: empresaEmailHistorico,
                empresaWebHistorica: empresaWebHistorica,
                expedienteOrigenIdHistorico: expedienteOrigenIdHistorico,
                expedienteCodigoHistorico: expedienteCodigoHistorico,
                expedienteNombreHistorico: expedienteNombreHistorico,
                presupuestoCodigoHistorico: presupuestoCodigoHistorico,
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
      Value<String> tipoMovimiento,
      Value<String?> cobroOrigenId,
      Value<String> motivo,
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
      Value<String> tipoMovimiento,
      Value<String?> cobroOrigenId,
      Value<String> motivo,
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

  static $CobrosTable _cobroOrigenIdTable(_$AppDatabase db) =>
      db.cobros.createAlias('cobros__cobro_origen_id__cobros__id');

  $$CobrosTableProcessedTableManager? get cobroOrigenId {
    final $_column = $_itemColumn<String>('cobro_origen_id');
    if ($_column == null) return null;
    final manager = $$CobrosTableTableManager(
      $_db,
      $_db.cobros,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cobroOrigenIdTable($_db));
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

  ColumnFilters<String> get tipoMovimiento => $composableBuilder(
    column: $table.tipoMovimiento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivo => $composableBuilder(
    column: $table.motivo,
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

  $$CobrosTableFilterComposer get cobroOrigenId {
    final $$CobrosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cobroOrigenId,
      referencedTable: $db.cobros,
      getReferencedColumn: (t) => t.id,
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

  ColumnOrderings<String> get tipoMovimiento => $composableBuilder(
    column: $table.tipoMovimiento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivo => $composableBuilder(
    column: $table.motivo,
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

  $$CobrosTableOrderingComposer get cobroOrigenId {
    final $$CobrosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cobroOrigenId,
      referencedTable: $db.cobros,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CobrosTableOrderingComposer(
            $db: $db,
            $table: $db.cobros,
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

  GeneratedColumn<String> get tipoMovimiento => $composableBuilder(
    column: $table.tipoMovimiento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get motivo =>
      $composableBuilder(column: $table.motivo, builder: (column) => column);

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

  $$CobrosTableAnnotationComposer get cobroOrigenId {
    final $$CobrosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cobroOrigenId,
      referencedTable: $db.cobros,
      getReferencedColumn: (t) => t.id,
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
          PrefetchHooks Function({bool facturaId, bool cobroOrigenId})
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
                Value<String> tipoMovimiento = const Value.absent(),
                Value<String?> cobroOrigenId = const Value.absent(),
                Value<String> motivo = const Value.absent(),
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
                tipoMovimiento: tipoMovimiento,
                cobroOrigenId: cobroOrigenId,
                motivo: motivo,
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
                Value<String> tipoMovimiento = const Value.absent(),
                Value<String?> cobroOrigenId = const Value.absent(),
                Value<String> motivo = const Value.absent(),
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
                tipoMovimiento: tipoMovimiento,
                cobroOrigenId: cobroOrigenId,
                motivo: motivo,
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
          prefetchHooksCallback: ({facturaId = false, cobroOrigenId = false}) {
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
                    if (cobroOrigenId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cobroOrigenId,
                                referencedTable: $$CobrosTableReferences
                                    ._cobroOrigenIdTable(db),
                                referencedColumn: $$CobrosTableReferences
                                    ._cobroOrigenIdTable(db)
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
      PrefetchHooks Function({bool facturaId, bool cobroOrigenId})
    >;
typedef $$ComprasTableCreateCompanionBuilder =
    ComprasCompanion Function({
      required String id,
      required String expedienteId,
      Value<String?> proveedorId,
      Value<String> proveedorNombre,
      Value<DateTime> fecha,
      Value<String?> numeroFactura,
      Value<String> concepto,
      Value<double> baseImponible,
      Value<double> ivaPorcentaje,
      Value<double> importeTotal,
      Value<String> estado,
      Value<String?> observaciones,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });
typedef $$ComprasTableUpdateCompanionBuilder =
    ComprasCompanion Function({
      Value<String> id,
      Value<String> expedienteId,
      Value<String?> proveedorId,
      Value<String> proveedorNombre,
      Value<DateTime> fecha,
      Value<String?> numeroFactura,
      Value<String> concepto,
      Value<double> baseImponible,
      Value<double> ivaPorcentaje,
      Value<double> importeTotal,
      Value<String> estado,
      Value<String?> observaciones,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });

final class $$ComprasTableReferences
    extends BaseReferences<_$AppDatabase, $ComprasTable, Compra> {
  $$ComprasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExpedientesTable _expedienteIdTable(_$AppDatabase db) =>
      db.expedientes.createAlias('compras__expediente_id__expedientes__id');

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
}

class $$ComprasTableFilterComposer
    extends Composer<_$AppDatabase, $ComprasTable> {
  $$ComprasTableFilterComposer({
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

  ColumnFilters<String> get proveedorId => $composableBuilder(
    column: $table.proveedorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proveedorNombre => $composableBuilder(
    column: $table.proveedorNombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroFactura => $composableBuilder(
    column: $table.numeroFactura,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get baseImponible => $composableBuilder(
    column: $table.baseImponible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ivaPorcentaje => $composableBuilder(
    column: $table.ivaPorcentaje,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get importeTotal => $composableBuilder(
    column: $table.importeTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
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
}

class $$ComprasTableOrderingComposer
    extends Composer<_$AppDatabase, $ComprasTable> {
  $$ComprasTableOrderingComposer({
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

  ColumnOrderings<String> get proveedorId => $composableBuilder(
    column: $table.proveedorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proveedorNombre => $composableBuilder(
    column: $table.proveedorNombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroFactura => $composableBuilder(
    column: $table.numeroFactura,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get baseImponible => $composableBuilder(
    column: $table.baseImponible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ivaPorcentaje => $composableBuilder(
    column: $table.ivaPorcentaje,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get importeTotal => $composableBuilder(
    column: $table.importeTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
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

class $$ComprasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComprasTable> {
  $$ComprasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get proveedorId => $composableBuilder(
    column: $table.proveedorId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get proveedorNombre => $composableBuilder(
    column: $table.proveedorNombre,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get numeroFactura => $composableBuilder(
    column: $table.numeroFactura,
    builder: (column) => column,
  );

  GeneratedColumn<String> get concepto =>
      $composableBuilder(column: $table.concepto, builder: (column) => column);

  GeneratedColumn<double> get baseImponible => $composableBuilder(
    column: $table.baseImponible,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ivaPorcentaje => $composableBuilder(
    column: $table.ivaPorcentaje,
    builder: (column) => column,
  );

  GeneratedColumn<double> get importeTotal => $composableBuilder(
    column: $table.importeTotal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

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
}

class $$ComprasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComprasTable,
          Compra,
          $$ComprasTableFilterComposer,
          $$ComprasTableOrderingComposer,
          $$ComprasTableAnnotationComposer,
          $$ComprasTableCreateCompanionBuilder,
          $$ComprasTableUpdateCompanionBuilder,
          (Compra, $$ComprasTableReferences),
          Compra,
          PrefetchHooks Function({bool expedienteId})
        > {
  $$ComprasTableTableManager(_$AppDatabase db, $ComprasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComprasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComprasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComprasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> expedienteId = const Value.absent(),
                Value<String?> proveedorId = const Value.absent(),
                Value<String> proveedorNombre = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> numeroFactura = const Value.absent(),
                Value<String> concepto = const Value.absent(),
                Value<double> baseImponible = const Value.absent(),
                Value<double> ivaPorcentaje = const Value.absent(),
                Value<double> importeTotal = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComprasCompanion(
                id: id,
                expedienteId: expedienteId,
                proveedorId: proveedorId,
                proveedorNombre: proveedorNombre,
                fecha: fecha,
                numeroFactura: numeroFactura,
                concepto: concepto,
                baseImponible: baseImponible,
                ivaPorcentaje: ivaPorcentaje,
                importeTotal: importeTotal,
                estado: estado,
                observaciones: observaciones,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String expedienteId,
                Value<String?> proveedorId = const Value.absent(),
                Value<String> proveedorNombre = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> numeroFactura = const Value.absent(),
                Value<String> concepto = const Value.absent(),
                Value<double> baseImponible = const Value.absent(),
                Value<double> ivaPorcentaje = const Value.absent(),
                Value<double> importeTotal = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComprasCompanion.insert(
                id: id,
                expedienteId: expedienteId,
                proveedorId: proveedorId,
                proveedorNombre: proveedorNombre,
                fecha: fecha,
                numeroFactura: numeroFactura,
                concepto: concepto,
                baseImponible: baseImponible,
                ivaPorcentaje: ivaPorcentaje,
                importeTotal: importeTotal,
                estado: estado,
                observaciones: observaciones,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ComprasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expedienteId = false}) {
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
                    if (expedienteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.expedienteId,
                                referencedTable: $$ComprasTableReferences
                                    ._expedienteIdTable(db),
                                referencedColumn: $$ComprasTableReferences
                                    ._expedienteIdTable(db)
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

typedef $$ComprasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComprasTable,
      Compra,
      $$ComprasTableFilterComposer,
      $$ComprasTableOrderingComposer,
      $$ComprasTableAnnotationComposer,
      $$ComprasTableCreateCompanionBuilder,
      $$ComprasTableUpdateCompanionBuilder,
      (Compra, $$ComprasTableReferences),
      Compra,
      PrefetchHooks Function({bool expedienteId})
    >;
typedef $$ProveedoresTableCreateCompanionBuilder =
    ProveedoresCompanion Function({
      required String id,
      required String nombre,
      Value<String?> personaContacto,
      Value<String> nif,
      Value<String> telefono,
      Value<String> email,
      Value<String> direccion,
      Value<String> poblacion,
      Value<String> provincia,
      Value<String> codigoPostal,
      Value<String> pais,
      Value<String> observaciones,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });
typedef $$ProveedoresTableUpdateCompanionBuilder =
    ProveedoresCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String?> personaContacto,
      Value<String> nif,
      Value<String> telefono,
      Value<String> email,
      Value<String> direccion,
      Value<String> poblacion,
      Value<String> provincia,
      Value<String> codigoPostal,
      Value<String> pais,
      Value<String> observaciones,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });

class $$ProveedoresTableFilterComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableFilterComposer({
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

  ColumnFilters<String> get personaContacto => $composableBuilder(
    column: $table.personaContacto,
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

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
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
}

class $$ProveedoresTableOrderingComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableOrderingComposer({
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

  ColumnOrderings<String> get personaContacto => $composableBuilder(
    column: $table.personaContacto,
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

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
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

class $$ProveedoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableAnnotationComposer({
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

  GeneratedColumn<String> get personaContacto => $composableBuilder(
    column: $table.personaContacto,
    builder: (column) => column,
  );

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

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

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
}

class $$ProveedoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProveedoresTable,
          Proveedore,
          $$ProveedoresTableFilterComposer,
          $$ProveedoresTableOrderingComposer,
          $$ProveedoresTableAnnotationComposer,
          $$ProveedoresTableCreateCompanionBuilder,
          $$ProveedoresTableUpdateCompanionBuilder,
          (
            Proveedore,
            BaseReferences<_$AppDatabase, $ProveedoresTable, Proveedore>,
          ),
          Proveedore,
          PrefetchHooks Function()
        > {
  $$ProveedoresTableTableManager(_$AppDatabase db, $ProveedoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProveedoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProveedoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProveedoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> personaContacto = const Value.absent(),
                Value<String> nif = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> poblacion = const Value.absent(),
                Value<String> provincia = const Value.absent(),
                Value<String> codigoPostal = const Value.absent(),
                Value<String> pais = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProveedoresCompanion(
                id: id,
                nombre: nombre,
                personaContacto: personaContacto,
                nif: nif,
                telefono: telefono,
                email: email,
                direccion: direccion,
                poblacion: poblacion,
                provincia: provincia,
                codigoPostal: codigoPostal,
                pais: pais,
                observaciones: observaciones,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                Value<String?> personaContacto = const Value.absent(),
                Value<String> nif = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> poblacion = const Value.absent(),
                Value<String> provincia = const Value.absent(),
                Value<String> codigoPostal = const Value.absent(),
                Value<String> pais = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProveedoresCompanion.insert(
                id: id,
                nombre: nombre,
                personaContacto: personaContacto,
                nif: nif,
                telefono: telefono,
                email: email,
                direccion: direccion,
                poblacion: poblacion,
                provincia: provincia,
                codigoPostal: codigoPostal,
                pais: pais,
                observaciones: observaciones,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProveedoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProveedoresTable,
      Proveedore,
      $$ProveedoresTableFilterComposer,
      $$ProveedoresTableOrderingComposer,
      $$ProveedoresTableAnnotationComposer,
      $$ProveedoresTableCreateCompanionBuilder,
      $$ProveedoresTableUpdateCompanionBuilder,
      (
        Proveedore,
        BaseReferences<_$AppDatabase, $ProveedoresTable, Proveedore>,
      ),
      Proveedore,
      PrefetchHooks Function()
    >;
typedef $$CertificacionesTableCreateCompanionBuilder =
    CertificacionesCompanion Function({
      required String id,
      required String expedienteId,
      Value<String?> presupuestoId,
      Value<String> codigo,
      Value<DateTime> fecha,
      Value<String> descripcion,
      Value<double> baseImponible,
      Value<double> ivaPorcentaje,
      Value<double> importeTotal,
      Value<String> estado,
      Value<String?> observaciones,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });
typedef $$CertificacionesTableUpdateCompanionBuilder =
    CertificacionesCompanion Function({
      Value<String> id,
      Value<String> expedienteId,
      Value<String?> presupuestoId,
      Value<String> codigo,
      Value<DateTime> fecha,
      Value<String> descripcion,
      Value<double> baseImponible,
      Value<double> ivaPorcentaje,
      Value<double> importeTotal,
      Value<String> estado,
      Value<String?> observaciones,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });

final class $$CertificacionesTableReferences
    extends
        BaseReferences<_$AppDatabase, $CertificacionesTable, Certificacione> {
  $$CertificacionesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExpedientesTable _expedienteIdTable(_$AppDatabase db) => db
      .expedientes
      .createAlias('certificaciones__expediente_id__expedientes__id');

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

  static $PresupuestosTable _presupuestoIdTable(_$AppDatabase db) => db
      .presupuestos
      .createAlias('certificaciones__presupuesto_id__presupuestos__id');

  $$PresupuestosTableProcessedTableManager? get presupuestoId {
    final $_column = $_itemColumn<String>('presupuesto_id');
    if ($_column == null) return null;
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

class $$CertificacionesTableFilterComposer
    extends Composer<_$AppDatabase, $CertificacionesTable> {
  $$CertificacionesTableFilterComposer({
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

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get baseImponible => $composableBuilder(
    column: $table.baseImponible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ivaPorcentaje => $composableBuilder(
    column: $table.ivaPorcentaje,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get importeTotal => $composableBuilder(
    column: $table.importeTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
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

class $$CertificacionesTableOrderingComposer
    extends Composer<_$AppDatabase, $CertificacionesTable> {
  $$CertificacionesTableOrderingComposer({
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

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get baseImponible => $composableBuilder(
    column: $table.baseImponible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ivaPorcentaje => $composableBuilder(
    column: $table.ivaPorcentaje,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get importeTotal => $composableBuilder(
    column: $table.importeTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
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

class $$CertificacionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CertificacionesTable> {
  $$CertificacionesTableAnnotationComposer({
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

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get baseImponible => $composableBuilder(
    column: $table.baseImponible,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ivaPorcentaje => $composableBuilder(
    column: $table.ivaPorcentaje,
    builder: (column) => column,
  );

  GeneratedColumn<double> get importeTotal => $composableBuilder(
    column: $table.importeTotal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

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

class $$CertificacionesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CertificacionesTable,
          Certificacione,
          $$CertificacionesTableFilterComposer,
          $$CertificacionesTableOrderingComposer,
          $$CertificacionesTableAnnotationComposer,
          $$CertificacionesTableCreateCompanionBuilder,
          $$CertificacionesTableUpdateCompanionBuilder,
          (Certificacione, $$CertificacionesTableReferences),
          Certificacione,
          PrefetchHooks Function({bool expedienteId, bool presupuestoId})
        > {
  $$CertificacionesTableTableManager(
    _$AppDatabase db,
    $CertificacionesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CertificacionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CertificacionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CertificacionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> expedienteId = const Value.absent(),
                Value<String?> presupuestoId = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<double> baseImponible = const Value.absent(),
                Value<double> ivaPorcentaje = const Value.absent(),
                Value<double> importeTotal = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CertificacionesCompanion(
                id: id,
                expedienteId: expedienteId,
                presupuestoId: presupuestoId,
                codigo: codigo,
                fecha: fecha,
                descripcion: descripcion,
                baseImponible: baseImponible,
                ivaPorcentaje: ivaPorcentaje,
                importeTotal: importeTotal,
                estado: estado,
                observaciones: observaciones,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String expedienteId,
                Value<String?> presupuestoId = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<double> baseImponible = const Value.absent(),
                Value<double> ivaPorcentaje = const Value.absent(),
                Value<double> importeTotal = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CertificacionesCompanion.insert(
                id: id,
                expedienteId: expedienteId,
                presupuestoId: presupuestoId,
                codigo: codigo,
                fecha: fecha,
                descripcion: descripcion,
                baseImponible: baseImponible,
                ivaPorcentaje: ivaPorcentaje,
                importeTotal: importeTotal,
                estado: estado,
                observaciones: observaciones,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CertificacionesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({expedienteId = false, presupuestoId = false}) {
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
                        if (expedienteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.expedienteId,
                                    referencedTable:
                                        $$CertificacionesTableReferences
                                            ._expedienteIdTable(db),
                                    referencedColumn:
                                        $$CertificacionesTableReferences
                                            ._expedienteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (presupuestoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.presupuestoId,
                                    referencedTable:
                                        $$CertificacionesTableReferences
                                            ._presupuestoIdTable(db),
                                    referencedColumn:
                                        $$CertificacionesTableReferences
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

typedef $$CertificacionesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CertificacionesTable,
      Certificacione,
      $$CertificacionesTableFilterComposer,
      $$CertificacionesTableOrderingComposer,
      $$CertificacionesTableAnnotationComposer,
      $$CertificacionesTableCreateCompanionBuilder,
      $$CertificacionesTableUpdateCompanionBuilder,
      (Certificacione, $$CertificacionesTableReferences),
      Certificacione,
      PrefetchHooks Function({bool expedienteId, bool presupuestoId})
    >;
typedef $$DocumentosTableCreateCompanionBuilder =
    DocumentosCompanion Function({
      required String id,
      required String expedienteId,
      required String titulo,
      required String nombreArchivo,
      required String rutaArchivo,
      Value<String?> mimeType,
      required int tamanoBytes,
      Value<DateTime> fecha,
      Value<String?> observaciones,
      Value<String> tipo,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });
typedef $$DocumentosTableUpdateCompanionBuilder =
    DocumentosCompanion Function({
      Value<String> id,
      Value<String> expedienteId,
      Value<String> titulo,
      Value<String> nombreArchivo,
      Value<String> rutaArchivo,
      Value<String?> mimeType,
      Value<int> tamanoBytes,
      Value<DateTime> fecha,
      Value<String?> observaciones,
      Value<String> tipo,
      Value<bool> eliminado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<int> rowid,
    });

final class $$DocumentosTableReferences
    extends BaseReferences<_$AppDatabase, $DocumentosTable, Documento> {
  $$DocumentosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExpedientesTable _expedienteIdTable(_$AppDatabase db) =>
      db.expedientes.createAlias('documentos__expediente_id__expedientes__id');

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
}

class $$DocumentosTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentosTable> {
  $$DocumentosTableFilterComposer({
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

  ColumnFilters<String> get nombreArchivo => $composableBuilder(
    column: $table.nombreArchivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rutaArchivo => $composableBuilder(
    column: $table.rutaArchivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tamanoBytes => $composableBuilder(
    column: $table.tamanoBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
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
}

class $$DocumentosTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentosTable> {
  $$DocumentosTableOrderingComposer({
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

  ColumnOrderings<String> get nombreArchivo => $composableBuilder(
    column: $table.nombreArchivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rutaArchivo => $composableBuilder(
    column: $table.rutaArchivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tamanoBytes => $composableBuilder(
    column: $table.tamanoBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
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

class $$DocumentosTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentosTable> {
  $$DocumentosTableAnnotationComposer({
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

  GeneratedColumn<String> get nombreArchivo => $composableBuilder(
    column: $table.nombreArchivo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rutaArchivo => $composableBuilder(
    column: $table.rutaArchivo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get tamanoBytes => $composableBuilder(
    column: $table.tamanoBytes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

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
}

class $$DocumentosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentosTable,
          Documento,
          $$DocumentosTableFilterComposer,
          $$DocumentosTableOrderingComposer,
          $$DocumentosTableAnnotationComposer,
          $$DocumentosTableCreateCompanionBuilder,
          $$DocumentosTableUpdateCompanionBuilder,
          (Documento, $$DocumentosTableReferences),
          Documento,
          PrefetchHooks Function({bool expedienteId})
        > {
  $$DocumentosTableTableManager(_$AppDatabase db, $DocumentosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> expedienteId = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String> nombreArchivo = const Value.absent(),
                Value<String> rutaArchivo = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<int> tamanoBytes = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentosCompanion(
                id: id,
                expedienteId: expedienteId,
                titulo: titulo,
                nombreArchivo: nombreArchivo,
                rutaArchivo: rutaArchivo,
                mimeType: mimeType,
                tamanoBytes: tamanoBytes,
                fecha: fecha,
                observaciones: observaciones,
                tipo: tipo,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String expedienteId,
                required String titulo,
                required String nombreArchivo,
                required String rutaArchivo,
                Value<String?> mimeType = const Value.absent(),
                required int tamanoBytes,
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentosCompanion.insert(
                id: id,
                expedienteId: expedienteId,
                titulo: titulo,
                nombreArchivo: nombreArchivo,
                rutaArchivo: rutaArchivo,
                mimeType: mimeType,
                tamanoBytes: tamanoBytes,
                fecha: fecha,
                observaciones: observaciones,
                tipo: tipo,
                eliminado: eliminado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DocumentosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expedienteId = false}) {
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
                    if (expedienteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.expedienteId,
                                referencedTable: $$DocumentosTableReferences
                                    ._expedienteIdTable(db),
                                referencedColumn: $$DocumentosTableReferences
                                    ._expedienteIdTable(db)
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

typedef $$DocumentosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentosTable,
      Documento,
      $$DocumentosTableFilterComposer,
      $$DocumentosTableOrderingComposer,
      $$DocumentosTableAnnotationComposer,
      $$DocumentosTableCreateCompanionBuilder,
      $$DocumentosTableUpdateCompanionBuilder,
      (Documento, $$DocumentosTableReferences),
      Documento,
      PrefetchHooks Function({bool expedienteId})
    >;
typedef $$TimelineEventsTableCreateCompanionBuilder =
    TimelineEventsCompanion Function({
      required String id,
      required String expedienteId,
      Value<DateTime> fecha,
      required String tipo,
      Value<String> titulo,
      Value<String?> descripcion,
      Value<String?> referenciaId,
      Value<DateTime> fechaCreacion,
      Value<int> rowid,
    });
typedef $$TimelineEventsTableUpdateCompanionBuilder =
    TimelineEventsCompanion Function({
      Value<String> id,
      Value<String> expedienteId,
      Value<DateTime> fecha,
      Value<String> tipo,
      Value<String> titulo,
      Value<String?> descripcion,
      Value<String?> referenciaId,
      Value<DateTime> fechaCreacion,
      Value<int> rowid,
    });

final class $$TimelineEventsTableReferences
    extends BaseReferences<_$AppDatabase, $TimelineEventsTable, TimelineEvent> {
  $$TimelineEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExpedientesTable _expedienteIdTable(_$AppDatabase db) => db
      .expedientes
      .createAlias('timeline_events__expediente_id__expedientes__id');

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
}

class $$TimelineEventsTableFilterComposer
    extends Composer<_$AppDatabase, $TimelineEventsTable> {
  $$TimelineEventsTableFilterComposer({
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

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
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
}

class $$TimelineEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $TimelineEventsTable> {
  $$TimelineEventsTableOrderingComposer({
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

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
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

class $$TimelineEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimelineEventsTable> {
  $$TimelineEventsTableAnnotationComposer({
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

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
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
}

class $$TimelineEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimelineEventsTable,
          TimelineEvent,
          $$TimelineEventsTableFilterComposer,
          $$TimelineEventsTableOrderingComposer,
          $$TimelineEventsTableAnnotationComposer,
          $$TimelineEventsTableCreateCompanionBuilder,
          $$TimelineEventsTableUpdateCompanionBuilder,
          (TimelineEvent, $$TimelineEventsTableReferences),
          TimelineEvent,
          PrefetchHooks Function({bool expedienteId})
        > {
  $$TimelineEventsTableTableManager(
    _$AppDatabase db,
    $TimelineEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimelineEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimelineEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimelineEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> expedienteId = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<String?> referenciaId = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimelineEventsCompanion(
                id: id,
                expedienteId: expedienteId,
                fecha: fecha,
                tipo: tipo,
                titulo: titulo,
                descripcion: descripcion,
                referenciaId: referenciaId,
                fechaCreacion: fechaCreacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String expedienteId,
                Value<DateTime> fecha = const Value.absent(),
                required String tipo,
                Value<String> titulo = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<String?> referenciaId = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimelineEventsCompanion.insert(
                id: id,
                expedienteId: expedienteId,
                fecha: fecha,
                tipo: tipo,
                titulo: titulo,
                descripcion: descripcion,
                referenciaId: referenciaId,
                fechaCreacion: fechaCreacion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimelineEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expedienteId = false}) {
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
                    if (expedienteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.expedienteId,
                                referencedTable: $$TimelineEventsTableReferences
                                    ._expedienteIdTable(db),
                                referencedColumn:
                                    $$TimelineEventsTableReferences
                                        ._expedienteIdTable(db)
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

typedef $$TimelineEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimelineEventsTable,
      TimelineEvent,
      $$TimelineEventsTableFilterComposer,
      $$TimelineEventsTableOrderingComposer,
      $$TimelineEventsTableAnnotationComposer,
      $$TimelineEventsTableCreateCompanionBuilder,
      $$TimelineEventsTableUpdateCompanionBuilder,
      (TimelineEvent, $$TimelineEventsTableReferences),
      TimelineEvent,
      PrefetchHooks Function({bool expedienteId})
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
  $$ComprasTableTableManager get compras =>
      $$ComprasTableTableManager(_db, _db.compras);
  $$ProveedoresTableTableManager get proveedores =>
      $$ProveedoresTableTableManager(_db, _db.proveedores);
  $$CertificacionesTableTableManager get certificaciones =>
      $$CertificacionesTableTableManager(_db, _db.certificaciones);
  $$DocumentosTableTableManager get documentos =>
      $$DocumentosTableTableManager(_db, _db.documentos);
  $$TimelineEventsTableTableManager get timelineEvents =>
      $$TimelineEventsTableTableManager(_db, _db.timelineEvents);
}
