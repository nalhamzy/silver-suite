# In-App Purchases - Silver Suite

## Current model

Silver Suite uses a 7-day local trial, then one lifetime unlock. There is no subscription in the current app build.

| ID | Type | Price | What it does |
|---|---|---|---|
| `ss_premium_lifetime` | Non-Consumable | $49.99 | Silver+ Lifetime: removes ads and keeps all premium features unlocked forever |

Legacy sandbox IDs from earlier builds (`ss_remove_ads`, `ss_premium_monthly`, `ss_premium_yearly`) are not queried by new builds. If a tester already has one stored locally, the app still treats it as unlocked so old sandbox state does not strand QA.

## Setup checklists

### App Store Connect

1. Use bundle `com.idealai.silversuite`.
2. Create/keep non-consumable `ss_premium_lifetime`.
3. Do not create a free-trial offer on this product. The 7-day trial is local app logic, because Apple/Google native free trials are subscription constructs.
4. Ensure Paid Apps Agreement, tax, and banking are active before IAP review.

### Google Play Console

1. Use package `com.idealai.silversuite`.
2. Create/keep managed product `ss_premium_lifetime`.
3. Add `nalhamzy@gmail.com` as a license tester.
4. Confirm the product is active before testing from an Internal Testing build.

## Testing

### iOS

1. iPhone Settings -> App Store -> sign in with sandbox tester.
2. In app: More tab -> Silver+ card -> Continue.
3. Paywall reacts on `iap.onPurchaseSuccess` -> `premiumProvider.activate()`.
4. Ad banner disappears immediately on success.

### Android

1. Signed AAB -> Internal Testing track.
2. Launch via tester link.
3. Buy `ss_premium_lifetime` as a Play Billing test purchase.
4. Restore purchases from the paywall on a reinstall.

## Code touchpoints

- Product IDs: `lib/core/constants/iap_ids.dart`
- Service: `lib/core/services/iap_service{,_mobile,_stub}.dart`
- State: `lib/core/models/premium_state.dart`
- Provider: `lib/providers/iap_provider.dart`
- Paywall UI: `lib/screens/paywall_screen.dart`
- Banner ad widget: `lib/widgets/ad_banner_widget.dart`

## Purchase flow

```text
first launch -> PremiumNotifier starts 7-day local trial
trial active -> isPremium + hideAds return true
trial expired -> user sees lifetime paywall
iap.buy(ss_premium_lifetime)
store confirms purchase
iap.onPurchaseSuccess(productId)
PremiumNotifier.activate(productId)
hideAdsProvider rebuilds -> AdBannerWidget returns SizedBox.shrink()
```

## Restoration

The paywall Restore button calls `iap.restore()`. Any restored transaction hits `onPurchaseSuccess` and stores `ss_premium_lifetime` locally.
