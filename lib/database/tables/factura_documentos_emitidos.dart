import 'package:drift/drift.dart';

import 'facturas.dart';

class FacturaDocumentosEmitidos extends Table {
  TextColumn get facturaId => text().references(Facturas, #id)();
  BlobColumn get pdf => blob()();
  TextColumn get sha256 => text()();
  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {facturaId};
}
