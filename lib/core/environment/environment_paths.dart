import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app_environment.dart';

/// Development retains the original database location without moving data.
class EnvironmentPaths {
  const EnvironmentPaths(this.documentsDirectory, this.environment);

  final Directory documentsDirectory;
  final AppEnvironment environment;

  static Future<EnvironmentPaths> resolve(AppEnvironment environment) async =>
      EnvironmentPaths(await getApplicationDocumentsDirectory(), environment);

  Directory get dataDirectory =>
      Directory(p.join(documentsDirectory.path, 'OBRA IA', environment.name));

  File get databaseFile => environment == AppEnvironment.development
      ? File(p.join(documentsDirectory.path, 'obraia.sqlite'))
      : File(p.join(dataDirectory.path, 'obraia_prod.sqlite'));

  Directory get backupDirectory =>
      Directory(p.join(dataDirectory.path, 'backups'));
  Directory get generatedDirectory =>
      Directory(p.join(dataDirectory.path, 'generated'));
}
