import 'dart:io';

/// AdMob unit IDs.
/// Google provides stable test IDs — safe to ship in debug/beta builds.
/// For production, swap `_prodBanner*` / `_prodInterstitial*` with your
/// real unit IDs from the AdMob console. Set `kUseTestAds = false`
/// (or define `--dart-define=USE_TEST_ADS=false`) to switch.
class AdIds {
  static const bool kUseTestAds = bool.fromEnvironment(
    'USE_TEST_ADS',
    defaultValue: true,
  );

  // ------- TEST IDs (Google) -------
  static const _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const _testBannerIos = 'ca-app-pub-3940256099942544/2934735716';
  static const _testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const _testInterstitialIos = 'ca-app-pub-3940256099942544/4411468910';

  // ------- PRODUCTION placeholders — replace before release -------
  // Each must be created in AdMob console (Apps → Silver Suite → Ad Units)
  static const _prodBannerAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const _prodBannerIos = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const _prodInterstitialAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const _prodInterstitialIos = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

  static String banner() {
    if (kUseTestAds) {
      return Platform.isIOS ? _testBannerIos : _testBannerAndroid;
    }
    return Platform.isIOS ? _prodBannerIos : _prodBannerAndroid;
  }

  static String interstitial() {
    if (kUseTestAds) {
      return Platform.isIOS ? _testInterstitialIos : _testInterstitialAndroid;
    }
    return Platform.isIOS ? _prodInterstitialIos : _prodInterstitialAndroid;
  }
}

/// AdMob *App* IDs (different from unit IDs). Goes in manifest/plist.
class AdAppIds {
  // Google test AdMob app IDs — swap for your AdMob console values.
  static const testAndroid = 'ca-app-pub-3940256099942544~3347511713';
  static const testIos = 'ca-app-pub-3940256099942544~1458002511';

  // Production placeholders — replace before release.
  static const prodAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX';
  static const prodIos = 'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX';
}
