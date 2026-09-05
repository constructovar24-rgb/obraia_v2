import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/tenant/tenant_context.dart';
import 'app_database.dart';
import 'database_lifecycle_controller.dart';

final databaseLifecycleControllerProvider =
    Provider<DatabaseLifecycleController>((ref) {
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
  final lifecycle = ref.watch(databaseLifecycleControllerProvider);
  void invalidate() => ref.invalidateSelf();
  lifecycle.addListener(invalidate);
  ref.onDispose(() => lifecycle.removeListener(invalidate));
  return lifecycle.activeDatabase;
});

final tenantContextProvider = Provider<TenantContext>((ref) {
  return ref.watch(databaseProvider).tenantContext;
});

final activeTenantIdProvider = Provider<String>((ref) {
  final context = ref.watch(tenantContextProvider);
  void invalidate() => ref.invalidateSelf();
  context.addListener(invalidate);
  ref.onDispose(() => context.removeListener(invalidate));
  return context.requireTenantId();
});
