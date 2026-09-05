import 'dart:io';

import 'package:path/path.dart' as p;

import 'app_environment.dart';

/// A missing profile means legacy development. Invalid profiles fail closed.
class EnvironmentProfileStore {
  EnvironmentProfileStore(Directory documentsDirectory)
    : file = File(
        p.join(documentsDirectory.path, 'OBRA IA', 'environment.txt'),
      );

  final File file;

  Future<AppEnvironment> read() async => await file.exists()
      ? AppEnvironment.parse((await file.readAsString()).trim())
      : AppEnvironment.development;

  Future<void> write(AppEnvironment environment) async {
    await file.parent.create(recursive: true);
    final temporary = File('${file.path}.pending');
    await temporary.writeAsString(environment.name, flush: true);
    await temporary.rename(file.path);
  }
}
