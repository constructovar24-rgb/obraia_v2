import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/plan_economico_repository.dart';

final planEconomicoRepositoryProvider = Provider<PlanEconomicoRepository>((
  ref,
) {
  ref.watch(activeTenantIdProvider);
  return PlanEconomicoRepository(ref.watch(databaseProvider));
});
