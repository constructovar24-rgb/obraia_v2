import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/facturacion_parcial_repository.dart';

final facturacionParcialRepositoryProvider =
    Provider<FacturacionParcialRepository>(
      (ref) => FacturacionParcialRepository(ref.watch(databaseProvider)),
    );
