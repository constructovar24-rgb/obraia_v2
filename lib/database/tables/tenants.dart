import 'package:drift/drift.dart';

const defaultTenantIdForTesting = '00000000-0000-4000-8000-000000000023';

class Tenants extends Table {
  TextColumn get id => text()();
  TextColumn get nombre =>
      text().customConstraint("NOT NULL CHECK (length(trim(nombre)) > 0)")();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaModificacion => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
