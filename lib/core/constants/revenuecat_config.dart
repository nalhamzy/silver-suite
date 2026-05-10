/// RevenueCat public API key for Silver Suite.
///
/// Supplied at build time via:
///   --dart-define=REVENUECAT_IOS_API_KEY=appl_xxxxxxxxxxxx
/// Codemagic injects this from the `revenuecat_silver_suite` env group.
///
/// NOTE: Silver Suite v1.0 uses the native `in_app_purchase` plugin.
/// This constant is declared now so that when the RC SDK (purchases_flutter)
/// is added in a future patch, the Codemagic env group and dart-define
/// injection are already in place — no pipeline changes needed.
const revenueCatIosApiKey = String.fromEnvironment('REVENUECAT_IOS_API_KEY');
const revenueCatAndroidApiKey =
    String.fromEnvironment('REVENUECAT_ANDROID_API_KEY');
