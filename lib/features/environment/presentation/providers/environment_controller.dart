import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/environment/app_environment.dart';
import '../../../../core/environment/environment_paths.dart';
import '../../../../core/environment/environment_profile_store.dart';
import '../../../../database/app_database.dart';
import '../../../../database/database_lifecycle_controller.dart';

final environmentControllerProvider = Provider<EnvironmentController>(
  (ref) => throw StateError(
    'El entorno debe inicializarse antes de abrir la aplicación.',
  ),
);

class EnvironmentController extends ChangeNotifier {
  EnvironmentController({
    required this.documentsDirectory,
    required this.profileStore,
    required AppEnvironment initialEnvironment,
    required this.detachSession,
  }) : _environment = initialEnvironment {
    lifecycle = DatabaseLifecycleController(
      initialDatabase: _createDatabase(),
      databaseFactory: _createDatabase,
      activeDatabasePathResolver: () async => paths.databaseFile.path,
    );
  }

  final Directory documentsDirectory;
  final EnvironmentProfileStore profileStore;

  /// Completes after the old widgets and provider container are disposed.
  final Future<void> Function() detachSession;
  late final DatabaseLifecycleController lifecycle;
  AppEnvironment _environment;
  bool switching = false;
  String? error;
  bool available = true;
  int session = 0;

  AppEnvironment get environment => _environment;
  EnvironmentPaths get paths =>
      EnvironmentPaths(documentsDirectory, environment);
  AppDatabase _createDatabase() =>
      AppDatabase(file: paths.databaseFile, environment: environment);

  Future<void> changeEnvironment(AppEnvironment target) async {
    if (target == environment) return;
    await lifecycle.runExclusiveMaintenance(() async {
      final previous = environment;
      switching = true;
      error = null;
      notifyListeners();
      try {
        await detachSession();
        final database = lifecycle.activeDatabase;
        await database.exclusively(() => database.ensureReady());
        await lifecycle.closeActiveDatabase();
        _environment = target;
        await lifecycle.openAndPublishActiveDatabase();
        await profileStore.write(target);
      } catch (_) {
        await lifecycle.closeActiveDatabase();
        _environment = previous;
        try {
          await lifecycle.openAndPublishActiveDatabase();
          error =
              'No se pudo cambiar el entorno. Se ha recuperado ${previous.label}.';
        } catch (_) {
          available = false;
          error =
              'No se pudo reabrir la base. Cierra y vuelve a abrir OBRA IA.';
        }
      } finally {
        session++;
        switching = false;
        notifyListeners();
      }
    });
  }

  /// Prevents a change while a multi-step operation in Settings is saving.
  Future<T> runOperation<T>(Future<T> Function() action) =>
      lifecycle.runExclusiveMaintenance(action);

  Future<void> close() => lifecycle.close();

  @override
  void dispose() {
    lifecycle.dispose();
    super.dispose();
  }
}
