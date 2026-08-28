import 'dart:async';

import 'package:flutter/foundation.dart';

import 'app_database.dart';

typedef AppDatabaseFactory = AppDatabase Function();
typedef ActiveDatabasePathResolver = Future<String> Function();

/// Owns the only active application database and replaces it atomically after
/// a validated restore. Consumers receive a new instance only after it opens.
class DatabaseLifecycleController extends ChangeNotifier {
  DatabaseLifecycleController({
    required AppDatabase initialDatabase,
    required this.databaseFactory,
    required this.activeDatabasePathResolver,
  }) : _activeDatabase = initialDatabase;

  AppDatabase? _activeDatabase;
  final AppDatabaseFactory databaseFactory;
  final ActiveDatabasePathResolver activeDatabasePathResolver;
  bool _maintenanceInProgress = false;
  bool _isDisposed = false;
  int _generation = 0;

  AppDatabase get activeDatabase {
    final database = _activeDatabase;
    if (database == null) {
      throw const DatabaseUnavailableException();
    }
    return database;
  }

  bool get maintenanceInProgress => _maintenanceInProgress;
  int get generation => _generation;

  Future<String> get activeDatabasePath => activeDatabasePathResolver();

  Future<T> runExclusiveMaintenance<T>(Future<T> Function() action) async {
    if (_maintenanceInProgress) {
      throw const DatabaseMaintenanceInProgressException();
    }
    _maintenanceInProgress = true;
    try {
      return await action();
    } finally {
      _maintenanceInProgress = false;
    }
  }

  /// Closing is idempotent because a failed exchange can request another close
  /// before reopening the rollback database.
  Future<void> closeActiveDatabase() async {
    final database = _activeDatabase;
    _activeDatabase = null;
    if (database != null) {
      await database.close();
    }
  }

  /// Publishes only an instance that has opened and answered a health query.
  Future<void> openAndPublishActiveDatabase() async {
    if (_activeDatabase != null) {
      throw const DatabaseLifecycleStateException();
    }

    final database = databaseFactory();
    try {
      await database.customSelect('SELECT 1;').getSingle();
      _activeDatabase = database;
      _generation++;
      if (!_isDisposed) {
        notifyListeners();
      }
    } catch (_) {
      await database.close();
      rethrow;
    }
  }

  Future<void> close() => closeActiveDatabase();

  @override
  void dispose() {
    _isDisposed = true;
    unawaited(closeActiveDatabase());
    super.dispose();
  }
}

class DatabaseMaintenanceInProgressException implements Exception {
  const DatabaseMaintenanceInProgressException();
}

class DatabaseUnavailableException implements Exception {
  const DatabaseUnavailableException();
}

class DatabaseLifecycleStateException implements Exception {
  const DatabaseLifecycleStateException();
}
