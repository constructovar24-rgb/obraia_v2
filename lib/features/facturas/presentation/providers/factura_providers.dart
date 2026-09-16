import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/factura_repository.dart';

final facturaRepositoryProvider = Provider<FacturaRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  return FacturaRepository(ref.watch(databaseProvider));
});
