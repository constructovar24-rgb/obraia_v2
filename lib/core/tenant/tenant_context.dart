import 'package:flutter/foundation.dart';

class MissingTenantContextException implements Exception {
  const MissingTenantContextException();

  @override
  String toString() => 'No hay un tenant activo para esta operación.';
}

class TenantContext extends ChangeNotifier {
  TenantContext({String? initialTenantId}) : _activeTenantId = initialTenantId;

  String? _activeTenantId;

  String? get activeTenantId => _activeTenantId;

  String requireTenantId() {
    final tenantId = _activeTenantId;
    if (tenantId == null || tenantId.trim().isEmpty) {
      throw const MissingTenantContextException();
    }
    return tenantId;
  }

  void activate(String tenantId) {
    if (tenantId.trim().isEmpty) {
      throw ArgumentError.value(tenantId, 'tenantId');
    }
    if (_activeTenantId == tenantId) return;
    _activeTenantId = tenantId;
    notifyListeners();
  }

  void clear() {
    if (_activeTenantId == null) return;
    _activeTenantId = null;
    notifyListeners();
  }
}
