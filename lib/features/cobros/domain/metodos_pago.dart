const metodosPagoCobro = <String>[
  'Transferencia',
  'Efectivo',
  'Tarjeta',
  'Domiciliacion',
  'Otro',
];

const metodoPagoOtro = 'Otro';

bool metodoPagoCobroConocido(String value) => metodosPagoCobro.contains(value);

bool descripcionMetodoPagoOtroValida({
  required String metodoPago,
  required String descripcion,
}) => metodoPago != metodoPagoOtro || descripcion.trim().length >= 3;
