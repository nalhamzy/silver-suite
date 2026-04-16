# AdMob Setup — Silver Suite

## What's in the code

- Test IDs ship by default. Switch to production with:
  `--dart-define=USE_TEST_ADS=false` (also wired in `codemagic.yaml`).
- App IDs live in `lib/core/constants/ad_ids.dart` (Dart) and
  - Android: `android/app/src/main/AndroidManifest.xml` → `com.google.android.gms.ads.APPLICATION_ID`
  - iOS: `ios/Runner/Info.plist` → `GADApplicationIdentifier`
- Banner: `lib/widgets/ad_banner_widget.dart` — hides itself when `hideAdsProvider` is true.
- Interstitial (optional): `AdService.showInterstitial()` — a slot exists but nothing currently triggers one on v1 (blueprint-aligned — seniors + interstitials = review risk).

## Admob console steps

1. Sign in at https://apps.admob.com with `nalhamzy@gmail.com`.
2. **Apps → Add app → App Store / Play Store listing** (use both platforms).
3. Copy the **App ID** for each platform (format `ca-app-pub-XXXX~YYYY`) and replace the placeholders in `lib/core/constants/ad_ids.dart` under `AdAppIds.prodAndroid` / `AdAppIds.prodIos`.
4. Also replace the `APPLICATION_ID` meta-data value in the Android manifest and `GADApplicationIdentifier` in the iOS Info.plist with the same values.
5. **Ad units → Create ad unit → Banner**. Create one for Android and one for iOS. Paste IDs into `_prodBannerAndroid` / `_prodBannerIos`.
6. **Ad units → Create ad unit → Interstitial** (keep for v1.1). Paste into `_prodInterstitialAndroid` / `_prodInterstitialIos`.

## iOS ATT (App Tracking Transparency)

For v1 we use **non-personalized ads only**, which means the ATT prompt isn't shown. If you turn personalized ads on later, AdMob SDK will show the system ATT prompt — the rationale string is already in Info.plist as `NSUserTrackingUsageDescription`.

## SKAdNetwork

The `Info.plist` ships with the AdMob base SKAdNetworkIdentifier. When you run Silver Suite through Apple Search Ads or other networks, append the full AdMob list from the AdMob docs. Short-term: this single entry is enough to serve AdMob banners.

## Content ratings

Silver Suite AdMob app content rating: **G / All ages** — our audience is 60+.
In AdMob → App settings → Content rating, select "General audiences (G)." This blocks questionable creatives.

## Verification

Before flipping `USE_TEST_ADS=false`:
1. Run a debug build. Banner shows "Test Ad" watermark — confirms wiring.
2. Tap "Remove Ads" in paywall → banner disappears.
3. Relaunch — banner stays hidden. Purchase persists via `PremiumState`.
