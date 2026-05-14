/// Product IDs must match App Store Connect + Google Play Console exactly.
/// Current model: 7-day local trial, then one lifetime unlock.
class IapProductIds {
  static const premiumLifetime = 'ss_premium_lifetime';

  // Legacy IDs are kept only so old local purchase state still unlocks the
  // app if a tester bought an earlier sandbox build. New builds query only
  // the lifetime product.
  static const legacyPremiumIds = <String>{
    'ss_premium_monthly',
    'ss_premium_yearly',
    'ss_remove_ads',
  };

  static const subscriptionIds = <String>{};
  static const nonConsumableIds = <String>{premiumLifetime};
  static const all = <String>{premiumLifetime};
}
