import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'database/app_database.dart';
import 'database/database_lifecycle_controller.dart';
import 'database/database_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  await database.ensureReady();
  final lifecycle = DatabaseLifecycleController(
    initialDatabase: database,
    databaseFactory: AppDatabase.new,
    activeDatabasePathResolver: () async {
      final file = await AppDatabase.defaultDatabaseFile();
      return file.path;
    },
  );
  runApp(
    ProviderScope(
      overrides: [
        databaseLifecycleControllerProvider.overrideWith((ref) => lifecycle),
      ],
      child: const ObraIAApp(),
    ),
  );
}
