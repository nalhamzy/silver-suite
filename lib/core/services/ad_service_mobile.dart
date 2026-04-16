import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:silver_suite/core/constants/ad_ids.dart';

import 'ad_service.dart';

AdService createAdService() {
  if (Platform.isAndroid || Platform.isIOS) {
    return _MobileAdService();
  }
  return _DesktopAdService();
}

class _MobileAdService implements AdService {
  bool _initialized = false;
  InterstitialAd? _interstitial;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;
    _preloadInterstitial();
  }

  void _preloadInterstitial() {
    InterstitialAd.load(
      adUnitId: AdIds.interstitial(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (_) => _interstitial = null,
      ),
    );
  }

  @override
  Widget bannerWidget() {
    if (!_initialized) {
      initialize();
      return const SizedBox(height: 60);
    }
    return _BannerView(unitId: AdIds.banner());
  }

  @override
  Future<void> showInterstitial() async {
    final ad = _interstitial;
    if (ad == null) return;
    _interstitial = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _preloadInterstitial();
      },
    );
    await ad.show();
  }
}

class _BannerView extends StatefulWidget {
  final String unitId;
  const _BannerView({required this.unitId});

  @override
  State<_BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<_BannerView> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: widget.unitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _loaded = true),
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox(height: 50);
    return SizedBox(
      width: _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      child: AdWidget(ad: _ad!),
    );
  }
}

class _DesktopAdService implements AdService {
  @override
  Future<void> initialize() async {}
  @override
  Widget bannerWidget() => const SizedBox.shrink();
  @override
  Future<void> showInterstitial() async {}
}
