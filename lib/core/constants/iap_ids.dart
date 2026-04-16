/// Product IDs must match App Store Connect + Google Play Console exactly.
/// Same pricing ladder as Parenting Pulse (user directive).
class IapProductIds {
  static const premiumMonthly = 'ss_premium_monthly';       // $3.99/mo
  static const premiumYearly = 'ss_premium_yearly';         // $29.99/yr
  static const premiumLifetime = 'ss_premium_lifetime';     // $49.99 lifetime
  // Stand-alone "just remove ads" option
  static const removeAds = 'ss_remove_ads';                 // $2.99

  static const subscriptionIds = <String>{
    premiumMonthly,
    premiumYearly,
  };
  static const nonConsumableIds = <String>{
    premiumLifetime,
    removeAds,
  };
  static const all = <String>{
    premiumMonthly,
    premiumYearly,
    premiumLifetime,
    removeAds,
  };
}
