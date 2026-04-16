import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silver_suite/providers/iap_provider.dart';

/// Renders the AdMob banner unless Silver+ / Remove-Ads is active.
class AdBannerWidget extends ConsumerWidget {
  const AdBannerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideAds = ref.watch(hideAdsProvider);
    if (hideAds) return const SizedBox.shrink();
    final ad = ref.read(adServiceProvider);
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 4),
      child: ad.bannerWidget(),
    );
  }
}
