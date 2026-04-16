---
title: Privacy Policy
permalink: /privacy.html
---

# Silver Suite — Privacy Policy

_Effective date: 17 April 2026_

Silver Suite ("the app") is built by Nasir Alhamzy. This document is the full story of what the app does with your information.

## TL;DR

- **No account. No login.** The app works fully the moment you open it.
- **All your data stays on your phone.** Contacts, pills, notes, settings — local only.
- **One narrow exception: ads.** On the free tier, Google AdMob serves a banner. The Ad-free tier ($2.99 one-time) or any Silver+ plan removes it permanently.
- **No third-party analytics.** No Google Analytics, no Sentry, no Mixpanel, no Meta SDK.
- **No data sales. Ever.**

## Data we collect

**Silver Suite itself collects nothing.** There is no usage telemetry, no crash reporter, no server we control. The app does not have an account system.

### Ads (free tier only, via Google AdMob)

When ads are enabled (i.e. you haven't yet bought Remove Ads or a Silver+ plan), the Google Mobile Ads SDK runs inside the app. By default we request **non-personalized** ads, which means AdMob does not build a behavioral profile. AdMob still receives:

- Your device's advertising identifier (IDFA on iOS, AAID on Android)
- The ad request itself (country-level IP, ad unit ID, app version)

It uses this to serve contextual ads and for click fraud detection. You can reset the advertising identifier in iOS Settings → Privacy & Security → Tracking, or Android Settings → Google → Ads.

**The moment you buy Remove Ads or a Silver+ plan**, the AdMob SDK is no longer called — `hideAdsProvider` short-circuits the banner widget. No further ad requests are made.

AdMob's full policy: https://policies.google.com/privacy

## What lives on your device

- Pill schedules and taken-today log
- Contacts (name, phone, relation, emergency flag)
- Notes
- Display settings (dark mode, text size preset)
- Premium state (which tier you bought, if any)

Nothing here leaves the device. There is no cloud sync. Uninstalling the app deletes all of it.

## In-App Purchases

Processed entirely by Apple App Store / Google Play Billing. Silver Suite receives a signed receipt containing only the product ID + purchase state, used to flip local flags. We never see your card, Apple ID, or Google account email.

## Phone calls

When you tap a contact's call button, Silver Suite invokes the system dialer via a standard `tel:` URL. We do not place the call, intercept it, or log it. Your phone's call history is the only place that records it.

## Flashlight / magnifier

- The flashlight uses your device's camera flash hardware through the `torch_light` plugin. We toggle it on/off; we never access the camera image.
- The magnifier never touches the camera — you type or paste text; we render it large.

## Permissions

| Permission | When | Why |
|---|---|---|
| Camera (Android: `CAMERA`, iOS: `NSCameraUsageDescription`) | Required by `torch_light` | To toggle the torch LED. We do not capture video/photos. |
| Internet (Android: `INTERNET`) | Free-tier only | AdMob ad requests. |
| Billing (Android: `com.android.vending.BILLING`) | On purchase | Talk to Play Billing. |

We request **nothing else**: no contacts, no calendar, no microphone, no location.

## Children

Silver Suite is designed for adults. It is not directed at children under 13 and we do not knowingly collect personal information from them.

## GDPR / California / Australia

- **Right to access**: everything is on your device.
- **Right to deletion**: uninstall the app.
- **Right to opt out of sale**: no sale happens — nothing to opt out of.
- **Right to object to automated decision-making**: no automated decisions are made.

For EU/UK users, the legal basis for processing the advertising identifier (free tier only) is your consent. You can withdraw consent at any time by upgrading to any paid tier — or by denying the relevant device-level setting.

## Changes

Material changes will be surfaced in-app before taking effect. The Effective Date at top will bump.

## Contact

Questions? **nalhamzy@gmail.com**.
