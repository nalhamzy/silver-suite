import 'package:flutter/widgets.dart';

import 'ad_service_stub.dart'
    if (dart.library.io) 'ad_service_mobile.dart';

/// Platform-aware ads facade. No-op on web/desktop.
abstract class AdService {
  factory AdService() => createAdService();

  Future<void> initialize();

  /// Returns a live banner widget (or SizedBox.shrink on unsupported).
  Widget bannerWidget();

  /// Show a cached interstitial. Resolves when dismissed (or immediately
  /// if nothing's ready). Safe to call on any platform.
  Future<void> showInterstitial();
}
