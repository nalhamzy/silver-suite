import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silver_suite/app.dart';
import 'package:silver_suite/core/services/ad_service.dart';
import 'package:silver_suite/core/services/iap_service.dart';
import 'package:silver_suite/core/services/storage_service.dart';
import 'package:silver_suite/providers/iap_provider.dart';
import 'package:silver_suite/providers/storage_provider.dart';

class _FakeIap implements IapService {
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

class _FakeAd implements AdService {
  @override
  Future<void> initialize() async {}
  @override
  Widget bannerWidget() => const SizedBox.shrink();
  @override
  Future<void> showInterstitial() async {}
}

void main() {
  testWidgets('App boots and shows Tools grid', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          iapServiceProvider.overrideWithValue(_FakeIap()),
          adServiceProvider.overrideWithValue(_FakeAd()),
        ],
        child: const SilverSuiteApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tools'), findsOneWidget);
    expect(find.text('Pills'), findsWidgets);
    expect(find.text('Contacts'), findsOneWidget);
  });
}
