import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'database_lifecycle_controller.dart';

final databaseLifecycleControllerProvider =
    ChangeNotifierProvider<DatabaseLifecycleController>((ref) {
      final controller = DatabaseLifecycleController(
        initialDatabase: AppDatabase(),
        databaseFactory: AppDatabase.new,
        activeDatabasePathResolver: () async {
          final file = await AppDatabase.defaultDatabaseFile();
          return file.path;
        },
      );
      ref.onDispose(controller.dispose);
      return controller;
    });

final databaseProvider = Provider<AppDatabase>((ref) {
  return ref.watch(databaseLifecycleControllerProvider).activeDatabase;
});
