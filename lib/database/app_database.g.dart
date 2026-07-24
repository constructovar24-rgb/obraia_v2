// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExpedientesTable expedientes = $ExpedientesTable(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final ExpedientesDao expedientesDao = ExpedientesDao(
    this as AppDatabase,
  );
  late final ClientesDao clientesDao = ClientesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [expedientes, clientes];
}

typedef $$ExpedientesTableCreateCompanionBuilder =
    ExpedientesCompanion Function({
      required String id,
      required String codigo,
      required String nombre,
      Value<String> cliente,
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
          (
            Expediente,
            BaseReferences<_$AppDatabase, $ExpedientesTable, Expediente>,
          ),
          Expediente,
          PrefetchHooks Function()
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (
        Expediente,
        BaseReferences<_$AppDatabase, $ExpedientesTable, Expediente>,
      ),
      Expediente,
      PrefetchHooks Function()
    >;
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
          (Cliente, BaseReferences<_$AppDatabase, $ClientesTable, Cliente>),
          Cliente,
          PrefetchHooks Function()
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (Cliente, BaseReferences<_$AppDatabase, $ClientesTable, Cliente>),
      Cliente,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db, _db.expedientes);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
}
