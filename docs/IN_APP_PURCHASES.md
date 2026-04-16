# In-App Purchases — Silver Suite

## Products

| ID | Type | Price | What it does |
|---|---|---|---|
| `ss_remove_ads` | Non-Consumable | $2.99 | Removes banner ad. That's it. |
| `ss_premium_monthly` | Auto-Renewable Subscription | $3.99 / mo | Silver+ Monthly: ads removed + unlimited pills/contacts/notes |
| `ss_premium_yearly` | Auto-Renewable Subscription | $29.99 / yr | Silver+ Yearly (save 37%) |
| `ss_premium_lifetime` | Non-Consumable | $49.99 | Silver+ Lifetime |

Any premium tier auto-removes ads — no need to buy `ss_remove_ads` on top.

## Setup checklists

### App Store Connect
1. Subscription Group: `Silver+ Membership`. Localized display name identical.
2. Subscriptions: add `ss_premium_monthly`, `ss_premium_yearly`.
3. Non-consumables: `ss_remove_ads`, `ss_premium_lifetime`.
4. For v1 we skip free trials. (Add `ss_premium_yearly` intro offer in v1.1.)

### Google Play Console
1. Subscriptions: `ss_premium_monthly`, `ss_premium_yearly` under base plan group `silver-plus`.
2. Managed products: `ss_remove_ads`, `ss_premium_lifetime`.
3. License testers: add `nalhamzy@gmail.com`.

## Testing

### iOS
1. iPhone → Settings → App Store → sign in with sandbox tester.
2. In app: More tab → Upgrade to Silver+ → pick tier → Continue.
3. Paywall reacts on `iap.onPurchaseSuccess` → `premiumProvider.activate()`.
4. Ad banner disappears immediately on success.

### Android (Play Billing test mode)
1. Signed AAB → Internal Testing track.
2. Launch via tester link, purchase runs as test.

## Code touchpoints

- Product IDs: `lib/core/constants/iap_ids.dart`
- Service: `lib/core/services/iap_service{,_mobile,_stub}.dart`
- State: `lib/core/models/premium_state.dart`
- Provider + both `isPremiumProvider` and `hideAdsProvider`:
  `lib/providers/iap_provider.dart`
- Paywall UI: `lib/screens/paywall_screen.dart`
- Banner ad widget (respects `hideAds`): `lib/widgets/ad_banner_widget.dart`

## Purchase → ad-removal flow

```
iap.buy(productId)
      │
      ▼
Store prompts user for payment
      │
      ▼
Success → iap.onPurchaseSuccess(productId)
      │
      ▼
PremiumNotifier.activate() sets
    activeProductId + adsRemoved=true (on any ad-removing product)
      │
      ▼
hideAdsProvider rebuilds → AdBannerWidget returns SizedBox.shrink()
```

## Restoration

Same button on the paywall calls `iap.restore()`. On iOS this queries StoreKit; on Android this queries Play Billing history. Any restored transactions hit `onPurchaseSuccess` same as a fresh purchase.
