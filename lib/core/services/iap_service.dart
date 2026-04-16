import 'iap_service_stub.dart'
    if (dart.library.io) 'iap_service_mobile.dart';

abstract class IapService {
  factory IapService() => createIapService();

  Future<void> initialize();

  set onPurchaseSuccess(void Function(String productId) handler);

  Future<List<IapProduct>> loadProducts();

  Future<bool> buy(String productId);

  Future<void> restore();

  bool isActive(String productId);
}

class IapProduct {
  final String id;
  final String title;
  final String description;
  final String price;
  final double rawPrice;
  final String currencyCode;

  const IapProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
  });
}
