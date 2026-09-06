import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/fiscal/data/configuracion_fiscal_repository.dart';

Future<void> prepararFiscalPrueba(AppDatabase db, {int? ejercicio}) async {
  await db.ensureReady();
  final anio = ejercicio ?? DateTime.now().year;
  final repo = ConfiguracionFiscalRepository(db);
  if ((await repo.obtener(anio)).isNotEmpty) return;
  await repo.configurarEjercicio(
    ejercicio: anio,
    serieOrdinaria: 'FAC',
    inicialOrdinaria: 1,
    serieRectificativa: 'RECT',
    inicialRectificativa: 1,
    preparada: true,
  );
}
