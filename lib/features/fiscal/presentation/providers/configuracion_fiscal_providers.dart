import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/database_provider.dart';
import '../../data/configuracion_fiscal_repository.dart';

final configuracionFiscalRepositoryProvider =
    Provider<ConfiguracionFiscalRepository>((ref) {
      ref.watch(activeTenantIdProvider);
      return ConfiguracionFiscalRepository(ref.watch(databaseProvider));
    });
