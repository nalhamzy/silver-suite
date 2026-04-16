import 'package:flutter/widgets.dart';
import 'ad_service.dart';

AdService createAdService() => _StubAdService();

class _StubAdService implements AdService {
  @override
  Future<void> initialize() async {}

  @override
  Widget bannerWidget() => const SizedBox.shrink();

  @override
  Future<void> showInterstitial() async {}
}
