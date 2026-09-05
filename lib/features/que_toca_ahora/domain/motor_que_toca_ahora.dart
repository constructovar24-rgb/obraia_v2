// ignore_for_file: curly_braces_in_flow_control_structures

import 'recomendacion_operativa.dart';

class MotorQueTocaAhora {
  const MotorQueTocaAhora();
  List<RecomendacionOperativa> calcular(RecommendationContext c) {
    final r = <RecomendacionOperativa>[];
    void add(
      String id,
      CategoriaRecomendacion cat,
      PrioridadRecomendacion p,
      String title,
      String why,
      String action,
      String target, {
      DateTime? date,
    }) => r.add(
      RecomendacionOperativa(
        reglaId: id,
        categoria: cat,
        prioridad: p,
        titulo: title,
        explicacion: why,
        accion: action,
        destino: target,
        fechaObjetivo: date,
      ),
    );
    if (!c.tienePresupuestos)
      add(
        'comercial.sin_presupuesto',
        CategoriaRecomendacion.comercial,
        PrioridadRecomendacion.media,
        'Preparar presupuesto',
        'El expediente no tiene ningún presupuesto registrado.',
        'Abrir Presupuestos',
        'presupuestos',
      );
    else if (c.tienePresupuestoBorrador && !c.tienePresupuestoAceptado)
      add(
        'comercial.presupuesto_borrador',
        CategoriaRecomendacion.comercial,
        PrioridadRecomendacion.media,
        'Revisar presupuesto',
        'Existe un presupuesto en borrador pendiente de completar.',
        'Abrir Presupuestos',
        'presupuestos',
      );
    if (c.tienePresupuestoAceptado &&
        c.inicioPrevisto == null &&
        c.estadoOperativo == 'pendiente')
      add(
        'planificacion.sin_inicio',
        CategoriaRecomendacion.planificacion,
        PrioridadRecomendacion.alta,
        'Programar inicio de obra',
        'Hay presupuesto aceptado, pero no existe fecha prevista de inicio.',
        'Abrir Planificación',
        'planificacion',
      );
    if (c.inicioPrevisto != null &&
        c.inicioPrevisto!.isBefore(_dia(c.hoy)) &&
        {'pendiente', 'preparada'}.contains(c.estadoOperativo))
      add(
        'planificacion.inicio_vencido',
        CategoriaRecomendacion.planificacion,
        PrioridadRecomendacion.alta,
        'Revisar inicio previsto',
        'La fecha prevista de inicio ha vencido y la obra aún no está en ejecución.',
        'Abrir Planificación',
        'planificacion',
        date: c.inicioPrevisto,
      );
    if (c.actuacionesVencidas > 0)
      add(
        'planificacion.actuaciones_vencidas',
        CategoriaRecomendacion.planificacion,
        PrioridadRecomendacion.alta,
        'Atender actuaciones vencidas',
        'Hay ${c.actuacionesVencidas} actuación(es) pendiente(s) con fecha vencida.',
        'Abrir Planificación',
        'planificacion',
      );
    if (c.estadoOperativo == 'enEjecucion' &&
        (c.proximoPaso == null || c.proximoPaso!.trim().isEmpty))
      add(
        'planificacion.sin_proximo_paso',
        CategoriaRecomendacion.planificacion,
        PrioridadRecomendacion.media,
        'Definir próximo paso',
        'La obra está en ejecución y no tiene próximo paso manual.',
        'Abrir Planificación',
        'planificacion',
      );
    if (c.proximoPaso?.trim().isNotEmpty == true)
      add(
        'planificacion.proximo_paso_manual',
        CategoriaRecomendacion.ejecucion,
        PrioridadRecomendacion.media,
        c.proximoPaso!.trim(),
        'Es el próximo paso definido explícitamente para la obra.',
        'Abrir Planificación',
        'planificacion',
      );
    if (c.incidenciasAltasAbiertas > 0)
      add(
        'incidencia.alta_abierta',
        CategoriaRecomendacion.incidencia,
        PrioridadRecomendacion.critica,
        'Resolver incidencia prioritaria',
        'Hay ${c.incidenciasAltasAbiertas} incidencia(s) de prioridad alta abierta(s).',
        'Abrir Incidencias',
        'incidencias',
      );
    if (c.facturaProveedorVencidaPendiente)
      add(
        'proveedores.factura_vencida',
        CategoriaRecomendacion.proveedores,
        PrioridadRecomendacion.alta,
        'Revisar pago vencido a proveedor',
        'Existe una factura recibida vencida con saldo pendiente.',
        'Abrir Compras / Suministros',
        'suministros',
      );
    else if (c.documentosPendientesReconciliar > 0)
      add(
        'suministros.sin_reconciliar',
        CategoriaRecomendacion.suministros,
        PrioridadRecomendacion.media,
        'Reconciliar factura de proveedor',
        'Hay ${c.documentosPendientesReconciliar} imputación(es) todavía sin reconocimiento o reconciliación económica.',
        'Abrir Compras / Suministros',
        'suministros',
      );
    if (c.albaranesPendientesFactura > 0)
      add(
        'suministros.albaran_sin_factura',
        CategoriaRecomendacion.suministros,
        PrioridadRecomendacion.baja,
        'Revisar albaranes pendientes',
        'Hay ${c.albaranesPendientesFactura} albarán(es) recibido(s) aún no facturado(s).',
        'Abrir Compras / Suministros',
        'suministros',
      );
    if (c.facturasClientePendientesCentimos > 0)
      add(
        'cobros.saldo_pendiente',
        CategoriaRecomendacion.cobros,
        PrioridadRecomendacion.alta,
        'Gestionar cobro pendiente',
        'Las facturas emitidas tienen ${(c.facturasClientePendientesCentimos / 100).toStringAsFixed(2)} € pendientes.',
        'Abrir Facturas',
        'facturas',
      );
    if (c.perdidaPrevistaCentimos > 0 && !c.economiaCerrada)
      add(
        'economia.perdida_prevista',
        CategoriaRecomendacion.economia,
        PrioridadRecomendacion.critica,
        'Revisar pérdida prevista',
        'La previsión económica refleja una pérdida de ${(c.perdidaPrevistaCentimos / 100).toStringAsFixed(2)} €.',
        'Abrir Economía',
        'economia',
      );
    if (c.estadoOperativo == 'finalizada' && !c.economiaCerrada)
      add(
        'cierre.obra_finalizada_abierta',
        CategoriaRecomendacion.cierre,
        PrioridadRecomendacion.alta,
        'Revisar cierre económico',
        'La obra está operativamente finalizada y su economía continúa abierta.',
        'Abrir Economía',
        'economia',
      );
    r.sort((a, b) {
      final p = a.prioridad.index.compareTo(b.prioridad.index);
      return p != 0 ? p : a.reglaId.compareTo(b.reglaId);
    });
    return List.unmodifiable(r);
  }

  DateTime _dia(DateTime d) => DateTime(d.year, d.month, d.day);
}
