import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/backup_restore_coordinator.dart';

final backupRestoreCoordinatorProvider = Provider<BackupRestoreCoordinator>((
  ref,
) {
  return BackupRestoreCoordinator(
    databaseLifecycle: ref.read(databaseLifecycleControllerProvider),
  );
});
