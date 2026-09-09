import 'dart:io';
import 'dart:typed_data';

/// Reads one bounded snapshot through one handle and rejects incomplete reads.
/// Reopening the path later is necessary to detect replacement of that path.
Future<Uint8List> readStableOriginal(File source) async {
  final before = await source.stat();
  if (before.type != FileSystemEntityType.file) {
    throw StateError('Archivo no encontrado o no disponible.');
  }
  if (before.size <= 0) {
    throw StateError(
      'El archivo está vacío (0 bytes). Guarda su contenido y espera a que esté disponible antes de incorporarlo.',
    );
  }
  if (before.size > 100 * 1024 * 1024) {
    throw StateError('El archivo supera 100 MB.');
  }
  final handle = await source.open(mode: FileMode.read);
  try {
    if (await handle.length() != before.size) {
      throw StateError(
        'El archivo cambió durante la lectura. Vuelve a seleccionarlo.',
      );
    }
    final bytes = Uint8List(before.size);
    var offset = 0;
    while (offset < bytes.length) {
      final count = await handle.readInto(bytes, offset);
      if (count == 0) {
        throw StateError(
          'Lectura incompleta del archivo. No se ha incorporado.',
        );
      }
      offset += count;
    }
    final after = await source.stat();
    if (await handle.length() != before.size ||
        after.type != FileSystemEntityType.file ||
        after.size != before.size ||
        after.modified != before.modified ||
        after.changed != before.changed) {
      throw StateError(
        'El archivo cambió durante la lectura. Vuelve a seleccionarlo.',
      );
    }
    return bytes;
  } finally {
    await handle.close();
  }
}
