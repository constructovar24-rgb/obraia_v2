import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/backup_restore_coordinator.dart';
import '../controllers/backup_controller.dart';

final backupRestoreCoordinatorProvider = Provider<BackupRestoreCoordinator>((
  ref,
) {
  return BackupRestoreCoordinator(
    databaseLifecycle: ref.read(databaseLifecycleControllerProvider),
  );
});

final backupControllerProvider = ChangeNotifierProvider<BackupController>((
  ref,
) {
  final controller = BackupController(
    ref.watch(databaseProvider),
    ref.read(backupRestoreCoordinatorProvider),
  );
  controller.checkDaily();
  return controller;
});
