import 'app_database.dart';

Future<void> crearProteccionesSeriesFiscales(AppDatabase db) async {
  await db.customStatement("""
    CREATE TRIGGER IF NOT EXISTS serie_fiscal_uso_inmutable
    BEFORE UPDATE ON series_fiscales WHEN (OLD.emisiones > 0 OR (OLD.documentos_previos > 0 AND OLD.preparada = 1)) AND (
      NEW.tenant_id != OLD.tenant_id OR NEW.ejercicio != OLD.ejercicio OR
      NEW.tipo != OLD.tipo OR NEW.serie != OLD.serie OR
      NEW.documentos_previos != OLD.documentos_previos OR NEW.numero_inicial != OLD.numero_inicial OR NEW.preparada != OLD.preparada OR
      NEW.fecha_configuracion != OLD.fecha_configuracion OR
      (OLD.emisiones > 0 AND NEW.primer_uso IS NOT OLD.primer_uso) OR
      NEW.emisiones != OLD.emisiones + 1 OR
      NEW.siguiente_numero != OLD.siguiente_numero + 1)
    BEGIN SELECT RAISE(ABORT, 'Serie fiscal utilizada: configuración inmutable'); END
  """);
  await db.customStatement("""
    CREATE TRIGGER IF NOT EXISTS serie_fiscal_no_borrar
    BEFORE DELETE ON series_fiscales
    BEGIN SELECT RAISE(ABORT, 'No se elimina configuración fiscal'); END
  """);
  for (final op in ['UPDATE', 'DELETE']) {
    await db.customStatement("""
      CREATE TRIGGER IF NOT EXISTS evento_serie_fiscal_${op.toLowerCase()}
      BEFORE $op ON eventos_serie_fiscal
      BEGIN SELECT RAISE(ABORT, 'Auditoría fiscal inmutable'); END
    """);
  }
}
