import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:silver_suite/core/constants/iap_ids.dart';

import 'iap_service.dart';

IapService createIapService() {
  if (Platform.isAndroid || Platform.isIOS) return _MobileIapService();
  return _DesktopIapService();
}

class _MobileIapService implements IapService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  void Function(String productId)? _onPurchaseSuccess;
  final Map<String, ProductDetails> _products = {};
  final Set<String> _active = {};

  @override
  set onPurchaseSuccess(void Function(String productId) h) =>
      _onPurchaseSuccess = h;

  @override
  Future<void> initialize() async {
    final available = await _iap.isAvailable();
    if (!available) return;
    _sub = _iap.purchaseStream.listen(
      _onUpdate,
      onError: (_) {},
      onDone: () => _sub?.cancel(),
    );
    await _loadFromStore();
  }

  Future<void> _loadFromStore() async {
    final resp = await _iap.queryProductDetails(IapProductIds.all);
    for (final p in resp.productDetails) {
      _products[p.id] = p;
    }
  }

  @override
  Future<List<IapProduct>> loadProducts() async {
    if (_products.isEmpty) await _loadFromStore();
    return _products.values
        .map((p) => IapProduct(
              id: p.id,
              title: p.title,
              description: p.description,
              price: p.price,
              rawPrice: p.rawPrice,
              currencyCode: p.currencyCode,
            ))
        .toList()
      ..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
  }

  @override
  Future<bool> buy(String productId) async {
    final details = _products[productId];
    if (details == null) return false;
    return _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: details),
    );
  }

  @override
  Future<void> restore() => _iap.restorePurchases();

  @override
  bool isActive(String productId) => _active.contains(productId);

  void _onUpdate(List<PurchaseDetails> updates) {
    for (final p in updates) {
      switch (p.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _active.add(p.productID);
          _onPurchaseSuccess?.call(p.productID);
          break;
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
        case PurchaseStatus.pending:
          break;
      }
      if (p.pendingCompletePurchase) {
        _iap.completePurchase(p);
      }
    }
  }
}

class _DesktopIapService implements IapService {
  @override
  Future<void> initialize() async {}
  @override
  set onPurchaseSuccess(void Function(String productId) _) {}
  @override
  Future<List<IapProduct>> loadProducts() async => const [];
  @override
  Future<bool> buy(String productId) async => false;
  @override
  Future<void> restore() async {}
  @override
  bool isActive(String productId) => false;
}
