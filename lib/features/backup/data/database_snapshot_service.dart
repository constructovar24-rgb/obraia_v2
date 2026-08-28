import 'dart:io';

import '../../../database/app_database.dart';

class DatabaseSnapshotService {
  const DatabaseSnapshotService();

  Future<void> createSnapshot({
    required AppDatabase database,
    required String destinationPath,
  }) async {
    if (destinationPath.trim().isEmpty) {
      throw ArgumentError.value(
        destinationPath,
        'destinationPath',
        'La ruta de destino no puede estar vacía.',
      );
    }

    final destination = File(destinationPath);
    if (await destination.exists()) {
      throw const SnapshotDestinationExistsException();
    }

    await database.exclusively(() async {
      await database.customStatement('VACUUM INTO ?;', [destinationPath]);
    });
  }
}

class SnapshotDestinationExistsException implements Exception {
  const SnapshotDestinationExistsException();

  @override
  String toString() => 'El destino del snapshot ya existe.';
}
