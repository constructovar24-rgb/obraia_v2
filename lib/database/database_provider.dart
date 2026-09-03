import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/tenant/tenant_context.dart';
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

final tenantContextProvider = ChangeNotifierProvider<TenantContext>((ref) {
  return ref.watch(databaseProvider).tenantContext;
});

final activeTenantIdProvider = Provider<String>((ref) {
  return ref.watch(tenantContextProvider).requireTenantId();
});
