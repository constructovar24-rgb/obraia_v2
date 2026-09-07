import '../../documentos/data/managed_document_store.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';
import '../../../core/environment/environment_paths.dart';

import '../domain/backup_manifest.dart';
import 'backup_archive_service.dart';

class DocumentRestoreSwap {
  DocumentRestoreSwap(this.paths, this.source, this.manifest);
  final EnvironmentPaths paths;
  final Directory source;
  final BackupManifest manifest;
  final List<File> _installed = [];
  final Map<String, File> _previous = {};
  Directory? _rollback;

  Future<void> activate() async {
    final root = paths.managedDocumentsDirectory;
    await ManagedDocumentStore.requireNoLinks(root.path);
    await root.create(recursive: true);
    _rollback = await root.createTemp('.restore-');
    try {
      for (final entry in manifest.entries.where(
        (e) => e.type == 'managed-document',
      )) {
        final relative = entry.path.substring('documents/'.length);
        final segments = relative.split('/');
        if (segments.length != 2 ||
            !RegExp(r'^[0-9a-f]{64}$').hasMatch(segments.first) ||
            segments.last != '${entry.sha256}.original') {
          throw const BackupValidationException();
        }
        final target = File(p.joinAll([root.path, ...segments]));
        for (final path in [root.path, target.parent.path, target.path]) {
          if (await FileSystemEntity.type(path, followLinks: false) ==
              FileSystemEntityType.link) {
            throw const BackupValidationException();
          }
        }
        final incoming = File(p.joinAll([source.path, ...segments]));
        final bytes = await incoming.readAsBytes();
        if (bytes.length != entry.sizeBytes ||
            sha256.convert(bytes).toString() != entry.sha256) {
          throw const BackupValidationException();
        }
        await target.parent.create(recursive: true);
        if (await target.exists()) {
          if (sha256.convert(await target.readAsBytes()).toString() ==
              entry.sha256) {
            continue;
          }
          _previous[target.path] = await target.rename(
            p.join(_rollback!.path, '${_previous.length}.original'),
          );
        }
        _installed.add(target);
        await target.create(exclusive: true);
        await target.writeAsBytes(bytes, flush: true);
      }
    } catch (_) {
      await rollback();
      rethrow;
    }
  }

  Future<void> rollback() async {
    for (final target in _installed.reversed) {
      if (await target.exists()) await target.delete();
    }
    _installed.clear();
    for (final entry in _previous.entries.toList()) {
      await entry.value.rename(entry.key);
      _previous.remove(entry.key);
    }
    _previous.clear();
  }
}
