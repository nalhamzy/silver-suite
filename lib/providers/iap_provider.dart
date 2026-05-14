import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silver_suite/core/constants/iap_ids.dart';
import 'package:silver_suite/core/models/premium_state.dart';
import 'package:silver_suite/core/services/ad_service.dart';
import 'package:silver_suite/core/services/iap_service.dart';
import 'package:silver_suite/providers/storage_provider.dart';

final iapServiceProvider = Provider<IapService>(
  (ref) =>
      throw UnimplementedError('iapServiceProvider must be overridden in main'),
);

final adServiceProvider = Provider<AdService>(
  (ref) =>
      throw UnimplementedError('adServiceProvider must be overridden in main'),
);

final premiumProvider = NotifierProvider<PremiumNotifier, PremiumState>(
  PremiumNotifier.new,
);

class PremiumNotifier extends Notifier<PremiumState> {
  @override
  PremiumState build() {
    final saved = ref.read(storageServiceProvider).loadPremium();
    if (saved.trialStartedAt != null || saved.hasLifetime) return saved;
    final started = saved.copyWith(trialStartedAt: DateTime.now());
    ref.read(storageServiceProvider).savePremium(started);
    return started;
  }

  Future<void> activate(String productId) async {
    state = state.copyWith(
      activeProductId: productId,
      activatedAt: DateTime.now(),
      adsRemoved: state.adsRemoved || _isAdRemovingProduct(productId),
    );
    await ref.read(storageServiceProvider).savePremium(state);
  }

  Future<void> clear() async {
    state = const PremiumState();
    await ref.read(storageServiceProvider).savePremium(state);
  }

  bool _isAdRemovingProduct(String id) =>
      id == IapProductIds.premiumLifetime ||
      IapProductIds.legacyPremiumIds.contains(id);
}

final hideAdsProvider = Provider<bool>(
  (ref) => ref.watch(premiumProvider).hideAds,
);

final isPremiumProvider = Provider<bool>(
  (ref) => ref.watch(premiumProvider).isPremium,
);

final iapProductsProvider = FutureProvider<List<IapProduct>>(
  (ref) => ref.read(iapServiceProvider).loadProducts(),
);
