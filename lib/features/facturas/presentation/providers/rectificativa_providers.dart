import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/rectificativa_repository.dart';

final rectificativaRepositoryProvider = Provider<RectificativaRepository>((
  ref,
) {
  ref.watch(activeTenantIdProvider);
  return RectificativaRepository(ref.watch(databaseProvider));
});
