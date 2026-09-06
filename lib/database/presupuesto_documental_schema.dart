import 'app_database.dart';

/// No backfill: legacy duplicates and accepted budgets remain unchanged.
Future<void> crearProteccionesPresupuesto(AppDatabase db) async {
  await db.customStatement(
    'CREATE INDEX IF NOT EXISTS presupuestos_tenant_codigo_idx ON presupuestos(tenant_id, codigo)',
  );
  for (final operation in ['INSERT', 'UPDATE OF codigo, tenant_id']) {
    final suffix = operation.startsWith('INSERT') ? 'insert' : 'update';
    await db.customStatement("""
      CREATE TRIGGER IF NOT EXISTS presupuesto_codigo_$suffix
      BEFORE $operation ON presupuestos
      WHEN trim(NEW.codigo) != '' AND EXISTS (
        SELECT 1 FROM presupuestos p WHERE p.tenant_id = NEW.tenant_id
          AND p.codigo = NEW.codigo AND p.id != NEW.id
      )
      BEGIN SELECT RAISE(ABORT, 'Referencia de presupuesto duplicada'); END
    """);
  }
  for (final operation in ['UPDATE', 'DELETE']) {
    await db.customStatement("""
      CREATE TRIGGER IF NOT EXISTS presupuesto_aceptado_${operation.toLowerCase()}
      BEFORE $operation ON presupuestos
      WHEN lower(trim(OLD.estado)) = 'aceptado'
      BEGIN SELECT RAISE(ABORT, 'Presupuesto aceptado protegido'); END
    """);
    await db.customStatement("""
      CREATE TRIGGER IF NOT EXISTS documento_presupuesto_${operation.toLowerCase()}
      BEFORE $operation ON presupuesto_documentos_aceptados
      BEGIN SELECT RAISE(ABORT, 'Documento aceptado inmutable'); END
    """);
  }
  // SQL defense for newly frozen budgets. Legacy is protected by domain/DAO,
  // without fabricating a historical document or changing stored rows.
  for (final operation in ['INSERT', 'UPDATE', 'DELETE']) {
    final rows = operation == 'INSERT'
        ? ['NEW']
        : operation == 'DELETE'
        ? ['OLD']
        : ['OLD', 'NEW'];
    final conditions = rows
        .map(
          (row) =>
              'EXISTS (SELECT 1 FROM presupuesto_documentos_aceptados d WHERE d.tenant_id = $row.tenant_id AND d.presupuesto_id = $row.presupuesto_id)',
        )
        .join(' OR ');
    await db.customStatement("""
      CREATE TRIGGER IF NOT EXISTS partida_presupuesto_congelado_${operation.toLowerCase()}
      BEFORE $operation ON lineas_presupuesto WHEN $conditions
      BEGIN SELECT RAISE(ABORT, 'Partidas aceptadas inmutables'); END
    """);
  }
}
