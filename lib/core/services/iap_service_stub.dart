import 'iap_service.dart';

IapService createIapService() => _StubIapService();

class _StubIapService implements IapService {
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
