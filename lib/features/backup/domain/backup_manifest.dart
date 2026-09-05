import '../../../core/environment/app_environment.dart';

class BackupManifest {
  const BackupManifest({
    this.environment = AppEnvironment.development,
    required this.createdAtUtc,
    required this.appVersion,
    required this.appBuildNumber,
    required this.schemaVersion,
    required this.databasePath,
    required this.totalUncompressedBytes,
    required this.entries,
  });

  static const format = 'obraia-backup';
  static const currentFormatVersion = 1;
  static const manifestPath = 'manifest.json';
  static const defaultDatabasePath = 'database/obraia.sqlite';

  final AppEnvironment environment;
  final DateTime createdAtUtc;
  final String appVersion;
  final String appBuildNumber;
  final int schemaVersion;
  final String databasePath;
  final int totalUncompressedBytes;
  final List<BackupManifestEntry> entries;

  Map<String, Object> toJson() => <String, Object>{
    'environment': environment.name,
    'format': format,
    'formatVersion': currentFormatVersion,
    'createdAtUtc': createdAtUtc.toUtc().toIso8601String(),
    'appVersion': appVersion,
    'appBuildNumber': appBuildNumber,
    'schemaVersion': schemaVersion,
    'databasePath': databasePath,
    'totalUncompressedBytes': totalUncompressedBytes,
    'entryCount': entries.length,
    'entries': entries.map((entry) => entry.toJson()).toList(),
  };

  factory BackupManifest.fromJson(Object? json) {
    final map = _asStringMap(json, 'El manifiesto debe ser un objeto JSON.');
    if (_requiredString(map, 'format') != format) {
      throw const FormatException('Formato de backup no reconocido.');
    }

    final formatVersion = _requiredInt(map, 'formatVersion');
    if (formatVersion != currentFormatVersion) {
      throw const FormatException('Versión de formato no compatible.');
    }

    final createdAtText = _requiredString(map, 'createdAtUtc');
    if (!createdAtText.endsWith('Z')) {
      throw const FormatException('La fecha del backup debe estar en UTC.');
    }
    final createdAt = DateTime.tryParse(createdAtText);
    if (createdAt == null || !createdAt.isUtc) {
      throw const FormatException('Fecha de backup no válida.');
    }

    final rawEntries = map['entries'];
    if (rawEntries is! List<Object?>) {
      throw const FormatException('El inventario del backup no es válido.');
    }
    final entries = rawEntries
        .map(BackupManifestEntry.fromJson)
        .toList(growable: false);
    if (_requiredInt(map, 'entryCount') != entries.length) {
      throw const FormatException('El número de entradas no coincide.');
    }

    final manifest = BackupManifest(
      environment: map.containsKey('environment')
          ? AppEnvironment.parse(map['environment'])
          : AppEnvironment.development,
      createdAtUtc: createdAt,
      appVersion: _requiredNonEmptyString(map, 'appVersion'),
      appBuildNumber: _requiredNonEmptyString(map, 'appBuildNumber'),
      schemaVersion: _requiredPositiveInt(map, 'schemaVersion'),
      databasePath: _requiredNonEmptyString(map, 'databasePath'),
      totalUncompressedBytes: _requiredNonNegativeInt(
        map,
        'totalUncompressedBytes',
      ),
      entries: entries,
    );

    final calculatedSize = entries.fold<int>(
      0,
      (total, entry) => total + entry.sizeBytes,
    );
    if (manifest.totalUncompressedBytes != calculatedSize) {
      throw const FormatException('El tamaño total del backup no coincide.');
    }
    return manifest;
  }
}

class BackupManifestEntry {
  const BackupManifestEntry({
    required this.path,
    required this.type,
    required this.sizeBytes,
    required this.sha256,
  });

  static const sqliteDatabaseType = 'sqlite-database';

  final String path;
  final String type;
  final int sizeBytes;
  final String sha256;

  Map<String, Object> toJson() => <String, Object>{
    'path': path,
    'type': type,
    'sizeBytes': sizeBytes,
    'sha256': sha256,
  };

  factory BackupManifestEntry.fromJson(Object? json) {
    final map = _asStringMap(
      json,
      'Cada entrada del inventario debe ser un objeto JSON.',
    );
    final hash = _requiredString(map, 'sha256');
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(hash)) {
      throw const FormatException('La huella SHA-256 no es válida.');
    }
    return BackupManifestEntry(
      path: _requiredNonEmptyString(map, 'path'),
      type: _requiredNonEmptyString(map, 'type'),
      sizeBytes: _requiredNonNegativeInt(map, 'sizeBytes'),
      sha256: hash,
    );
  }
}

Map<String, Object?> _asStringMap(Object? value, String message) {
  if (value is! Map<Object?, Object?>) {
    throw FormatException(message);
  }
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    if (entry.key is! String) {
      throw FormatException(message);
    }
    result[entry.key! as String] = entry.value;
  }
  return result;
}

String _requiredString(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is! String) {
    throw FormatException('El campo $key no es válido.');
  }
  return value;
}

String _requiredNonEmptyString(Map<String, Object?> map, String key) {
  final value = _requiredString(map, key);
  if (value.trim().isEmpty) {
    throw FormatException('El campo $key no puede estar vacío.');
  }
  return value;
}

int _requiredInt(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is! int) {
    throw FormatException('El campo $key no es válido.');
  }
  return value;
}

int _requiredPositiveInt(Map<String, Object?> map, String key) {
  final value = _requiredInt(map, key);
  if (value <= 0) {
    throw FormatException('El campo $key debe ser positivo.');
  }
  return value;
}

int _requiredNonNegativeInt(Map<String, Object?> map, String key) {
  final value = _requiredInt(map, key);
  if (value < 0) {
    throw FormatException('El campo $key no puede ser negativo.');
  }
  return value;
}
